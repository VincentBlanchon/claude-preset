---
name: design-flow
description: Flux front de Vincent. A utiliser des qu'il demande de creer ou modifier une page, un ecran, une modale, un composant, ou toute UI visible. Le design vit dans Claude Design (exploration) puis Handoff vers Claude Code (implementation). Tous les gates passent par /canvas (Vincent decide a l'oeil).
---

# /design-flow — Le front, de l'idee a l'ecran livre

Vincent est **non-dev, bosse dans Claude Desktop, decide a l'oeil**. Le front est sa **priorite n°1** : il est moderne, epure, exigeant sur l'interface. Ce flux est concu pour ca : il explore le design dans **Claude Design**, et Claude Code **implemente fidelement** derriere, avec une barre de gout haute et une **preuve visuelle** a chaque etape. Chaque gate = une page **`/canvas`** (jamais un pave terminal).

## Les 2 surfaces de design (savoir laquelle)

- **Claude Design** (claude.ai/design) = **defaut pour explorer/generer le front.** C'est la ou Vincent fait naitre le visuel. Quand le design lui plait, il fait **"Handoff to Claude Code"** : Claude Code recupere le code/HTML et l'implemente proprement dans le projet.
  - ⚠️ **Quota separe** de Claude Code. S'il est epuise (Claude Design ne repond plus / cooldown), **ne pas bloquer Vincent** : basculer sur Pencil (MCP, il pilote lui-meme) ou sur un build direct aux tokens du DESIGN.md. Le prevenir en une phrase.
- **Pencil** (MCP) = alternative quand Vincent prefere **dessiner lui-meme** (ex projets ou il a deja sa maquette .pen). Claude Code lit le .pen via le MCP Pencil et implemente.
- **design-flow ancien (3-5 directions generees par Claude)** = retire. Vincent veut piloter le visuel, pas choisir dans une grille.

## Bien utiliser Claude Design (le coeur du front — methodes officielles Anthropic, juin 2026)

**1. SEED le design system UNE FOIS (le levier n°1 anti-generique).**
Avant tout, lier le codebase du projet via **Import** dans Claude Design : il analyse tes composants, ton theming, tes patterns de framework, et **rejoue TON style automatiquement** sur chaque nouveau design. Sans ca, sa sortie par defaut est competente mais **generique** ("AI beige") et on se bat contre l'esthetique tout du long. Gros repo : lier le **package/dossier des composants**, pas tout le repo ; exclure `.git` et `node_modules`. C'est ce qui sert Vincent (moderne, epure, exigeant) des le premier ecran.

**2. Prompter / iterer (la bonne main au bon endroit) :**
- **Chat** = structure, layout, gros partis-pris esthetiques (ex : "settings page avec sections account, billing, notifications, integrations").
- **Commentaires inline** = retouches locales (spacing, traitement d'un bouton, swap de composant).
- **Sliders custom** (Claude les fabrique) = regler une valeur fine a l'oeil.
- **Referencer les composants par NOM** : "utilise ProductCard", "meme layout que la page settings". Ca porte jusqu'a l'implementation.

**3. Avant le Handoff (preparer la livraison) :**
- Demander a Claude Design de montrer les **etats** : vide / erreur / chargement + **gros volumes de donnees**.
- **Nommer clairement** les elements dans le proto (les noms suivent jusqu'au code).
- **Logguer les decisions dans le chat** (ca devient le contexte pour l'implementation).

**4. Le Handoff vers Claude Code :**
Export → **"Hand off to Claude Code"**. Bundle cree = fichiers de design + le chat + un README + tokens du design system + structure des composants + intention de chaque page. Dans Claude Code, **une seule instruction** suffit. Surtout puissant quand **le codebase est lie** (Claude Code connait deja les composants).

**5. Regle d'or : ne JAMAIS designer ET coder dans la meme conversation.** Claude Design = exploration visuelle, Claude Code = production. Melanger = heures perdues. La frontiere, c'est le Handoff.

## Regles absolues (valables quelle que soit la surface)

- **Reutiliser les composants existants** (`src/components/ui/`). Ne jamais recreer Button/Card/Input/Badge/Modal.
- **DESIGN.md du projet prime** (tokens, palette, typo, spacing, radii). S'y tenir a la lettre.
- **Coherence avec l'existant.** Lire les pages existantes (structure, patterns, spacing) avant de coder. S'inscrire dedans, pas page blanche.
- **Pas d'invention de valeurs** quand des tokens/classes existent deja.

---

## Etape 0 — BRIEF (rapide)

Extraire : **audience**, **action primaire / CTA**, **priorite de contenu**, **contraintes** (DESIGN.md, composants dispo, reference eventuelle). Si une info cle manque, une seule question, pas un interrogatoire. Lire DESIGN.md + pages existantes.

## Etape 1 — D'OU VIENT LE DESIGN ?

Trois entrees possibles, detecter laquelle :

- **A. Vincent pointe une reference** ("fais comme Mistral", "reprends ce hero") → **mode REFERENCE** :
  1. Analyser la reference pour de vrai : l'ouvrir (Claude_in_Chrome), lire la structure (DOM), le comportement au scroll, les couleurs, la typo, les espacements.
  2. Restituer dans `/canvas` : "voici ce que j'ai compris" (structure + interactions + tokens extraits). **Pas de code encore.**
  3. Implementer seulement APRES validation de cette comprehension. La fidelite prime sur la creativite.
- **B. Vincent a explore dans Claude Design** → il fait "Hand off to Claude Code" (voir la section dediee plus haut). Recuperer le **bundle** (design + chat + README + tokens), l'implementer DEPUIS ce bundle en **nettoyant aux conventions du projet** (composants ui/, tokens DESIGN.md), jamais coller le code brut.
- **C. Rien de tout ca** (petit composant, pas de reference) → build direct aux tokens du projet, en s'appuyant sur la barre de gout ci-dessous.

## Etape 2 — BUILD (barre de gout haute)

Construire production-ready, aux tokens DESIGN.md, en reutilisant les composants `ui/`.

- **Gout / anti-slop via le skill officiel `frontend-design`** (a activer via `/plugins`). Objectif : moderne, epure, un point de vue. Typographies distinctives, palette assumee, au moins un detail memorable. **Test anti-slop (OUI a tout)** : CTA visible sans scroller ? hierarchie claire ? un choix specifique au produit (pas interchangeable avec 20 startups) ? l'interface sert le contenu ?
- **Etats + accessibilite DES le build** (pas a l'audit) : etats **erreur / vide / chargement**, **touch targets >= 44px**, **contraste WCAG AA**, **focus visible**. Penser le PARCOURS complet, pas juste l'ecran heureux.
- Micro-interactions CSS (hover/focus/active), transitions 150-300ms ease-out.

## Etape 3 — PREUVE VISUELLE → `/canvas`

**Interdit de dire "c'est fait" sans montrer.** C'est la friction n°1 de Vincent (la navbar qui disparait).

1. Lancer le rendu reel : dev server, screenshot frais (Claude_Preview / Claude_in_Chrome), 375 / 768 / 1440 si possible.
2. **Montrer le screenshot dans `/canvas`.** Si un screenshot d'avant la modif existe dans la conversation, les mettre cote a cote ("avant / apres, qu'est-ce qui a bouge ?"). La comparaison, c'est l'oeil de Vincent, pas un diff pixel. **Ne pas stocker de PNG de reference dans le repo.**
3. Recommandations d'amelioration = cartes cochables dans `/canvas` (multi-selection), pas un pave. Vincent coche, on applique, on re-verifie.

## Etape 4 — AUDIT (auto, sans deranger)

- **Code** : typecheck + lint + tests du projet, boucle jusqu'au vert (max 3 boucles, sinon STOP + /canvas EXPLAIN).
- **a11y** : contrastes AA, focus visible, aria-labels, ordre de tab, alt text, labels de formulaire.
- **Perf** : images < 200KB + lazy below-the-fold, pas de layout shift, animations transform/opacity only.
- **Responsive** : 375/768/1440, pas de scroll horizontal, touch >= 44px, texte >= 16px mobile.
- **Anti-patterns** : pas de z-index > 50 injustifie, pas de `!important` (hors reset), pas de couleurs hardcodees (tokens only), pas de `console.log`.

## Etape 5 — RELEASE GATE → `/canvas`

Verdict final **visuel** (jamais de "COMPLETE" automatique). Recap : brief respecte, DESIGN.md respecte, composants reutilises, audit PASS, warnings restants. Verdict **READY / READY WITH WARNINGS / NOT READY**, decision a Vincent.

---

## Notes

- **Tous les gates passent par `/canvas`** (reference comprise, preuve visuelle, recos, gate). Voir le skill `/canvas` pour la mecanique.
- **Visuels / assets (posters, images, PNG)** != UI d'app. Pour ca, capacite de design natif de Claude (artifacts), pas ce flux.
- Si la feature est XL (auth/paiement/donnees/5+ fichiers), c'est `vincent-context` qui porte le workflow global et appelle ce flux pour la partie front.
- Argument optionnel : `/design-flow <page/composant>` cible directement cet ecran.
