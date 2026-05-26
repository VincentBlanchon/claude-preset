---
name: vincent-context
description: Regles transverses Vincent appliquees a tous ses projets code (Bridge, ClubHouse, AppDiag, CV Virtuel, Funnel, csp-back). Inclut le workflow feature en 10 etapes obligatoire, les regles design system (utiliser composants ui/), l'interdiction des em dashes, la discipline tests, le pattern Things That Will Bite You, le workflow Git/Codex. A invoquer automatiquement sur tout projet contenant package.json ou un framework Next.js/React/React Native.
---

# Vincent Context — Regles transverses pour tous projets code

Ce skill consolide les regles que Vincent applique sur tous ses projets code. **Si tu lis ce skill, respecte ces regles meme si elles ne sont pas repetees dans le CLAUDE.md du projet.**

## Workflow feature OBLIGATOIRE

Quand Vincent demande une nouvelle feature ou modification significative, suis ce flow dans l'ordre. **Ne saute aucune etape.**

### Etape 1 — Comprendre (QUESTIONS)
- Quel est l'objectif metier ? Pourquoi cette feature ?
- Qui va l'utiliser ? Quel parcours utilisateur ?
- Y a-t-il des contraintes specifiques ?
- Si quelque chose est flou, DEMANDE. Ne devine pas.

### Etape 2 — Rechercher (RESEARCH-FIRST)
Avant de coder, cherche si une solution existe :
- Dans le codebase (composant similaire ? helper reutilisable ?)
- Sur GitHub, npm, doc officielle de la lib
- Ne reinvente pas la roue.

### Etape 3 — Planifier (PLAN MODE)
Presente un plan structure AVANT de coder :
- Fichiers a creer/modifier
- Composants existants a reutiliser
- Tables/API concernees
- Criteres de succes verifiables

### Etape 4 — Challenge du plan (CODEX) — OBLIGATOIRE
**YOU MUST envoyer le plan a Codex AVANT de demander validation a Vincent.**

```
/codex:rescue Analyse ce plan et challenge-le : faisabilite, risques, alternatives plus simples.
```

Presente a Vincent : le plan original + feedback Codex + ajustements faits.

### Etape 4b — Creer la branche (AUTOMATIQUE)
AVANT de coder, creer une branche depuis main :
1. Proposer le nom : "Je cree `feat/description-courte`, OK ?"
2. `git checkout -b feat/description-courte`
3. Travailler EXCLUSIVEMENT sur cette branche.

**Ne JAMAIS coder une feature sur main.**

### Etape 5 — Detecter la complexite
Si plan > 3 etapes ou 4+ fichiers ou nouvelle page → feature complexe. Demander confirmation avant implementation.

### Etape 6 — Implementer
Code en suivant le plan valide. Utilise les composants ui/ existants. Ecris les tests.

### Etape 7 — QA
Lance build, lint, typecheck, tests. Si fail → corrige (max 3 boucles avant remontee a Vincent).

### Etape 8 — Review Codex SYSTEMATIQUE
```
/codex:adversarial-review --base main
```
Le compteur Codex est separe de Claude — utilise-le sans crainte de manger ton quota.

### Etape 9 — Verification visuelle
Ouvre l'app (Computer Use prioritaire, Playwright fallback). Screenshots.

### Etape 10 — PR
Cree la PR avec description claire + screenshots.

## Regles design system

- **Utilise TOUJOURS les composants de src/components/ui/.** Ne redesigne JAMAIS un composant existant.
- Si un composant manque, cree-le dans ui/ d'abord puis utilise-le.
- Respecte les tokens du DESIGN.md du projet si present.
- **Pour ClubHouse specifiquement** : Pencil pour le design (Vincent), Claude pour l'integration. Claude ne designe PAS l'UI.

## Regles texte produit

- **Pas d'em dashes (—) dans le texte visible** (UI, posts, descriptions, placeholders, emails). Utiliser virgule, point, parentheses.
- Les em dashes sont un signal artificiel "IA" que Vincent deteste.
- Idem : pas de "Tantot... tantot...", pas de "C'est non seulement... mais aussi...". Phrases courtes, directes.
- Pas de "il est important de", "il convient de noter", "il est a noter que".

## Discipline tests

- **Toute logique metier DOIT avoir des tests.**
- Ne JAMAIS marquer une tache comme terminee sans tests qui passent.
- TDD encourage : ecrire le test qui reproduit le bug, puis le faire passer.
- Ne JAMAIS faire passer un test en cassant le vrai usage. Le test doit refleter le besoin reel.

## Pattern "Things That Will Bite You" — meta-regle

Quand Vincent te corrige sur une erreur :
1. Identifie la regle qui aurait empeche l'erreur.
2. Ajoute-la dans la section `## Things That Will Bite You` du CLAUDE.md projet.
3. Format : `**[Topic]** : description courte + exemple concret + raison.`

Cette section est ta memoire long-terme des pieges specifiques au projet. Plus elle grandit, moins Claude refait les memes erreurs.

**Limite** : si la section depasse 10 entrees, demander a Vincent de prioriser/archiver. Sinon ca dilue le contexte.

## Workflow Git

- Branches : `feat/`, `fix/`, `refactor/`, `chore/`, `docs/`. Jamais sur main.
- Commits : conventional commits en anglais (`feat: add login flow`).
- PR : description claire, screenshots si UI, mention des tests ajoutes.
- **Jamais `--no-verify`** — bloque par hook PreToolUse.

## Mode plan vs implementation

**Pour toute feature non triviale, commencer en Plan mode.** Ne jamais implementer sans plan valide.

## Long-running tasks — Quand utiliser /goal

Pour les taches qui prennent plus de 5 minutes ou qui ont plusieurs etapes verifiables :

1. Exprime l'objectif comme critere verifiable :
   `/goal all tests in tests/auth pass and lint is clean`
2. Combine avec Auto Mode (`shift+tab`) pour skip les permission prompts
3. Push notif mobile quand atteint ou besoin d'input

**A NE PAS utiliser** pour "make it better" ou taches ambigues — definir le critere d'abord.

## Comportements interdits (synthese)

- Ajouter des features non demandees (Karpathy rule 2).
- Refactor du code adjacent qui marche (Karpathy rule 3).
- Supprimer du dead code sans permission (Karpathy rule 3).
- Faire passer un test en cassant le vrai usage.
- Skipper les hooks (--no-verify).
- Push directement sur main.
- Faire un commit sans message clair.
- Utiliser des em dashes dans le texte produit.
- Redesigner un composant ui/ existant.

## Workflow journalier optimise (rappel)

1. **Matin** : `/goal Process bookmarks veille du jour` + Auto Mode + push notif
2. **Apres feature** : `/codex:rescue` plan + branche auto + implementation + `/codex:adversarial-review`
3. **Hands-off** : combo `/goal` + `/remote-control` + push notif mobile
4. **Recurrents** : `/schedule "every X" task` pour les jobs reguliers
