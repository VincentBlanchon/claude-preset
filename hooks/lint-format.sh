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

# Cherche le formatter dans les node_modules locaux puis tombe sur npx global
format_file() {
  local file="$1"
  # Trouver le repo root (le premier package.json en remontant)
  local dir
  dir=$(dirname "$file")
  while [ "$dir" != "/" ] && [ ! -f "$dir/package.json" ]; do
    dir=$(dirname "$dir")
  done

  # 1) biome local
  if [ -x "$dir/node_modules/.bin/biome" ]; then
    "$dir/node_modules/.bin/biome" format --write "$file" >/dev/null 2>&1 && return 0
  fi
  # 2) prettier local
  if [ -x "$dir/node_modules/.bin/prettier" ]; then
    "$dir/node_modules/.bin/prettier" --write "$file" >/dev/null 2>&1 && return 0
  fi
  # 3) Fallback npx
  if command -v npx >/dev/null 2>&1; then
    (cd "$dir" && npx biome format --write "$file" >/dev/null 2>&1) && return 0
    (cd "$dir" && npx prettier --write "$file" >/dev/null 2>&1) && return 0
  fi
  return 1
}

case "$file_path" in
  *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs|*.json|*.jsonc)
    if format_file "$file_path"; then
      exit 0
    else
      echo "[lint-format hook] Format failed for $file_path. Aucun biome/prettier accessible." >&2
      exit 1
    fi
    ;;
  *.css|*.scss)
    format_file "$file_path" || true
    exit 0
    ;;
  *)
    exit 0
    ;;
esac
