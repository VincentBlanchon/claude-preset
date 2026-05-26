#!/usr/bin/env bash
# Hook SessionStart : diagnostic git pour projets multi-machine + detection projet vierge
# A placer dans ~/.claude/hooks/git-diagnostic.sh et ~/Developer/claude-preset/hooks/git-diagnostic.sh
# Source : docs/consultant-claude-code-mai-2026.md section 3.4

set -e

# Detection projet vierge (compatible avec le hook actuel de Vincent)
if [ ! -f CLAUDE.md ] && [ ! -d .git ]; then
  echo "[PROJET VIERGE] Tape /init-project pour initialiser"
  exit 0
fi

# Si pas dans un repo git, skip
if [ ! -d .git ]; then
  exit 0
fi

# Recupere le path courant
cwd=$(pwd)

# Liste des projets multi-machine (a etendre selon besoin)
multi_machine_projects=(
  "/Users/vincentblanchon/Developer/Carriere"
  "/Users/vincentblanchon/Developer/veille-tech"
  "/Users/vincentblanchon/Developer/claude-preset"
  "/Users/vincentblanchon/Developer/Perso/Carrière"
  "/Users/vincentblanchon/Developer/Perso/Vie"
)

# Verifie si on est dans un projet multi-machine
is_multi=false
for proj in "${multi_machine_projects[@]}"; do
  if [[ "$cwd" == "$proj"* ]]; then
    is_multi=true
    break
  fi
done

if [ "$is_multi" = "false" ]; then
  exit 0
fi

# Diagnostic affiche dans la session Claude
echo "[Multi-machine project: $(basename "$cwd")]"

# Fetch silencieux (ne plante pas si offline)
git fetch --quiet 2>/dev/null || {
  echo "  WARN: git fetch failed (offline?)"
  exit 0
}

# Status (gere absence d'upstream)
ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo "0")
behind=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
dirty=$(git status --porcelain | wc -l | tr -d ' ')

if [ "$behind" -gt 0 ]; then
  echo "  WARN: $behind commit(s) behind origin. Run: git pull"
fi
if [ "$ahead" -gt 0 ]; then
  echo "  INFO: $ahead commit(s) ahead of origin (unpushed)"
fi
if [ "$dirty" -gt 0 ]; then
  echo "  INFO: $dirty uncommitted change(s)"
fi
if [ "$behind" -eq 0 ] && [ "$ahead" -eq 0 ] && [ "$dirty" -eq 0 ]; then
  echo "  OK: synced with origin, clean"
fi

exit 0
