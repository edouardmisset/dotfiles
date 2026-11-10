---
name: up-snapshot
description: "Captures readable visual evidence for a pull request and adds approved images to its description. Use when: snapshotting visual PR changes, adding UI screenshots to a PR description, refreshing PR visual evidence."
argument-hint: "[PR URL or number; defaults to current PR] [optional route, component, or states]"
disable-model-invocation: true
---

# PR Visual Snapshots

## Overview

Capture the rendered UI affected by a pull request, split long previews into
readable images, and embed them in the PR description after user approval.
Default to the current PR. Silently skip PRs with no visual modifications.
This workflow is framework-independent and MUST NOT assume a particular app,
preview component, repository, or browser implementation.

## Parameters

- **PR** (optional): URL or repository-qualified number. Otherwise resolve the
  current branch's open PR with `gh pr view`.
- **Additional PRs** (optional): Explicit destinations supplied by the user.
  Related issues and companion PRs are context, not permission to publish there.
- **Visual scope** (optional): Route, component, viewport, or states to capture.
  Otherwise derive these from the PR diff and existing preview/test fixtures.

## Steps

### 1. Resolve the PR and gate on visual changes

1. Verify GitHub authentication and resolve each target's repository, PR number,
   URL, head branch, head SHA, and base branch.
2. Read the PR diff against its actual base. Check changed components, templates,
   styles, assets, and rendering behavior; a non-visual file can still affect UI.
3. If there are no visual modifications, MUST silently skip that PR: no capture,
   upload, PR edit, comment, or skip-status message. If all targets are skipped,
   stop without a user-facing response.
4. If the visual impact is genuinely uncertain, ask a focused question rather
   than silently treating uncertainty as no visual change.
5. If the current PR cannot be uniquely resolved, ask for a PR URL. MUST NOT
   create a PR or guess a destination because publication is PR-scoped.

### 2. Establish the rendered source and capture scope

1. Inspect worktree status and compare the local revision to the target PR head.
   Preserve existing edits. If captures would include unrelated or unpushed visual
   changes, disclose the mismatch and ask which revision to render before capture.
2. Inspect documented run commands and reuse an existing preview, story, dummy
   app, or test fixture covering the changes. Prefer deterministic sample data.
3. Identify the changed states and edge cases that need visual evidence, such as
   loading, errors, empty content, pending/resolved actions, and narrow layouts.
   If a whole preview was requested, inventory every scenario and include them
   all, not just those initially visible.
4. Use existing dependencies first. Only install or restore them after a
   missing-dependency failure or a necessary manifest change.
5. Reuse an appropriate running server or start a task-owned server. Check the
   actual listening URL from its output and verify readiness; do not assume port
   flags were forwarded correctly.
6. MUST NOT trigger real emails, purchases, destructive actions, or external
   mutations merely to obtain screenshots. Use fixtures or ask for a safe path.

### 3. Capture complete, readable images

1. Render the relevant UI in a browser. Wait for fonts, images, and rendering to
   settle. Disable animations for capture where supported without replacing a
   loading state with a different UI state.
2. Exclude unrelated app content, transient toasts, developer overlays, and
   browser chrome. Avoid exposing personal data or secrets.
3. Check both the configured viewport and the page's actual
   `window.innerWidth` / `window.innerHeight`. Embedded browsers may resize during
   capture. After viewport changes, wait for layout and recompute element bounds.
4. Prefer element screenshots of complete components or logical scenario groups.
   A scrollable container may still clip its children: verify the rendered
   content, not just its declared height or screenshot file dimensions.
5. MUST NOT publish a single extremely tall strip because GitHub scales it into
   unreadable text and capture tools may truncate it. Split at scenario
   boundaries, keeping each card, its heading, footer, controls, and borders
   intact. As a practical target, keep each image's height at or below 1.5 times
   its width; split further when readability requires it.
6. For a long gallery, capture individual complete scenarios at their original
   widths. MAY compose those captures into numbered, balanced panels using
   existing image tooling. Keep narrow-layout samples narrow and preserve text
   and image pixels; add padding or captions rather than stretching cards.
   Clarify that panels are a montage, not the app's original page layout.
7. MUST NOT redesign or alter component content just to fit a screenshot because
   the images must represent the PR. Prefer smaller capture scopes over changing
   the app or globally relaying out its DOM. Any necessary fixture/code changes
   require agreement and the repository's normal validation.
8. Use a task-specific temporary directory. Keep an ordered capture inventory:
   filename, label, included scenarios, dimensions, and relevant viewport.

### 4. Validate and obtain approval

1. Open and inspect every final image. Check all edges, first and last content,
   complete action rows, text legibility, blank regions, and unwanted overlays.
   Pixel dimensions alone do not prove completeness.
2. Compare the inventory with the intended scope. Confirm every requested
   scenario appears exactly where expected, including the final placeholder or
   empty state. Re-capture clipped, blank, or illegible images.
3. Present the final previews with concise captions and the exact target PRs.
   State whether the images are individual captures or composed panels.
4. MUST ask for approval before uploading images or editing descriptions.
   Capture approval MUST NOT be inferred from invoking this skill.
5. If the user requests changes, revise and revalidate the images, then ask
   again. If approval is declined, do not publish; retain local previews only if
   the user wants them.

### 5. Embed approved images in the PR description

1. Re-read the latest PR body immediately before editing to avoid overwriting
   another edit. Inspect repository PR templates, including
   `.github/pull_request_template.md` and `.github/PULL_REQUEST_TEMPLATE/`.
   Preserve existing template headings, comments, checklist items, ordering,
   prose, and validation evidence. Do not invent test results for a capture task.
2. Prefer the installed `gh` CLI. Check `gh pr edit --help` for native attachment
   support before assuming a limitation from the REST or MCP API.
3. Where supported, attach files directly to the description:

   ```sh
   rtk gh pr edit 42 --repo owner/repo \
     --attach '/absolute/path/panel-1.png#Preview 1: loading and error states' \
     --attach '/absolute/path/panel-2.png#Preview 2: resolved and narrow states'
   ```

   Without a body flag, this preserves the existing description and appends the
   attachments. For a labeled block or an update, prepare the latest body with
   only the snapshot block changed and use `--body-file` plus attachments.
   Verify how that installed CLI rewrites local Markdown image references.
4. Group images under a clearly labeled visual-snapshots subsection where the
   template permits. Use descriptive alt text and stable panel ordering.
   For repeat runs, replace this skill's existing snapshot block instead of
   duplicating it. Optional `<!-- up-snapshot:start -->` and
   `<!-- up-snapshot:end -->` markers can delimit the owned block.
5. MUST put screenshots in the description, not a conversation or review
   comment, because the description is the requested review surface.
   MUST NOT delete unrelated images or comments. Remove misplaced comments
   only with explicit permission or when correcting ones created in this run.
6. If CLI attachment support is unavailable, try the signed-in GitHub browser's
   PR-description editor and native file upload. Ask the user to sign in if
   needed. MUST NOT extract session cookies, expose tokens, or upload private
   screenshots to an unrelated service to work around authentication.
7. If neither supported path works, ask for guidance. MUST NOT silently create
   hosting branches, commits, releases, or comments as an alternative destination.
8. For multiple approved PRs, publish explicitly to each repository/PR.
   An upload may partially succeed: inspect the latest body before retrying,
   reuse successful attachments where appropriate, and avoid duplicates.

### 6. Verify persistence and clean up

1. Read each updated PR body and confirm the expected image count, order,
   captions, and persistent GitHub attachment links. Confirm that non-snapshot
   description content is preserved.
2. Where browser access is available, inspect the rendered description to verify
   image loading and legibility. Distinguish API verification from visual
   verification if browser access is unavailable.
3. Remove only task-owned temporary captures after successful publication.
   Stop only servers started for this task; leave pre-existing services alone.
4. Verify the worktree remains unchanged, or report intentional agreed changes.
5. Return concise links to the updated PR descriptions and the number of images.
   State any incomplete publication or verification explicitly.

## Example

User: `/up-snapshot` on a PR adding a reply panel, action states, and a long
preview gallery.

1. Resolve the current PR and confirm the diff has visual changes.
2. Inventory the gallery's scenarios and render its existing safe fixture.
3. Capture complete cards, including loading, error, empty, resolved, and narrow
   cases. Compose several numbered panels instead of one tall strip, preserving
   each original layout and keeping all action rows visible.
4. Inspect every panel and show the user the images with the destination PR.
5. After approval, add a visual-snapshots block to the latest PR description
   using native attachments; retain all template sections and prose.
6. Verify the uploaded images and unchanged description content, stop the
   task-owned server, clean temporary files, and return the PR link.

If the current PR instead changes only a non-rendering backend utility,
stop silently without screenshots or PR edits.

## Troubleshooting

- **Tall, blank, or truncated PNG:** Compare actual viewport and element bounds.
  Capture smaller complete elements that fit the real viewport, inspect each,
  and compose panels only after validating their source captures.
- **Clipped card footer:** Inspect overflow and scrolling in the rendered
  component. Re-capture the entire card; do not crop out missing controls.
- **Private PR shows 404 in the browser:** Verify the destination through `gh`,
  then use native CLI attachments or request browser sign-in. Do not guess URLs
  or treat access failure as a missing PR.
- **Render fails:** Report the specific blocker and try the repository's
  supported setup. Do not publish an error overlay as the requested UI.
- **PR body changed during capture:** Re-read it and apply only the approved
  snapshot update, preserving concurrent edits.
