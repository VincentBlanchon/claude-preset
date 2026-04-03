## Working with Vincent

Vincent pilote Claude Code pour coder. Il comprend les concepts business
et l'architecture de maniere intuitive, pas les details d'implementation.

- Premiere rencontre avec un concept technique : expliquer brievement
  avec une analogie si pertinent. Ex: "RLS = chaque user ne voit que
  ses donnees, comme une cle de chambre d'hotel."
- Rencontres suivantes : rappel en une phrase. Si Vincent dit "je gere",
  avancer. S'il pose une question, prendre le temps d'expliquer.
- Si Vincent utilise un terme technique, ne pas supposer qu'il le
  maitrise. En cas de doute, faire un rappel rapide. Le corriger
  gentiment si la definition est approximative — ca l'aide a progresser.
- Decisions structurantes (architecture, choix de lib, design pattern) :
  poser la question, expliquer les options et trade-offs AVANT d'agir.
- Diagrammes Mermaid quand l'architecture est complexe.

## DETECTION PROJET VIERGE — AUTOMATIQUE

Si tu detectes que le dossier courant n'a PAS de CLAUDE.md ET PAS de .git/ (projet vierge), OU si Vincent dit "nouveau projet", "on demarre un projet", "init project", ou equivalent :
- PROPOSE IMMEDIATEMENT : "Ce projet est vierge. Tape `/init-project` dans le prompt pour lancer l'initialisation complete."
- N'attends PAS que Vincent le demande. Propose-le.

## NEVER KILL PROCESSES — ABSOLUTE RULE

- **NEVER** run `taskkill`, `pkill`, `kill`, `killall`, or ANY process-killing command.
- If a port is in use, **ASK the user** which process to stop. Do NOT kill anything yourself.
- The user runs MULTIPLE agents and servers simultaneously. Killing processes destroys all of them.
- This rule has NO exceptions. Even if something seems stuck, ASK FIRST.

## NEVER CRASH / STOP MID-CONVERSATION

- If context is getting long, compress or summarize — do NOT die.
- If a tool fails, retry or ask the user — do NOT bail out.
- Always finish what you started. No silent deaths. No unexplained stops.

## Sync auto — projets multi-machines

Les projets suivants sont partages entre l'ordi pro et l'ordi perso.
Toujours synchroniser via git pour eviter les divergences.

Projets concernes :
- `/Users/vincent/Developer/Carriere` (origin: GitHub)
- `/Users/vincent/Developer/Veille tech` (origin: GitHub)
- `/Users/vincent/Developer/claude-preset` (origin: GitHub) — source de verite pour les skills et la config

**En arrivant sur le projet** (debut de conversation) :
→ `git pull` pour recuperer les derniers changements.

**En quittant le projet** (quand Vincent dit qu'il a fini, ou fin de session) :
→ `git add -A && git commit -m "chore: sync" && git push` si des fichiers ont change.

**Apres un pull de claude-preset** :
→ Lancer `./install.sh` pour mettre a jour les skills globaux sur cette machine.
