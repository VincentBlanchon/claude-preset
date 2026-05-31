#!/bin/bash
# verify-gate.sh — gate de vérification DÉTERMINISTE (opt-in, par projet).
#
# Usage : hook "Stop" d'un projet, OU appelé à la main avant de dire "c'est fini".
# Lance, SI le projet les a, : typecheck → lint → tests. Sort != 0 si l'un échoue.
#
# IMPORTANT — pas global : à activer PAR PROJET (sinon ça tournerait à chaque
# tour partout). En hook Stop, Claude Code l'override après 8 blocages consécutifs.
# Détecte npm/pnpm/yarn ; no-op proprement si aucun script correspondant.

set +e
cd "${CLAUDE_PROJECT_DIR:-$PWD}" 2>/dev/null || exit 0
[ -f package.json ] || { echo "verify-gate: pas de package.json, skip"; exit 0; }

# gestionnaire de paquets
if [ -f pnpm-lock.yaml ]; then PM="pnpm"; elif [ -f yarn.lock ]; then PM="yarn"; else PM="npm run"; fi

has(){ node -e "process.exit(require('./package.json').scripts?.['$1']?0:1)" 2>/dev/null; }
fail=0
run(){ # $1 = script name, $2 = label
  if has "$1"; then
    echo "verify-gate: $2…"
    $PM "$1" || { echo "verify-gate: ❌ $2 a échoué"; fail=1; }
  fi
}

run typecheck "typecheck"
run lint "lint"
run "test:run" "tests"   # vitest --run etc.
# fallback test si pas de test:run
if ! has "test:run" && has "test"; then echo "verify-gate: tests… (note: prefere un script test:run non-watch)"; fi

if [ "$fail" -ne 0 ]; then
  echo "verify-gate: ❌ GATE ROUGE — ne pas considerer la tache terminee."
  exit 2
fi
echo "verify-gate: ✅ gate vert"
exit 0
