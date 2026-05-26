#!/usr/bin/env bash
# Hook PostToolUse pour Write/Edit
# Recupere le path correct via jq (TOOL_INPUT est un JSON envoye sur stdin),
# lint + format avec biome puis prettier en fallback,
# propage le exit code (au lieu de swallow comme le hook actuel)
#
# A placer dans ~/Developer/claude-preset/hooks/lint-format.sh
# Reference par les settings.json projet via :
#   "command": "bash ${HOME}/Developer/claude-preset/hooks/lint-format.sh"
#
# Source : docs/consultant-claude-code-mai-2026.md section 3.3

set -e

# La doc Anthropic mai 2026 confirme :
# TOOL_INPUT est un JSON envoye sur stdin (pas en variable env)
# Le path est dans .tool_input.file_path
input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")

# Pas de fichier ou fichier non-code = skip silencieux
if [ -z "$file_path" ]; then
  exit 0
fi

# Pas existant (write avorte) = skip
if [ ! -f "$file_path" ]; then
  exit 0
fi

case "$file_path" in
  *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs|*.json|*.jsonc)
    # On essaie biome d'abord
    if command -v npx >/dev/null 2>&1; then
      if npx --no-install biome format --write "$file_path" >/dev/null 2>&1; then
        exit 0
      elif npx --no-install prettier --write "$file_path" >/dev/null 2>&1; then
        exit 0
      else
        # Si les deux echouent, signaler a Claude (non-blocking, exit 1)
        echo "[lint-format hook] Format failed for $file_path. Neither biome nor prettier available or both errored." >&2
        exit 1
      fi
    else
      # npx absent, skip
      exit 0
    fi
    ;;
  *.css|*.scss)
    if command -v npx >/dev/null 2>&1; then
      npx --no-install prettier --write "$file_path" >/dev/null 2>&1 || true
    fi
    exit 0
    ;;
  *)
    exit 0
    ;;
esac
