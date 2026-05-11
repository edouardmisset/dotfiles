---
name: create-skill
description: 'Scaffold a new agent skill in the dotfiles skills directory. Use when: creating a new skill, adding a skill, making a workflow skill, setting up a new automation.'
argument-hint: 'Skill name and brief description of what it should do'
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
description: '<What it does>. Use when: <trigger phrase 1>, <trigger phrase 2>, <trigger phrase 3>.'
argument-hint: '<What input the user should provide>'
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
- Always create in `~/.dotfiles/agents/skills/` (the canonical location)
- Folder name must exactly match the `name` field in frontmatter
- Description must include "Use when:" with specific trigger phrases
- SKILL.md body should stay under 500 lines; use `./references/` for large content
