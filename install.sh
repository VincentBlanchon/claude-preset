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

# Skills a installer (socle v2 + vincent-context + canvas/patterns)
SKILLS=(init-project design-flow feature take-your-time vincent-context canvas patterns)

# Creer les dossiers et copier les skills (tout le contenu : SKILL.md + scripts bundles comme serve.py)
echo "[1/4] Skills globaux..."
for skill in "${SKILLS[@]}"; do
  if [ -f "$SCRIPT_DIR/skills/$skill/SKILL.md" ]; then
    mkdir -p "$CLAUDE_DIR/skills/$skill"
    cp -R "$SCRIPT_DIR/skills/$skill/." "$CLAUDE_DIR/skills/$skill/"
    echo "  -> /$skill installe"
  else
    echo "  -> /$skill (skipped, source absent)"
  fi
done

# Copier la config globale (CLAUDE.md)
echo "[2/4] Config globale (CLAUDE.md)..."
cp "$SCRIPT_DIR/global/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "  -> ~/.claude/CLAUDE.md installe"

# Copier les hooks (depuis mai 2026)
echo "[3/4] Hooks scripts..."
if [ -d "$SCRIPT_DIR/hooks" ]; then
  mkdir -p "$CLAUDE_DIR/hooks"
  cp "$SCRIPT_DIR/hooks/git-diagnostic.sh" "$CLAUDE_DIR/hooks/git-diagnostic.sh"
  chmod +x "$CLAUDE_DIR/hooks/git-diagnostic.sh"
  echo "  -> ~/.claude/hooks/git-diagnostic.sh installe"
  chmod +x "$SCRIPT_DIR/hooks/"*.sh
  echo "  -> claude-preset/hooks/*.sh executables"
else
  echo "  -> dossier hooks absent (skip)"
fi

# Store de patterns transversaux (ne PAS ecraser les .md existants)
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
echo "Pour verifier : claude et tape /init-project, /design-flow, /canvas, /patterns, /take-your-time, /vincent-context"
