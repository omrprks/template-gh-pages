#!/usr/bin/env sh

REPO_URI="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
REMOTE_NAME="${REMOTE_NAME:-origin}"
MASTER_BRANCH="${MASTER_BRANCH:-master}"
TARGET_BRANCH="${TARGET_BRANCH:-gh-pages}"
OUT="${OUT}"
CNAME="${CNAME}"

if [ -z "${OUT}" ] || [ -z "${CNAME}" ]; then
  echo "OUT or CNAME not set. Exiting..."
  exit 1;
fi

cd "$GITHUB_WORKSPACE"

git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"

touch "${OUT}/.nojekyll"
echo "${CNAME}" > "${OUT}/CNAME"

git add -f "${OUT}"

git commit -m "chore(release): deploys to gh-pages"
if [ $? -ne 0 ]; then
  echo "nothing added to commit"
  exit 0
fi

git remote set-url "${REMOTE_NAME}" "${REPO_URI}"
git subtree split --prefix "${OUT}" -b "${TARGET_BRANCH}"
git push -f origin "${TARGET_BRANCH}":"${TARGET_BRANCH}"
git branch -D "${TARGET_BRANCH}"
