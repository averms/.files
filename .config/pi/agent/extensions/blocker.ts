/*
 * Blocker
 *
 * Instead of parsing the command string and blocking the tool call, this
 * overrides the built-in `bash` tool with one whose spawnHook injects
 * exported bash functions (`BASH_FUNC_<name>%%`) into the environment.
 * Bash imports those at startup, so the shim shadows the real program
 * anywhere it appears - pipelines, subshells, scripts, `xargs`-free cases
 * the parser misses - and prints guidance instead of running.
 */

import { existsSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import {
  createBashTool,
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

export default function blockedCommandsEnvExtension(pi: ExtensionAPI): void {
  pi.registerTool(
    createBashTool(process.cwd(), {
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
}
