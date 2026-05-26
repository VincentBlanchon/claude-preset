#!/bin/bash
# install.sh — Installe le preset Claude Code de Vincent sur cette machine
#
# Usage : ./install.sh
#
# Ce script copie les skills, la config globale, et les hooks dans ~/.claude/
# Il ne supprime rien, il ecrase uniquement les fichiers du preset.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "=== Claude Preset — Installation ==="
echo ""
echo "Source :      $SCRIPT_DIR"
echo "Destination : $CLAUDE_DIR"
echo ""

# Skills a installer (4 globaux + 1 socle vincent-context)
SKILLS=(init-project design-flow feature take-your-time vincent-context)

# Creer les dossiers et copier les skills
echo "[1/3] Skills globaux..."
for skill in "${SKILLS[@]}"; do
  if [ -f "$SCRIPT_DIR/skills/$skill/SKILL.md" ]; then
    mkdir -p "$CLAUDE_DIR/skills/$skill"
    cp "$SCRIPT_DIR/skills/$skill/SKILL.md" "$CLAUDE_DIR/skills/$skill/SKILL.md"
    echo "  -> /$skill installe"
  else
    echo "  -> /$skill (skipped, source absent)"
  fi
done

# Copier la config globale (CLAUDE.md)
echo "[2/3] Config globale (CLAUDE.md)..."
cp "$SCRIPT_DIR/global/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "  -> ~/.claude/CLAUDE.md installe"

# Copier les hooks (depuis mai 2026)
echo "[3/3] Hooks scripts..."
if [ -d "$SCRIPT_DIR/hooks" ]; then
  # Hooks utilises par les settings.json projet (referencent ce dossier)
  # Pas besoin de copier ailleurs, claude-preset/hooks/ est la source de verite

  # git-diagnostic.sh est aussi installe globalement pour le hook SessionStart de ~/.claude/settings.json
  mkdir -p "$CLAUDE_DIR/hooks"
  cp "$SCRIPT_DIR/hooks/git-diagnostic.sh" "$CLAUDE_DIR/hooks/git-diagnostic.sh"
  chmod +x "$CLAUDE_DIR/hooks/git-diagnostic.sh"
  echo "  -> ~/.claude/hooks/git-diagnostic.sh installe"

  # S'assurer que les scripts dans claude-preset/hooks/ sont executables
  chmod +x "$SCRIPT_DIR/hooks/"*.sh
  echo "  -> claude-preset/hooks/*.sh executables"
else
  echo "  -> dossier hooks absent (skip)"
fi

echo ""
echo "=== Installation terminee ==="
echo ""
echo "Skills installes :"
for skill in "${SKILLS[@]}"; do
  echo "  /$skill"
done
echo ""
echo "Hooks scripts disponibles :"
if [ -d "$SCRIPT_DIR/hooks" ]; then
  for hook in "$SCRIPT_DIR/hooks/"*.sh; do
    echo "  $(basename "$hook")"
  done
fi
echo ""
echo "Pour verifier : claude et tape /init-project, /design-flow, /take-your-time, ou /vincent-context"
