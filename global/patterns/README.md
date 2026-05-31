# Patterns transversaux de Vincent

Store de patterns / décisions / conventions **réutilisables entre TOUS les projets**.
Installé dans `~/.claude/patterns/` par `install.sh`, synchronisé multi-machine via ce repo.

Pourquoi ici et pas dans la mémoire native : la mémoire auto de Claude Code est par-projet
ET par-machine (doc Anthropic) — elle ne partage rien entre projets. Ce dossier comble ce trou.

Règles : un thème = un fichier `.md` court (1-2 lignes par pattern, sinon c'est ignoré).
Géré par le skill `/patterns` (load au démarrage de projet, save quand un pattern réutilisable émerge — avec accord de Vincent).

Exemples de fichiers à créer au fil de l'eau :
- `stack.md` — choix techniques récurrents (ex: Next.js + biome + vitest)
- `conventions.md` — structure de dossiers, nommage, style
- `ui.md` — préférences design (ex: tokens vncbln par défaut)
- `pieges.md` — erreurs déjà rencontrées à ne pas refaire
