---
name: design-flow
description: Flux front de Vincent. A utiliser des qu'il demande de creer ou modifier une page, un ecran, une modale, un composant, ou toute UI visible. Vincent COMPOSE dans Figma (il deplace des formes, c'est sa creativite), Claude lit via le MCP Figma et code en vrai (React/Tailwind/shadcn), soigne. L'oeil de Vincent juge le beau ; les gates passent par /canvas.
---

# /design-flow — Le front : Figma + Claude

Vincent est **non-dev, ultra-perfectionniste sur le front, decide a l'oeil**. Il a un **abonnement Figma Full** (design + Dev Mode/MCP). **Son envie, ferme et definitive : composer ses pages dans Figma** (deplacer des cubes/textes/zones, facon Canva, ajouter/enlever/reorganiser), et que **Claude code a partir de ca**. C'est un travail A DEUX : Vincent designe, Claude implemente. **La machine ne juge JAMAIS le beau a sa place** — c'est l'oeil de Vincent, et c'est la raison d'etre de Figma ici.

## Regle d'or

**Ne JAMAIS designer ET coder dans la meme conversation.** Figma = la surface de design (Vincent compose). Claude Code = la production (implemente le vrai code). La frontiere, c'est le MCP. Melanger = perdre des heures.

## Phase 0 — Le design system dans Figma (une fois par projet)

Le levier n°1 anti-generique : Figma et le code parlent les MEMES tokens.
- Poser les **Variables Figma** : couleurs (semantiques : primary/muted/destructive…), echelle d'espacement, typo, radius. + un **`DESIGN.md`** miroir a la racine du repo (la reference ecrite).
- Si le projet a deja des composants : **lier le codebase** dans Figma (Import → le dossier des composants, pas tout le repo) pour que Figma rejoue le style existant.
- Tokens shadcn en **OKLCH** + `@theme` Tailwind v4 cote code, memes valeurs que les Variables Figma.
- **Gate `/canvas`** : Vincent valide le systeme (palette + echelles cote a cote) avant qu'on genere un ecran. Ses couleurs/polices sont OK, ne pas les remettre en cause.

## Phase 1 — Vincent compose la page dans Figma (sa creativite)

C'est SON espace. Trois entrees possibles :
- **Reference** : Vincent pointe un site qu'il aime → `generate_figma_design` (code-to-canvas) le transforme en **calques editables** qu'il rearrange.
- **From scratch** : il pose ses blocs/zones/textes a l'oeil, depuis un kit (Community : shadcn kit, Untitled UI).
- **Je lui genere une base** dans son Figma (`use_figma` — **invoquer la skill `/figma-use` AVANT**), qu'il reorganise ensuite a l'oeil.
Bonnes habitudes a encourager (sans le bloquer) : **nommer les calques clairement** (les noms suivent jusqu'au code : `bouton-principal`, pas `Rectangle 3`), utiliser les Variables du design system, penser les **etats** (vide/erreur/chargement).

## Phase 2 — Claude lit la frame via le MCP et code en vrai

- Lire : `get_design_context` (structure/layout) + `get_variable_defs` (tokens) + `get_screenshot` (le rendu vise). Referencer les composants **par leur nom Figma**.
- Implementer en **React/Tailwind/shadcn**, **aux tokens du repo** (jamais de hex en dur, jamais de valeur inventee), en reutilisant `src/components/ui/`.
- **Le soin que Vincent exige (non-negociable)** : spacing maitrise (echelle de tokens, pas de valeur au pif) ; **micro-animations** sobres (Motion : hover/focus/transitions 150-300ms, sous-menus soignes) ; **zero composant par defaut non personnalise** (pas de shadcn brut violet) ; etats erreur/vide/chargement ; a11y (contraste AA, focus, 44px).
- Activer le skill officiel **`frontend-design`** (anti-AI-slop) sur toute tache front.

## Phase 3 — La boucle a l'oeil (Vincent juge le beau)

- Claude rend → **screenshot frais dans `/canvas`**. Jamais "c'est fait" sans l'image.
- Vincent dirige en langage produit ("plus d'air", "ce bloc plus bas", "le CTA doit dominer") OU **retourne rearranger dans Figma** et on re-handoff. Son oeil tranche le beau, point.
- Quand un composant lui plait, le **promouvoir dans `src/components/ui/`** (sa lib enrichie de SES variantes) → le prochain ecran le reutilise, l'effort decroit.

## Anti-AI-slop : les tells a bannir

Par defaut (sauf si le DESIGN.md le demande) : pas de **pilules** (radius 9999px → 8px sobre), pas de **bordures epaisses/tout-encadre**, pas de **degrades** (violet IA), pas de **blur/glassmorphism**, pas d'**ombres molles/glow**, pas d'**em dashes** ni d'**emojis** en puces/titres, pas d'**accent violet shadcn brut**, pas de **hero centre generique**, pas de **copy fade** ("Unlock the power of"). Palette beige/vert/terracotta, Inter + DM Sans. Test : si un ecran pourrait etre celui de 20 autres startups, c'est rate. La liste GRANDIT (quand Vincent dit "ca fait IA", l'ajouter).

## Setup (a verifier/installer une fois)

- **MCP Figma** (Dev Mode) : deja connecte, siege Full OK. Skill **`/figma-use`** avant tout `use_figma`.
- **shadcn** + son MCP (gratuit) ; **Tailwind v4** (OKLCH, `@theme`).
- Skill **`frontend-design`** (deja la). **Motion** pour les animations.
- References imposees : **Mobbin / Refero** (poser 2-3 vraies refs premium avant un nouvel ecran-type).

## Discipline (non-negociable)

- Iteration **composant par composant**, pas une page entiere d'un coup (un composant valide+promu avant le suivant).
- **Regle de la 3e gen** : si apres 3 tours un ecran ne converge pas, le probleme est le DESIGN.md flou ou la reference manquante, pas la generation. On remonte d'un cran.
- **References imposees** avant generation : pas de nouvel ecran-type sans 2-3 refs reelles. "Inspire-toi de mon gout" ne suffit pas.

## Notes
- Figma = surface de design ; Claude Code = production. Jamais les deux dans la meme conversation.
- Tous les gates passent par `/canvas`. Vincent ne lit ni code ni terminal.
- Feature XL (auth/paiement/donnees/5+ fichiers) : `vincent-context` porte le workflow et appelle ce flux pour le front.
