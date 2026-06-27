#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

chmod +x .githooks/pre-commit
git config core.hooksPath .githooks

echo "Git hooks installed from .githooks"
echo "Bypass once with: SKIP_LOCAL_HOOKS=1 git commit ..."

