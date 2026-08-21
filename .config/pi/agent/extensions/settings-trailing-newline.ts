/**
 * Keep a trailing newline at the end of settings.json.
 *
 * pi persists settings with `JSON.stringify(settings, null, 2)` and no final
 * newline (see SettingsManager#persistScopedSettings in the pi package), so
 * every settings change rewrites the file as a POSIX-incorrect text file.
 *
 * The extension imports the same SettingsManager class object that pi itself
 * uses (extension imports of "@earendil-works/pi-coding-agent" are aliased to
 * pi's own dist/index.js, so the class identity is shared) and wraps the
 * storage write for the duration of the persist call, appending "\n" to the
 * serialized JSON. Applies to both the global (~/.pi/agent/settings.json) and
 * project (.pi/settings.json) scopes.
 */
import { SettingsManager } from "@earendil-works/pi-coding-agent";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

type SettingsStorage = {
  withLock(
    scope: string,
    fn: (current: string | undefined) => string | undefined,
  ): void;
};

type PatchableSettingsManager = {
  persistScopedSettings?: (...args: unknown[]) => unknown;
  __trailingNewlinePatched?: boolean;
};

const withTrailingNewline = (storage: SettingsStorage): SettingsStorage => ({
  withLock(scope, fn) {
    storage.withLock(scope, (current) => {
      const next = fn(current);
      if (typeof next !== "string" || next.endsWith("\n")) return next;
      return `${next}\n`;
    });
  },
});

export default function (pi: ExtensionAPI) {
  const proto =
    SettingsManager.prototype as unknown as PatchableSettingsManager;

  // Extension factories re-run on reload/session switch.
  if (proto.__trailingNewlinePatched) return;

  const original = proto.persistScopedSettings;
  if (typeof original !== "function") {
    // pi renamed or removed the persist hook so fail loudly.
    pi.on("session_start", (_event, ctx) => {
      ctx.ui.notify(
        "settings-trailing-newline: SettingsManager#persistScopedSettings is gone, extension needs updating",
        "warning",
      );
    });
    return;
  }

  proto.__trailingNewlinePatched = true;
  proto.persistScopedSettings = function (
    this: { storage: SettingsStorage },
    ...args: unknown[]
  ) {
    const storage = this.storage;
    if (!storage || typeof storage.withLock !== "function")
      return original.apply(this, args);
    // persistScopedSettings writes synchronously inside withLock, so swapping
    // the storage for the duration of the call is safe.
    this.storage = withTrailingNewline(storage);
    try {
      return original.apply(this, args);
    } finally {
      this.storage = storage;
    }
  };
}
