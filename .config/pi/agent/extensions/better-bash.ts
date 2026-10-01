/*
 * This extension improves the Bash tool in 2 ways:
 *
 * - It includes the ability to block commands from running and instead return guidance
 *   to the LLM. This uses exported Bash functions.
 *
 * - It runs the first `bash` on PATH instead of pi's hardcoded /bin/bash default
 *   (ends up as an ancient version on macOS).
 */

import { existsSync, statSync } from "node:fs";
import { delimiter, dirname, join, resolve } from "node:path";
import {
  createBashTool,
  createLocalBashOperations,
  type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";

type BlockSpecification = {
  cmd: string;
  msg: string;
  when?: (cwd: string) => boolean;
};

const inJjRepo = (cwd: string): boolean => {
  for (let d = resolve(cwd); ; d = dirname(d)) {
    if (existsSync(join(d, ".jj"))) return true;
    if (dirname(d) === d) return false;
  }
};

const blockedCommands: BlockSpecification[] = [
  {
    cmd: "pip",
    msg: "Error: pip is disabled. Use uv: uv add PKG / uv run --with PKG ...",
  },
  {
    cmd: "pip3",
    msg: "Error: pip3 is disabled. Use uv: uv add PKG / uv run --with PKG ...",
  },
  {
    cmd: "npm",
    msg: "Error: npm is disabled. Use pnpm (pnpm add / pnpm install / pnpm run).",
  },
  {
    cmd: "npx",
    msg: "Error: npx is disabled. Use pnpm dlx [--package PKG] EXECUTABLE.",
  },
  {
    cmd: "timeout",
    msg: "Error: GNU timeout is disabled. Use your bash tool's timeout parameter instead.",
  },
  {
    cmd: "git",
    msg: [
      "Error: git is disabled in jj repos. Use jj instead.",
      "Note that jj makes changes to its CLI often so use `jj help`",
    ].join("\n"),
    when: inJjRepo,
  },
];

const singleQuote = (s: string) => `'${s.replaceAll("'", `'\\''`)}'`;

/// Convert from { cmd, msg } to an exported Bash function as an env var
const toExportedBashFunc = (cmd: string, msg: string): [string, string] => [
  `BASH_FUNC_${cmd}%%`,
  `() { printf '%s\\n' ${singleQuote(msg)} >&2; return 1; }`,
];

/// First regular file named name on PATH
const findOnPath = (name: string): string | undefined => {
  for (const dir of (process.env.PATH ?? "").split(delimiter)) {
    if (!dir) continue;
    const candidate = join(dir, name);
    try {
      if (statSync(candidate).isFile()) return candidate;
    } catch {
      // not in `dir`, keep looking
    }
  }
  return undefined;
};

export default function blockedCommandsEnvExtension(pi: ExtensionAPI): void {
  const shellPath = findOnPath("bash");

  pi.registerTool(
    createBashTool(process.cwd(), {
      shellPath,
      spawnHook: ({ command, cwd, env }) => {
        const blockedEnv = Object.fromEntries(
          blockedCommands
            .filter(({ when }) => !when || when(cwd))
            .map(({ cmd, msg }) => toExportedBashFunc(cmd, msg)),
        );

        return {
          command,
          cwd,
          env: { ...env, ...blockedEnv },
        };
      },
    }),
  );

  pi.on("user_bash", () => ({
    operations: createLocalBashOperations({ shellPath }),
  }));
}
