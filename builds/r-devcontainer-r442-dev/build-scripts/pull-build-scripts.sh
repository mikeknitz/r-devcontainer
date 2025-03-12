#!/bin/bash

set -ue

# Location of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# common-utils, git ============================================================

# https://github.com/devcontainers/features/tree/main/src/common-utils
# https://github.com/devcontainers/features/tree/2951f0481a488ea43a6f2ea6f18a47f0a0bf744d/src/common-utils

# https://github.com/devcontainers/features/tree/main/src/git
# https://github.com/devcontainers/features/tree/2951f0481a488ea43a6f2ea6f18a47f0a0bf744d/src/git

COMMIT_TO_PULL="2951f0481a488ea43a6f2ea6f18a47f0a0bf744d"
git init -b main
git config core.sparseCheckout true
git remote add -f origin https://github.com/devcontainers/features.git
echo "src/common-utils/" >> .git/info/sparse-checkout
echo "src/git/" >> .git/info/sparse-checkout
git fetch origin "${COMMIT_TO_PULL}"
git checkout "${COMMIT_TO_PULL}"
rm -rf .git
mv src/common-utils .
mv src/git .
rmdir src

# tmux =========================================================================

# https://github.com/duduribeiro/devcontainer-features/tree/main/src/neovim
# https://github.com/duduribeiro/devcontainer-features/tree/92129ce9d2057508166d5d87c08d5fc8ad203485/src/neovim

# https://github.com/duduribeiro/devcontainer-features/tree/main/src/tmux
# https://github.com/duduribeiro/devcontainer-features/tree/92129ce9d2057508166d5d87c08d5fc8ad203485/src/tmux

COMMIT_TO_PULL="92129ce9d2057508166d5d87c08d5fc8ad203485"
git init -b main
git config core.sparseCheckout true
git remote add -f origin https://github.com/duduribeiro/devcontainer-features.git
echo "src/neovim/" >> .git/info/sparse-checkout
echo "src/tmux/" >> .git/info/sparse-checkout
git fetch origin "${COMMIT_TO_PULL}"
git checkout "${COMMIT_TO_PULL}"
rm -rf .git
mv src/tmux .
mv src/neovim .
rmdir src

# neofetch =====================================================================

# https://github.com/devcontainers-contrib/features/tree/main/src/neofetch
# https://github.com/devcontainers-contrib/features/tree/9a1d24b27b2d1ea8916ebe49c9ce674375dced27/src/neofetch

COMMIT_TO_PULL="9a1d24b27b2d1ea8916ebe49c9ce674375dced27"
git init -b main
git config core.sparseCheckout true
git remote add -f origin https://github.com/devcontainers-contrib/features.git
echo "src/neofetch/" >> .git/info/sparse-checkout
git fetch origin "${COMMIT_TO_PULL}"
git checkout "${COMMIT_TO_PULL}"
rm -rf .git
mv src/neofetch .
rmdir src

# ==============================================================================

echo "done"
