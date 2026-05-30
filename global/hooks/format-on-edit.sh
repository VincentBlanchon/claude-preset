#!/bin/bash
# format-on-edit.sh — hook PostToolUse (Edit/Write/MultiEdit).
# Auto-formate le fichier qui vient d'etre edite SI le projet a un formatter.
#
# Garanties :
#   - Ne bloque JAMAIS, n'echoue JAMAIS (exit 0 quoi qu'il arrive).
#   - No-op silencieux si : pas un fichier de code, pas de projet, pas de formatter.
#   - N'installe rien (npx --no-install) : utilise uniquement le formatter local du projet.
#
# Lit le JSON du hook sur stdin, en extrait tool_input.file_path.

input="$(cat)"

file="$(printf '%s' "$input" | python3 -c '
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get("tool_input", {}).get("file_path", ""))
except Exception:
    print("")
' 2>/dev/null)"

[ -z "$file" ] && exit 0
[ -f "$file" ] || exit 0

# Uniquement les fichiers de code formatables (les .md, images, etc. -> no-op)
case "$file" in
  *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs|*.css|*.scss|*.json|*.jsonc) ;;
  *) exit 0 ;;
esac

# Remonter jusqu'a la racine du projet (premier package.json trouve)
dir="$(dirname "$file")"
root=""
while [ "$dir" != "/" ] && [ -n "$dir" ]; do
  if [ -f "$dir/package.json" ]; then root="$dir"; break; fi
  dir="$(dirname "$dir")"
done
[ -z "$root" ] && exit 0

cd "$root" || exit 0

if [ -f "biome.json" ] || [ -f "biome.jsonc" ]; then
  npx --no-install biome format --write "$file" >/dev/null 2>&1 || true
elif [ -f ".prettierrc" ] || [ -f ".prettierrc.json" ] || [ -f ".prettierrc.js" ] || [ -f "prettier.config.js" ] || [ -f "prettier.config.mjs" ]; then
  npx --no-install prettier --write "$file" >/dev/null 2>&1 || true
fi

exit 0
