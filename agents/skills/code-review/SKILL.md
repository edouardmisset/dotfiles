---
name: code-review
description: "Review a codebase for architecture, code quality, performance, and refactoring opportunities. Use when: reviewing code quality, architecture review, performance review, refactoring suggestions, assessing code health, evaluating code patterns."
argument-hint: "File, folder, entire codebase, or component to review (optional, defaults to the file currently open in the editor)"
---

# Code Review

## When to Use

- Evaluating a codebase's overall health and quality
- Reviewing architecture and design patterns
- Identifying performance bottlenecks
- Finding refactoring opportunities
- Assessing maintainability and scalability

## Procedure

### Step 1: Gather Context

- Identify the scope of the review (specific files, folder, or full codebase)
- Understand the project's tech stack, framework, and conventions
- Review the project structure and entry points

### Step 2: Architecture Review

Evaluate the overall structure and patterns:

1. **Module organization** — Are responsibilities clearly separated? Is there a consistent layering (e.g., controllers/services/repositories)?
2. **Dependency direction** — Do dependencies flow inward (toward domain logic)? Are there circular dependencies?
3. **Abstractions** — Are abstractions appropriate (not over-engineered, not leaky)?
4. **Scalability** — Can the architecture accommodate growth without major rewrites?
5. **Design patterns** — Are patterns used correctly and consistently?

### Step 3: Code Quality Review

Assess readability and maintainability:

1. **Naming conventions** — Are names descriptive, consistent, and following language idioms?
2. **Code organization** — Are files, functions, and classes appropriately sized and focused?
3. **Error handling** — Are errors handled gracefully? Are failure modes clear?
4. **Duplication** — Is there unnecessary code repetition? Are shared utilities extracted?
5. **Commenting** — Are complex sections documented? Are comments accurate and up-to-date?

### Step 4: Performance Review

Identify performance concerns:

1. **Algorithmic efficiency** — Are there O(n²) loops or unnecessary iterations that could be optimized?
2. **Resource utilization** — Are connections pooled? Are large objects disposed properly?
3. **Caching** — Are expensive computations or I/O results cached where appropriate?
4. **Bottlenecks** — Are there blocking operations, N+1 queries, or synchronous waits in hot paths?
5. **Memory** — Are there potential memory leaks, excessive allocations, or unbounded growth?

### Step 5: Refactoring Opportunities

Suggest concrete improvements:

1. **Extract** — Functions or classes that do too much
2. **Consolidate** — Repeated patterns that should be unified
3. **Simplify** — Over-complex logic that can be made clearer
4. **Modernize** — Outdated patterns that have better alternatives in the current stack

### Step 6: Produce the Review

Output a structured review organized by area.

## Output Format

### Architecture

| Aspect              | Assessment             | Details   |
| ------------------- | ---------------------- | --------- |
| Module organization | Good/Needs improvement | Specifics |
| ...                 | ...                    | ...       |

**Key findings:**

- Finding with specific file/location reference
- ...

### Code Quality

**Good patterns observed:**

- Specific example with file reference

**Issues found:**

- Issue with specific file/location and suggested fix

### Performance

**Potential bottlenecks:**

- Description with file/location and optimization suggestion

### Refactoring Suggestions

For each suggestion:

- **What**: Description of the change
- **Where**: Specific file(s) and location
- **Why**: Benefit (readability, performance, maintainability)
- **How**: Brief sketch of the refactored approach

## Constraints

**Primary (always apply):**

1. Always provide specific file paths and code references — never give generic advice without examples
2. Respect existing conventions — suggest improvements within the project's style, not personal preferences

**Secondary (apply within the bounds of the primary constraints):**

3. Prioritize findings by impact (high → low)
4. Distinguish between critical issues and nice-to-haves
5. Keep suggestions actionable and concrete
6. Do not suggest adding comments, docstrings, or type annotations unless they solve a real ambiguity
