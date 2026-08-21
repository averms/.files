/**
 * Bash Timeout Policy
 *
 * Intercepts the built-in `bash` tool through pi's `tool_call` event and
 * injects a default `timeout` parameter when the model omits one (or
 * supplies a non-positive value). Also appends a system-prompt section
 * explaining the timeout policy so the model knows to set explicit
 * timeouts for long-running commands.
 *
 */

import {
  isToolCallEventType,
  type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";

const BASH_DEFAULT_TIMEOUT_SECONDS = 30;

const BASH_TIMEOUT_PROMPT = `
The bash tool enforces timeouts even when you omit the timeout parameter.

- Default timeout: ${BASH_DEFAULT_TIMEOUT_SECONDS}s

For long-running commands (builds, installs, test suites), set an
explicit timeout that fits the workload. Do not assume commands run
forever.
`;

export default function bashTimeoutExtension(pi: ExtensionAPI): void {
  pi.on("tool_call", async (event) => {
    if (!isToolCallEventType("bash", event)) return;

    const current = event.input.timeout;
    if (current === undefined || current <= 0) {
      event.input.timeout = BASH_DEFAULT_TIMEOUT_SECONDS;
    }
  });

  pi.on("before_agent_start", async (event) => ({
    systemPrompt: `${event.systemPrompt}\n${BASH_TIMEOUT_PROMPT}`,
  }));
}
