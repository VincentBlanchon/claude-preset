---
name: design-flow
description: Pipeline UI piloté à l'œil dans /canvas — explorer plusieurs directions, choisir, builder, réviser visuellement, livrer. Utiliser quand Vincent demande de créer ou modifier une page, modale, dashboard, formulaire, ou tout composant avec une UI visible.
---

# /design-flow — Pipeline UI piloté dans /canvas

Vincent est **non-dev, bosse dans Claude Desktop, décide à l'œil** (il ne lit pas le terminal). Ce pipeline le fait **choisir et valider en cliquant dans des pages `/canvas`**, jamais devant un pavé de texte. À chaque gate visuel → utiliser le skill **`/canvas`** (page HTML interactive, ouverte dans le navigateur, retour auto).

## Règles absolues

- **DESIGN.md prime sur tout.** Lire le `DESIGN.md` du projet en premier et le respecter à la lettre (tokens, palette, typo, spacing, radii). Pour vncbln : beige `#f2ead8`, vert `#3f5a2a`, terracotta `#b85436`, **Inter + DM Sans** (oui, Inter — c'est SON système). Si pas de DESIGN.md mais un site live, en extraire les tokens.
- **Réutiliser les composants existants** (`src/components/ui/`). Ne jamais recréer Button/Card/Input/Badge/Modal.
- **Cohérence avec l'existant.** Lire les pages existantes (structure, patterns, spacing) avant de coder. S'inscrire dans l'existant, pas page blanche.
- **Pas d'invention de valeurs** quand des tokens/classes existent déjà.

---

## Étape 0 — BRIEF (rapide)

Extraire de la demande : **audience**, **action primaire / CTA**, **priorité de contenu**, **contraintes** (DESIGN.md, composants dispo, références). Si une info clé manque, la demander en une question — pas un interrogatoire. Lire DESIGN.md + pages existantes.

## Étape 1 — EXPLORE (la nouveauté clé) → `/canvas`

Avant de builder, **proposer 3-5 directions distinctes** et laisser Vincent choisir à l'œil (pattern Claude Design / Thariq : « 6 approches en grille »).

- Générer une page `/canvas` (mode décision) présentant les directions **en grille**, chacune avec :
  - un **mini-mockup réel** rendu aux tokens du projet (un aperçu HTML/CSS compact, pas une description), OU à défaut une vignette + 2 lignes.
  - un **titre** + le **parti-pris** (ex: « éditorial serif », « bold split », « minimal centré ») + le **tradeoff**.
- **Toujours inclure une option « Aucune → relance »** dans la grille (+ un champ pour décrire la vibe/référence cherchée). Vincent doit pouvoir dire « aucune ne me parle » sans être coincé.
- Vincent clique sa direction préférée (+ commentaire éventuel) → le retour revient via le serveur `/canvas`.
- Si « Aucune » ou rien ne plaît → **relancer une grille avec des pistes différentes** (oser des directions plus originales/tendance : néo-brutalisme, bento, méga-typo, organique…), en tenant compte de ses indications. Ne PAS builder avant qu'une direction soit choisie.

## Étape 2 — BUILD

Construire la direction choisie, **production-ready**, aux tokens DESIGN.md, en réutilisant les composants `ui/`.
- Micro-interactions CSS (hover/focus/active), transitions 150-300ms ease-out.
- Anti-slop (répondre OUI) : CTA visible sans scroller ? hiérarchie claire ? au moins un choix spécifique au produit (pas interchangeable avec 20 startups) ? composants au service du contenu ?

## Étape 3 — VISUAL REVIEW → `/canvas`

**C'est l'étape collaborative — Vincent décide en regardant + en cliquant.**

1. Lancer le rendu : démarrer le dev server, `open http://localhost:...`. Screenshots 375 / 768 / 1440 si possible.
2. Faire les 3 passes d'analyse (sans modifier le code) :
   - **A — Structure & emphase** : focal point dans le 1er viewport, densité, frontières de sections, copy spécifique, CTA = next step logique.
   - **B — Typo & contenu** : échelle harmonieuse, line-heights (titres serrés, corps aérés), largeurs 45-75 caractères, contenu crédible.
   - **C — Finish & états** : hover/focus/active/disabled, transitions, empty/loading states, responsive 375/768, textes longs (ellipsis/line-clamp).
3. **Présenter les recommandations via `/canvas`** (PAS un pavé terminal) : une page où **chaque reco est une carte cochable** (multi-sélection), regroupées par passe, avec le lien localhost en tête. Vincent coche celles à appliquer (+ commentaire libre pour ses propres demandes).
4. Appliquer les recos cochées + le feedback de Vincent. Relancer le localhost, re-vérifier.

## Étape 4 — AUDIT + VÉRIF (auto)

Vérification technique avant livraison — **tourne sans déranger Vincent** :
- **Code** : typecheck + lint + tests du projet (ex: `npm run typecheck && npm run lint && npm run test:run`) → boucle jusqu'au vert. (Le hook auto-format a déjà reformaté.)
- **a11y** : contrastes WCAG AA (4.5:1 / 3:1), focus visible, aria-labels, ordre de tab, alt text, labels de formulaire.
- **Perf** : images optimisées (<200KB) + lazy below-the-fold, pas de layout shift, animations en transform/opacity uniquement.
- **Responsive** : 375/768/1440, pas de scroll horizontal, touch targets ≥44px, texte ≥16px mobile.
- **Anti-patterns** : pas de z-index>50 injustifié, pas de `!important` (hors reset), pas de magic numbers, pas de couleurs hardcodées (tokens only), pas de `console.log`.
Corriger les issues. Garder la liste des warnings pour le gate.

## Étape 5 — RELEASE GATE → `/canvas`

Verdict final présenté **visuellement** (page `/canvas`, mode explain/décision) — jamais de « COMPLETE » automatique. Récapituler :
- Brief respecté · DESIGN.md respecté · composants réutilisés · cohérence projet · audit+vérif PASS · warnings restants.
- Verdict : **READY / READY WITH WARNINGS / NOT READY**, et la décision à Vincent (livrer / corriger un point).

---

## Notes
- **Tous les gates passent par `/canvas`** (Explore, Visual Review, Gate). Voir le skill `/canvas` pour la mécanique (page tmp non-.html, serveur auto-fermant `--focus-app "Claude"`, zéro trace).
- Si la feature est grosse (3+ étapes, 4+ fichiers, route/auth/paiement), c'est `/feature` qui orchestre et appelle `/design-flow` pour la partie UI.
- Argument optionnel : `/design-flow <page/composant>` cible directement cet écran.
