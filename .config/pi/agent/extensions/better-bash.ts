/*
 * This extension improves the Bash tool in 2 ways:
 *
 * - It includes the ability to block commands from running and instead return guidance
 *   to the LLM. This uses exported Bash functions.
 *
 * - It runs the first `bash` on PATH instead of pi's hardcoded /bin/bash default
 *   (ends up as an ancient version on macOS).
 */

import { existsSync, realpathSync, statSync } from "node:fs";
import { delimiter, dirname, join, resolve } from "node:path";
import {
  createBashTool,
  createLocalBashOperations,
  type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";

const BLOCKED_COMMANDS = {
  pip: "Error: pip is disabled. Use uv: uv add PKG / uv run --with PKG ...",
  pip3: "Error: pip3 is disabled. Use uv: uv add PKG / uv run --with PKG ...",
  npm: "Error: npm is disabled. Use pnpm (pnpm add / pnpm install / pnpm run).",
  npx: "Error: npx is disabled. Use pnpm dlx [--package PKG] EXECUTABLE.",
} as const;

const BLOCKED_IN_JJ_REPO = {
  git: [
    "Error: git is disabled in jj repos. Use jj instead",
    "the only thing you might need git for is annotated tags.",
  ].join("\n"),
} as const;

const singleQuote = (s: string) => `'${s.replaceAll("'", `'\\''`)}'`;

const toExportedBashFuncs = (
  x: Record<string, string>,
): Record<string, string> =>
  Object.fromEntries(
    Object.entries(x).map(([name, message]) => [
      `BASH_FUNC_${name}%%`,
      `() { printf '%s\\n' ${singleQuote(message)} >&2; return 1; }`,
    ]),
  );

const inJjRepo = (dir: string): boolean => {
  for (let d = resolve(dir); ; d = dirname(d)) {
    if (existsSync(join(d, ".jj"))) return true;
    if (dirname(d) === d) return false;
  }
};

/// First executable `bash` on PATH, or undefined to use pi's default.
const resolvePathBash = (): string | undefined => {
  for (const dir of (process.env.PATH ?? "").split(delimiter)) {
    if (!dir) continue;
    const candidate = join(dir, "bash");
    try {
      if (!statSync(candidate).isFile()) continue;
      if (realpathSync(candidate) === realpathSync("/bin/bash")) {
        // we found pi's default, so no need to override
        return undefined;
      }
      return candidate;
    } catch {
      // not in `dir`, keep looking
    }
  }
  return undefined;
};

export default function blockedCommandsEnvExtension(pi: ExtensionAPI): void {
  const shellPath = resolvePathBash();

  pi.registerTool(
    createBashTool(process.cwd(), {
      shellPath,
      spawnHook: ({ command, cwd, env }) => {
        const blockedEnv = toExportedBashFuncs({
          ...BLOCKED_COMMANDS,
          ...(inJjRepo(cwd) ? BLOCKED_IN_JJ_REPO : {}),
        });

        return {
          command,
          cwd,
          env: { ...env, ...blockedEnv },
        };
      },
    }),
  );

  if (shellPath) {
    pi.on("user_bash", () => ({
      operations: createLocalBashOperations({ shellPath }),
    }));
  }
}
