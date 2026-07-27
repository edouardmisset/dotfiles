---
name: up-w-conf-eslint-migration
description: "Automates migration of Upfluence projects from legacy ESLint (.eslintrc) to the new flat config using @upfluence/w-conf, then iteratively cleans up surfaced rule violations rule-by-rule. Use when: migrating eslint to w-conf, updating eslint config, preparing an Upfluence project for ESLint v10+, converting legacy ESLint setups, cleaning up lint violations surfaced by a new config."
argument-hint: "Project path (e.g., 'ember-identity' or './path/to/project')"
user-invocable: true
---

# Upfluence w-conf ESLint Migration

Automates the conversion of Upfluence projects from the legacy `.eslintrc.js` format to ESLint's modern flat config with `@upfluence/w-conf`. This skill handles dependency updates, file generation, and cleanup.

## When to Use

- Migrating an Upfluence Ember addon or web app to use w-conf ESLint config
- Updating an older project to ESLint v10+ flat config format
- Standardizing ESLint setup across Upfluence projects
- Removing legacy ESLint plugins that are now bundled in w-conf
- Cleaning up the rule violations a new/stricter config surfaces, without one giant unreviewable commit

## Part 1: Base Migration (.eslintrc.js → eslint.config.mjs)

Installs `@upfluence/w-conf` from the npm registry and swaps the legacy `.eslintrc.js`/`.eslintignore`
setup for a flat `eslint.config.mjs`. This is always done against the published npm version — there is
no local-link mode.

### Procedure

#### Phase 1: Pre-flight Checks

1. Verify the project has an existing `.eslintrc.js` file
2. Confirm `package.json` exists and is valid
3. Check if `@upfluence/w-conf` is already listed in `devDependencies`

#### Phase 2: Update Dependencies

1. Add/update `@upfluence/w-conf` to the latest published npm version (e.g., `^0.3.0`) in `devDependencies`
2. Keep `eslint` and `prettier` as direct deps in the consuming project (they remain w-conf `peerDependencies`), updating `eslint` to satisfy `>=10.5.0`
3. Remove legacy packages that w-conf now bundles as its own `dependencies` (no longer needed in the consuming project):
   - `@typescript-eslint/parser`
   - `@typescript-eslint/eslint-plugin`
   - `eslint-config-prettier`
   - `eslint-plugin-ember`
   - `eslint-plugin-node` (or `eslint-plugin-n`)
   - `eslint-plugin-prettier`
   - `eslint-plugin-qunit`

#### Phase 3: Generate New Config

1. Create `eslint.config.mjs` using the w-conf `buildConfiguration()` function
2. Preserve existing ignore patterns from `.eslintignore` and `.eslintrc.js`
3. Configure `nodeFiles` patterns for config/build files
4. Set up custom `ignores` for project-specific directories (dist, tmp, vendor, etc.)

#### Phase 4: Cleanup

1. Delete `.eslintrc.js`
2. Delete `.eslintignore` (no longer needed with flat config)

#### Phase 5: Verification

1. Verify `eslint.config.mjs` syntax is valid
2. Confirm no leftover ESLint v7 config files
3. Check that `package.json` has correct dependency versions

### Configuration Template

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

### Constraints

- **ESLint version:** Must satisfy w-conf's `peerDependencies` range (`>=10.5.0`, flat config required)
- **Dependency ownership:** `eslint` and `prettier` stay as direct deps of the consuming project (peer deps of w-conf); all ESLint plugins/parsers (`typescript-eslint`, `eslint-plugin-ember`, `eslint-plugin-n`, `eslint-plugin-qunit`, `eslint-config-prettier`, etc.) are owned and versioned by w-conf as its own `dependencies` — do not add them to the consuming project
- **Node files:** List all config/build files that shouldn't be linted as browser code
- **Always production:** Install `@upfluence/w-conf` from the npm registry — there is no local-link mode
- **No mixing:** Do not keep both `.eslintrc.js` and `eslint.config.mjs` in the same project

## Part 2: Iterative Rule-by-Rule Violation Cleanup

After Part 1 lands, the stricter/bundled w-conf rules typically surface pre-existing violations across
the codebase. Fix them incrementally — one rule per commit, in descending order of violation count —
rather than in one large, hard-to-review commit.

### When to Use

- Right after completing Part 1, when `pnpm lint:js` reports violations that didn't exist under the legacy config
- Any time a config change (new rule, stricter setting) surfaces a backlog of violations to pay down

### Procedure

0. **Commit 0 — auto-fix pass**
   - Run `pnpm lint:js:fix` (or `eslint . --fix`) to resolve every auto-fixable violation in one shot.
   - Stage and commit this alone, before any manual fixing begins: `fix(lint): apply eslint --fix auto-fixes`
1. **Get violation counts per rule**
   - Run `./scripts/eslint-summary.zsh` (bundled with this skill) to tally violations by rule name, sorted descending
   - Requires `pnpm`, `jq`, and `column` on `PATH`
   - Sort rules descending by count
2. **Loop through rules, most frequent first**
   - Pick the single most frequent remaining rule
   - Fix every violation of *that rule only* — no drive-by fixes of other rules in the same pass
   - Choose the correct semantic fix per call site rather than a blind find/replace (e.g. `assert.strictEqual` vs `assert.deepEqual` depends on the value types being compared)
   - Re-run lint and confirm this rule's count is 0 and no other rule regressed
   - Stage the changes (`git add -A`)
   - **Stop and ask the user for approval before committing**
   - Once approved, commit as: `fix(lint): resolve <rule-name> violations`
   - Repeat with the next most frequent rule
3. **Threshold: group the tail into one final pass**
   - As soon as the next rule's count is **<= 3**, stop processing rules individually
   - Group that rule together with every remaining (smaller) rule into a single final pass
   - Fix them all, verify with a full lint run (0 errors expected), stage, and **stop for one last approval**
   - Commit as: `fix(lint): resolve remaining rule violations (<rule1>, <rule2>, ...)`
4. **Final verification**
   - Run the full lint suite (JS + template linting, e.g. `pnpm lint`) to confirm no regressions across the whole cleanup

### Commit Message Convention

- Commit 0: `fix(lint): apply eslint --fix auto-fixes`
- Per-rule commits: `fix(lint): resolve <rule> violations`
- Final combined commit: `fix(lint): resolve remaining rule violations (<rule1>, <rule2>, ...)`

### Constraints

- Never batch multiple high-count rules into a single non-final commit — one rule, one commit
- Only the tail of rules with count **<= 3** may be grouped, and only into the single final commit
- Always stop and get explicit user approval before every commit — do not chain commits automatically
- Re-verify (rule-count script or full lint run) after every pass, before staging
- Do not fix unrelated rules while working a given pass, even if they're trivial

## Reference

See `./references/MIGRATION_GUIDE.md` for detailed step-by-step instructions and troubleshooting.

See `./references/W_CONF_README.md` for the official w-conf ESLint documentation.
