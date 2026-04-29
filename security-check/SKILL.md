---
name: security-check
description: >
  Non-blocking security analysis that scans modified files for common vulnerability patterns.
  Trigger: During sdd-verify, after code changes, or when explicitly requested. Never during sdd-apply.
license: Apache-2.0
metadata:
  author: atarico
  version: "1.0"
  based-on: Anthropic security-guidance plugin (Apache-2.0)
---

## When to Use

Use this skill when:
- Running sdd-verify after implementation is complete
- Explicitly asked to check security in modified files
- Reviewing a PR for security issues before merge

**Never activate during sdd-apply** — analysis happens after code is written, not while writing it.

---

## Protocol

### Step 1 — Identify Scope

Collect the list of files modified in the current task, PR, or session.
If no list is available, ask the user which files to scan.

### Step 2 — Scan for Patterns

For each file, check for the 9 vulnerability patterns below.
Read file contents only when a pattern match is suspected based on file type.

### Step 3 — Classify Findings

For each match, determine severity:

| Level | Condition |
|-------|-----------|
| **CRITICAL** | Pattern present AND input comes from an external/untrusted source (user input, API response, env var, request body) |
| **WARNING** | Pattern present, risk depends on context — needs human review |
| **INFO** | Pattern present but likely intentional and safe — document the intent |

### Step 4 — Produce Report

```
## Security Check

Files scanned: N
Issues found: N

### CRITICAL
- [file:line] dangerouslySetInnerHTML with unsanitized user input
  → Use DOMPurify or textContent instead

### WARNING
- [file:line] eval() detected
  → Verify input is not user-controlled. If needed, document why.

### INFO
- [file:line] pickle used for internal serialization
  → Acceptable if data source is internal only. Consider adding a comment.

---
No blocking — review findings and decide next steps.
```

**Never block execution.** This skill reports only.

---

## The 9 Patterns

### 1. GitHub Actions Workflow Injection
**File**: `.github/workflows/*.yml` or `*.yaml`
**Risk**: Untrusted input (issue title, PR body, commit message) used directly in `run:` commands.
**Safe pattern**:
```yaml
env:
  TITLE: ${{ github.event.issue.title }}
run: echo "$TITLE"   # ✓ env var, not direct interpolation
```
**Risky inputs**: `github.event.issue.title`, `github.event.pull_request.body`,
`github.event.comment.body`, `github.head_ref`, `github.event.commits.*.message`

### 2. child_process.exec / execSync (Node.js)
**Pattern**: `child_process.exec(`, `exec(`, `execSync(`
**Risk**: Shell injection if string contains user-controlled input.
**Safer alternative**: `execFile()` — separates command from arguments, prevents shell injection.

### 3. new Function()
**Pattern**: `new Function(`
**Risk**: Executes arbitrary code from a string. Equivalent to eval().
**Fix**: Redesign to avoid dynamic code evaluation.

### 4. eval()
**Pattern**: `eval(`
**Risk**: Executes arbitrary code. Major attack surface.
**Fix**: Use `JSON.parse()` for data, redesign logic to avoid code evaluation.

### 5. dangerouslySetInnerHTML (React)
**Pattern**: `dangerouslySetInnerHTML`
**Risk**: XSS if content comes from user input or external data.
**Fix**: Sanitize with DOMPurify, or use `textContent` / safe DOM methods.

### 6. document.write
**Pattern**: `document.write`
**Risk**: XSS and performance issues.
**Fix**: Use `createElement()` + `appendChild()`.

### 7. innerHTML Assignment
**Pattern**: `.innerHTML =`, `.innerHTML=`
**Risk**: XSS if value contains unsanitized input.
**Fix**: Use `textContent` for plain text, DOMPurify for HTML.

### 8. pickle Deserialization (Python)
**Pattern**: `pickle`
**Risk**: Arbitrary code execution when deserializing untrusted data.
**Fix**: Use `json` or other safe serialization formats for external data.

### 9. os.system (Python)
**Pattern**: `os.system`, `from os import system`
**Risk**: Shell injection if arguments are user-controlled.
**Fix**: Use `subprocess.run()` with a list of arguments (no shell=True).

---

## Rules

- Scan AFTER implementation, never during apply
- Never block tool execution — report only
- Classify by actual risk context, not just pattern presence
- CRITICAL requires both: the pattern AND untrusted input flowing into it
- INFO is valid — some patterns are legitimate, document them
- Always recommend a specific fix, not just a warning
- Skip files that clearly can't contain these patterns (CSS, images, JSON data files)
