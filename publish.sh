#!/bin/zsh
# Publish a read-only snapshot exported from the CRM ("Share snapshot").
# Usage: ./publish.sh ~/Downloads/<snapshot>.html
set -euo pipefail
cd "$(dirname "$0")"
src="${1:?Usage: ./publish.sh path/to/snapshot.html}"
[[ -f "$src" ]] || { echo "Not found: $src"; exit 1; }
cp "$src" index.html
# Ask search engines not to index the page (not access control).
grep -q 'name="robots"' index.html || sed -i '' 's#<head>#<head><meta name="robots" content="noindex, nofollow">#' index.html
git add index.html
git commit -m "Update snapshot $(date '+%Y-%m-%d %H:%M')" || { echo "No changes."; exit 0; }
git push
echo "Published. Live in ~1 minute at: https://tim20020714-dot.github.io/tim-crm-snapshot/"
