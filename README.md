# Claude Code Skills

4 production-grade skills for Claude Code, OpenCode, Cursor, VS Code Copilot, and Gemini CLI.

Designed to work standalone or as a complement to the [gentle-ai](https://github.com/gentleman-programming/gentle-ai) SDD stack.

---

## Skills

| Skill | Description |
|-------|-------------|
| `code-review` | Deep PR review using 5 parallel agents with confidence-based scoring |
| `security-check` | Non-blocking security analysis — reports vulnerabilities, never interrupts your workflow |
| `frontend-design` | Production-grade UI with intentional aesthetic direction, zero generic AI aesthetics |
| `design-patterns` | Detects code smells, proposes the right GoF pattern with tradeoffs, implements on confirmation |

---

## Installation

### All skills, all detected tools (recommended)

```bash
git clone https://github.com/atarico/skills.git
cd skills
bash install.sh
```

The script detects which AI tools you have installed and creates symlinks automatically.
Supported: Claude Code, OpenCode, Cursor, VS Code Copilot, Gemini CLI.

### Individual skill

```bash
ln -s "$(pwd)/design-patterns" ~/.claude/skills/design-patterns
```

### Manual copy (no symlinks)

```bash
cp -r design-patterns ~/.claude/skills/
```

---

## gentle-ai Integration

If you use the [gentle-ai](https://github.com/gentleman-programming/gentle-ai) SDD stack, run this after installing to register the skills with the orchestrator:

```
/skill-registry
```

The SDD orchestrator will then automatically inject the relevant skills into sub-agents:
- `security-check` → injected into `sdd-verify`
- `code-review` → injected into `sdd-verify` after `branch-pr`
- `frontend-design` → injected into `sdd-apply` for UI/frontend tasks
- `design-patterns` → available on demand in any phase

---

## Uninstall

```bash
bash uninstall.sh
```

---

## Credits

`code-review`, `security-check`, and `frontend-design` are adapted from Anthropic's official
Claude Code plugins, which are licensed under Apache 2.0. The logic has been converted from
commands/hooks to skills for better integration with multi-agent SDD workflows.

`design-patterns` is an original skill.

---

## License

Apache 2.0 — see [LICENSE](LICENSE).
