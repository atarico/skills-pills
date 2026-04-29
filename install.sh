#!/usr/bin/env bash
# install.sh — installs skills into all detected AI coding tools

set -e

SKILLS_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS=(code-review security-check frontend-design design-patterns)
INSTALLED=0

install_to() {
  local config_dir="$1"
  local tool_name="$2"

  if [ -d "$config_dir" ]; then
    local target="$config_dir/skills"
    mkdir -p "$target"
    for skill in "${SKILLS[@]}"; do
      ln -sf "$SKILLS_DIR/$skill" "$target/$skill"
    done
    echo "✓ $tool_name → $target"
    INSTALLED=$((INSTALLED + 1))
  fi
}

echo "Installing skills from: $SKILLS_DIR"
echo ""

install_to "$HOME/.claude"             "Claude Code"
install_to "$HOME/.config/opencode"    "OpenCode"
install_to "$HOME/.cursor"             "Cursor"
install_to "$HOME/.copilot"            "VS Code Copilot"
install_to "$HOME/.gemini"             "Gemini CLI"

echo ""
if [ "$INSTALLED" -eq 0 ]; then
  echo "No supported AI tools detected."
  echo "Manual install: copy any skill folder to your tool's skills directory."
  echo "  e.g. cp -r design-patterns ~/.claude/skills/"
else
  echo "Installed ${#SKILLS[@]} skills into $INSTALLED tool(s)."
  echo ""
  echo "If using gentle-ai, run /skill-registry in an active project to register them."
fi
