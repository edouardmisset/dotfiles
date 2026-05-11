---
name: generate-docs
description: "Generate comprehensive documentation for a codebase including API docs, architecture overview, and developer guide. Use when: generating documentation, writing API docs, documenting architecture, creating a developer guide, onboarding documentation."
argument-hint: "Scope or type of documentation to generate (optional, defaults to all three sections: API reference, architecture overview, and developer guide)"
---

# Generate Documentation

## When to Use

- Generating API documentation for a service or library
- Documenting system architecture for a team
- Creating a developer onboarding guide
- Producing comprehensive project documentation from scratch

## Procedure

### Step 1: Gather Context

- Identify the project type (API, library, web app, CLI, monorepo)
- Explore the project structure, entry points, and key modules
- Find existing documentation (README, inline docs, comments)
- Identify the target audience (new developers, API consumers, stakeholders)

### Step 2: Generate API Documentation

For each public endpoint or exported interface:

1. **Endpoint / Function signature** — Method, path, parameters, return type
2. **Description** — What it does in plain language
3. **Request format** — Required and optional parameters with types and constraints
4. **Response format** — Success and error response shapes with examples
5. **Usage examples** — Practical code snippets showing common use cases
6. **Limitations** — Rate limits, auth requirements, known caveats

### Step 3: Generate Architecture Documentation

Document the system design:

1. **High-level overview** — One paragraph explaining what the system does and how
2. **Component diagram** — List of major components and their responsibilities (use Mermaid if supported)
3. **Component interactions** — How components communicate (HTTP, events, shared state)
4. **Data flow** — How data moves through the system from input to output
5. **Design decisions** — Key architectural choices and their rationale (why X over Y)
6. **Constraints and limitations** — Technical debt, known limitations, scaling boundaries

### Step 4: Generate Developer Guide

Create practical onboarding documentation:

1. **Prerequisites** — Required tools, versions, and system dependencies
2. **Setup instructions** — Step-by-step from clone to running locally
3. **Project structure** — Directory layout with explanation of each major folder
4. **Development workflow** — How to make changes, run locally, and iterate
5. **Testing** — How to run tests, write new tests, and check coverage
6. **Common issues** — Troubleshooting steps for frequent problems

### Step 5: Assemble and Format

- Combine all sections into a single coherent markdown document
- Add a table of contents at the top
- Ensure consistent heading levels and formatting
- Cross-link between sections where relevant

## Output Format

```markdown
# <Project Name> Documentation

## Table of Contents

- [API Reference](#api-reference)
- [Architecture](#architecture)
- [Developer Guide](#developer-guide)

## API Reference

...

## Architecture

...

## Developer Guide

...
```

## Constraints

**Required (accuracy — always apply first):**

1. Base documentation on actual code — never invent endpoints or features that don't exist
2. Use concrete examples from the codebase (real file paths, real function names)
3. Do not document internal/private APIs unless explicitly requested

**Quality (apply after accuracy constraints are met):**

4. Keep language concise and scannable (bullet points over paragraphs where possible)
5. Include code snippets that are copy-paste runnable
6. If the project is too large for a single document, split by domain and note the split
