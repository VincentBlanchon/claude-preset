#!/bin/bash
# install.sh — Installe le preset Claude Code de Vincent sur cette machine
#
# Usage : ./install.sh
#
# Ce script copie les skills et la config globale dans ~/.claude/
# Il ne supprime rien, il ecrase uniquement les fichiers du preset.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "=== Claude Preset — Installation ==="
echo ""
echo "Source :      $SCRIPT_DIR"
echo "Destination : $CLAUDE_DIR"
echo ""

# Skills a installer
SKILLS=(init-project design-flow feature take-your-time)

# Creer les dossiers et copier les skills
echo "[1/2] Skills globaux..."
for skill in "${SKILLS[@]}"; do
  mkdir -p "$CLAUDE_DIR/skills/$skill"
  cp "$SCRIPT_DIR/skills/$skill/SKILL.md" "$CLAUDE_DIR/skills/$skill/SKILL.md"
  echo "  -> /$skill installe"
done

# Copier la config globale (CLAUDE.md)
echo "[2/2] Config globale (CLAUDE.md)..."
cp "$SCRIPT_DIR/global/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "  -> ~/.claude/CLAUDE.md installe"

echo ""
echo "=== Installation terminee ==="
echo ""
echo "Skills installes :"
for skill in "${SKILLS[@]}"; do
  echo "  /$skill"
done
echo ""
echo "Pour verifier : claude et tape /init-project, /design-flow ou /take-your-time"
