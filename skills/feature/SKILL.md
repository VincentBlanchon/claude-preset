---
name: feature
description: Utiliser quand une feature touche auth, paiement, donnees sensibles, ou 5+ fichiers structurants. C'est la couche lourde (subagents + double review + audit securite) par-dessus le workflow de vincent-context. Pour le reste (feature courante, UI), c'est vincent-context qui pilote. Declenche automatiquement par Claude, jamais tape a la main.
---
# Harness pipeline

> **Source unique du workflow** : les etapes generales vivent dans le skill `vincent-context` (charge sur tout projet Node). Ce skill n'ajoute QUE la couche XL ci-dessous. Critere de bascule XL : auth / paiement / donnees sensibles / 5+ fichiers.

Ce skill est lance AUTOMATIQUEMENT par Claude quand il detecte une feature complexe.
Vincent ne le tape jamais manuellement.

## Criteres de declenchement
- Le plan depasse 3 etapes
- Ca touche 4+ fichiers
- Ca cree une nouvelle page/route
- Ca touche auth, paiement, mode OPEN, ou donnees sensibles

## Pipeline

### Phase 1 — Planification
1. ARCHITECT (Opus) → plan.md + contrat-qualite.md
2. /codex:rescue — challenge du plan (TOUJOURS)
   - Prompt : "Challenge ce plan en architecte sceptique. Trouve les failles archi, la dette technique potentielle, les angles morts, les risques de scalabilite."
   - Read-only : Codex donne un avis, il ne reecrit pas le plan.
   - Feedback integre dans le plan par ARCHITECT.
3. Vincent valide le plan → Go / No-go

### Phase 2 — Design (conditionnel)
4. /design-flow — si UI detectee
   - Pipeline complet : brief, build, visual review (gate humaine), audit, release gate
   - Si pas d'UI → skip direct a la phase 3

### Phase 3 — Implementation
5. DEVELOPER (Opus) dans un git worktree isole → implemente selon le plan valide

### Phase 4 — Review + QA (double review)
6. /codex:review — review qualite du code
   - Flags : --scope working-tree --wait
   - Read-only : remonte les problemes, ne corrige rien.
7. DEVELOPER integre le feedback Codex
8. QA (Opus) → typecheck + lint + tests + build + code review
   - Verdict : PASS / FAIL
9. Si FAIL → /codex:rescue diagnostique + propose un fix
   - DEVELOPER applique le fix → retour etape 8

### Phase 5 — Verification visuelle
10. VERIFY-APP (Opus) → Computer Use + screenshots
    - Si problemes visuels → DEVELOPER corrige → retour ici

### Phase 6 — Audit securite (double audit)
11. Audit securite — toujours au moins un, potentiellement deux :
    - Code standard : /codex:adversarial-review (auth, data loss, race conditions, rollback safety)
    - Code sensible (auth, paiement, OPEN, donnees sensibles) : SECURITY-AUDITOR (Opus) + /codex:adversarial-review en parallele
    - Si fixes necessaires → DEVELOPER corrige → retour QA (etape 8)

### Phase 7 — Livraison
12. Commit + Push + PR creee automatiquement
