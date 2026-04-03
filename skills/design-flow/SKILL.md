---
name: design-flow
description: Pipeline UI complet en 5 etapes (design, critique, typeset, polish, audit). Utiliser quand Vincent demande de creer ou modifier une page, modale, dashboard, formulaire, ou tout composant avec une UI visible.
---

# /design-flow — Pipeline UI en 5 etapes

Pipeline complet pour creer ou ameliorer une interface. Execute les 5 etapes dans l'ordre.
Si un argument est fourni (ex: `/design-flow page pricing`), l'appliquer a cette page/composant.

IMPORTANT: Si le projet a un fichier DESIGN.md (tokens, palette, typo, spacing), il prime TOUJOURS sur les suggestions de chaque etape. Le lire en premier.
IMPORTANT: Si le projet a un dossier src/components/ui/, toujours reutiliser les composants existants.

---

## Etape 1 — FRONTEND DESIGN (Build)

Tu es un designer frontend senior. Construis l'interface.

### Avant de coder
- Lis DESIGN.md si present (tokens, palette, typo, spacing, radii, shadows)
- Lis les composants ui/ existants dans le projet
- Comprends le contexte : quel probleme cette interface resout ? Pour qui ?

### Direction esthetique
Choisis une direction BOLD et intentionnelle. Pas de design generique.
- **Typographie** : polices distinctives et memorables. JAMAIS Inter, Roboto, Arial, system fonts generiques
- **Couleurs** : palette cohesive avec des accents forts. Pas de violet-degrade-sur-blanc cliche
- **Motion** : animations pour les micro-interactions. CSS-only prefere. Staggered reveals > micro-interactions eparses
- **Composition** : layouts inattendus, asymetrie, overlap, grids casses, espace negatif genereux
- **Fond & details** : atmosphere et profondeur (gradients, textures, patterns, grain, ombres)

### Implementation
- Code production-ready et fonctionnel
- Visuellement frappant et memorable
- Cohesif avec un point de vue esthetique clair
- Si DESIGN.md existe : respecter ses tokens a la lettre
- Si composants ui/ existent : les reutiliser, ne pas redesigner

---

## Etape 2 — CRITIQUE (Review Design Director)

Tu es un directeur artistique senior exigeant. Tu n'as PAS designe cette interface.

### Evaluation (score /10)
Evalue chaque axe sur 10 :
- **Hierarchie visuelle** : l'oeil sait ou aller en premier ?
- **Coherence** : tokens, spacing, typo, couleurs respectes partout ?
- **Impact** : c'est memorable ou generique ?
- **Fonctionnalite** : ca marche, les interactions sont claires ?
- **Craft** : les details sont soignes (alignements, spacing, micro-interactions) ?

### Issues par priorite
- **P0 — Bloquant** : casse l'UX, illisible, inaccessible
- **P1 — Important** : incoherence design system, hierarchie confuse
- **P2 — Amelioration** : pourrait etre plus raffine, plus impactant
- **P3 — Nice-to-have** : touches finales, polish supplementaire

### Output
```
CRITIQUE: [score global /10]
P0: [liste ou "aucun"]
P1: [liste ou "aucun"]
P2: [liste]
P3: [liste]
```

Corrige les P0 et P1 immediatement. Propose les P2.

---

## Etape 3 — TYPESET (Typographie & Hierarchie)

Tu es un typographe senior. Affine la typographie et la hierarchie de l'information.

### Check systematique
- **Echelle typographique** : les tailles forment-elles une echelle harmonieuse ? (ratio 1.2-1.5)
- **Poids** : utilise-t-on assez de variation (light/regular/medium/semibold/bold) ?
- **Line-height** : titres serres (1.1-1.2), corps aeres (1.5-1.7) ?
- **Letter-spacing** : titres resserres (-0.01 a -0.03em), small text espace (+0.02em) ?
- **Mesure** : largeur de ligne optimale (45-75 caracteres pour le corps) ?
- **Hierarchie** : 3 niveaux max clairement distincts (titre, sous-titre, corps) ?
- **Contraste** : suffisamment de difference entre les niveaux ?
- **Rythme vertical** : spacing coherent entre les blocs de texte ?

### Actions
Corrige les problemes trouves directement dans le code.
Ne change PAS les polices definies dans DESIGN.md.

---

## Etape 4 — POLISH (Qualite finale)

Tu es un designer pixel-perfect obsede par les details. Derniere passe avant l'audit.

### Checklist
- [ ] **Alignement** : tout est aligne sur la grille, pas de decalages de 1-2px
- [ ] **Spacing** : utilise uniquement les valeurs du systeme (4, 8, 12, 16, 24, 32, 48, 64)
- [ ] **Etats** : hover, focus, active, disabled — tous definis et visuellement distincts
- [ ] **Transitions** : toutes les interactions ont des transitions fluides (150-300ms, ease-out)
- [ ] **Bordures & ombres** : coherentes avec le design system
- [ ] **Icones** : taille et style coherents, alignees optiquement
- [ ] **Couleurs** : pas de couleurs hardcodees, tout via tokens/variables CSS
- [ ] **Responsive** : verifie a 375px, 768px, 1440px — pas de debordement, texte lisible
- [ ] **Dark mode** : si applicable, verifie que les contrastes tiennent
- [ ] **Empty states** : les etats vides ont un message et un CTA
- [ ] **Loading states** : les chargements sont visibles (skeleton, spinner)
- [ ] **Truncation** : les textes longs sont geres (ellipsis, line-clamp)

### Actions
Corrige chaque point qui ne passe pas. Pas de compromis sur le pixel-perfect.

---

## Etape 5 — AUDIT (Technique)

Tu es un auditeur technique frontend. Derniere verification avant livraison.

### Accessibilite (a11y)
- Contrastes WCAG AA (4.5:1 texte normal, 3:1 gros texte)
- Focus visible sur tous les elements interactifs
- aria-labels sur les elements sans texte visible
- Ordre de tabulation logique
- Images avec alt text
- Formulaires avec labels associes

### Performance
- Pas d'images non optimisees (> 200KB)
- Pas de CSS/JS inline massif
- Lazy loading sur les images below-the-fold
- Pas de layout shift (CLS)
- Animations via transform/opacity uniquement (pas de top/left/width)

### Responsive
- Test a 375px, 768px, 1440px
- Pas de scroll horizontal
- Touch targets >= 44x44px sur mobile
- Texte lisible sans zoom sur mobile (>= 16px)

### Anti-patterns
- Pas de z-index > 50 sans justification
- Pas de !important sauf reset
- Pas de magic numbers (valeurs hardcodees sans token)
- Pas de duplication de styles (extraire dans un composant)
- Pas de console.log oublies

### Output
```
AUDIT: [PASS/FAIL]
a11y:        [OK/X issues]
Performance: [OK/X issues]
Responsive:  [OK/X issues]
Anti-patterns: [OK/X issues]
```

Corrige les issues FAIL. Liste les warnings.

---

## Resume final

A la fin du pipeline, affiche :

```
DESIGN-FLOW COMPLETE

Page/Composant: [nom]
Critique:       [score /10]
Issues P0:      [resolues/total]
Issues P1:      [resolues/total]
Audit:          [PASS/FAIL]
```
