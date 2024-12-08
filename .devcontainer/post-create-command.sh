#!/bin/bash
set -eu

sudo apt-get update
sudo apt-get install -y build-essential fzf

# install just
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin

# install act
gh extension install nektos/gh-act

# git config
git config --global user.name "${GIT_USER_NAME}" && git config --global user.email "${GIT_USER_EMAIL}"
