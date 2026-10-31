#!/usr/bin/env bash
# Runs before Paradev removes the worktree. Xcode keeps a DerivedData folder
# (builds, index, resolved packages) per checkout path, outside the worktree,
# so delete the ones that belong to this worktree. Never fails the archive.
set -u

here="$(pwd -P)"
[[ -e .git && "$here" != / ]] || exit 0
[[ "$here" != "$(cd "${SUPERSET_ROOT_PATH:-/}" 2>/dev/null && pwd -P)" ]] || exit 0

dd="$(defaults read com.apple.dt.Xcode IDECustomDerivedDataLocation 2>/dev/null || true)"
dd="${dd:-$HOME/Library/Developer/Xcode/DerivedData}"
[[ -d "$dd" ]] || exit 0

for plist in "$dd"/*/info.plist; do
  [[ -f "$plist" ]] || continue
  ws="$(/usr/libexec/PlistBuddy -c 'Print :WorkspacePath' "$plist" 2>/dev/null)" || continue
  case "$ws" in
    "$here"/* | "$PWD"/*)
      rm -rf "$(dirname "$plist")" && echo "Removed Xcode DerivedData for ${ws##*/}" ;;
  esac
done
exit 0
