#!/bin/bash

set -e

# Location of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR

# common-utils, git, github-cli ================================================
# https://github.com/devcontainers/features/tree/main/src/common-utils
# https://github.com/devcontainers/features/tree/main/src/git

COMMIT_TO_PULL="28846e52809dfd65c0569fb58eae55afcb5f366a"
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

# quarto-cli, pandoc ===========================================================
# https://github.com/rocker-org/devcontainer-features/tree/main/src/pandoc 
# https://github.com/rocker-org/devcontainer-features/tree/main/src/quarto-cli
# https://github.com/rocker-org/devcontainer-features/tree/main/src/rstudio-server


COMMIT_TO_PULL="89e5e7e91e8e3e1dfee25a8129413fb5c2c48dcc"
git init -b main
git config core.sparseCheckout true
git remote add -f origin https://github.com/rocker-org/devcontainer-features.git
echo "src/pandoc/" >> .git/info/sparse-checkout
echo "src/quarto-cli/" >> .git/info/sparse-checkout
echo "src/rstudio-server/" >> .git/info/sparse-checkout
git fetch origin "${COMMIT_TO_PULL}"
git checkout "${COMMIT_TO_PULL}"
rm -rf .git
mv src/pandoc .
mv src/quarto-cli .
mv src/rstudio-server .
rmdir src

# tmux =========================================================================
# https://github.com/duduribeiro/devcontainer-features/tree/main/src/neovim
# https://github.com/duduribeiro/devcontainer-features/tree/main/src/tmux

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

echo "done"
