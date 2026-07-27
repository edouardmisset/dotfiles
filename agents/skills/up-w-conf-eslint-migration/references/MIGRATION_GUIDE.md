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

```bash
cd your-project
bash path/to/migrate-eslint.sh .
```

The script will:

- Update eslint to ^10.5.0 (kept as a direct dep, since eslint/prettier remain peerDependencies of w-conf)
- Add/update @upfluence/w-conf to the latest published npm version
- Remove legacy plugins now bundled as w-conf's own `dependencies`
- Delete old config files

#### Option B: Manual

Update `package.json`:

```bash
# Install from npm registry
npm pkg set devDependencies['@upfluence/w-conf']='^0.3.0'

# Update ESLint (eslint/prettier remain direct deps — they're peerDependencies of w-conf)
npm pkg set devDependencies.eslint='^10.5.0'
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
```

### Step 3: Create New Config

Create `eslint.config.mjs` in your project root. Use your old `.eslintrc.js` and `.eslintignore` to guide the configuration:

**Template:**

```javascript
// @ts-check
import { defineConfig } from "eslint/config";
import { buildConfiguration } from "@upfluence/w-conf/eslint";

export default defineConfig(
  ...buildConfiguration({
    // Preserve your ignore patterns from .eslintignore
    ignores: [
      "blueprints/*/files/",
      "vendor/",
      "dist/",
      "tmp/",
      "node_modules/",
      "coverage/",
      // Add any custom patterns specific to your project
    ],
    // Files that should be linted with Node/CommonJS rules
    nodeFiles: [
      ".eslintrc.js",
      ".template-lintrc.js",
      "ember-cli-build.js",
      "index.js",
      "testem.js",
      "blueprints/*/index.js",
      "config/**/*.js",
      "tests/dummy/config/**/*.js",
    ],
  }),
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
import { defineConfig } from "eslint/config";
import { buildConfiguration } from "@upfluence/w-conf/eslint";

export default defineConfig(
  ...buildConfiguration({
    ignores: ["dist/", "vendor/"],
    nodeFiles: ["ember-cli-build.js", "config/**/*.js"],
  }),
  {
    // Custom rule overrides for your project
    files: ["addon/**/*.ts"],
    rules: {
      "ember/no-deprecated-methods": "warn",
    },
  },
);
```

### Advanced: Named Exports

For fine-grained control, import individual config blocks:

```javascript
import { defineConfig } from "eslint/config";
import {
  core,
  emberConfig,
  javascript,
  typescript,
  qunitTests,
  nodeFiles,
  DEFAULT_IGNORES,
  eslintConfigPrettierPlaceLast,
} from "@upfluence/w-conf/eslint";

export default defineConfig(
  ...DEFAULT_IGNORES,
  ...core,
  ...emberConfig,
  ...javascript,
  ...typescript,
  ...qunitTests(["tests/**/*-test.{js,ts}"]),
  ...nodeFiles(["config/**/*.js"]),
  eslintConfigPrettierPlaceLast,
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

## Part 2: Iterative Rule-by-Rule Violation Cleanup

Swapping in w-conf's bundled rules commonly surfaces a backlog of pre-existing violations that the
legacy config never caught (stricter TypeScript rules, `prefer-const`, QUnit assertion rules, etc.).
Rather than fixing everything in one sprawling commit, pay it down incrementally: one rule per commit,
most frequent first, with a standalone auto-fix commit first and a single grouped commit for the
long tail of low-count rules.

### Step 1: Auto-fix pass (Commit 0)

```bash
pnpm lint:js:fix
```

Stage and commit this on its own, before any manual fixing begins:

```bash
git add -A
git commit -m "fix: apply eslint --fix auto-fixes"
```

### Step 2: Tally violations by rule

Get a table of rule name → violation count, sorted descending, using the script bundled with this
skill (requires `pnpm`, `jq`, and `column` on `PATH`):

```bash
path/to/skill/scripts/eslint-summary.zsh
```

### Step 3: Fix the most frequent rule, verify, commit

For the single most frequent rule:

1. Fix every violation of that rule only — pick the correct semantic fix per call site (e.g.
   `assert.strictEqual` vs `assert.deepEqual`/`assert.propEqual` depending on what's being compared;
   don't blind find/replace)
2. Re-run the lint/summary command and confirm the rule's count is now 0 and nothing else regressed
3. `git add -A`
4. Stop and get explicit approval before committing
5. Commit as `fix: resolve <rule-name> violations`

Repeat for the next most frequent rule.

### Step 4: Group the tail (count <= 3) into one final commit

As soon as the next rule's count drops to **3 or fewer**, stop doing one-commit-per-rule. Instead,
fix that rule together with every remaining smaller rule in a single final pass, verify with a full
lint run (expect 0 errors), stage, get approval, and commit as:

```text
fix: resolve remaining rule violations (<rule1>, <rule2>, ...)
```

### Step 5: Final verification

```bash
pnpm lint
pnpm test
```

### Rules of the loop

- One rule per commit, except the final grouped pass for rules with count <= 3
- Never fix an unrelated rule while working a given pass
- Always stop for explicit user approval before every commit — never chain commits automatically
- Re-verify after each pass before staging

## Reference

- [w-conf README](./W_CONF_README.md)
- [ESLint Flat Config Documentation](https://eslint.org/docs/latest/use/configure/configuration-files-new)
- [typescript-eslint](https://typescript-eslint.io/)
