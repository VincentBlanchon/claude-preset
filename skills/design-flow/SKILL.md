---
name: design-flow
description: Pipeline UI complet en 5 etapes (brief, build, visual review, audit, release gate). Utiliser quand Vincent demande de creer ou modifier une page, modale, dashboard, formulaire, ou tout composant avec une UI visible.
---

# /design-flow — Pipeline UI en 5 etapes

Pipeline complet pour creer ou ameliorer une interface. Execute les 5 etapes dans l'ordre.
Si un argument est fourni (ex: `/design-flow page pricing`), l'appliquer a cette page/composant.

## Regles absolues

- **DESIGN.md prime sur tout.** Si le projet a un fichier DESIGN.md (tokens, palette, typo, spacing, radii, shadows), le lire en premier et le respecter a la lettre.
- **Reutiliser les composants existants.** Si le projet a un dossier src/components/ui/, utiliser les composants existants. Ne jamais recreer un Button, Card, Input, Badge ou Modal.
- **Coherence avec l'existant.** Avant de coder, lire les pages existantes du projet pour comprendre les patterns en place (structure de sections, style de headings, spacing entre blocs). Le nouveau code doit s'inscrire dans l'existant, pas partir d'une page blanche.
- **Classes et variables existantes.** Verifier les classes CSS / variables Tailwind / tokens deja utilises dans le projet. Ne pas inventer de nouvelles valeurs quand il en existe deja.

---

## Etape 0 — BRIEF

Avant de coder quoi que ce soit, etablir un brief minimum :
- **Audience** : pour qui est cette page/composant ?
- **Action primaire** : que doit faire l'utilisateur ?
- **CTA principal** : quel est le call-to-action dominant ?
- **Priorite de contenu** : quelles infos en premier, lesquelles secondaires ?
- **Contraintes** : tokens DESIGN.md, composants ui/ disponibles, references visuelles

Si Vincent fournit ces infos dans sa demande, les extraire. Sinon, poser les questions manquantes rapidement — pas un interrogatoire, juste ce qui manque pour ne pas designer dans le vide.

---

## Etape 1 — BUILD

Construire l'interface.

### Avant de coder
- Lire DESIGN.md
- Lire les composants ui/ existants
- Parcourir les pages existantes du projet (patterns, styles, structure)
- Relire le brief

### Direction esthetique
Si DESIGN.md definit le style : le respecter. Sinon, choisir une direction intentionnelle :
- **Typographie** : polices distinctives. JAMAIS Inter, Roboto, Arial, system fonts generiques
- **Couleurs** : palette cohesive avec des accents forts
- **Motion** : animations pour les micro-interactions. CSS-only prefere
- **Composition** : espace negatif genereux, hierarchie claire
- **Fond & details** : atmosphere et profondeur quand pertinent

### Anti-slop — Criteres de qualite
Le design doit repondre OUI a ces questions :
- Le CTA principal est-il visible sans scroller ?
- La hierarchie est-elle claire (on sait ou regarder en premier) ?
- Y a-t-il au moins un choix de design specifique au produit (pas interchangeable avec 20 autres startups) ?
- Les composants sont-ils utilises parce qu'ils servent le contenu, pas parce qu'ils "font premium" ?

Si la reponse est NON a l'une d'entre elles : corriger avant de passer a l'etape suivante.

### Implementation
- Code production-ready et fonctionnel
- Si DESIGN.md existe : respecter ses tokens
- Si composants ui/ existent : les reutiliser

---

## Etape 2 — VISUAL REVIEW

**C'est l'etape collaborative. Claude propose, Vincent decide.**

### Lancer le rendu
- Demarrer le serveur de dev (`npm run dev`, `pnpm dev`, ou equivalent)
- Ouvrir la page dans le navigateur de Vincent (`open http://localhost:...`)
- Si possible, prendre des screenshots a 375px, 768px, et 1440px

### Analyser et recommander (3 passes)

**Passe A — Structure et emphase :**
- Le focal point est-il clair dans le premier viewport ?
- La densite est-elle equilibree (pas trop vide, pas trop charge) ?
- Les sections ont-elles des frontieres claires ?
- Le copy est-il specifique (pas generique/placeholder) ?
- Le CTA correspond-il au next step logique de l'utilisateur ?

**Passe B — Typographie et contenu :**
- L'echelle typographique est-elle harmonieuse ?
- Les line-heights sont-ils corrects (titres serres, corps aeres) ?
- Les largeurs de ligne sont-elles dans la zone 45-75 caracteres ?
- Le contenu est-il credible et coherent avec le produit ?

**Passe C — Finish et etats :**
- Les etats interactifs sont-ils definis (hover, focus, active, disabled) ?
- Les transitions sont-elles fluides (150-300ms, ease-out) ?
- Les empty states et loading states sont-ils geres ?
- Le responsive tient-il a 375px et 768px ?
- Les textes longs sont-ils geres (ellipsis, line-clamp) ?

### Presenter les recommandations

Afficher les recommandations a Vincent avec ce format :

```
VISUAL REVIEW — [Page/Composant]

Localhost : http://localhost:[port]/[path]

Passe A — Structure :
- [observations + recommandations]

Passe B — Typo & contenu :
- [observations + recommandations]

Passe C — Finish :
- [observations + recommandations]
```

**NE PAS MODIFIER LE CODE.** Attendre le retour de Vincent.
Vincent regarde le localhost de son cote, lit les recommandations, et reagit :
- "ok, fais tout" → appliquer toutes les recommandations
- "le hero est trop charge" → integrer ce feedback + les recommandations validees
- "non, je prefere comme ca" → ne pas toucher ce point

Apres les corrections, relancer le localhost si besoin et verifier visuellement.

---

## Etape 3 — TECHNICAL AUDIT

Derniere verification technique avant livraison.

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
- Verifie a 375px, 768px, 1440px (si screenshots disponibles, les utiliser)
- Pas de scroll horizontal
- Touch targets >= 44x44px sur mobile
- Texte lisible sans zoom sur mobile (>= 16px)

### Anti-patterns
- Pas de z-index > 50 sans justification
- Pas de !important sauf reset
- Pas de magic numbers (valeurs hardcodees sans token)
- Pas de duplication de styles (extraire dans un composant)
- Pas de console.log oublies
- Pas de couleurs hardcodees — tout via tokens/variables CSS

### Output
```
AUDIT: [PASS/FAIL]
a11y:         [OK/X issues]
Performance:  [OK/X issues]
Responsive:   [OK/X issues]
Anti-patterns: [OK/X issues]
```

Corriger les issues. Lister les warnings.

---

## Etape 4 — RELEASE GATE

Verification finale. Pas de "COMPLETE" automatique.

### Checklist
- [ ] Le brief initial est-il respecte (audience, action, CTA) ?
- [ ] Le DESIGN.md est-il respecte (tokens, couleurs, typo) ?
- [ ] Les composants ui/ existants sont-ils reutilises ?
- [ ] Le style est-il coherent avec les autres pages du projet ?
- [ ] L'audit technique est-il PASS ?
- [ ] Vincent a-t-il valide le visuel ?

### Verdict

```
RELEASE GATE — [Page/Composant]

Brief respecte :     [oui/non]
Design system :      [oui/non]
Coherence projet :   [oui/non]
Audit technique :    [PASS/FAIL]
Validation Vincent : [oui/non]

Verdict : [READY / READY WITH WARNINGS / NOT READY]

Warnings non resolus :
- [liste ou "aucun"]
```
