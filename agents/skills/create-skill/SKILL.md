---
name: create-skill
description: "Scaffold and author a new agent skill or agent in the dotfiles directory. Use when: creating a new skill, writing a skill, building a skill, authoring an agent, or setting up a workflow skill."
argument-hint: "Skill/agent name and brief description of what it should do"
---

# Skill & Agent Authoring

## Overview

This SOP guides you through creating, authoring, and validating a skill or standalone agent.

- **Skill** — a folder containing a `/SKILL.md` file, optionally with `/scripts`, `/references`, and `/assets` subdirectories. Most skills should be **SOPs** (step-by-step workflows) rather than pure reference documents.
- **Agent** — a standalone `.md` file with custom system instructions and execution permissions.

---

## Phase 1: Requirements Gathering & Planning

### 1. Gather Key Parameters

Before scaffolding, clarify the following with the user:

- **purpose** (required): What should the skill do?
- **skill_name** (required): Kebab-case identifier.
- **skill_type** (optional): `sop` (default) or `reference`.
- **structure needs**: Will it require utility scripts, templates, or separate references?

### 2. Name Verification

- **Formatting**: Lowercase alphanumeric + hyphens only (`pr-review`). 1-64 characters.
- **Collisions**: If the folder already exists in `~/.dotfiles/agents/skills/`, prompt for confirmation or a different name.

### 3. Determine Skill Type

| Signal                                                           | Type               | Structural Template                                        |
| :--------------------------------------------------------------- | :----------------- | :--------------------------------------------------------- |
| Contains sequential phases, dependencies, or a "how-to" process. | **SOP** (Standard) | Overview → Parameters → Steps → Examples → Troubleshooting |
| Independent rules, conventions, lookup tables, or style guides.  | **Reference**      | Principles with concrete BAD vs. GOOD pairs                |

---

## Phase 2: Directory & File Structure

Create the skill folder within `~/.dotfiles/agents/skills/<skill_name>/`. Maintain progressive disclosure to keep system prompts lean:

```
<skill-name>/
├── SKILL.md           # Core instructions (required, absolute entrypoint)
├── scripts/           # Utility scripts (for deterministic validations/formatting)
├── references/        # Deep-dive specs, long examples (if content > 500 lines)
└── assets/            # Templates, static data (optional)
```

**Constraints:**

- **No Duplicate Entrypoints**: MUST NOT include `README.md` inside a skill directory. `SKILL.md` is the sole entrypoint.
- **Keep it Leaf-level**: Keep references and assets at most one level deep.

---

## Phase 3: Drafting the Frontmatter

The frontmatter is the only portion loaded at baseline to evaluate whether the skill triggers.

```yaml
---
name: kebab-case-name
description: "One sentence overview of the capability. Use when: [first keyword], [second keyword]."
argument-hint: "Optional input guidance for the user"
---
```

**Description Rules:**

- **Format**: `[What it does] + [When to use it] + [Trigger keywords]`.
- **Length**: 1-1024 characters in third person.
- **Strictly No XML Brackets**: Never use `<` or `>` in raw frontmatter, as it breaks downstream parsing of XML system prompts.

---

## Phase 4: Writing Content

### SOP Style Structure

```markdown
# [Skill Title]

## Overview

[1-3 sentences: what this SOP does and when to use it]

## Parameters

- **param** (required|optional): Description and acquisition method

## Steps

### 1. [Step Name]

[Clear, actionable step with visible output/confirmation]

**Constraints:**

- MUST / SHOULD / MAY rules

## Examples

[Realistic, complex example showing trigger → parameters → execution → final output]

## Troubleshooting

### [Common Failure / Gap]

[Actionable remediation step]
```

### Reference Style Structure

````markdown
# [Convention Name]

## [Principle Name]

[Clarifying prose explaining the principle/convention]

BAD:

```typescript
// Anti-pattern
```
````markdown

GOOD:

```typescript
// Refactored clean code
```

````

### Content General Constraints
- **Competence Assumption**: Do not explain obvious language features. Focus instructions purely on the custom workflow or domain constraints.
- **Constraint Standards**: Use RFC 2119 keywords (`MUST`, `SHOULD`, `MAY`, `MUST NOT`). Negative constraints must state their reasoning.
- **Length Limit**: Keep `SKILL.md` under 500 lines. Offload lookup tables, verbose APIs, or massive examples into `./references/`.

---

## Phase 5: Agent Authoring (Standalone .md)

Standalone agents specialize in dedicated multi-step roles and reside in `~/dotfiles/agents/<name>.md`.

```yaml
---
description: Coordinates code reviews or testing using specialized subagents.
mode: subagent
permission:
  edit: ask
  bash:
    "git *": allow
---
# [Agent Role Title]

We are/You are the [Agent Name]. [Brief persona statement].

## Protocol
1. [Inbound trigger analysis]
2. [Step-by-step sequence]

## Constraints
- MUST NOT bypass validation checks.
````

---

## Phase 6: Validation & Verification

Always cross-reference against this final checklist before declaring a skill complete:

- [ ] Folder uses kebab-case matching `name` in frontmatter exactly.
- [ ] No XML angle brackets (`<` or `>`) exist in the frontmatter.
- [ ] No `README.md` in the skill folder.
- [ ] The description uses "Use when:" with at least 2 distinct trigger phrases.
- [ ] `SKILL.md` is under 500 lines.
- [ ] Contains at least one non-trivial, end-to-end example.
