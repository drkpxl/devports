#!/usr/bin/env bash
#
# bump-version.sh - Helper script to bump version across all files
#
# Usage: ./bump-version.sh <new_version>
# Example: ./bump-version.sh 1.1.0
#

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <new_version>"
    echo "Example: $0 1.1.0"
    exit 1
fi

NEW_VERSION="$1"

# Validate version format (basic semver check)
if ! echo "$NEW_VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    echo "❌ Invalid version format. Please use semantic versioning (e.g., 1.2.3)"
    exit 1
fi

echo "🔄 Updating version to $NEW_VERSION..."

# Get current version from devports script
CURRENT_VERSION=$(grep '^VERSION=' devports | cut -d'"' -f2)
echo "Current version: $CURRENT_VERSION"

# Update version in devports script
sed -i.bak "s/^VERSION=\".*\"/VERSION=\"$NEW_VERSION\"/" devports
echo "✅ Updated devports script"

# Update version in Makefile
sed -i.bak "s/^VERSION = .*/VERSION = $NEW_VERSION/" Makefile
echo "✅ Updated Makefile"

# Update CHANGELOG.md - move Unreleased to new version
TODAY=$(date +"%Y-%m-%d")
sed -i.bak "s/## \[Unreleased\]/## [$NEW_VERSION] - $TODAY/" CHANGELOG.md
echo "✅ Updated CHANGELOG.md"

# Add new Unreleased section to CHANGELOG.md
sed -i.bak "/^## \[$NEW_VERSION\] - $TODAY/i\\
## [Unreleased]\\
\\
### Added\\
\\
### Changed\\
\\
### Fixed\\
\\
" CHANGELOG.md

# Clean up backup files
rm -f devports.bak Makefile.bak CHANGELOG.md.bak

echo ""
echo "✅ Version bump complete!"
echo ""
echo "Next steps:"
echo "1. Review the changes: git diff"
echo "2. Test the updated version: make test"
echo "3. Commit changes: git commit -am 'Bump version to $NEW_VERSION'"
echo "4. Create tag: git tag -a v$NEW_VERSION -m 'Release v$NEW_VERSION'"
echo "5. Push changes and tag: git push origin main v$NEW_VERSION"