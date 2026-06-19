---
name: design-flow
description: Flux front de Vincent. A utiliser des qu'il demande de creer ou modifier une page, un ecran, une modale, un composant, ou toute UI visible. Le design se manipule dans Figma (canvas navigateur), Claude Code lit via le MCP Figma et implemente. Tous les gates passent par /canvas (Vincent decide a l'oeil).
---

# /design-flow — Le front, de Figma a l'ecran livre

Vincent est **non-dev, bosse dans Claude Desktop, decide a l'oeil**. Le front est sa **priorite n°1** : moderne, epure, exigeant. Il **manipule le design lui-meme dans Figma** (vrai canvas : bouger, modifier, redimensionner), et **Claude Code implemente** derriere via le MCP Figma, avec une barre de gout haute, l'anti-slop, et une **preuve visuelle**. Chaque gate = une page **`/canvas`**.

> Son probleme avec les outils precedents (Claude Design, retire) = le **rendu generique / "full IA"**. La parade dans Figma : **partir de vraies references** (decortiquer un site qu'il aime en calques editables) + **seeder son design system** + l'**anti-slop**. C'est l'antidote au generique.

## Surface de design

- **Figma (defaut)** : Vincent designe dans le navigateur. Claude Code lit le design via le **MCP Figma** (`get_design_context`, `get_screenshot`, `get_variable_defs`) et l'implemente. Peut aussi ecrire/generer dans Figma (`generate_figma_design`, `create_new_file`). **Skill `/figma-use` obligatoire avant d'appeler `use_figma`.**
- **Siege / cout** : utiliser l'espace de l'org **"Les Fabricants"** (Vincent y a un siege **Dev** = MCP debloque, deja paye). Son espace perso ("L'equipe de v.blanchon") est en **starter = 6 appels MCP/mois**, a eviter pour du design reel.
- **Pencil** (MCP) reste un repli possible s'il prefere un jour. **Claude Design = retire** (rendu trop generique a son gout).

## Bien utiliser Figma (le coeur du front)

**1. REFERENCE d'abord (l'antidote au generique, son levier n°1).**
Quand Vincent pointe un site qu'il aime ("fais comme X", "ce hero") : utiliser le **code-to-canvas** de Figma (`generate_figma_design`) pour transformer l'UI live en **calques Figma editables**. Vincent les bouge/modifie a l'oeil, puis Claude Code implemente. Partir d'une vraie reference shippee bat la generation a partir de zero. Restituer dans `/canvas` "voici ce que j'ai compris" avant d'implementer.

**2. SEED le design system UNE FOIS.**
Lier le codebase du projet (le **dossier des composants**, pas tout le repo ; exclure `.git`/`node_modules`) et/ou poser ses **variables Figma** (tokens : radius 8px, palette beige/vert/terracotta, Inter+DM Sans). Claude rejoue SON style au lieu d'inventer. `get_variable_defs` recupere ces tokens a l'implementation.

**3. Manipuler / iterer (a l'oeil) :**
- Vincent bouge/redimensionne/modifie directement sur le canvas Figma.
- **Nommer clairement** les calques (`bouton-principal`, pas `Rectangle 3`) : les noms suivent jusqu'au code.
- Referencer les composants par NOM ("utilise ProductCard", "meme layout que la page settings").

**4. Preuve visuelle.** Apres implementation, screenshot frais du rendu reel (`get_screenshot` Figma ou Claude_Preview) montre dans `/canvas`. Comparer au design Figma a l'oeil.

## Anti-AI-slop : les tells a bannir (signature "full IA" interdite)

Vincent reconnait et DETESTE le look "genere par IA". INTERDITS par defaut (sauf si le DESIGN.md le demande). A appliquer a l'implementation ET a coller dans les notes du fichier Figma.

BANNIR :
- **Les pilules** (border-radius pleine rondeur / 9999px). Radius du projet (vncbln : 8px, carre sobre).
- **Les bordures epaisses / le tout-encadre**. Separer par l'espace, un fond teinte, ou un filet 1px discret.
- **Les degrades** (surtout violet/indigo "gradient IA"). Aplats, couleurs franches.
- **Le blur / glassmorphism**. Surfaces nettes.
- **Les ombres molles / glow**. Rares et subtiles, ou aucune.
- **Les em dashes (—)** dans les textes. Virgule, point, parentheses.
- **Les emojis en puces ou titres**. Puces sobres.
- **L'accent violet/indigo par defaut** (shadcn brut). Palette du projet (vert olive + terracotta).
- **Tout centre** (hero centre + 2 pilules + degrade = la landing IA type). Asymetrique, editorial, du vide assume.
- **La copy generique** ("Unlock the power of", "Seamlessly", "Elevate your"). Concret, voix du produit.
- **Trop de poids de police / polices decoratives**. Type restreint (Inter + DM Sans).

ESPRIT : moderne, epure, editorial. Test : si un ecran pourrait etre celui de 20 autres startups, c'est rate. Cette liste GRANDIT : quand Vincent dit "ca fait IA", l'ajouter.

## Regles absolues (implementation)

- **Reutiliser les composants existants** (`src/components/ui/`). Ne jamais recreer Button/Card/Input/Badge/Modal.
- **DESIGN.md du projet prime** (tokens, palette, typo). Couleurs/polices de Vincent = OK, ne pas les remettre en cause.
- **Coherence avec l'existant.** Lire les pages existantes avant de coder.
- Etats **erreur / vide / chargement** + **a11y** (contraste AA, focus, touch >= 44px) DES le build.
- Gout / anti-slop via le skill officiel **`frontend-design`**.

## Le pipeline (rappel)

```
0. BRIEF (audience, CTA, contraintes, DESIGN.md)
1. FIGMA : reference -> calques editables OU manip directe -> Vincent ajuste a l'oeil
2. BUILD : Claude Code lit le MCP Figma, implemente aux tokens/composants, anti-slop
3. PREUVE : screenshot frais montre dans /canvas
4. AUDIT auto : typecheck + lint + tests + a11y + responsive (375/768/1440)
5. GATE /canvas : READY / WITH WARNINGS / NOT READY, Vincent decide
```

## Notes
- Tous les gates passent par `/canvas`. Voir le skill `/canvas`.
- Feature XL (auth/paiement/donnees/5+ fichiers) : `vincent-context` porte le workflow et appelle ce flux pour le front.
- **`/figma-use` AVANT tout `use_figma`** (regle du MCP Figma officiel).
