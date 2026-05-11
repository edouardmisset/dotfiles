---
name: test-review
description: "Review test coverage and suggest comprehensive unit tests for a codebase. Use when: reviewing test coverage, suggesting tests, writing unit tests, identifying untested code, improving test quality, adding edge case tests."
argument-hint: "File or component to review/test (optional, defaults to entire codebase)"
---

# Test Review

## When to Use

- Identifying gaps in test coverage
- Suggesting new unit tests for a module or function
- Reviewing existing test quality and patterns
- Adding edge case and error scenario tests
- Recommending testing strategies for a project

## Procedure

### Step 1: Gather Context

- Identify the testing framework and conventions used in the project
- Locate existing test files and understand the test structure
- Understand the code under review (functions, classes, modules)
- Identify public interfaces vs. internal implementation details

### Step 2: Assess Current Coverage

1. **Untested components** — Which exported functions, classes, or modules have no corresponding tests?
2. **Partial coverage** — Which tested components only cover the happy path?
3. **Dead tests** — Are there tests that test removed or renamed functionality?
4. **Test organization** — Are tests co-located or in a separate tree? Is the structure consistent?

### Step 3: Evaluate Test Quality

For existing tests:

1. **Assertions** — Are assertions specific and meaningful (not just "doesn't throw")?
2. **Isolation** — Are tests independent of each other and external state?
3. **Readability** — Do test names describe the behavior being verified?
4. **Mocking** — Are mocks/stubs used appropriately (not over-mocking implementation details)?
5. **Determinism** — Are there flaky tests relying on timing, randomness, or external services?

### Step 4: Suggest New Tests

For each untested or under-tested component, propose tests covering:

1. **Happy path** — Normal expected usage with valid inputs
2. **Edge cases** — Boundary values, empty inputs, maximum values, single-element collections
3. **Error scenarios** — Invalid inputs, missing data, network failures, permission errors
4. **State transitions** — Before/after states for stateful operations
5. **Integration points** — Behavior at module boundaries and with external dependencies

### Step 5: Recommend Testing Strategy

Based on the project's needs:

1. **Unit vs. integration balance** — Where is each type most valuable?
2. **Test data management** — Factories, fixtures, or builders?
3. **Mocking strategy** — What to mock and what to test with real implementations?
4. **CI considerations** — Test parallelization, speed, and reliability

### Step 6: Produce the Review

## Output Format

### Coverage Gaps

| Component | File               | Current Coverage | Missing            |
| --------- | ------------------ | ---------------- | ------------------ |
| name      | `path/to/file.ext` | Happy path only  | Edge cases, errors |

### Test Quality Issues

- **[test file:line]**: Description of the quality issue and fix

### Suggested Tests

For each component:

#### `<function/class name>` in `<file path>`

```language
// Test: <descriptive name of what is being tested>
<test code skeleton>
```

Repeat for each suggested test case.

### Strategy Recommendations

- Prioritized list of testing improvements with rationale

## Constraints

**Required (always apply, in order of precedence):**

1. Use the project's existing testing framework and conventions
2. Test behavior, not implementation details — tests must survive internal refactoring without needing to change
3. Prioritize test suggestions in this order: critical paths → error handling → edge cases → exhaustive coverage

**Quality (apply after required constraints are met):**

4. Only suggest tests that validate critical functionality, edge cases, or error scenarios — skip tests for trivial getters/setters, obvious one-line wrappers, or pure delegation with no logic
5. Provide runnable test skeletons with correct imports and proper setup/teardown
6. Keep test names descriptive of the behavior: e.g., `"should reject expired tokens"` not `"test case 3"`
7. Do not suggest snapshot tests unless the output being snapshotted is genuinely meaningful to verify (e.g., a complex rendered structure, not a simple string)
