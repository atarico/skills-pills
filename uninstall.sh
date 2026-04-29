#!/usr/bin/env bash
# uninstall.sh — removes skill symlinks from all detected AI coding tools

set -e

SKILLS=(code-review security-check frontend-design design-patterns)
REMOVED=0

remove_from() {
  local config_dir="$1"
  local tool_name="$2"

  if [ -d "$config_dir/skills" ]; then
    for skill in "${SKILLS[@]}"; do
      local target="$config_dir/skills/$skill"
      if [ -L "$target" ]; then
        rm "$target"
        echo "✓ Removed $skill from $tool_name"
        REMOVED=$((REMOVED + 1))
      fi
    done
  fi
}

remove_from "$HOME/.claude"             "Claude Code"
remove_from "$HOME/.config/opencode"    "OpenCode"
remove_from "$HOME/.cursor"             "Cursor"
remove_from "$HOME/.copilot"            "VS Code Copilot"
remove_from "$HOME/.gemini"             "Gemini CLI"

echo ""
if [ "$REMOVED" -eq 0 ]; then
  echo "No skill symlinks found to remove."
else
  echo "Removed $REMOVED symlink(s)."
fi
