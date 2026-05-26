---
name: vincent-context
description: Regles transverses Vincent appliquees a tous ses projets code (Bridge, ClubHouse, AppDiag, CV Virtuel, Funnel, csp-back, PennyLane). Inclut workflow feature 10 etapes obligatoire, design system, em dashes interdits, tests obligatoires, pattern Things That Will Bite You, workflow Git/Codex. A invoquer automatiquement sur tout projet avec package.json (Next, React, RN, SvelteKit, Node).
---

# Vincent Context — Regles transverses

Si tu lis ce skill, **respecte ces regles meme si elles ne sont pas dans le CLAUDE.md projet**.

## Workflow feature OBLIGATOIRE

Quand Vincent demande une feature ou modification significative, suis dans l'ordre :

1. **Comprendre** — Pose des questions metier/UX/contraintes. Si flou, DEMANDE, ne devine pas.
2. **Rechercher** — Cherche si une solution existe (codebase, GitHub, npm, doc lib). Ne reinvente pas.
3. **Planifier** (Plan mode) — Fichiers, composants reutilises, tables/API, criteres succes.
4. **Challenge Codex OBLIGATOIRE** : `/codex:rescue Analyse ce plan : faisabilite, risques, alternatives plus simples`. Presente plan + feedback + ajustements.
5. **Branche auto** : `feat/xxx` (jamais sur main). Proposer le nom avant.
6. **Detecter complexite** : > 3 etapes / 4+ fichiers / nouvelle page = complexe → demander confirmation.
7. **Implementer** : composants ui/ existants, tests pour la logique metier.
8. **QA** : build + lint + typecheck + tests. Max 3 boucles de fix.
9. **Codex review SYSTEMATIQUE** : `/codex:adversarial-review --base main`. Compteur separe de Claude, utilise-le sans crainte.
10. **Verif visuelle** : Computer Use prio, Playwright fallback. Screenshots.
11. **PR** : description claire + screenshots.

## Design system

- Utilise TOUJOURS `src/components/ui/`. Ne redesigne JAMAIS un composant existant.
- Si un composant manque, crees-le dans ui/ d'abord, puis utilise-le.
- DESIGN.md du projet prime sur les suggestions.
- **ClubHouse specifique** : Pencil pour le design (Vincent), Claude integre uniquement.

## Texte produit

- **Pas d'em dashes (—)** dans le texte visible (UI, posts, descriptions, placeholders, emails). Virgule, point ou parentheses.
- Pas d'emojis ni d'icones glyphs (check, croix, warning) dans les reponses chat — Vincent les deteste comme "AI tell" amateur.
- Phrases courtes, directes. Pas de "il est important de", "il convient de noter", "tantot... tantot...".

## Tests

- Toute logique metier DOIT avoir des tests.
- Jamais marquer une tache terminee sans tests passants.
- TDD encourage : test qui reproduit le bug, puis le faire passer.
- Ne JAMAIS faire passer un test en cassant le vrai usage.

## Things That Will Bite You — meta-regle

Quand Vincent corrige une erreur :
1. Identifie la regle qui aurait empeche l'erreur.
2. Ajoute-la dans `## Things That Will Bite You` du CLAUDE.md projet.
3. Format : `**[Topic]** : description + exemple + raison.`

Limite : 10 entrees max par projet. Si plus, demander a Vincent de prioriser/archiver.

## Git

- Branches : `feat/`, `fix/`, `refactor/`, `chore/`, `docs/`. **Jamais sur main**.
- Conventional commits en anglais (`feat: add login`).
- PR : description + screenshots si UI + tests mentionnes.
- **Jamais `--no-verify`** (bloque par hook).

## Long-running tasks — `/goal`

Pour les taches > 5 min ou multi-etapes verifiables :
1. Critere verifiable : `/goal all tests in tests/auth pass and lint is clean`
2. Auto Mode (`shift+tab`) pour skip permissions
3. Push notif quand done ou besoin d'input

Pas pour "make it better" ambigu — definir le critere d'abord.

## Interdits (synthese)

- Ajouter features non demandees (Karpathy 2)
- Refactor adjacent qui marche (Karpathy 3)
- Supprimer dead code sans permission (Karpathy 3)
- Faire passer un test en cassant le vrai usage
- Skipper hooks (`--no-verify`)
- Push direct sur main
- Em dashes dans texte produit
- Redesigner composant ui/ existant
