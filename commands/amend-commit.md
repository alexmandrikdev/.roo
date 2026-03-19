---
description: Amend current changes to the latest commit and update the message
mode: commit-gen
---

Amend the current changes to the latest commit with these instructions:

1. **Analyze Current Changes**
   - Use `git status` to check staged and unstaged changes
   - Use `git diff --cached` to see what's currently staged
   - Use `git log -1` to see the current commit message

2. **Stage All Changes**
   - If there are unstaged changes, stage them with `git add -A`
   - Confirm what will be amended

3. **Review Current Commit Message**
   - Check if the existing commit message still accurately describes all changes
   - Determine if the message needs updating based on the new changes

4. **Generate Updated Commit Message**
   - Analyze the combined changes (original commit + new changes)
   - Generate a commit message following Conventional Commits specification
   - Ensure the message accurately describes the entire changeset
   - Keep the original type/scope if the changes are related, or update if significantly different

5. **Present for Review**
   - Show the current commit message
   - Show the proposed updated message
   - Explain what changed and why the message was updated (or kept the same)

6. **Execute Amend**
   - Once approved, execute: `git commit --amend -m "commit message"`
   - For multi-line messages, use appropriate formatting
   - Confirm the amendment was successful

**Important Considerations:**

- Preserve the semantic meaning of the original commit if changes are minor
- Update the commit type (feat, fix, etc.) if the nature of changes has shifted
- Warn if this will rewrite history on a shared branch
- Handle cases where there are no changes to amend gracefully
