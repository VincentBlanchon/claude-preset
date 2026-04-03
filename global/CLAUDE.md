# Global Rules — All Projects

## DETECTION PROJET VIERGE — AUTOMATIQUE
Si tu detectes que le dossier courant n'a PAS de CLAUDE.md ET PAS de .git/ (projet vierge), OU si Vincent dit "nouveau projet", "on demarre un projet", "init project", ou equivalent :
- PROPOSE IMMEDIATEMENT : "Ce projet est vierge. Tape `/init-project` dans le prompt pour lancer l'initialisation complete. Ca va te poser des questions pour bien cadrer le projet avant de toucher au code."
- IMPORTANT : `/init-project` est une commande que VINCENT doit taper lui-meme dans le prompt. Tu ne peux PAS la lancer toi-meme via le Skill tool. Demande-lui de la taper.
- N'attends PAS que Vincent le demande. Propose-le.
- Si le hook SessionStart affiche "[PROJET VIERGE]", c'est la confirmation — propose le init-project.

## NEVER KILL PROCESSES — ABSOLUTE RULE
- **NEVER** run `taskkill`, `pkill`, `kill`, `killall`, or ANY process-killing command.
- **NEVER** run `taskkill //F //IM "node.exe"` or similar — this kills ALL running agents, dev servers, and tools on the machine.
- If a port is in use, **ASK the user** which process to stop. Do NOT kill anything yourself.
- If a dev server needs restarting, **ASK the user** to do it manually.
- The user runs MULTIPLE agents and servers simultaneously. Killing processes destroys all of them.
- This rule has NO exceptions. Even if something seems stuck, ASK FIRST.

## NEVER CRASH / STOP MID-CONVERSATION
- **NEVER** stop, crash, or kill the session mid-task.
- If context is getting long, compress or summarize — do NOT die.
- If a tool fails, retry or ask the user — do NOT bail out.
- If unsure about something, ASK — do NOT stop working.
- Always finish what you started. No silent deaths. No unexplained stops.
