---
name: up-w-conf-eslint-migration
description: "Automates migration of Upfluence projects from legacy ESLint (.eslintrc) to the new flat config using @upfluence/w-conf. Use when: migrating eslint to w-conf, updating eslint config, preparing an Upfluence project for ESLint v10+, converting legacy ESLint setups."
argument-hint: "Project path (e.g., 'ember-identity' or './path/to/project') and optional mode flag (--mode=local or --mode=production; defaults to local)"
user-invocable: true
---

# Upfluence w-conf ESLint Migration

Automates the conversion of Upfluence projects from the legacy `.eslintrc.js` format to ESLint's modern flat config with `@upfluence/w-conf`. This skill handles dependency updates, file generation, and cleanup.

## When to Use

- Migrating an Upfluence Ember addon or web app to use w-conf ESLint config
- Updating an older project to ESLint v10+ flat config format
- Standardizing ESLint setup across Upfluence projects
- Removing legacy ESLint plugins that are now bundled in w-conf

## Modes

**Local Mode** (default, `--mode=local`)

- Links to `../w-conf` for local development/testing
- Use when testing changes to w-conf itself alongside your project
- Faster iteration on config changes

**Production Mode** (`--mode=production`)

- Installs `@upfluence/w-conf` from npm registry
- Use for stable production deployments
- Recommended for CI/CD and team deployments

## Procedure

### Phase 1: Pre-flight Checks

1. Verify the project has an existing `.eslintrc.js` file
2. Confirm `package.json` exists and is valid
3. Check if `@upfluence/w-conf` is already listed in `devDependencies`

### Phase 2: Update Dependencies

1. Add/update `@upfluence/w-conf` based on mode:
   - **Local mode** (default): `link:../w-conf`
   - **Production mode**: Latest npm version (e.g., `^0.3.0`)
2. Update `eslint` to v10+: `^10.0.0`
3. Remove legacy ESLint packages that w-conf bundles:
   - `@typescript-eslint/parser`
   - `@typescript-eslint/eslint-plugin`
   - `eslint-config-prettier`
   - `eslint-plugin-ember`
   - `eslint-plugin-node` (or `eslint-plugin-n`)
   - `eslint-plugin-prettier`
   - `eslint-plugin-qunit`
   - `@trivago/prettier-plugin-sort-imports` (if present)

### Phase 3: Generate New Config

1. Create `eslint.config.mjs` using the w-conf `buildConfiguration()` function
2. Preserve existing ignore patterns from `.eslintignore` and `.eslintrc.js`
3. Configure `nodeFiles` patterns for config/build files
4. Set up custom `ignores` for project-specific directories (dist, tmp, vendor, etc.)

### Phase 4: Cleanup

1. Delete `.eslintrc.js`
2. Delete `.eslintignore` (no longer needed with flat config)

### Phase 5: Verification

1. Verify `eslint.config.mjs` syntax is valid
2. Confirm no leftover ESLint v7 config files
3. Check that `package.json` has correct dependency versions

## Configuration Template

Use the template in `./assets/eslint.config.template.mjs` as a reference. Key patterns:

```javascript
// @ts-check
import { defineConfig } from 'eslint/config';
import { buildConfiguration } from '@upfluence/w-conf/eslint';

export default defineConfig(
  ...buildConfiguration({
    ignores: ['dist/', 'vendor/', 'node_modules/', ...],
    nodeFiles: ['ember-cli-build.js', 'config/**/*.js', ...]
  })
);
```

## Constraints

- **ESLint version:** Must be v10.0.0 or higher (flat config required)
- **Node files:** List all config/build files that shouldn't be linted as browser code
- **Mode flag:** Use `--mode=local` (default) for testing or `--mode=production` for npm-based installs
- **Local mode:** Requires `../w-conf` directory to exist relative to the project
- **No mixing:** Do not keep both `.eslintrc.js` and `eslint.config.mjs` in the same project

## Reference

See `./references/MIGRATION_GUIDE.md` for detailed step-by-step instructions and troubleshooting.

See `./references/W_CONF_README.md` for the official w-conf ESLint documentation.
