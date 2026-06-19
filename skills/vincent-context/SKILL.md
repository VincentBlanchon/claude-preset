---
name: vincent-context
description: Regles transverses appliquees a tout projet code de Vincent. A invoquer automatiquement des qu'un projet contient package.json (Next, React, RN, SvelteKit, Node), ou quand Vincent demande une feature/modification significative sur un projet existant. Porte le workflow feature de reference, la verification par preuve visuelle, les garde-fous comportementaux, le front (via Claude Design), Git/Codex.
---

# Vincent Context — Regles transverses

Si tu lis ce skill, **respecte ces regles meme si elles ne sont pas dans le CLAUDE.md projet**.

## Workflow feature (source unique)

> C'est LA reference du workflow. Le skill `feature` ne le re-decrit pas : il ajoute seulement la couche lourde (subagents, double review, audit securite) pour les features XL (auth / paiement / donnees sensibles / 5+ fichiers).

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

## Plan verrouille avant tout build

Des qu'un changement touche 2+ fichiers ou une UI visible : pose le plan dans `/canvas` et ATTENDS le "Go" de Vincent. RIEN ne s'ecrit avant (scaffolder = ecrire = bloque). Sa pire friction : "t'as lance sans que je valide".
Le plan a deux audiences, ne pas les melanger :
- Le .md de travail (pour l'agent executant) : chemins de fichiers EXACTS, noms de fonctions/composants EXACTS, zero placeholder. Si tu ne sais pas, tu DEMANDES.
- Le `/canvas` (pour Vincent) : briques en langage produit + vrais tradeoffs, zero jargon technique.

## Verification avant de dire "c'est fait"

Ne JAMAIS dire "fait / corrige / ca marche" sans avoir, DANS CE MESSAGE :
1. Lance la commande de verif (test / build / lint) et lu l'output ET l'exit code.
2. Pour une UI : pris un SCREENSHOT FRAIS du rendu reel et MONTRE-le dans `/canvas`. La preuve que Vincent lit, c'est l'image, pas le terminal.
3. Si un subagent a bosse : verifie SON DIFF GIT, pas son rapport (il finit toujours vite).
Mots bannis avant preuve : "should", "probably", "devrait", "normalement".
Si une verif ECHOUE : n'affiche jamais le terminal brut a Vincent. Ouvre `/canvas` mode EXPLAIN ("voici ce qui casse, en clair, je propose X").

## Design system + front

- Le front est la PRIORITE de Vincent (moderne, epure, exigeant). Le flux complet vit dans le skill `design-flow`.
- **Front = Figma + Claude (definitif, abonnement Figma Full pris).** Vincent COMPOSE ses pages dans Figma (il deplace les formes, c'est sa creativite), Claude lit via le MCP Figma et code en vrai (React/Tailwind/shadcn) a ses tokens, soigne (spacing, micro-animations, zero composant par defaut). L'oeil de Vincent juge le beau, jamais la machine. Regle d'or : ne jamais designer ET coder dans la meme conversation. Detail dans le skill `design-flow`.
- Utilise TOUJOURS `src/components/ui/`. Ne redesigne JAMAIS un composant existant. S'il manque, crees-le dans ui/ d'abord.
- DESIGN.md du projet prime. Ses couleurs/polices sont OK, ne pas les remettre en cause.
- **Preuve visuelle obligatoire** apres toute modif UI (screenshot frais montre dans `/canvas`).

## Texte produit

- **Pas d'em dashes (—)** dans le texte visible (UI, posts, descriptions, placeholders, emails). Virgule, point ou parentheses.
- Pas d'emojis ni d'icones glyphs (check, croix, warning) dans les reponses chat — Vincent les deteste comme "AI tell" amateur.
- Phrases courtes, directes. Pas de "il est important de", "il convient de noter", "tantot... tantot...".

## Tests

- Toute logique metier DOIT avoir des tests.
- Jamais marquer une tache terminee sans tests passants.
- TDD encourage : test qui reproduit le bug, puis le faire passer.
- Ne JAMAIS faire passer un test en cassant le vrai usage.

## Debug : trouve la cause + regle des 3 fixes

Trouve la cause AVANT de patcher (lis l'erreur en entier, reproduis, regarde le git diff recent). Un fix qui marche "par hasard" en cache un autre.
Regle des 3 fixes : si 3 tentatives de fix echouent, STOP, n'en tente pas un 4e. Ce n'est probablement pas l'hypothese, c'est l'approche. Explique dans `/canvas` (EXPLAIN) et propose de repenser. Evite les 2h de patches en boucle qui font chauffer la machine.

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

## Frein a l'ambition

Si une demande empile de la complexite au-dela du besoin reel : DIS-LE avant d'accompagner. "Je trouve ca too much, on peut faire plus simple en faisant X." Test : un senior dirait-il que c'est sur-engineere ?
Variante visuelle/3D (CV-Virtuel, vncbln) : si un rendu lourd, des animations lourdes ou une video vont faire chauffer/crasher la machine ou exploser le temps de render, PREVIENS du cout et propose la version legere. Vincent regrette l'escalade apres coup.

## Repondre a une review (Codex / Opus)

Pas d'acquiescement performatif ("tu as raison !"). Evalue techniquement, pousse si le reviewer a tort. Avant d'implementer une suggestion "propre" : grep le codebase, si pas utilise (YAGNI), propose de ne pas l'ajouter.
Ordre impose : conformite a la demande D'ABORD (rien en moins, rien en trop), qualite ENSUITE.
Double review (Codex spec + Opus qualite) SEULEMENT sur le code a risque : logique metier, auth, paiement, donnees sensibles. UI / CSS : une seule passe suffit.

## Cloture d'une feature

Feature terminee → verif d'abord (build + lint + tests). Rouge → STOP, explique dans `/canvas`, aucune cloture proposee. Vert → propose dans `/canvas` 4 options :
1. **Merge local + cleanup** (RECO PAR DEFAUT : fusionne dans la base, supprime branche + worktree).
2. **Push + PR** (description + screenshots).
3. **Garder tel quel**.
4. **Jeter** (exige que Vincent tape "discard").
Jamais `git push --force`, jamais sur main. Puis soulage la machine : liste les serveurs/process lourds que TU as lances, identifie le PID precis (lsof sur le port), propose "Process X (PID Y) tourne encore, je coupe ? (Y/N)". JAMAIS killall/pkill.

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
- Dire "c'est fait" sans preuve (output de commande + screenshot UI)
- Lancer un build/scaffold avant le "Go" de Vincent sur le plan

## Journal de friction (capture passive)

Quand Vincent exprime une friction verbatim ("c'est nul", "supprime tout", "trop", "tu devines", "ca chauffe", "t'as lance sans valider") : note-la, datee, dans la memoire (`feedback_friction_log`), SANS interrompre la tache. Quand il dit "fais le point sur mon workflow" : relis ce journal, regroupe les frictions recurrentes, propose dans `/canvas` quel garde-fou durcir.
