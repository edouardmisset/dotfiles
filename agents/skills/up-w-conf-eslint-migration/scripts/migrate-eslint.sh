#!/bin/bash
# Automated ESLint migration script for Upfluence projects
# Usage: ./scripts/migrate-eslint.sh <project-path> [--mode=local|--mode=production]
#
# Modes:
#   local      - Link to ../w-conf (for local development/testing) [default]
#   production - Install from npm registry (for production deployments)

set -e

PROJECT_PATH="${1:-.}"
MODE="${2:-local}"

# Parse mode flag
if [[ "$MODE" == --mode=* ]]; then
  MODE="${MODE#--mode=}"
fi

# Default to local mode
MODE="${MODE:-local}"

# Validate mode
if [[ ! "$MODE" =~ ^(local|production)$ ]]; then
  echo "❌ Error: Invalid mode '$MODE'. Must be 'local' or 'production'"
  exit 1
fi

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
echo "📦 Updating package.json dependencies (Mode: $MODE)..."

# Update w-conf based on mode
if [ "$MODE" = "local" ]; then
  if [ -d "../w-conf" ]; then
    echo "  → Using local w-conf link (../w-conf)"
    npm pkg set devDependencies['@upfluence/w-conf']='link:../w-conf'
  else
    echo "⚠️  Warning: ../w-conf directory not found"
    echo "  → Falling back to published npm version"
    npm pkg set devDependencies['@upfluence/w-conf']='^0.3.0'
  fi
elif [ "$MODE" = "production" ]; then
  echo "  → Using npm registry (production version)"
  npm pkg set devDependencies['@upfluence/w-conf']='^0.3.0'
fi

# Update ESLint to v10+
npm pkg set devDependencies.eslint='^10.0.0'

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
npm pkg delete devDependencies['@trivago/prettier-plugin-sort-imports']

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
echo "✅ Migration complete! (Mode: $MODE)"
echo ""
echo "📝 Next steps:"
echo "  1. Create eslint.config.mjs in your project root"
echo "  2. Run: pnpm install"
echo "  3. Run: pnpm lint:js to verify the new config works"
echo ""
echo "📚 For detailed instructions, see: ./references/MIGRATION_GUIDE.md"
