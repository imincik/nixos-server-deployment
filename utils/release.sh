#!/usr/bin/env bash

set -Eeuo pipefail

commit=${1:-HEAD}
release_tag=release-$(date "+%Y-%m-%d-%H-%M-%S")

# check current branch
if [[ "$(git branch --show-current)" != "master" ]]; then
    echo "Releases can be created only in master branch ! Exiting ..."
    exit 1
fi

# verify
echo "Release following commit for production deployment ?"
echo

git show --no-patch "$commit"

echo -e "\nPress [CTRL-C] to abort or [ENTER] to continue."
read -r

# release
git tag -f -a deploy -m "Current production deployment version"
git tag -a "$release_tag" -m "Released version"

git push -f origin deploy
git push origin "$release_tag"
