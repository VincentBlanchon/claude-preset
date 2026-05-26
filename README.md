# Claude Preset — Config portable de Vincent

Ce repo contient mes skills, mes hooks, mes templates et ma config Claude Code, synchronises entre mes machines via GitHub.

> Setup v2 applique mai 2026 — voir `docs/setup-v2-recap.md` pour le detail des standards.

## Contenu

```
claude-preset/
  global/
    CLAUDE.md              <- Regles globales (Karpathy 4 + kill rule of specificity + long-running + subagents read-only + sync)
  skills/
    init-project/SKILL.md  <- Initialise un projet complet (decouverte, stack, vision, roadmap, preset)
    design-flow/SKILL.md   <- Pipeline UI 5 etapes (design, critique, typeset, polish, audit)
    feature/SKILL.md       <- Harness pipeline pour features complexes (legacy, recouvre vincent-context)
    take-your-time/SKILL.md <- Co-fondateur virtuel : challenge, reflexion produit, planning
    vincent-context/SKILL.md <- NOUVEAU mai 2026 — Skill socle (workflow 10 etapes + design + em dashes + tests + meta TTWBY)
  hooks/                   <- NOUVEAU mai 2026 — Scripts centralises
    git-diagnostic.sh      <- SessionStart : statut git multi-machine
    lint-format.sh         <- PostToolUse : biome/prettier (FIX bug $TOOL_INPUT)
    block-no-verify.sh     <- PreToolUse Bash : bloque --no-verify
    typecheck-on-stop.sh   <- Stop : tsc --noEmit, exit 2 si erreurs (force fix)
  templates/               <- NOUVEAU mai 2026 — Templates pour nouveaux projets
    claude-md-projet.md    <- CLAUDE.md projet slim sub-100 lignes
    settings-projet.json   <- settings.json projet referencant les hooks centralises
    agent-template.md      <- Subagent au format plat officiel
  docs/
    diagrams.md
    setup-v2-recap.md      <- NOUVEAU mai 2026 — Recap complet standards et cibles
```

## Installation sur une nouvelle machine

```bash
git clone https://github.com/VincentBlanchon/claude-preset.git
cd claude-preset
./install.sh
```

L'`install.sh` deploie :
- 5 skills dans `~/.claude/skills/`
- `~/.claude/CLAUDE.md` (overwrite)
- `~/.claude/hooks/git-diagnostic.sh` (executable)
- Les scripts de `claude-preset/hooks/*.sh` (executables, restent dans le repo, references par les settings projet)

## Mise a jour

Quand un skill ou un hook est modifie sur une machine :

1. Modifier le fichier dans ce repo
2. `git commit + git push`
3. Sur l'autre machine : `git pull && ./install.sh`

## Setup v2 — Standards mai 2026

Voir `docs/setup-v2-recap.md` pour le detail complet :
- Securite : deny rules `printenv`/`env`/`grep -r .env*`, `.env*` en `ask`
- Skill socle vincent-context : evite 320 lignes dupliquees dans 4 CLAUDE.md projet
- Hooks corriges : fix bug $TOOL_INPUT (le PostToolUse classique ne formate JAMAIS), exit codes reels
- CLAUDE.md projet sub-100 lignes (plafond Mnilax 200)
- Subagents au format plat (`.claude/agents/name.md`)

## Skills

### /init-project
Initialisation complete d'un nouveau projet en 6 phases :
1. Decouverte (interview product manager)
2. Recommandation de stack
3. Vision produit + roadmap
4. Installation du preset (CLAUDE.md slim, rules, agents flat, skills, contexts, hooks centralises)
5. Init technique (framework, linter, tests)
6. GitHub + premier commit

### /design-flow
Pipeline UI en 5 etapes :
1. **Frontend Design** — build l'interface (tokens DESIGN.md + composants ui/)
2. **Critique** — review design director (score /10, issues P0-P3)
3. **Typeset** — typographie et hierarchie
4. **Polish** — pixel-perfect, etats, transitions, responsive
5. **Audit** — a11y, perf, responsive, anti-patterns

### /feature (legacy)
Harness pipeline automatique pour les features complexes. **Note** : recouvre partiellement le nouveau skill `vincent-context`. A terme, sera reserve aux features XL ou fusionne.

### /take-your-time
Co-fondateur virtuel en 2 modes :
- **Mode Projet** — creation from scratch (etincelle, marche, business, produit, synthese)
- **Mode Feature** — ajout sur projet existant (besoin, challenge, approches, risques, plan)

### /vincent-context (NOUVEAU mai 2026)
Skill socle qui s'auto-charge sur les projets code (presence package.json + framework Next/React/RN). Contient :
- Workflow feature 10 etapes obligatoire (questions, research, plan, Codex challenge, branche auto, complexite, implementation, QA, Codex review, verification visuelle, PR)
- Regles design system (composants ui/, Pencil pour ClubHouse, DESIGN.md prime)
- Pas d'em dashes ni emojis dans le texte produit
- Tests obligatoires sur toute logique metier
- Meta-regle Things That Will Bite You
- Workflow Git (branches feat/fix/refactor, conventional commits)

Evite la duplication massive (~320 lignes) dans les CLAUDE.md projet.
