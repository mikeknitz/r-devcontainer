#!/bin/bash

set -e

# Location of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR

# common-utils, git ============================================================

# https://github.com/devcontainers/features/tree/main/src/common-utils
# https://github.com/devcontainers/features/tree/d1c0cc2476690cb9479cf1b6a3e27211b14cbe88/src/common-utils

COMMIT_TO_PULL="d1c0cc2476690cb9479cf1b6a3e27211b14cbe88"
git init -b main
git config core.sparseCheckout true
git remote add -f origin https://github.com/devcontainers/features.git
echo "src/common-utils/" >> .git/info/sparse-checkout
git fetch origin "${COMMIT_TO_PULL}"
git checkout "${COMMIT_TO_PULL}"
rm -rf .git
mv src/common-utils .
rmdir src

# --------------------------------------------------------------------------------

echo "done"
