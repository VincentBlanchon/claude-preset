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

# Creer les dossiers si necessaire
mkdir -p "$CLAUDE_DIR/skills/init-project"
mkdir -p "$CLAUDE_DIR/skills/design-flow"

# Copier les skills globaux
echo "[1/3] Skills globaux..."
cp "$SCRIPT_DIR/skills/init-project/SKILL.md" "$CLAUDE_DIR/skills/init-project/SKILL.md"
echo "  -> /init-project installe"
cp "$SCRIPT_DIR/skills/design-flow/SKILL.md" "$CLAUDE_DIR/skills/design-flow/SKILL.md"
echo "  -> /design-flow installe"

# Copier la config globale (CLAUDE.md)
echo "[2/3] Config globale (CLAUDE.md)..."
cp "$SCRIPT_DIR/global/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "  -> ~/.claude/CLAUDE.md installe"

# Le skill /feature est un skill PROJET (pas global)
# Il est installe automatiquement par /init-project dans chaque nouveau projet
echo "[3/3] Skill /feature..."
echo "  -> /feature est un skill projet (installe par /init-project dans chaque projet)"
echo "  -> Copie de reference disponible dans skills/feature/SKILL.md"

echo ""
echo "=== Installation terminee ==="
echo ""
echo "Skills installes :"
echo "  /init-project  — Initialisation complete d'un nouveau projet"
echo "  /design-flow   — Pipeline UI en 5 etapes"
echo "  /feature       — Harness pipeline (installe par projet via /init-project)"
echo ""
echo "Pour verifier : claude et tape /init-project ou /design-flow"
