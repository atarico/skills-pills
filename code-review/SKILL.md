---
name: code-review
description: >
  Deep pull request review using 5 parallel agents with confidence-based scoring.
  Trigger: When reviewing a pull request, after branch-pr creates a PR, or during sdd-verify.
license: Apache-2.0
metadata:
  author: atarico
  version: "1.0"
  based-on: Anthropic code-review plugin (Apache-2.0)
---

## When to Use

Use this skill when:
- Reviewing a pull request before merge
- Running sdd-verify after sdd-apply completes
- Evaluating risky refactors or new features
- Checking CLAUDE.md compliance on a contribution

---

## Protocol

### Phase 1 — Eligibility Check (Haiku agent)

Before reviewing, verify the PR is eligible:
- Not closed or merged
- Not a draft
- Not already reviewed by you in this session
- Not an automated/trivial PR (dependency bumps, formatting-only)

If ineligible, stop and explain why.

### Phase 2 — Context Gathering (Haiku agent)

Collect, but do NOT read file contents yet:
- List of CLAUDE.md files in the repo root and directories touched by the PR
- PR summary: title, description, linked issue, file paths changed

### Phase 3 — 5 Parallel Review Agents (Sonnet)

Launch all 5 simultaneously. Each returns a list of issues with a one-line reason per issue.

| Agent | Focus |
|-------|-------|
| **#1 — Standards** | Check all changes against CLAUDE.md rules. Note: not every CLAUDE.md rule applies to code review — focus on rules that govern the written output. |
| **#2 — Bugs** | Shallow scan for obvious bugs in the diff only. Avoid reading extra context. Focus on large bugs, skip nitpicks and linter issues. |
| **#3 — History** | Read git blame and recent commits for modified files. Surface bugs visible only with historical context. |
| **#4 — Past PRs** | Read previous PRs that touched these files. Check if past review comments apply to the current change. |
| **#5 — Comments** | Read inline code comments in modified files. Verify the PR follows any guidance written in those comments. |

### Phase 4 — Confidence Scoring (parallel Haiku agents, one per issue)

For each issue found in Phase 3, score confidence 0–100:

| Score | Meaning |
|-------|---------|
| 0 | False positive — doesn't survive light scrutiny, or pre-existing issue |
| 25 | Uncertain — might be real, hard to verify, or stylistic without explicit CLAUDE.md backing |
| 50 | Moderate — real issue but minor or infrequent in practice |
| 75 | High — verified real, likely to be hit, or directly in CLAUDE.md |
| 100 | Certain — confirmed, happens frequently, evidence is direct |

**Filter**: discard everything below 80.

### Phase 5 — Final Report

If no issues survive the filter: report clean with a one-line summary.

If issues remain, produce a structured report:

```
## Code Review

Found N issues:

1. <brief description>
   Reason: <CLAUDE.md rule cited / bug explanation / historical context>
   Location: <file path, line range>

2. ...
```

**Do NOT post to GitHub automatically.** Present the report and ask the user if they want to post it as a PR comment.

---

## Rules

- Always run the eligibility check first — never review closed, draft, or already-reviewed PRs
- Launch all 5 review agents in parallel, never sequentially
- Filter aggressively: only report issues with confidence ≥ 80
- Never check build signal or run tests — CI handles that
- Never report pre-existing issues on lines not touched by the PR
- Never auto-post to GitHub — present the report and wait for explicit instruction
- Cite and link every issue to its location (file + line)

---

## False Positive Guide

Do NOT report:
- Pre-existing issues on unmodified lines
- Things a linter/typechecker would catch (CI handles it)
- Nitpicks a senior engineer wouldn't call out in review
- General quality concerns (test coverage, docs) unless explicitly in CLAUDE.md
- CLAUDE.md rules that are silenced in code (e.g. lint-ignore comments)
- Intentional behavior changes that are clearly related to the PR's purpose
