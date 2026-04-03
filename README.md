# Claude Preset — Config portable de Vincent

Ce repo contient mes skills et ma config Claude Code, synchronises entre mes machines via GitHub.

## Contenu

```
claude-preset/
  global/
    CLAUDE.md              <- Regles globales (preferences, detection projet vierge, never kill, sync)
  skills/
    init-project/SKILL.md  <- Initialise un projet complet (decouverte, stack, vision, roadmap, preset)
    design-flow/SKILL.md   <- Pipeline UI 5 etapes (design, critique, typeset, polish, audit)
    feature/SKILL.md       <- Harness pipeline pour features complexes (architect, codex, QA, verify)
    take-your-time/SKILL.md <- Co-fondateur virtuel : challenge, reflexion produit, planning
```

## Installation sur une nouvelle machine

```bash
git clone https://github.com/VincentBlanchon/claude-preset.git
cd claude-preset
./install.sh
```

## Mise a jour

Quand un skill est modifie sur une machine :

1. Modifier le fichier dans ce repo
2. `git commit + git push`
3. Sur l'autre machine : `git pull && ./install.sh`

## Skills

### /init-project
Initialisation complete d'un nouveau projet en 6 phases :
1. Decouverte (interview product manager)
2. Recommandation de stack
3. Vision produit + roadmap
4. Installation du preset (CLAUDE.md, rules, agents, skills, contexts, hooks)
5. Init technique (framework, linter, tests)
6. GitHub + premier commit

### /design-flow
Pipeline UI en 5 etapes :
1. **Frontend Design** — build l'interface (tokens DESIGN.md + composants ui/)
2. **Critique** — review design director (score /10, issues P0-P3)
3. **Typeset** — typographie et hierarchie
4. **Polish** — pixel-perfect, etats, transitions, responsive
5. **Audit** — a11y, perf, responsive, anti-patterns

### /feature
Harness pipeline automatique pour les features complexes :
1. ARCHITECT → plan + contrat qualite
2. CODEX adversarial review du plan
3. Validation Vincent
4. REVIEWER si UI
5. DEVELOPER en worktree isole
6. QA (build + lint + tests + review)
7. Boucle correction si fail
8. VERIFY-APP (Computer Use + screenshots)
9. SECURITY-AUDITOR si code sensible
10. PR auto

### /take-your-time
Co-fondateur virtuel en 2 modes :
- **Mode Projet** — creation from scratch (etincelle, marche, business, produit, synthese)
- **Mode Feature** — ajout sur projet existant (besoin, challenge, approches, risques, plan)
