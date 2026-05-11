---
name: document-review
description: "Review a written document (article, RFC, spec) for accuracy, consistency, completeness, and clarity. Use when: reviewing an article, reviewing an RFC, proofreading, checking document accuracy, reviewing a spec, reviewing technical writing."
argument-hint: "Path to the document or URL to review"
---

# Document Review

## When to Use

- Reviewing a blog post or article before publication
- Reviewing an RFC or technical spec before submission
- Proofreading documentation for accuracy and clarity
- Checking a spec for technical soundness and consistency

## Procedure

### Step 1: Identify Document Type

Determine the scope of review based on the document:

- **Article/Blog post** — Focus on accuracy, readability, and audience fit
- **RFC/Technical spec** — Focus on technical soundness, completeness, and cross-section consistency
- **General documentation** — Focus on clarity, correctness, and structure

### Step 2: Accuracy Review

1. **Factual claims** — Verify all claims are accurate. Flag anything unverifiable or potentially false
2. **Code examples** — Confirm code snippets are syntactically correct and would work as described
3. **Links** — Check that all URLs point to valid, real destinations (not 404s or placeholder URLs)
4. **Citations** — Verify references are from trustworthy sources. Suggest citations for unsupported claims
5. **Version accuracy** — Ensure version numbers, API references, and tool names are current

### Step 3: Consistency Review

1. **Terminology** — Is the same concept always referred to with the same term?
2. **Tone and voice** — Is the writing style consistent throughout?
3. **Formatting** — Are headings, lists, and code blocks used consistently?
4. **Cross-references** — Do internal references (section links, figure numbers) resolve correctly?

For RFCs specifically: 5. **Cross-section consistency** — Do frontend, backend, and common sections align? Are interfaces defined consistently across sections? 6. **Open questions** — Are all open questions explicitly called out? Are there implicit ones that should be raised?

### Step 4: Completeness Review

1. **Missing information** — Are there gaps where a reader would be left with unanswered questions?
2. **Edge cases** — Are boundary conditions and error scenarios addressed?
3. **Assumptions** — Are implicit assumptions made explicit?
4. **Scope** — Is the scope clearly defined? Are out-of-scope items noted?

For RFCs specifically: 5. **Migration plan** — Is there a clear path from current state to proposed state? 6. **Rollback strategy** — What happens if the change needs to be reverted?

### Step 5: Clarity Review

1. **Unclear phrases** — Flag sentences that are ambiguous or hard to parse
2. **Jargon** — Is domain-specific language explained or appropriate for the audience?
3. **Sentence structure** — Are sentences concise? Flag run-on sentences or excessive nesting
4. **Grammar and spelling** — Catch typos, grammatical errors, and awkward phrasing

### Step 6: Technical Soundness (RFCs/Specs only)

1. **Feasibility** — Is the proposed solution technically viable?
2. **Alternatives** — Were alternatives considered and dismissed with rationale?
3. **Security implications** — Are security considerations addressed?
4. **Performance implications** — Will the proposal introduce performance concerns?
5. **Backward compatibility** — Are breaking changes identified and justified?

### Step 7: Produce the Review

## Output Format

### Summary

One paragraph overall assessment: is the document ready, or does it need significant revision?

### Critical Issues

Issues that must be fixed before publication/approval:

- **[Location]**: Description of the issue and suggested fix

### Suggestions

Improvements that would strengthen the document:

- **[Location]**: Description and recommendation

### Minor / Nitpicks

Grammar, spelling, formatting:

- **[Location]**: Correction

### Questions for the Author

- Question that needs clarification before the document can be finalized

## Constraints

**Required (always apply, in order of precedence):**

1. Accuracy is paramount — never let false information pass without flagging; accuracy takes precedence over completeness
2. Always verify links point to real, valid URLs
3. Cite trustworthy sources when challenging a claim
4. Do not rewrite the document — provide specific, actionable feedback at specific locations
5. Distinguish between critical issues (must fix) and suggestions (nice to have)

**Quality (apply after required constraints are met):**

6. Keep feedback constructive and objective
7. For RFCs: perform a full review of the frontend sections (UI, client-side logic, component contracts) and common sections (shared types, API contracts, data models). For backend sections, review only for inconsistencies that affect the frontend/common interface (e.g., mismatched field names, incompatible types, missing endpoints) — do not perform a full backend review.
