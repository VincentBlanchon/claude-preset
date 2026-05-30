---
name: canvas
description: Ouvre une page HTML locale interactive (zero trace) quand il faut FAIRE TRANCHER une decision/un tradeoff a Vincent, ou lui EXPLIQUER un concept technique avec un schema. Vincent clique dans la page, son choix revient automatiquement a Claude et relance l'agent, puis l'onglet se ferme seul. Declencher proactivement pendant un build des qu'une decision structurante, une comparaison d'options, ou une explication technique gagnerait a etre visuelle/interactive plutot qu'un mur de texte. Aussi invocable a la main : /canvas.
---

# /canvas — Pages HTML interactives ephemeres pour decider & expliquer

Industrialise le pattern "HTML is the new markdown" (Thariq/Anthropic) + la boucle interactive (Paras Chopra) pour le workflow de Vincent : **quand je construis et qu'il y a un truc a trancher ou a expliquer, ouvre-moi une page ou je clique, ca me revient direct, et ca ne laisse aucune trace.**

C'est la **version interactive** de la regle globale de Vincent (« options A/B avec tradeoffs AVANT d'agir » + « diagrammes quand l'archi est complexe »).

## Contexte Vincent (IMPORTANT)

- Vincent bosse **principalement dans Claude Desktop**, et **ne lit jamais le code ni le terminal**. Pas technicien.
- Consequence : ces pages sont **son interface principale** pour decider/comprendre. Y aller des qu'une decision/explication a un interet visuel.
- La page doit etre **100% auto-suffisante** : tout le contexte dedans (recap, options, tradeoffs, schema). Il ne lira pas le terminal.
- **Choix triviaux** (oui/non, A/B sans visuel) → `AskUserQuestion` (picker natif Desktop), pas une page.

## Contraintes validees par Vincent (NE PAS DEVIER)

1. **Ouvrir UNIQUEMENT dans le navigateur.** Ne JAMAIS ecrire la page avec l'outil Write en `.html` → ca declenche le panneau preview du Desktop (page en double). **Ecrire le fichier sous une extension NON-html** (ex: `page.canvas`) — `serve.py` le sert en `text/html` quoi qu'il arrive. Puis `open` l'URL.
2. **La validation relance l'agent direct.** Le clic POST sur le serveur local → `serve.py` ecrit `result.json` et s'arrete → la tache background se termine → Claude est re-invoque automatiquement. Rien d'autre a faire cote Vincent.
3. **L'onglet se ferme tout seul apres validation** (fonction `closeTab()` du scaffold).

## Design — verrouille sur vncbln (NE PAS improviser)

Source de verite : `DESIGN.md` du projet `vncbln`. **Fond blanc, monochrome, carre, sobre** (style Linear / Vercel / Levels). Pas de degrade, pas d'effet verre/blur, pas de couleur d'accent fantaisie.

- **Fond : blanc** (`#fff`), force en `color-scheme: light` (ne PAS suivre le dark mode systeme — Vincent veut du blanc).
- Texte : `oklch(0.145 0 0)` (quasi noir) ; muted : `oklch(0.556 0 0)` ; bordures : `oklch(0.922 0 0)` ; fill selectionne : `oklch(0.97 0 0)`.
- Police : **Inter** (sans), **JetBrains Mono** (labels/code/kicker).
- **Radius 6px** (carre). Bordures fines 1px. Pas d'ombres marquees.
- Bouton primaire = fond noir / texte blanc (inversion), pas de degrade.

## Les 2 modes

### Mode DECISION
Header = la question. N **cartes d'option** : titre, l'upside, le **tradeoff**, badge mono « Recommandé » sur ta reco (toujours en premier). Selection. Champ commentaire optionnel. Bouton « Valider mon choix ».
Renvoie : `{ "mode":"decision", "choice":"<id>", "choices":["<id>",...], "comment":"..." }`

### Mode EXPLAIN
Header = le concept. Un **schema** (SVG inline de preference — toujours dispo, pas de reseau ; Mermaid via CDN seulement si diagramme complexe), puis sections annotees. Barre de feedback : « C'est clair ✅ » / « J'ai une question 💬 » + commentaire.
Renvoie : `{ "mode":"explain", "verdict":"clear|question", "comment":"..." }`

## Procedure (a suivre a chaque fois)

### 1. Choisir un port libre
```bash
python3 -c 'import socket;s=socket.socket();s.bind(("127.0.0.1",0));print(s.getsockname()[1]);s.close()'
```
Lire la valeur (ex: 51185).

### 2. Generer la page dans tmp, sous une extension non-html
- Dossier : `"${TMPDIR:-/tmp}/claude-canvas/<slug>"`. Jamais dans le repo.
- Ecrire `page.canvas` (PAS `.html`) a partir du scaffold ci-dessous, en **remplacant `__PORT__` par le port choisi** dans `SUBMIT_URL`. Adapter le header/cartes/schema au cas reel. Garder le `<script>` (submit + closeTab + fallback) tel quel.

### 3. Lancer le serveur (arriere-plan) + ouvrir le navigateur
```bash
# (a) serveur — run_in_background: true — bloque jusqu'au submit puis sort seul
python3 ~/.claude/skills/canvas/serve.py \
  --html "$DIR/page.canvas" --out "$DIR/result.json" --port __PORT__ --timeout 3600
```
```bash
# (b) ouvrir UNIQUEMENT le navigateur (foreground)
sleep 0.8 && open "http://127.0.0.1:__PORT__/"
```
Annoncer « page ouverte, je t'attends » puis **rendre la main**. Le submit de Vincent re-invoque Claude.

### 4. Lire le retour et continuer
Lire `"$DIR/result.json"`, parser choix/commentaire, **continuer**. Pas de fichier (timeout) → demander dans le terminal ou reproposer.

### 5. Nettoyer (zero trace — obligatoire)
`rm -rf "$DIR"`. Ne jamais commit ces fichiers.

## Regles
- **Never kill processes** : `serve.py` s'auto-ferme (submit ou timeout). Ne JAMAIS `kill`/`pkill`. Port pris → en choisir un autre.
- **Surgical** : page jetable, un seul fichier, pas de framework.
- **Fallback** : si le serveur est injoignable, le scaffold copie le payload JSON et affiche un bloc « colle dans Claude ».

## Scaffold (point de depart — remplacer __PORT__ + adapter le contenu, garder le `<script>`)

```html
<!doctype html>
<html lang="fr">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Canvas</title>
<style>
  :root{
    --font-sans:'Inter',system-ui,-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;
    --font-mono:'JetBrains Mono',ui-monospace,SFMono-Regular,Menlo,Monaco,monospace;
    --bg:#ffffff; --fg:oklch(0.145 0 0); --muted:oklch(0.556 0 0);
    --border:oklch(0.922 0 0); --fill:oklch(0.97 0 0); --radius:6px; color-scheme:light;
  }
  *{box-sizing:border-box} html,body{margin:0}
  body{background:var(--bg); color:var(--fg); font-family:var(--font-sans); -webkit-font-smoothing:antialiased;
    padding:56px 24px 120px; max-width:720px; margin:0 auto;}
  .kicker{font-family:var(--font-mono); font-size:11px; letter-spacing:.14em; text-transform:uppercase; color:var(--muted); margin:0 0 12px}
  h1{font-size:22px; font-weight:600; letter-spacing:-.01em; margin:0 0 8px; line-height:1.3}
  .sub{color:var(--muted); margin:0 0 32px; font-size:14px}
  .grid{display:flex; flex-direction:column; gap:10px}
  .card{background:var(--bg); border:1px solid var(--border); border-radius:var(--radius); padding:16px;
    cursor:pointer; transition:border-color .12s, background .12s; display:flex; gap:13px; align-items:flex-start}
  .card:hover{border-color:var(--fg)}
  .card.sel{border-color:var(--fg); background:var(--fill); box-shadow:inset 0 0 0 1px var(--fg)}
  .tick{flex:0 0 16px; width:16px; height:16px; border:1px solid var(--border); border-radius:3px; margin-top:2px; position:relative}
  .card.sel .tick{border-color:var(--fg); background:var(--fg)}
  .card.sel .tick::after{content:""; position:absolute; left:4.5px; top:1.5px; width:4px; height:8px; border:solid var(--bg); border-width:0 2px 2px 0; transform:rotate(45deg)}
  .body{flex:1}
  .card h3{margin:0 0 5px; font-size:15px; font-weight:600; display:flex; align-items:center; gap:10px}
  .badge{font-family:var(--font-mono); font-size:10px; letter-spacing:.1em; text-transform:uppercase; color:var(--muted); border:1px solid var(--border); border-radius:3px; padding:2px 6px; font-weight:500}
  .card p{margin:0; color:var(--muted); font-size:13.5px; line-height:1.5}
  label.cmt{display:block; font-size:13px; color:var(--muted); margin:26px 0 8px}
  textarea{width:100%; background:var(--bg); color:var(--fg); border:1px solid var(--border); border-radius:var(--radius); padding:11px 12px; font:inherit; font-size:14px; resize:vertical; min-height:64px}
  textarea:focus, .card:focus-visible{outline:2px solid var(--fg); outline-offset:2px}
  .bar{position:fixed; left:0; right:0; bottom:0; background:var(--bg); border-top:1px solid var(--border); padding:14px 24px; display:flex; gap:10px; justify-content:flex-end; align-items:center}
  .bar .hint{margin-right:auto; color:var(--muted); font-size:13px; font-family:var(--font-mono)}
  button{font:inherit; font-size:14px; font-weight:500; border-radius:var(--radius); padding:10px 16px; border:1px solid var(--border); background:var(--bg); color:var(--fg); cursor:pointer}
  button:hover{border-color:var(--fg)}
  button.primary{background:var(--fg); color:var(--bg); border-color:var(--fg)}
  button.primary:disabled{opacity:.35; cursor:not-allowed}
  .overlay{position:fixed; inset:0; display:none; place-items:center; background:var(--bg); text-align:center; padding:24px}
  .overlay.on{display:grid}
  .check{width:46px; height:46px; border:1.5px solid var(--fg); border-radius:50%; display:grid; place-items:center; margin:0 auto 16px}
  .check::after{content:""; width:9px; height:17px; border:solid var(--fg); border-width:0 2px 2px 0; transform:rotate(45deg); margin-top:-4px}
  .overlay p{color:var(--muted); font-size:14px; margin:4px 0}
  .fb{display:none; margin-top:18px; border:1px solid var(--border); border-radius:var(--radius); padding:14px; background:var(--fill)}
  .fb.on{display:block}
  .fb pre{font-family:var(--font-mono); font-size:12px; background:var(--bg); border:1px solid var(--border); border-radius:4px; padding:10px; overflow:auto; margin:10px 0 0; white-space:pre-wrap}
</style>
</head>
<body>
  <!-- ADAPTER header + cartes au cas reel (mode decision ci-dessous) -->
  <p class="kicker">Décision · /canvas</p>
  <h1>Question à trancher</h1>
  <p class="sub">Une phrase de contexte.</p>

  <div class="grid" id="opts">
    <div class="card" data-id="A" tabindex="0"><span class="tick"></span>
      <div class="body"><h3>Option A <span class="badge">Recommandé</span></h3>
        <p>✅ L'avantage en une ligne. &nbsp;·&nbsp; ⚖️ Le tradeoff en une ligne.</p></div>
    </div>
    <div class="card" data-id="B" tabindex="0"><span class="tick"></span>
      <div class="body"><h3>Option B</h3>
        <p>✅ L'avantage. &nbsp;·&nbsp; ⚖️ Le tradeoff.</p></div>
    </div>
  </div>

  <label class="cmt" for="comment">Commentaire (optionnel)</label>
  <textarea id="comment" placeholder="Nuance, autre option…"></textarea>

  <div class="bar">
    <span class="hint" id="hint">Choisis une option</span>
    <button id="copy">Copier</button>
    <button class="primary" id="send" disabled>Valider mon choix</button>
  </div>

  <div class="fb" id="fb">
    <b>⚠️ Envoi auto impossible — ton choix est copié.</b>
    <div style="color:var(--muted);font-size:13px;margin-top:4px">Colle ce texte dans Claude Code :</div>
    <pre id="fbjson"></pre>
  </div>

  <div class="overlay" id="ok"><div><div class="check"></div><p><strong style="color:var(--fg)">Envoyé à Claude.</strong></p><p>Cet onglet va se fermer…</p></div></div>

<script>
  const SUBMIT_URL = "http://127.0.0.1:__PORT__/submit"; // URL ABSOLUE => marche depuis toute surface
  let choice = null;
  const cards = [...document.querySelectorAll('#opts .card')];
  function pick(c){ cards.forEach(x=>x.classList.remove('sel')); c.classList.add('sel'); choice=c.dataset.id;
    document.getElementById('send').disabled=false; document.getElementById('hint').textContent='› '+choice; }
  cards.forEach(c => { c.addEventListener('click',()=>pick(c));
    c.addEventListener('keydown',e=>{ if(e.key==='Enter'||e.key===' '){e.preventDefault();pick(c);} }); });
  function payload(){ return { mode:'decision', choice, choices: choice?[choice]:[],
    comment: document.getElementById('comment').value.trim() }; }
  function closeTab(){ try{ window.open('','_self'); window.close(); }catch(e){}
    try{ window.close(); }catch(e){}
    setTimeout(()=>{ try{ window.open('about:blank','_self'); window.close(); }catch(e){} }, 150); }
  async function send(){
    const data = JSON.stringify(payload());
    try{
      const r = await fetch(SUBMIT_URL, { method:'POST', body:data }); // pas de Content-Type => requete simple, zero preflight
      if(!r.ok) throw new Error('status '+r.status);
      document.getElementById('ok').classList.add('on');
      setTimeout(closeTab, 600);
    }catch(e){
      try{ await navigator.clipboard.writeText(data); }catch(_){}
      document.getElementById('fbjson').textContent = data;
      document.getElementById('fb').classList.add('on');
      document.getElementById('hint').textContent = 'copié — colle dans Claude';
    }
  }
  document.getElementById('send').addEventListener('click', send);
  document.getElementById('copy').addEventListener('click', async ()=>{
    try{ await navigator.clipboard.writeText(JSON.stringify(payload())); document.getElementById('hint').textContent='copié ✓'; }catch(_){}
  });
</script>
</body>
</html>
```

## Renommer
Autre nom de commande souhaite ? Renommer le dossier du skill + le champ `name:` + l'entree dans `install.sh`, puis `./install.sh`.
</content>
