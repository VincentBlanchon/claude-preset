# Setup Vincent v2 — Recap mai 2026

> Date : 2026-05-13
> Status : applique sur Mac pro. A propager sur Mac perso via `./install.sh` (apres `git pull`).
> Source detaillee : repo `veille-tech`, `docs/consultant-claude-code-mai-2026.md` (1100 lignes).

## TL;DR

Refonte de l'environnement Claude Code Vincent pour atteindre les standards mai 2026 :
- **Securite** : deny rules strict sur les commandes Bash qui leakent les secrets, `.env*` en `ask`
- **Skill socle vincent-context** : workflow feature 10 etapes + design + em dashes + tests + meta TTWBY, sortis des CLAUDE.md projet (320 lignes liberees)
- **Hooks corriges** : scripts centralises `claude-preset/hooks/`, fix du bug $TOOL_INPUT JSON vs path, propagation reelle des exit codes
- **CLAUDE.md projet slim** : Bridge 150→82, ClubHouse 178→92, AppDiag 140→92, CV Virtuel 134→88
- **Subagents au format plat** : `.claude/agents/name.md` au lieu de `.claude/agents/name/CLAUDE.md`

## Architecture cible

```
~/.claude/
├── CLAUDE.md                          # 4 Karpathy + profil + kill rule + long-running + subagents
├── settings.json                      # Deny strict + ask sur secrets + hook SessionStart + Notification
├── hooks/
│   └── git-diagnostic.sh              # Diagnostic git multi-machine (deploye depuis claude-preset)
└── skills/
    ├── design-flow/
    ├── feature/
    ├── init-project/
    ├── take-your-time/
    └── vincent-context/               # NOUVEAU — skill socle

~/Developer/claude-preset/             # Source de verite
├── global/CLAUDE.md                   # Identique a ~/.claude/CLAUDE.md
├── hooks/                             # NOUVEAU
│   ├── git-diagnostic.sh
│   ├── lint-format.sh                 # FIX bug $TOOL_INPUT
│   ├── block-no-verify.sh
│   └── typecheck-on-stop.sh
├── skills/                            # 5 skills (4 historiques + vincent-context)
├── templates/                         # NOUVEAU
│   ├── claude-md-projet.md
│   ├── settings-projet.json
│   └── agent-template.md
├── docs/
│   └── setup-v2-recap.md              # Ce fichier
└── install.sh                         # Deploie skills + hooks + CLAUDE.md global

[projet quelconque]/.claude/
├── settings.json                      # Reference les hooks centralises
└── agents/                            # Format plat name.md (pas name/CLAUDE.md)
```

## Skills global (5)

| Skill | Quand il se charge | Role |
|---|---|---|
| **design-flow** | Vincent demande UI page/modale/form | Pipeline 5 etapes design |
| **feature** | Vincent demande feature complexe | Harness complet (legacy, recouvre vincent-context) |
| **init-project** | Projet vierge detecte | Onboarding nouveau projet |
| **take-your-time** | Vincent dit "challenge-moi" / nouveau projet | Mode reflexion approfondie |
| **vincent-context** | Tout projet code (Next/React/RN) — NOUVEAU | Workflow feature 10 etapes + regles transverses |

**Note** : `feature` et `vincent-context` se recouvrent partiellement. `vincent-context` est plus recent et plus precis sur les habitudes Vincent (em dashes, Codex obligatoire, branche auto). A terme, `feature` sera fusionne ou explicitement reserve aux features XL.

## Hooks centralises (4 scripts)

### `git-diagnostic.sh` (SessionStart global)
- Affiche le diagnostic ahead/behind/dirty pour les projets multi-machine listes
- Detecte aussi les projets vierges
- Silencieux pour les autres projets

### `lint-format.sh` (PostToolUse Write/Edit projet)
- Recupere le path via `jq -r '.tool_input.file_path'` (pas `$TOOL_INPUT` qui est un JSON)
- Cherche biome local (`node_modules/.bin/biome`), puis prettier local, puis npx fallback
- Propage l'exit code (1 si format echoue, 0 sinon)

### `block-no-verify.sh` (PreToolUse Bash projet)
- Bloque toute commande contenant `--no-verify` (skip hook git interdit)
- Exit 2 + raison passee a Claude

### `typecheck-on-stop.sh` (Stop projet)
- Lance `tsc --noEmit` si `package.json` present
- Exit 2 si erreurs TS (force Claude a continuer pour fixer, au lieu de declarer victoire)

## Templates (3)

### `claude-md-projet.md`
Template CLAUDE.md projet slim (sub-100 lignes). Placeholder pour stack/commandes/structure. Sections "Regles critiques specifiques" et "Things That Will Bite You" vides a remplir au fil.

### `settings-projet.json`
Template settings.json projet utilisant les hooks centralises de claude-preset/hooks/. A copier directement.

### `agent-template.md`
Template subagent au format plat officiel mai 2026 (`.claude/agents/name.md`). Frontmatter avec name + description trigger + tools restreints + model + permissionMode + maxTurns.

## Settings global `~/.claude/settings.json`

Standards mai 2026 appliques :
- **deny strict** sur les commandes Bash leakant les secrets : `printenv`, `env`, `grep -r .env*`, `grep -r STRIPE_*`, etc.
- **deny strict** sur les operations destructives : `rm -rf *`, `git push --force`, `killall`, `pkill`, `sudo`, `curl * | sh`, etc.
- **deny strict** sur les lectures fichiers vraiment sensibles : `~/.ssh/**`, `~/.aws/**`, `*.pem`, `*.key`, `id_rsa*`
- **ask** sur `.env*` (workflow Vincent : copy entre projets, pas a bloquer)
- **ask** sur `git push`, `rm -rf *`, `kill`, `WebFetch`
- **allow** large sur git read-only, pnpm, npm, ls/cat/grep/rg/jq
- **defaultMode** : `auto`
- **agentPushNotifEnabled** : true
- **effortLevel** : retire (laisse default Opus 4.7 = xhigh)

## CLAUDE.md global `~/.claude/CLAUDE.md`

132 lignes. Sections :
1. Working with Vincent (non-dev, format question structurante)
2. Karpathy 4 rules (ref repo a 127k stars, mention skill vincent-context pour +8 Mnilax)
3. Empty project detection
4. **Kill processes — Rule of specificity** (kill cible OK quand identifie, pattern-based interdit)
5. **Long-running tasks — When to use /goal** (verifiable condition + auto mode + push notif)
6. **Subagents — Read-only by default**
7. Never crash mid-conversation
8. Auto sync multi-machine (reference hook git-diagnostic.sh)

## Pour appliquer sur Mac perso

```bash
cd ~/Developer/claude-preset
git pull
./install.sh
```

L'install.sh deploie :
- 5 skills dans `~/.claude/skills/` (incl. vincent-context)
- `~/.claude/CLAUDE.md` (overwrite)
- `~/.claude/hooks/git-diagnostic.sh` (overwrite)

Puis a faire manuellement sur Mac perso :
1. Mettre a jour `~/.claude/settings.json` avec la version cible (voir `veille-tech/docs/configs/settings-global-v2.json`)
2. Re-faire le refactor projet (Bridge, ClubHouse, AppDiag, CV Virtuel) en pullant les branches `claude/setup-v2-mai-2026`

## Branches projets a merger

- `Bridge V1` : `claude/setup-v2-mai-2026` (slim CLAUDE.md + hooks + agents flat + biome migration v2.4)
- `ClubHouse` : `claude/setup-v2-mai-2026` (slim CLAUDE.md + hooks + agents flat + TTWBY remplie)
- `AppDiag` : `claude/setup-v2-mai-2026` (slim CLAUDE.md + hooks + agents flat + TTWBY remplie)
- `CV Virtuel` : `claude/setup-v2-mai-2026` (slim CLAUDE.md + hooks + Stop hook ajoute + agents flat)

A reviewer et merger sur main au rythme de Vincent.

## Decouvertes pendant l'audit

1. **Le hook PostToolUse de Bridge ne formatait JAMAIS** depuis qu'il etait installe — bug `$TOOL_INPUT` (JSON vs path) couple a `exit 0` qui swallow toute erreur. Fix appliquee dans `lint-format.sh`.

2. **biome.json Bridge etait obsolete** (schema 2.0 vs binaire 2.4.10), donc biome refusait de tourner. Migre automatiquement via `biome migrate --write`. Le nouveau hook (qui propage l'exit code) aurait revele ce probleme sans cette migration.

3. **ClubHouse a 89% du plafond** Mnilax (200 lignes / 14 regles). Slim a 46% apres refactor.

4. **Section "Things That Will Bite You" vide ou absente** sur AppDiag et ClubHouse, alors que stacks complexes. Remplies pendant le refactor avec contenu actionnable.

5. **9 subagents Bridge dupliques a 95%** dans ClubHouse et AppDiag (27 fichiers quasi-identiques). Templates parameteres a creer dans une iteration suivante pour deduplication.

6. **4 skills globaux + 1 nouveau (vincent-context)** = 5. Plafond communautaire 2026 : 3-5 actifs simultanement. On est au max.

7. **claude-preset a 132 lignes globales** (vs 200 plafond). Marge OK pour ajouter quelques regles s'il le faut.

## Pour la prochaine iteration (backlog)

- [ ] Dedupliquer les 27 subagents : templates parameteres `{{STACK}}` dans `claude-preset/agents-templates/`
- [ ] Update `init-project/SKILL.md` pour utiliser les templates (claude-md-projet.md + settings-projet.json + agent-template.md)
- [ ] Ajouter un script `claude-preset/sync-projects.sh` qui propage les hooks/agents/CLAUDE.md skeleton aux projets actifs
- [ ] Plugin `babysit-pr` installation (workflow PR automation)
- [ ] PostHog MCP sur Bridge (`npx @posthog/wizard mcp add`)
- [ ] Plugin officiel Anthropic `claude-api` skill (deja livre avec Claude Code v2.1.130+)
- [ ] Cost tracker hook SessionEnd
- [ ] Re-evaluation harness apres release Opus 5

## Reference cross-machine

- Mac pro : applique 2026-05-13 (commit principal `dddde2d` sur veille-tech)
- Mac perso : a appliquer apres `git pull && ./install.sh` dans claude-preset
