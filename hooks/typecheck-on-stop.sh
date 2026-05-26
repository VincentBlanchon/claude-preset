#!/usr/bin/env bash
# Hook Stop : verifie typecheck Next.js/TS avant de laisser Claude finir
# Si erreurs TS, exit 2 force Claude a continuer pour les corriger
# (au lieu de l'actuel `exit 0` qui le laisse declarer victoire en silence)
#
# A placer dans ~/Developer/claude-preset/hooks/typecheck-on-stop.sh
# Reference par les settings.json projet via :
#   "command": "bash ${HOME}/Developer/claude-preset/hooks/typecheck-on-stop.sh"
#
# Source : docs/consultant-claude-code-mai-2026.md section 3.3

# Skip si pas un projet Node/TS
if [ ! -f package.json ]; then
  exit 0
fi

# Skip si tsc pas installe
if ! command -v npx >/dev/null 2>&1; then
  exit 0
fi

# Run typecheck avec capture
output=$(npx --no-install tsc --noEmit 2>&1)
ec=$?

if [ $ec -ne 0 ]; then
  # Afficher les 15 dernieres lignes (utile pour Claude)
  echo "$output" | tail -15
  echo ""
  echo "[Stop hook] TypeScript errors detected. Fix before finishing." >&2
  exit 2
fi

exit 0
