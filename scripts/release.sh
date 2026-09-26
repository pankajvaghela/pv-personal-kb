#!/usr/bin/env bash
#
# Cut a release: tag the current version and publish its changelog entry.
#
# The release body is *extracted* from CHANGELOG.md, never written here. Two
# copies of the same fact drift, and the changelog is the copy that gets kept —
# so the release page is a rendering of it rather than a second thing to
# maintain. If a note is missing from the release, it is missing from the
# changelog, which is the right place to fix it.
#
# Usage:  scripts/release.sh [--dry-run]

set -euo pipefail

cd "$(dirname "$0")/.."

DRY_RUN=""
[ "${1:-}" = "--dry-run" ] && DRY_RUN=1

read_version() {
  grep -oE '"version": *"[0-9]+\.[0-9]+\.[0-9]+"' "$1" \
    | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+'
}

VERSION=$(read_version .claude-plugin/plugin.json)
TAG="v${VERSION}"

# --- checks: refuse to publish something half-finished -------------------

if [ -n "$(git status --porcelain)" ]; then
  echo "error: working tree is dirty. Commit first — a release should point at" >&2
  echo "       a commit anyone can check out and see." >&2
  exit 1
fi

BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$BRANCH" != "main" ]; then
  echo "error: on '$BRANCH', not main. Release from main." >&2
  exit 1
fi

MARKETPLACE_VERSION=$(read_version .claude-plugin/marketplace.json)
if [ "$MARKETPLACE_VERSION" != "$VERSION" ]; then
  echo "error: version mismatch — plugin.json is $VERSION, marketplace.json is" >&2
  echo "       $MARKETPLACE_VERSION. Both must agree before a tag means anything." >&2
  exit 1
fi

if ! grep -qE "^## ${VERSION}$" CHANGELOG.md; then
  echo "error: no '## ${VERSION}' section in CHANGELOG.md." >&2
  echo "       Every released version has one, including the 'Existing vaults:'" >&2
  echo "       line that tells people whether they need to run /pkb-upgrade." >&2
  exit 1
fi

git fetch --tags --quiet
if git rev-parse -q --verify "refs/tags/${TAG}" >/dev/null; then
  echo "error: ${TAG} already exists. Bump the version in .claude-plugin/plugin.json." >&2
  exit 1
fi

# --- the release body, taken from the changelog --------------------------

NOTES=$(awk -v heading="## ${VERSION}" '
  $0 == heading { found = 1; next }
  found && /^## / { exit }
  found { print }
' CHANGELOG.md)

if [ -z "$(printf '%s' "$NOTES" | tr -d '[:space:]')" ]; then
  echo "error: the ${VERSION} section of CHANGELOG.md is empty." >&2
  exit 1
fi

if command -v claude >/dev/null 2>&1; then
  claude plugin validate . >/dev/null || {
    echo "error: claude plugin validate failed. Not tagging a broken release." >&2
    exit 1
  }
fi

# --- publish -------------------------------------------------------------

if [ -n "$DRY_RUN" ]; then
  echo "would tag ${TAG} on $(git rev-parse --short HEAD) and publish:"
  echo
  printf '%s\n' "$NOTES"
  exit 0
fi

git tag -a "$TAG" -m "$TAG"
git push origin "$TAG"

printf '%s\n\n---\n\nUpdate: `claude plugin update pv-personal-kb@pankajvaghela`\n' "$NOTES" \
  | gh release create "$TAG" --title "$TAG" --notes-file -

echo "Released ${TAG}"
