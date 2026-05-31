---
name: patterns
description: Bibliothèque de patterns / décisions / conventions RÉUTILISABLES, partagée entre TOUS les projets de Vincent. Comble le trou de la mémoire native (qui est par-projet ET par-machine). Charger au début d'un projet, ou quand Vincent dit « mes patterns », « comme d'habitude », « mes conventions ». Sauver quand une décision réutilisable émerge. Aussi : /patterns.
---

# /patterns — Mémoire transversale entre projets

**Le problème (vérifié, doc Anthropic mai 2026) :** la mémoire auto native est **par-projet** (dérivée du dépôt git) **et par-machine** (pas de cloud) → elle ne donne PAS un pool de savoir partagé entre projets. Vincent démarre souvent de nouveaux projets et bosse sur 2 Macs → il lui faut un store transversal.

**La solution :** `~/.claude/patterns/*.md` — un fichier court par thème (stack, conventions de code, déploiement, pièges récurrents, préférences UI…). Synchronisé multi-machine via le repo `claude-preset` (donc présent sur Mac perso ET pro).

## LOAD — quand lire le store
- Au **démarrage d'un nouveau projet** (et dans `/init-project`) : lire `~/.claude/patterns/` et proposer ce qui s'applique (« d'habitude tu fais X — on garde ? »).
- Quand Vincent dit « **mes patterns / mes habitudes / comme d'hab / mes conventions** ».
- Astuce auto : un projet peut ajouter `@~/.claude/patterns/<theme>.md` dans son `CLAUDE.md` pour charger un pattern automatiquement.

## SAVE — quand écrire dans le store
Quand une **décision/convention/snippet réutilisable** émerge qui vaudrait pour **d'autres** projets (choix de stack récurrent, structure de dossiers, piège évité, préférence forte). Écrire dans `~/.claude/patterns/<theme>.md`, court et actionnable.
- **Demander à Vincent avant d'ajouter** un pattern (éviter le bloat).
- NE PAS y mettre du spécifique à UN projet (ça, c'est la mémoire/CLAUDE.md du projet).

## Règles
- **Court = suivi.** Comme les rules : un store gonflé est ignoré. Une ligne ou deux par pattern, pas des pavés.
- **Un thème = un fichier.** Ne pas tout entasser dans un seul.
- Après ajout : `cd ~/.claude` n'est pas versionné, mais le store vient de `claude-preset/global/patterns/` → pour le sync multi-machine, ajouter aussi le pattern là-bas et commit (sinon il reste local).
