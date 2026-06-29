# @upfluence/w-conf ESLint Configuration

From the official w-conf README - ESLint section

## ESLint: Shared Flat Config

A shared flat ESLint config (ESLint ≥ 10) for Upfluence Ember apps/addons.

It includes:

- `eslint:recommended`
- `eslint-plugin-ember` (+ `emberCompatibilityDisables`)
- `typescript-eslint` (`recommended`, untyped)
- `eslint-plugin-qunit` for tests
- `eslint-plugin-n` for node/config files
- `eslint-config-prettier`

### Why w-conf?

The ESLint export bundles its plugins and presets as package dependencies. In consumer repositories, the minimal install is:

```bash
pnpm add -D @upfluence/w-conf eslint
```

When migrating from legacy `.eslintrc`, you can remove:

```bash
pnpm remove @typescript-eslint/parser @typescript-eslint/eslint-plugin
```

### Basic Usage

Create an `eslint.config.mjs` at the root of your project.

By default, the package exports a standard, zero-config resolved array:

```js
// @ts-check
import { defineConfig } from 'eslint/config';
import upfluence from '@upfluence/w-conf/eslint';

export default defineConfig(...upfluence);
```

### Customization with buildConfiguration

To customize globs/ignores, use `buildConfiguration`:

```js
import { defineConfig } from 'eslint/config';
import { buildConfiguration } from '@upfluence/w-conf/eslint';

export default defineConfig(
  ...buildConfiguration({
    ignores: ['dist/', 'declarations/', 'coverage/', 'my-custom-unlinted-folder/'],
    testFiles: ['packages/*/tests/**/*-test.{js,ts}'],
    nodeFiles: ['ember-cli-build.js', 'config/**/*.js', 'gulpfile.js']
  })
);
```

Note: `.ts` files are linted by default — no `--ext` flag needed.

> Note: `.ts` files are linted via `typescript-eslint` with its `recommended`
> (untyped) preset. Type-aware linting (`recommendedTypeChecked`) is intentionally
> deferred.

### Advanced: Named Exports for Composition

For advanced composition (monorepos, custom blocks), use named exports and keep
`eslintConfigPrettierPlaceLast` last:

```js
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
  ...qunitTests(['packages/*/tests/**/*-test.{js,ts}']),
  ...nodeFiles(),
  eslintConfigPrettierPlaceLast
);
```

## API Reference

### buildConfiguration(options)

**Options:**

```ts
interface BuildConfigurationOptions {
  ignores?: string[];      // Glob patterns to ignore
  testFiles?: string[];    // Glob patterns for test files (optional)
  nodeFiles?: string[];    // Glob patterns for Node/config files
}
```

**Returns:** Array of ESLint flat config objects

### Named Exports

- `core` - ESLint recommended rules
- `emberConfig` - Ember plugin configuration
- `javascript` - JavaScript/ES6 rules
- `typescript` - TypeScript rules via typescript-eslint
- `qunitTests(pattern)` - QUnit test rules for specified test files
- `nodeFiles(pattern)` - Node/CommonJS rules for config files
- `DEFAULT_IGNORES` - Standard ignore patterns
- `eslintConfigPrettierPlaceLast` - Prettier config (must be last)

## References

- ESLint Flat Config: https://eslint.org/docs/latest/use/configure/configuration-files-new
- typescript-eslint: https://typescript-eslint.io/
- eslint-plugin-ember: https://github.com/ember-best-practices/eslint-plugin-ember
- Linear Issue: https://linear.app/upfluence/issue/CD-205/introduce-shared-eslint-configuration
- Audit: https://linear.app/upfluence/issue/CD-249/w-conf-package-ships-with-a-shared-eslint-config-projectsaddons-can
