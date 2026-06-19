---
name: design-flow
description: Flux front de Vincent. A utiliser des qu'il demande de creer ou modifier une page, un ecran, une modale, un composant, ou toute UI visible. Par defaut Claude PRODUIT le front et Vincent dirige a l'oeil via /canvas (du propre sans effort). Option Figma (MCP) quand Vincent veut designer lui-meme et monter en competence. Le but : du front propre, pas du "full IA".
---

# /design-flow — Du front propre sans etre designer, sans outil de design

Vincent est **non-dev, non-designer, bosse dans Claude Desktop, decide a l'oeil**. Son probleme reel : **il n'arrive pas a sortir du front propre**. La solution par defaut ne demande **aucun outil**. Mais Vincent **veut aussi apprendre Figma** : il est donc dispo en **option** (voir "Deux entrees").

**Le principe : Claude produit le front, Vincent dirige a l'oeil.** Il ne touche jamais a un outil de design ni au code. Il regarde, il dit "plus aere / ce bouton trop gros / j'aime pas ce bloc", Claude ajuste. Le "propre" ne vient pas d'un outil, il vient de **4 leviers** ci-dessous. C'est tout le secret.

## Deux entrees (Vincent choisit selon l'envie)

- **A. Defaut — Claude produit, Vincent dirige.** Pour quand il veut juste du propre, vite. Vincent decrit / pointe une reference, Claude code, Vincent juge a l'oeil dans `/canvas` et ajuste. Zero outil.
- **B. Option Figma — Vincent designe, Claude implemente.** Pour quand Vincent VEUT manipuler lui-meme et **monter en competence sur Figma** (un de ses objectifs). Il maquette dans Figma, Claude lit via le MCP Figma (`get_design_context`, `get_variable_defs`, `get_screenshot`) et implemente. Bosser dans l'org **"Les Fabricants"** (siege Dev = MCP debloque) ; **`/figma-use` avant tout `use_figma`**. Faire progresser Vincent pas a pas, ne pas le noyer.

Les DEUX passent par les memes garde-fous qualite ci-dessous (leviers + anti-slop + boucle visuelle). Le choix de l'entree ne change rien a l'exigence de "propre".

## Les 4 leviers du front propre (l'anti-"full IA")

**1. JAMAIS partir de zero.** "Page blanche + fais joli" = la machine a slop. Toujours demarrer de :
- une **lib de composants polie** deja installee (shadcn/ui en priorite ; sinon Untitled UI, etc.). Reutiliser `src/components/ui/`, ne jamais recreer Button/Card/Input.
- le **DESIGN.md du projet** (tokens + direction). S'il n'existe pas, le creer une fois (voir plus bas).

**2. TOUJOURS partir d'une vraie reference.** Le generique vient de "j'invente". La parade : Vincent pointe **un vrai site qu'il aime** ("fais le hero comme Linear", "ce pricing comme Stripe"). Claude l'ouvre (Claude_in_Chrome), lit la structure / le scroll / les espacements, et **reprend le parti-pris** (pas un copier-coller : il l'adapte aux tokens du projet). Si Vincent n'a pas de reference, lui en proposer 2-3 (vrais sites shippes du meme secteur) avant de coder. Partir d'un vrai design qui marche bat toute generation a partir de rien.

**3. Le skill officiel `frontend-design` est le moteur de gout.** L'activer sur TOUTE tache front (il est installe : `frontend-design@claude-plugins-official`). C'est l'outil concu par Anthropic pour produire du front distinctif et eviter l'esthetique IA generique. Si une UI sort fade, c'est souvent qu'on ne l'a pas sollicite.

**4. La boucle visuelle (Vincent dirige a l'oeil).** Apres chaque build : **screenshot frais du rendu reel montre dans `/canvas`** (jamais "c'est fait" sans image). Vincent regarde et dirige en langage produit ("plus d'air", "ce bloc en premier", "trop de bordures"). Claude applique, re-screenshote. On itere jusqu'a ce que ce soit beau a SON oeil. Lui ne lit ni code ni terminal.

## Anti-AI-slop : les tells a bannir (signature "full IA" interdite)

Vincent reconnait et DETESTE le look "genere par IA". INTERDITS par defaut (sauf si le DESIGN.md le demande) :
- **Pilules** (border-radius pleine rondeur / 9999px). Radius du projet (vncbln : 8px, carre sobre).
- **Bordures epaisses / tout-encadre**. Separer par l'espace, un fond teinte, un filet 1px discret.
- **Degrades** (surtout violet/indigo "gradient IA"). Aplats, couleurs franches.
- **Blur / glassmorphism**. Surfaces nettes.
- **Ombres molles / glow**. Rares et subtiles, ou aucune.
- **Em dashes (—)** dans les textes. Virgule, point, parentheses.
- **Emojis en puces ou titres**. Puces sobres.
- **Accent violet/indigo par defaut** (shadcn brut non personnalise). Palette du projet (vert olive + terracotta).
- **Tout centre** (hero centre + 2 pilules + degrade = la landing IA type). Asymetrique, editorial, du vide assume.
- **Copy generique** ("Unlock the power of", "Seamlessly", "Elevate your"). Concret, voix du produit.
- **Trop de poids de police / polices decoratives**. Type restreint (Inter + DM Sans).

ESPRIT : moderne, epure, editorial. Test : si un ecran pourrait etre celui de 20 autres startups, c'est rate. Cette liste GRANDIT : quand Vincent dit "ca fait IA", l'ajouter.

## Le DESIGN.md du projet (une fois par projet)

Pour que Claude ait le style de Vincent au lieu d'inventer, poser a la racine un `DESIGN.md` court :
- **Couleurs** (variables + hex), **typo** (familles + echelle), **radius/spacing**, **direction** (1 phrase : "editorial chaud, beige/vert/terracotta, sobre").
- **Do's & Don'ts** = la liste anti-slop ci-dessus.
Claude le lit en premier sur toute tache front et s'y tient. Les couleurs/polices de Vincent sont OK, ne pas les remettre en cause.

## Qualite a chaque build (non negociable)

- Etats **erreur / vide / chargement** + **a11y** (contraste AA, focus visible, touch >= 44px) DES le build, pas a la fin.
- Coherence avec les pages existantes (lire avant de coder).
- Micro-interactions sobres (hover/focus, transitions 150-300ms).

## Le pipeline (rappel)

```
0. BRIEF court (quel ecran, quelle action, quelle reference ?)
1. REFERENCE : Vincent pointe un site qu'il aime (ou Claude en propose 2-3). Claude l'analyse.
2. BUILD : Claude produit le front (frontend-design + lib ui/ + tokens DESIGN.md + anti-slop)
3. PREUVE : screenshot frais montre dans /canvas
4. VINCENT DIRIGE a l'oeil ("plus d'air", "j'aime pas ce bloc") -> Claude ajuste -> re-screenshot
5. AUDIT auto : typecheck + lint + tests + a11y + responsive (375/768/1440)
6. GATE /canvas : READY / WITH WARNINGS / NOT READY, Vincent decide
```

## Notes
- Tous les gates passent par `/canvas`. Vincent ne voit jamais de terminal ni de code.
- Par defaut, aucun outil (Claude produit, Vincent dirige). L'option Figma (entree B) est la quand Vincent veut designer / apprendre Figma. Pencil reste un candidat alternatif s'il prefere un jour.
- Feature XL (auth/paiement/donnees/5+ fichiers) : `vincent-context` porte le workflow et appelle ce flux pour le front.
