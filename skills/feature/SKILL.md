---
name: feature
description: Launch the full harness pipeline for complex features. Auto-detected by Claude, not manually invoked.
---
# Harness pipeline

Ce skill est lance AUTOMATIQUEMENT par Claude quand il detecte une feature complexe.
Vincent ne le tape jamais manuellement.

## Criteres de declenchement
- Le plan depasse 3 etapes
- Ca touche 4+ fichiers
- Ca cree une nouvelle page/route
- Ca touche auth, paiement, mode OPEN, ou donnees sensibles

## Pipeline

### Phase 1 — Planification
1. ARCHITECT (Opus) → plan.md + contrat-qualite.md + **docs/progress/<feature>.json** (liste des features end-to-end, chacune `passing`/`failing` — la source de verite du « brique par brique », rendable en /canvas) + **claude-progress.txt** (etat synthetique pour reprise sur contexte frais)
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

### Phase 4 — Review + QA (gate deterministe + double review)
6. Review croisee du code :
   - /codex:review (--scope working-tree --wait, read-only)
   - **/code-review** en parallele (Code Review manage d'Anthropic : flotte d'agents anti-bugs sur infra Anthropic, avec etape anti-faux-positifs). Cumuler les deux remontees.
7. DEVELOPER integre le feedback
8. QA (Opus) — **GATE DETERMINISTE, doit etre 100% vert avant d'avancer** : typecheck + lint + tests + build.
   - **Test E2E navigateur** (Claude-in-Chrome / Puppeteer MCP) du parcours utilisateur cle, exerce comme un humain — c'est ce qui attrape les bugs invisibles dans le code (le plus important pour Vincent, non-dev : il ne peut pas les voir lui-meme).
   - Ne marquer une feature `passing` dans le JSON de progres qu'APRES un test E2E reussi. **Interdit de supprimer ou d'editer un test pour faire passer le gate** (ca masque des fonctionnalites manquantes/buggees).
   - Verdict : PASS / FAIL.
9. Si FAIL → /codex:rescue diagnostique + propose un fix → DEVELOPER applique → retour etape 8 (boucle jusqu'au vert).

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
