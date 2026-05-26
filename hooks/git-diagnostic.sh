#!/usr/bin/env bash
# SessionStart hook : diagnostic git LOCAL pour projets multi-machine
# Pas de git fetch (reseau lent, 1-20s). Utilise juste le cache local.
# Pour fresh fetch, Vincent fait git pull/fetch manuellement.

# Detection projet vierge
if [ ! -f CLAUDE.md ] && [ ! -d .git ]; then
  echo "[PROJET VIERGE] Tape /init-project pour initialiser"
  exit 0
fi

# Si pas dans un repo git, skip
if [ ! -d .git ]; then
  exit 0
fi

cwd=$(pwd)

# Liste des projets multi-machine
case "$cwd" in
  /Users/vincentblanchon/Developer/Carriere*|\
  /Users/vincentblanchon/Developer/veille-tech*|\
  /Users/vincentblanchon/Developer/claude-preset*|\
  /Users/vincentblanchon/Developer/Perso/Carrière*|\
  /Users/vincentblanchon/Developer/Perso/Vie*)
    ;;
  *)
    exit 0
    ;;
esac

# Diagnostic LOCAL only (pas de fetch reseau, instantane)
ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo "0")
behind=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
dirty=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')

# N'affiche que si quelque chose merite l'attention (sinon silencieux)
if [ "$behind" -gt 0 ] || [ "$dirty" -gt 5 ]; then
  echo "[$(basename "$cwd")]"
  [ "$behind" -gt 0 ] && echo "  $behind commit(s) behind. git pull avant de travailler."
  [ "$ahead" -gt 0 ] && echo "  $ahead commit(s) ahead (unpushed)."
  [ "$dirty" -gt 5 ] && echo "  $dirty uncommitted change(s)."
fi

exit 0
