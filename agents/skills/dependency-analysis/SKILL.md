---
name: dependency-analysis
description: "Analyze project dependencies for outdated packages, vulnerabilities, and optimization opportunities. Use when: checking dependencies, finding outdated packages, auditing packages, reviewing dependency health, suggesting package alternatives."
argument-hint: "Package manifest file path (optional, auto-detected from project root)"
---

# Dependency Analysis

## When to Use

- Checking for outdated or deprecated packages
- Auditing dependencies for known vulnerabilities
- Evaluating whether dependencies are justified
- Finding lighter or better-maintained alternatives
- Preparing for a major version upgrade

## Procedure

### Step 1: Identify Package Manifests

Locate dependency files:

- `package.json` / `package-lock.json` / `yarn.lock` / `pnpm-lock.yaml` (Node.js)
- `Gemfile` / `Gemfile.lock` (Ruby)
- `requirements.txt` / `pyproject.toml` / `Pipfile` (Python)
- `go.mod` (Go)
- `Cargo.toml` (Rust)
- `composer.json` (PHP)

### Step 2: Check for Outdated Packages

For each dependency:

1. Compare installed version against latest available version
2. Identify major version gaps (potential breaking changes)
3. Flag packages that are unmaintained (no release in 2+ years, archived repo)
4. Note packages with deprecation notices

### Step 3: Vulnerability Scan

1. Cross-reference dependencies with known CVE databases
2. Check for advisories in the package ecosystem (npm audit, GitHub advisories)
3. Identify transitive dependencies with known issues
4. Assess severity and exploitability in the context of this project

### Step 4: Usage Analysis

1. Identify unused dependencies (declared but never imported)
2. Flag heavy dependencies used for trivial functionality (e.g., pulling in lodash for one function)
3. Check for duplicate functionality across dependencies
4. Identify dependencies that could be replaced with built-in language features

### Step 5: Suggest Alternatives

For problematic dependencies, suggest alternatives based on:

- Active maintenance and community
- Bundle size / footprint
- API compatibility (ease of migration)
- Security track record

### Step 6: Produce the Report

## Output Format

### Outdated Packages

| Package | Current | Latest | Gap               | Risk              | Notes                           |
| ------- | ------- | ------ | ----------------- | ----------------- | ------------------------------- |
| name    | x.y.z   | a.b.c  | Major/Minor/Patch | Breaking changes? | Deprecation, maintenance status |

### Vulnerabilities

| Package | Version | CVE / Advisory | Severity | Fix Version | Exploitable Here? |
| ------- | ------- | -------------- | -------- | ----------- | ----------------- |

### Optimization Opportunities

| Package | Issue                          | Suggestion             | Impact                           |
| ------- | ------------------------------ | ---------------------- | -------------------------------- |
| name    | Unused / Oversized / Duplicate | Alternative or removal | Bundle size / maintenance burden |

### Upgrade Recommendations

Prioritized list of recommended actions:

1. **Immediate** — Security fixes and critical updates
2. **Short-term** — Major version upgrades with clear migration paths
3. **Consider** — Replacements and removals for long-term health

## Constraints

**Required (always apply):**

1. Always specify exact version numbers (current and recommended)
2. Respect lockfile integrity — suggest commands to update, not manual edits
3. Do not recommend removing dependencies without first verifying they are unused (not imported anywhere in the codebase)

**Quality (apply after required constraints are met):**

4. Only flag vulnerabilities in dependencies that are included in the project's dependency tree; exclude advisories that only apply to optional or peer dependencies the project does not install
5. Provide migration effort estimates (trivial / moderate / significant) for major upgrades
