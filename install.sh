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
SKILLS=(init-project design-flow feature take-your-time canvas challenge patterns)

# Creer les dossiers et copier les skills (tout le contenu : SKILL.md + scripts bundles)
echo "[1/3] Skills globaux..."
for skill in "${SKILLS[@]}"; do
  mkdir -p "$CLAUDE_DIR/skills/$skill"
  cp -R "$SCRIPT_DIR/skills/$skill/." "$CLAUDE_DIR/skills/$skill/"
  echo "  -> /$skill installe"
done

# Copier la config globale (CLAUDE.md)
echo "[2/3] Config globale (CLAUDE.md)..."
cp "$SCRIPT_DIR/global/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "  -> ~/.claude/CLAUDE.md installe"

# Installer les scripts de hooks (le cablage dans settings.json reste manuel/explicite)
echo "[3/4] Hooks..."
if [ -d "$SCRIPT_DIR/global/hooks" ]; then
  mkdir -p "$CLAUDE_DIR/hooks"
  cp "$SCRIPT_DIR/global/hooks/"*.sh "$CLAUDE_DIR/hooks/" 2>/dev/null || true
  chmod +x "$CLAUDE_DIR/hooks/"*.sh 2>/dev/null || true
  echo "  -> scripts de hooks copies dans ~/.claude/hooks/"
fi

# Installer le store de patterns transversaux (ne PAS ecraser les .md existants — uniquement ajouter le README)
echo "[4/4] Patterns transversaux..."
if [ -d "$SCRIPT_DIR/global/patterns" ]; then
  mkdir -p "$CLAUDE_DIR/patterns"
  cp -n "$SCRIPT_DIR/global/patterns/"*.md "$CLAUDE_DIR/patterns/" 2>/dev/null || true
  echo "  -> ~/.claude/patterns/ pret (store cross-projet)"
fi

echo ""
echo "=== Installation terminee ==="
echo ""
echo "Skills installes :"
for skill in "${SKILLS[@]}"; do
  echo "  /$skill"
done
echo ""
echo "Pour verifier : claude et tape /init-project, /design-flow ou /take-your-time"
