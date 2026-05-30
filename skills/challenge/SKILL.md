---
name: challenge
description: Attaque une idée/décision sous plusieurs angles AVANT que Vincent s'y engage (anti « oui-oui »). Déclencher quand Vincent dit « challenge-moi », « t'es sûr ? », « trouve les failles », « avant qu'on se lance », ou avant de valider une direction structurante. Aussi invocable à la main : /challenge. Complète le challenge de plan déjà présent dans /feature et /take-your-time, mais utilisable à tout moment, en pleine conversation.
---

# /challenge — Board of Advisors (anti « oui-oui »)

Les modèles sont des « oui-oui » convaincants : par défaut j'abonde dans le sens de Vincent. Ce skill force le **challenge multi-angles** avant qu'il s'engage sur une idée/décision. Vincent est non-dev → il ne peut pas toujours me contredire techniquement, donc le système doit produire la contradiction lui-même.

## Quand l'utiliser
- Vincent demande explicitement de le challenger (« challenge-moi », « t'es sûr ? », « trouve les failles »).
- AVANT de s'engager sur une décision structurante (archi, choix de produit, direction).
- Quand je me surprends à être trop d'accord trop vite.

Pour un simple oui/non sans enjeu → inutile, répondre directement.

## Les 5 angles d'attaque (Board of Advisors)

Attaquer l'idée depuis 5 perspectives distinctes — chacune cherche à la **faire tomber**, pas à la valider :

1. **Avocat du diable** — suppose que l'idée va échouer et tente de le prouver. Quel est le scénario d'échec le plus probable ?
2. **Élimineur d'hypothèses** — retire les hypothèses implicites. Qu'est-ce qui DOIT être vrai pour que ça marche ? Lesquelles sont fragiles ?
3. **Critique d'exécution** — faisabilité, temps, complexité. « C'est faisable, mais à quel coût / dans quels délais réalistes ? »
4. **Réaliste marché/utilisateur** — confronte aux vrais usages, à la concurrence, à ce que l'utilisateur fera vraiment (pas ce qu'on espère).
5. **Explorateur d'alternatives** — propose 1-2 approches radicalement différentes. « Et si on faisait l'inverse / rien / autre chose ? »

## Comment procéder

1. **Reformuler** l'idée/décision en une phrase nette (vérifier qu'on attaque la bonne cible).
2. **Lancer les 5 angles.**
   - Décision à fort enjeu → spawner les 5 en **sous-agents parallèles** (Agent tool), chacun avec sa lentille, consigne « cherche à réfuter, sois impitoyable mais concret ». Pour un très gros sujet, possible via un workflow.
   - Décision rapide → dérouler les 5 angles inline.
3. **Synthétiser** : les **3-5 objections les plus tranchantes** (pas du bruit), ce qui devrait être vrai pour que l'idée tienne, et un **verdict clair** : `GO` / `AJUSTE (quoi)` / `REPENSE (pourquoi)`.
4. **Présenter à Vincent via `/canvas`** (il est visuel, non-dev) : une page mode explain/décision avec, par angle, l'objection clé, puis le verdict et une décision (`On y va` / `J'ajuste` / `On repense`). Voir le skill `/canvas`.

## Règles
- **Vraies objections, pas du théâtre.** Si l'idée est solide, le dire — mais seulement après l'avoir vraiment attaquée. Le but n'est pas de tout casser, c'est d'éclairer les angles morts.
- **Concret.** Chaque objection doit être actionnable ou vérifiable, pas une généralité.
- **Tranche.** Finir par un avis assumé, pas un « ça dépend ».
- Ne pas confondre avec `/feature` (qui challenge le PLAN une fois la direction prise) : `/challenge` sert à choisir la direction elle-même.
