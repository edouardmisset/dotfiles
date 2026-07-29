#!/bin/bash
# Automated ESLint migration script for Upfluence projects
# Usage: ./scripts/migrate-eslint.sh <project-path>
#
# Always installs @upfluence/w-conf from the npm registry (production mode).

set -e

PROJECT_PATH="${1:-.}"

if [ ! -d "$PROJECT_PATH" ]; then
  echo "❌ Error: Project path '$PROJECT_PATH' does not exist"
  exit 1
fi

if [ ! -f "$PROJECT_PATH/package.json" ]; then
  echo "❌ Error: No package.json found in '$PROJECT_PATH'"
  exit 1
fi

cd "$PROJECT_PATH"

echo "🔍 Checking existing ESLint configuration..."

if [ ! -f ".eslintrc.js" ]; then
  echo "ℹ️  No .eslintrc.js found (already migrated or fresh project)"
else
  echo "✓ Found .eslintrc.js"
fi

if [ -f ".eslintignore" ]; then
  echo "✓ Found .eslintignore (will be removed)"
fi

echo ""
echo "📦 Updating package.json dependencies..."

# Install @upfluence/w-conf from the npm registry
echo "  → Using npm registry (production version)"
npm pkg set devDependencies['@upfluence/w-conf']='^0.3.0'

# Update ESLint to satisfy w-conf's peerDependencies range (eslint stays a direct dep)
npm pkg set devDependencies.eslint='^10.5.0'

# Remove legacy ESLint packages
echo "  → Removing legacy ESLint packages..."
npm pkg delete devDependencies['@typescript-eslint/parser']
npm pkg delete devDependencies['@typescript-eslint/eslint-plugin']
npm pkg delete devDependencies['eslint-config-prettier']
npm pkg delete devDependencies['eslint-plugin-ember']
npm pkg delete devDependencies['eslint-plugin-node']
npm pkg delete devDependencies['eslint-plugin-n']
npm pkg delete devDependencies['eslint-plugin-prettier']
npm pkg delete devDependencies['eslint-plugin-qunit']

echo ""
echo "🗑️  Removing old ESLint config files..."

if [ -f ".eslintrc.js" ]; then
  rm .eslintrc.js
  echo "  → Removed .eslintrc.js"
fi

if [ -f ".eslintignore" ]; then
  rm .eslintignore
  echo "  → Removed .eslintignore"
fi

echo ""
echo "✅ Migration complete!"
echo ""
echo "📝 Next steps:"
echo "  1. Create eslint.config.mjs in your project root"
echo "  2. Make sure prettier (^3.6.2) is also present as a direct dependency"
echo "  3. Run: pnpm install"
echo "  4. Run: pnpm lint:js to verify the new config works"
echo ""
echo "📚 For detailed instructions, see: ./references/MIGRATION_GUIDE.md"
