#!/usr/bin/env bash
# Prepares a new workspace. Paradev runs this from the worktree root when the
# workspace is created (in the cloud, on every boot), so every step is
# idempotent and skips itself when the repo has nothing for it to do.
set -euo pipefail

warn() { echo "warning: $*" >&2; }

# 1. A worktree only gets tracked files. Copy gitignored local config
#    (xcconfig secrets, .env files, Firebase plist) from the main checkout,
#    never overwriting a file that is already here.
root="${SUPERSET_ROOT_PATH:-}"
if [[ -n "$root" && -d "$root" && "$(cd "$root" && pwd -P)" != "$(pwd -P)" ]]; then
  git -C "$root" ls-files -z --others --ignored --exclude-standard -- \
    '*.xcconfig' '*.env' '*.env.*' '*GoogleService-Info.plist' |
    while IFS= read -r -d '' f; do
      case "/$f" in */.build/* | */build/* | */DerivedData/* | */Pods/* | */Carthage/*) continue ;; esac
      [[ -e "$f" ]] && continue
      mkdir -p "$(dirname "$f")"
      cp -p "$root/$f" "$f"
      echo "Copied $f from the main checkout"
    done
fi

# 2. Resolve Swift packages now so the first build doesn't stall fetching
#    them. Not fatal: Xcode retries when it opens the project.
if [[ -f Package.swift ]] && command -v swift >/dev/null; then
  swift package resolve || warn "swift package resolve failed"
fi
if command -v xcodebuild >/dev/null; then
  for proj in *.xcodeproj */*.xcodeproj; do
    [[ -d "$proj" ]] || continue
    xcodebuild -resolvePackageDependencies -project "$proj" -quiet ||
      warn "could not resolve packages for $proj"
  done
fi
