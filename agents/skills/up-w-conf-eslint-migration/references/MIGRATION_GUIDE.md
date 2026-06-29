# ESLint Migration Guide: Legacy to w-conf

This guide walks through migrating an Upfluence Ember project from the legacy `.eslintrc.js` format to the modern flat config using `@upfluence/w-conf`.

## Overview

**Before:** ESLint v7/8 with `.eslintrc.js`, separate plugins, `.eslintignore`
**After:** ESLint v10+ with flat config (`eslint.config.mjs`), bundled plugins from w-conf

## Why Migrate?

- ✅ Simpler configuration (w-conf bundles plugins)
- ✅ No need to install and manage individual ESLint plugins
- ✅ Standardized setup across all Upfluence projects
- ✅ Better TypeScript support out of the box
- ✅ Consistent rules and practices

## Step-by-Step Migration

### Understanding the Modes

**Local Mode** (default)
- Links to `../w-conf` using `link:` protocol
- Use when developing/testing changes to w-conf alongside your project
- Allows fast iteration on ESLint config changes
- ⚠️ Requires the `w-conf` directory to exist locally

**Production Mode**
- Installs `@upfluence/w-conf@^0.3.0` from npm registry
- Use for stable, team-wide, and CI/CD deployments
- Ensures everyone uses the same released version
- Recommended for production environments

### Step 1: Understand Your Current Setup

Examine your `.eslintrc.js`:
- What plugins are active? (ember, node, prettier, typescript, qunit)
- What ignore patterns are in `.eslintignore`?
- Any custom rules or overrides?

The w-conf config includes:
- `eslint:recommended`
- `eslint-plugin-ember`
- `typescript-eslint` (recommended, untyped)
- `eslint-plugin-qunit` for tests
- `eslint-plugin-n` for node files
- `eslint-config-prettier`

### Step 2: Update Dependencies

#### Option A: Automated (Using Script)

**Default (Local Mode):**
```bash
cd your-project
bash path/to/migrate-eslint.sh .
```

**Production Mode:**
```bash
cd your-project
bash path/to/migrate-eslint.sh . --mode=production
```

The script will:
- Update eslint to ^10.0.0
- Add/update @upfluence/w-conf (local link or npm version based on mode)
- Remove legacy plugins
- Delete old config files

#### Option B: Manual

Update `package.json`:

**Local Mode (for development/testing):**
```bash
# Link to local w-conf
npm pkg set devDependencies['@upfluence/w-conf']='link:../w-conf'

# Update ESLint
npm pkg set devDependencies.eslint='^10.0.0'
```

**Production Mode (for deployments):**
```bash
# Install from npm registry
npm pkg set devDependencies['@upfluence/w-conf']='^0.3.0'

# Update ESLint
npm pkg set devDependencies.eslint='^10.0.0'
```

Then remove old plugins:
```bash
npm pkg delete devDependencies['@typescript-eslint/parser']
npm pkg delete devDependencies['@typescript-eslint/eslint-plugin']
npm pkg delete devDependencies['eslint-config-prettier']
npm pkg delete devDependencies['eslint-plugin-ember']
npm pkg delete devDependencies['eslint-plugin-node']
npm pkg delete devDependencies['eslint-plugin-prettier']
npm pkg delete devDependencies['eslint-plugin-qunit']
npm pkg delete devDependencies['@trivago/prettier-plugin-sort-imports']
```

### Step 3: Create New Config

Create `eslint.config.mjs` in your project root. Use your old `.eslintrc.js` and `.eslintignore` to guide the configuration:

**Template:**

```javascript
// @ts-check
import { defineConfig } from 'eslint/config';
import { buildConfiguration } from '@upfluence/w-conf/eslint';

export default defineConfig(
  ...buildConfiguration({
    // Preserve your ignore patterns from .eslintignore
    ignores: [
      'blueprints/*/files/',
      'vendor/',
      'dist/',
      'tmp/',
      'node_modules/',
      'coverage/',
      // Add any custom patterns specific to your project
    ],
    // Files that should be linted with Node/CommonJS rules
    nodeFiles: [
      '.eslintrc.js',
      '.template-lintrc.js',
      'ember-cli-build.js',
      'index.js',
      'testem.js',
      'blueprints/*/index.js',
      'config/**/*.js',
      'tests/dummy/config/**/*.js'
    ]
  })
);
```

### Step 4: Clean Up Old Files

Delete the legacy config files:

```bash
rm .eslintrc.js
rm .eslintignore
```

### Step 5: Install and Verify

```bash
# Install dependencies
pnpm install

# Verify the config works
pnpm lint:js

# Fix any auto-fixable issues
pnpm lint:js:fix
```

## Custom Configuration

### Extending the Configuration

If you need to add project-specific rules, you can extend the base configuration:

```javascript
import { defineConfig } from 'eslint/config';
import { buildConfiguration } from '@upfluence/w-conf/eslint';

export default defineConfig(
  ...buildConfiguration({
    ignores: ['dist/', 'vendor/'],
    nodeFiles: ['ember-cli-build.js', 'config/**/*.js']
  }),
  {
    // Custom rule overrides for your project
    files: ['addon/**/*.ts'],
    rules: {
      'ember/no-deprecated-methods': 'warn'
    }
  }
);
```

### Advanced: Named Exports

For fine-grained control, import individual config blocks:

```javascript
import { defineConfig } from 'eslint/config';
import {
  core,
  emberConfig,
  javascript,
  typescript,
  qunitTests,
  nodeFiles,
  DEFAULT_IGNORES,
  eslintConfigPrettierPlaceLast
} from '@upfluence/w-conf/eslint';

export default defineConfig(
  ...DEFAULT_IGNORES,
  ...core,
  ...emberConfig,
  ...javascript,
  ...typescript,
  ...qunitTests(['tests/**/*-test.{js,ts}']),
  ...nodeFiles(['config/**/*.js']),
  eslintConfigPrettierPlaceLast
);
```

## Troubleshooting

### Issue: "Cannot find module '@upfluence/w-conf/eslint'"

**Cause:** Dependencies not installed after updating package.json

**Solution:**
```bash
pnpm install
```

### Issue: ESLint lints files it shouldn't (e.g., vendor files)

**Cause:** Ignore patterns not properly configured

**Solution:** Check `ignores` array in `eslint.config.mjs` matches your `.eslintignore`

### Issue: TypeScript files not being linted

**Solution:** Unlike the old config, flat config lints `.ts` files by default (no `--ext` flag needed). If not working, verify your `tsconfig.json` exists and is referenced correctly.

### Issue: "prettier/recommended" rules not applied

**Cause:** Prettier config must be last in the config array

**Solution:** Ensure `eslintConfigPrettierPlaceLast` is the final config block (it's included automatically with `buildConfiguration()`)

## Testing the Migration

After migration, verify everything works:

```bash
# Run ESLint
pnpm lint:js

# Run all linters
pnpm lint

# Run tests to ensure nothing broke
pnpm test
```

## Reference

- [w-conf README](./W_CONF_README.md)
- [ESLint Flat Config Documentation](https://eslint.org/docs/latest/use/configure/configuration-files-new)
- [typescript-eslint](https://typescript-eslint.io/)
