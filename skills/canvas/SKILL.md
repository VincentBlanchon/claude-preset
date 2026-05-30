---
name: canvas
description: Ouvre une page HTML locale interactive (zero trace) quand il faut FAIRE TRANCHER une decision/un tradeoff a Vincent, ou lui EXPLIQUER un concept technique avec un schema. Vincent clique/commente dans la page, son choix revient automatiquement a Claude via un serveur local auto-fermant. Declencher proactivement pendant un build des qu'une decision structurante, une comparaison d'options, ou une explication technique gagnerait a etre visuelle/interactive plutot qu'un mur de texte dans le terminal. Aussi invocable a la main : /canvas.
---

# /canvas — Pages HTML interactives ephemeres pour decider & expliquer

Ce skill industrialise le pattern "HTML is the new markdown" (Thariq/Anthropic) + la boucle interactive (Paras Chopra) pour le workflow de Vincent : **quand je construis et qu'il y a un truc a trancher ou a expliquer, ouvre-moi une page locale ou je clique/interagis, et que ca ne laisse aucune trace.**

C'est la **version interactive** de la regle globale de Vincent (« options A/B avec tradeoffs AVANT d'agir » + « diagrammes Mermaid quand l'archi est complexe »). Au lieu d'un mur de texte dans le terminal, on rend une vraie page.

## Contexte Vincent (IMPORTANT)

- Vincent bosse **principalement dans Claude Desktop**, et **ne lit jamais le code ni le terminal**. Il n'est pas technicien.
- Consequence : ces pages `/canvas` sont **son interface principale** pour decider/comprendre, pas un gadget occasionnel. Y aller des qu'une decision/explication a un interet visuel.
- La page doit etre **100% auto-suffisante** : tout le contexte necessaire dedans (recap, options, tradeoffs, schema), aucune dependance a ce qui est ecrit dans le terminal.
- **Surface choisie par Vincent : onglet navigateur + retour auto** (le mini-serveur local). Donc : generer le HTML, lancer `serve.py`, et **toujours `open` la page** — ne pas se contenter de l'ecrire.
- **Choix triviaux (oui/non, A/B simple, sans visuel)** : utiliser `AskUserQuestion` (picker natif, integre au Desktop, cliquable) plutot qu'une page. Reserver `/canvas` aux cas ou voir/comparer/schematiser aide vraiment.

## Quand l'utiliser (et quand NON)

**Utiliser** — proactivement, sans que Vincent le demande, quand pendant un build :
- Il y a une **decision structurante** a trancher (archi, choix de lib, design pattern) avec ≥ 2 options et de vrais tradeoffs.
- Il faut **comparer plusieurs options** cote a cote (mockups, approches, configs) — la comparaison visuelle bat le texte.
- Il faut **expliquer un concept technique** ou un flux ou un bout d'archi — un **schema** (SVG/diagramme) vaut 1000 mots.
- Il faut **ajuster/trier/tuner** quelque chose de penible a decrire en texte (ordre de priorites, valeurs, couleurs, params).

**NE PAS utiliser** (rester en terminal / AskUserQuestion) :
- Choix binaire trivial (oui/non, un nom de variable) → demander en une ligne, ou `AskUserQuestion`.
- Rien de visuel ni d'options multiples a comparer → le HTML (2-4x plus lent a generer) n'apporte rien.
- Pendant une tache ou Vincent a demande de ne pas etre interrompu / mode autonome.

> Regle de jugement : « est-ce que voir + cliquer aide vraiment Vincent a decider/comprendre, vs lire 5 lignes ? » Si oui → /canvas. Sinon → terminal.

## Les 2 modes

### Mode DECISION
Header = la question. N **cartes d'option**, chacune : titre, l'upside en une ligne, le **tradeoff** en une ligne, badge « Recommandé » sur celle que tu conseilles (toujours mettre ta reco en premier, comme la regle globale). Selection (radio = un choix, cases = multi). Champ commentaire optionnel. Bouton « Valider mon choix ».
Payload renvoye : `{ "mode": "decision", "choice": "<id>", "choices": ["<id>", ...], "comment": "..." }`

### Mode EXPLAIN
Header = le concept. Un **schema** (SVG inline de preference, ou Mermaid via CDN), puis des sections annotees (flux, snippets de code colorises, section « pieges »). Barre de feedback en bas : « C'est clair ✅ » / « J'ai une question 💬 » + champ commentaire.
Payload renvoye : `{ "mode": "explain", "verdict": "clear|question", "comment": "..." }`

Pour les schemas : **SVG inline** (toujours dispo, pas de reseau) pour flowcharts/boxes-and-arrows simples. **Mermaid** (`https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.min.js`) acceptable pour les diagrammes complexes (sequence, ER, gantt) si une connexion est probable.

## Procedure (a suivre a chaque fois)

### 1. Generer la page dans un dossier tmp (zero trace)
- Dossier : `"${TMPDIR:-/tmp}/claude-canvas/<slug>"` ou `<slug>` = horodatage + sujet court en kebab-case. Ne JAMAIS ecrire dans le repo du projet.
- Ecrire `page.html` : **un seul fichier auto-suffisant** (CSS + JS inline), en partant du scaffold ci-dessous. Soigner le design (Vincent est exigeant : dark theme, spacing genereux, hierarchie claire, « museum quality »).
- Adapter le contenu a la decision/explication reelle. Garder le bloc `<script>` de submit/fallback tel quel.

### 2. Lancer le serveur local auto-fermant
Choisir un port libre, puis lancer le serveur en **arriere-plan** (`run_in_background: true`) et ouvrir le navigateur. Le serveur vit a `~/.claude/skills/canvas/serve.py`.

```bash
# (a) port libre — lis la valeur renvoyee
python3 -c 'import socket;s=socket.socket();s.bind(("127.0.0.1",0));print(s.getsockname()[1]);s.close()'
```
Puis, en substituant le port lu (ex: 54321) :
```bash
# (b) serveur en arriere-plan (run_in_background: true) — il bloque jusqu'au submit, puis sort seul
python3 ~/.claude/skills/canvas/serve.py \
  --html "$DIR/page.html" --out "$DIR/result.json" --port 54321 --timeout 3600
```
```bash
# (c) ouvrir la page (foreground)
open "http://127.0.0.1:54321/"
```
Annoncer a Vincent : « page ouverte dans ton navigateur, je t'attends » — puis **rendre la main**. Quand Vincent valide, `serve.py` ecrit `result.json` et s'arrete → la tache background se termine → Claude est re-invoque automatiquement.

### 3. Lire le retour et continuer
- Lire `"$DIR/result.json"`, parser le choix/commentaire, **continuer le travail** en consequence.
- Si pas de `result.json` (timeout / fermeture) : demander a Vincent dans le terminal, ou proposer de relancer.

### 4. Nettoyer (zero trace — obligatoire)
- `rm -rf "$DIR"` une fois le retour lu. Le dossier est dans tmp donc l'OS le purge de toute facon, mais nettoyer explicitement.
- **Ne jamais commit** ces fichiers. **Ne jamais** les laisser dans le repo. Aucune trace ne doit subsister.

## Regles
- **Never kill processes** : `serve.py` s'auto-ferme (submit ou timeout). Ne JAMAIS `kill`/`pkill` un serveur canvas ni un autre process. Si un port semble pris, en choisir un autre.
- **Surgical** : la page est jetable, purpose-built pour CETTE decision. Pas de framework, pas de build, un seul fichier.
- **Fallback toujours present** : le bouton « Copier (secours) » du scaffold copie le payload JSON dans le presse-papier — si le serveur a un souci, Vincent colle dans le terminal et Claude lit ca.

## Scaffold HTML (point de depart — adapter le contenu, garder le `<script>`)

```html
<!doctype html>
<html lang="fr">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Canvas — décision</title>
<style>
  :root{
    --bg:#0b0d12; --surface:#141821; --surface-2:#1b2130; --border:#2a3242;
    --text:#e7ecf3; --muted:#94a3b8; --accent:#7c9cff; --accent-2:#a78bfa;
    --ok:#34d399; --warn:#fbbf24; --radius:14px;
  }
  *{box-sizing:border-box} html,body{margin:0}
  body{background:radial-gradient(1200px 600px at 70% -10%,#1a2030,transparent),var(--bg);
    color:var(--text); font:15px/1.55 -apple-system,BlinkMacSystemFont,"Segoe UI",Inter,sans-serif;
    padding:40px 20px 140px; max-width:900px; margin:0 auto;}
  h1{font-size:24px; margin:0 0 6px; letter-spacing:-.02em}
  .sub{color:var(--muted); margin:0 0 28px}
  .grid{display:grid; gap:16px}
  .card{background:var(--surface); border:1px solid var(--border); border-radius:var(--radius);
    padding:18px 18px 16px; cursor:pointer; transition:border-color .15s, transform .05s, background .15s; position:relative}
  .card:hover{border-color:var(--accent)}
  .card.sel{border-color:var(--accent); background:var(--surface-2); box-shadow:0 0 0 1px var(--accent) inset}
  .card h3{margin:0 0 8px; font-size:17px}
  .card .up{color:var(--text)} .card .trade{color:var(--muted); font-size:13.5px; margin-top:4px}
  .badge{position:absolute; top:14px; right:14px; font-size:11px; font-weight:600; color:#0b0d12;
    background:linear-gradient(90deg,var(--accent),var(--accent-2)); padding:3px 9px; border-radius:999px}
  .tag{display:inline-block; font-size:12px; color:var(--muted); border:1px solid var(--border); border-radius:999px; padding:1px 8px; margin-right:6px}
  textarea{width:100%; margin-top:18px; background:var(--surface); color:var(--text); border:1px solid var(--border);
    border-radius:12px; padding:12px; font:inherit; resize:vertical; min-height:64px}
  .bar{position:fixed; left:0; right:0; bottom:0; background:rgba(11,13,18,.85); backdrop-filter:blur(10px);
    border-top:1px solid var(--border); padding:14px 20px; display:flex; gap:12px; justify-content:flex-end; align-items:center}
  .bar .hint{margin-right:auto; color:var(--muted); font-size:13px}
  button{font:inherit; font-weight:600; border-radius:11px; padding:11px 18px; border:1px solid var(--border);
    background:var(--surface-2); color:var(--text); cursor:pointer}
  button.primary{border:0; background:linear-gradient(90deg,var(--accent),var(--accent-2)); color:#0b0d12}
  button:disabled{opacity:.45; cursor:not-allowed}
  .overlay{position:fixed; inset:0; display:none; place-items:center; background:rgba(11,13,18,.92); backdrop-filter:blur(6px); text-align:center}
  .overlay.on{display:grid} .overlay .big{font-size:42px} .overlay p{color:var(--muted)}
  svg .box{fill:var(--surface-2); stroke:var(--border)} svg text{fill:var(--text); font:13px sans-serif}
</style>
</head>
<body>
  <!-- ADAPTER: le header + les cartes au cas reel. Mode decision ci-dessous. -->
  <h1>⟶ Question a trancher</h1>
  <p class="sub">Une phrase de contexte sur la decision.</p>

  <div class="grid" id="opts">
    <!-- data-id sert d'identifiant renvoye a Claude -->
    <div class="card" data-id="A"><span class="badge">Recommandé</span>
      <h3>Option A</h3>
      <div class="up">✅ L'avantage principal en une ligne.</div>
      <div class="trade">⚖️ Le tradeoff / cout en une ligne.</div>
    </div>
    <div class="card" data-id="B">
      <h3>Option B</h3>
      <div class="up">✅ L'avantage principal.</div>
      <div class="trade">⚖️ Le tradeoff.</div>
    </div>
  </div>

  <textarea id="comment" placeholder="Commentaire / nuance / autre option (optionnel)…"></textarea>

  <div class="bar">
    <span class="hint" id="hint">Choisis une option</span>
    <button id="copy">Copier (secours)</button>
    <button class="primary" id="send" disabled>Valider mon choix</button>
  </div>

  <div class="overlay" id="ok"><div><div class="big">✅</div><p>Envoyé à Claude — tu peux fermer cet onglet.</p></div></div>

<script>
  // --- selection (radio par defaut ; pour du multi, retirer le reset de classe) ---
  let choice = null;
  const cards = [...document.querySelectorAll('#opts .card')];
  cards.forEach(c => c.addEventListener('click', () => {
    cards.forEach(x => x.classList.remove('sel'));
    c.classList.add('sel'); choice = c.dataset.id;
    document.getElementById('send').disabled = false;
    document.getElementById('hint').textContent = 'Option ' + choice + ' sélectionnée';
  }));

  function payload(){
    return { mode:'decision', choice, choices: choice?[choice]:[],
             comment: document.getElementById('comment').value.trim() };
  }
  // --- submit au serveur local ; l'agent est reveille a la reception ---
  async function send(){
    try{
      await fetch('/submit', {method:'POST', headers:{'Content-Type':'application/json'},
        body: JSON.stringify(payload())});
      document.getElementById('ok').classList.add('on');
    }catch(e){ copyFallback(true); }
  }
  // --- fallback : copier le JSON pour coller dans le terminal si le serveur est down ---
  function copyFallback(auto){
    navigator.clipboard.writeText(JSON.stringify(payload())).then(()=>{
      document.getElementById('hint').textContent =
        (auto?'Serveur injoignable — ':'') + 'copié ✓ colle-le dans Claude Code';
    });
  }
  document.getElementById('send').addEventListener('click', send);
  document.getElementById('copy').addEventListener('click', ()=>copyFallback(false));
</script>
</body>
</html>
```

## Renommer
Si Vincent prefere un autre nom de commande (ex: `/visuel`, `/atelier`, `/sketch`), renommer le dossier du skill + le champ `name:` + l'entree dans `install.sh`, puis relancer `./install.sh`.
</content>
