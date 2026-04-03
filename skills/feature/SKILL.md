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
1. ARCHITECT (Opus) → plan.md + contrat-qualite.md
2. /codex:adversarial-review du plan → feedback integre
3. Vincent valide le plan
4. REVIEWER (Opus) si UI detecte → propositions design
5. DEVELOPER (Opus) dans un git worktree isole → implemente
6. QA (Opus) → typecheck + lint + tests + build + review
7. Si FAIL → CODEX diagnostique → DEVELOPER corrige → retour QA
8. VERIFY-APP (Opus) → Computer Use + screenshots
9. Si problemes visuels → DEVELOPER corrige
10. SECURITY-AUDITOR (Sonnet) si code sensible (OPEN, auth, paiement)
11. PR creee automatiquement
