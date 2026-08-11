#!/usr/bin/env bash
#
# Create (or repair) one instance of the OurStory activity.
#
#   ./scripts/new-instance.sh "Bootcamp 2026"
#
# The only thing you have to supply is the name of the instance.
# Running it twice is safe: it creates whatever is missing and leaves whatever already exists alone, so if a step fails you can just run it again.

set -euo pipefail

INSTANCE_NAME="${1:-}"
if [ -z "$INSTANCE_NAME" ]; then
  echo "usage: $0 \"Bootcamp 2026\"" >&2
  exit 64
fi

# Turn "Bootcamp 2026" into "OurStory-Bootcamp-2026".
SLUG="OurStory-$(printf '%s' "$INSTANCE_NAME" | tr -cs '[:alnum:]' '-' | sed 's/-*$//')"

command -v gh >/dev/null || { echo "The GitHub CLI (gh) is not installed. See https://cli.github.com" >&2; exit 69; }
gh auth status >/dev/null 2>&1 || { echo "Not logged in. Run: gh auth login" >&2; exit 69; }

OWNER="$(gh api user --jq .login)"
TEMPLATE="${TEMPLATE_REPO:-$OWNER/OurStory}"
TARGET="$OWNER/$SLUG"

say() { printf '\n\033[1m%s\033[0m\n' "$*"; }

say "Instance: $INSTANCE_NAME"
echo "  template -> $TEMPLATE"
echo "  new repo -> $TARGET"

# 1. The repository itself.
if gh repo view "$TARGET" >/dev/null 2>&1; then
  echo "  repo already exists, leaving it alone"
else
  gh repo create "$TARGET" \
    --template "$TEMPLATE" \
    --public \
    --description "Let's write a short story together — $INSTANCE_NAME"
  echo "  created"
  # A repo made from a template needs a moment before it can be cloned.
  sleep 3
fi

# 2. Stamp the instance name into the repo, so it shows up on the published site.
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
gh repo clone "$TARGET" "$WORK/repo" -- --quiet
cd "$WORK/repo"

printf '%s\n' "$INSTANCE_NAME" > instance.txt
if ! git diff --quiet -- instance.txt; then
  git add instance.txt
  git commit -qm "Set the instance name to $INSTANCE_NAME"
  git push -q
  echo "  instance name recorded"
else
  echo "  instance name already set"
fi

# 3. Turn on GitHub Pages, published by the workflow rather than from a branch.
if gh api "repos/$TARGET/pages" >/dev/null 2>&1; then
  gh api -X PUT "repos/$TARGET/pages" -f build_type=workflow >/dev/null
  echo "  Pages already on"
else
  gh api -X POST "repos/$TARGET/pages" -f build_type=workflow >/dev/null 2>&1 \
    && echo "  Pages enabled" \
    || echo "  could not enable Pages automatically — switch it on under Settings > Pages (Source: GitHub Actions)"
fi

PAGES_URL="https://$(printf '%s' "$OWNER" | tr '[:upper:]' '[:lower:]').github.io/$SLUG/"

# 4. Put the site link in the About box, which is where the README tells students to look for it.
gh repo edit "$TARGET" --homepage "$PAGES_URL" >/dev/null 2>&1 || true

# 5. The editing-zone dial, off by default.
# Students are told to pick any line anywhere, and their own bias towards the top of the file supplies the collisions. See TEACHERS.md before turning this on.
gh variable set HOT_LINES --repo "$TARGET" --body "${HOT_LINES:-0}" >/dev/null 2>&1 \
  || echo "  could not set HOT_LINES — set it under Settings > Secrets and variables > Actions"

# 6. Kick the first build so the site exists before anyone arrives.
gh workflow run "Build and publish the site" --repo "$TARGET" >/dev/null 2>&1 || true

say "Ready."
cat <<EOF

  Repo            https://github.com/$TARGET
  Story site      $PAGES_URL
  Pick the story  https://github.com/$TARGET/actions/workflows/pick-story.yml
  Fork network    https://github.com/$TARGET/network
  Forks so far    https://github.com/$TARGET/forks

Next: open TEACHERS.md and run through the checklist.
EOF
