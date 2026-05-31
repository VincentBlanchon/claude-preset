#!/usr/bin/env bash
# SessionStart hook : diagnostic git LOCAL pour les repos multi-machine de Vincent.
# PORTABLE : identifie les repos par leur REMOTE git (identique sur tous les Macs,
# quels que soient le username, le chemin ou le nom de dossier local).
# Pas de fetch reseau (instantane) : utilise le cache local. Silencieux sauf si action requise.

# Projet vierge -> proposer l'init
if [ ! -f CLAUDE.md ] && [ ! -d .git ]; then
  echo "[PROJET VIERGE] Tape /init-project pour initialiser"
  exit 0
fi

# Pas un repo git -> rien a diagnostiquer
[ -d .git ] || exit 0

# Repos multi-machine reconnus par leur remote origin (insensible a la casse).
# Pour inclure un repo : ajouter un motif sur le nom tel qu'il apparait dans l'URL du remote.
remote=$(git config --get remote.origin.url 2>/dev/null | tr '[:upper:]' '[:lower:]')
case "$remote" in
  *claude-preset*|*veille-tech*|*carriere*|*/vie|*/vie.git)
    ;;
  *)
    exit 0
    ;;
esac

# Diagnostic LOCAL uniquement (pas de reseau)
ahead=$(git rev-list --count '@{u}..HEAD' 2>/dev/null || echo 0)
behind=$(git rev-list --count 'HEAD..@{u}' 2>/dev/null || echo 0)
dirty=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')

# N'affiche que si quelque chose merite l'attention
if [ "${behind:-0}" -gt 0 ] || [ "${dirty:-0}" -gt 5 ]; then
  echo "[$(basename "$(pwd)")]"
  [ "${behind:-0}" -gt 0 ] && echo "  $behind commit(s) behind — git pull avant de travailler."
  [ "${ahead:-0}" -gt 0 ] && echo "  $ahead commit(s) ahead (unpushed)."
  [ "${dirty:-0}" -gt 5 ] && echo "  $dirty changement(s) non commit(s)."
fi

exit 0
