---
name: create-skill
description: "Scaffold a new agent skill in the dotfiles skills directory. Use when: creating a new skill, adding a skill, making a workflow skill, setting up a new automation."
argument-hint: "Skill name and brief description of what it should do"
---

# Create a New Skill

## When to Use

- Creating a new reusable workflow skill
- Converting a repetitive prompt into a skill

## Procedure

### Step 1: Clarify Requirements

Ask the user:

1. What does this skill do? (one sentence)
2. When should it be triggered? (list trigger phrases)
3. Does it need scripts, templates, or reference docs?
4. Should it be a slash command (`user-invocable: true`) or auto-discovered only?

### Step 2: Choose a Name

- Lowercase alphanumeric + hyphens only
- 1-64 characters
- Descriptive (e.g., `pr-review`, `deploy-staging`, `ember-component`)
- If the name is already taken by an existing folder in `~/.dotfiles/agents/skills/`, prompt the user to choose a different name
- If the name contains invalid characters (uppercase, spaces, special characters other than hyphens), ask the user to correct it before proceeding

### Step 3: Create the Folder Structure

Create in `~/.dotfiles/agents/skills/<skill-name>/`:

```
<skill-name>/
├── SKILL.md
├── scripts/      # (if needed)
├── references/   # (if large docs needed)
└── assets/       # (if templates needed)
```

### Step 4: Write SKILL.md

Follow this template:

```markdown
---
name: <skill-name>
description: "<One sentence: what the skill does, e.g. 'Summarizes pull request changes and gives structured feedback.'>. Use when: <concrete trigger phrase, e.g. 'reviewing a PR'>, <concrete trigger phrase, e.g. 'code review'>, <concrete trigger phrase, e.g. 'analyzing diffs'>."
argument-hint: "<What input the user should provide, e.g. 'PR number or URL'>"
---

# <Skill Title>

## When to Use

- <Scenario 1>
- <Scenario 2>

## Procedure

1. <Step 1>
2. <Step 2>
3. <Step 3>

## Constraints

- <Rule 1>
- <Rule 2>
```

### Step 5: Validate

- Confirm `name` in frontmatter matches folder name
- Confirm `description` contains trigger keywords
- Confirm SKILL.md is under 500 lines
- The skill is immediately available via symlinks (no restart needed)

## Constraints

**Required (must always be satisfied):**

1. Always create in `~/.dotfiles/agents/skills/` (the canonical location)
2. Folder name must exactly match the `name` field in frontmatter
3. Description must include "Use when:" followed by at least two specific trigger phrases

**Quality (apply after required constraints are met):**

4. SKILL.md body should stay under 500 lines; use `./references/` for large content
