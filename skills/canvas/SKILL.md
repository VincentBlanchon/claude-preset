---
name: canvas
description: Ouvre une page HTML locale interactive (zero trace) quand il faut FAIRE TRANCHER une decision/un tradeoff a Vincent, ou lui EXPLIQUER un concept technique avec un schema. Vincent clique dans la page, son choix revient automatiquement a Claude et relance l'agent, l'onglet se ferme seul et la fenetre Claude revient au premier plan. Declencher proactivement pendant un build des qu'une decision structurante, une comparaison d'options, ou une explication technique gagnerait a etre visuelle/interactive plutot qu'un mur de texte. Aussi invocable a la main : /canvas.
---

# /canvas — Pages HTML interactives ephemeres pour decider & expliquer

Industrialise "HTML is the new markdown" (Thariq/Anthropic) + la boucle interactive (Paras Chopra) pour Vincent : **quand je construis et qu'il y a un truc a trancher ou a expliquer, ouvre-moi une page ou je clique, ca me revient direct, ca me ramene dans Claude, et ca ne laisse aucune trace.** C'est la version interactive de sa regle globale (« options A/B avec tradeoffs AVANT d'agir » + diagrammes).

## Contexte Vincent (IMPORTANT)

- Vincent bosse **dans Claude Desktop**, **ne lit jamais le code ni le terminal**. Pas technicien.
- Ces pages sont **son interface principale** pour decider/comprendre. Y aller des qu'une decision/explication a un interet visuel.
- Page **100% auto-suffisante** : tout le contexte dedans (recap, options, tradeoffs, schema).
- **Choix triviaux** (oui/non sans visuel) → `AskUserQuestion`, pas une page.

## Contraintes validees par Vincent (NE PAS DEVIER)

1. **Ouvrir UNIQUEMENT dans le navigateur.** Ne JAMAIS ecrire la page avec l'outil Write en `.html` (ca declenche le panneau preview du Desktop = doublon). **Ecrire sous extension non-html** (`page.canvas`) ; `serve.py` la sert en `text/html`. Puis `open` l'URL.
2. **La validation relance l'agent direct.** Clic → POST → `serve.py` ecrit `result.json` et s'arrete → tache background terminee → Claude re-invoque.
3. **L'onglet se ferme tout seul** apres validation (`closeTab()`).
4. **Retour auto sur Claude** : `serve.py --focus-app "Claude"` ramene la fenetre Claude au premier plan au submit.
5. **Toujours reafficher le choix de Vincent.** Il ne voit PAS son clic dans le fil Claude. Donc apres lecture de `result.json`, **commencer la reponse par un rappel visible** : ex. `✅ Ton choix : Option B — commentaire : "…"`. Sinon il ne sait pas ce qu'il a repondu.

## Design — verrouille sur vncbln.fr (NE PAS improviser)

Palette **beige / vert / terracotta**, chaude et editoriale (PAS monochrome). Tokens reels du site live (`vncbln.fr`) :

| Role | Valeur |
|---|---|
| Fond (`--bg`) | `#f2ead8` (beige creme) |
| Texte (`--fg`) | `#1a1812` (brun quasi noir) |
| Muted | `#857461` (taupe) |
| Bordure | `#d7c9a8` (tan) |
| Primary (boutons) | `#3f5a2a` (vert olive) / texte `#f2ead8` |
| Accent | `#b85436` (terracotta) |
| Success / Warning | `#5a8b5c` / `#d9a14b` |

Polices : **DM Sans** (titres), **Inter** (corps), **JetBrains Mono** (kicker/labels), chargees via Google Fonts (fallback system si offline). **Radius 8px** (carre, sobre). Pas de degrade, pas de blur. Style editorial chaud.

> Le `DESIGN.md` du repo local vncbln est un TEMPLATE non rempli (valeurs placeholder monochromes) — ne PAS s'y fier. La source de verite des couleurs = le site live ci-dessus.

## Les 2 modes

### Mode DECISION
Header = la question. N **cartes d'option** : titre, upside, **tradeoff**, badge « Recommandé » (terracotta) sur ta reco, toujours en premier. Selection + commentaire optionnel. Bouton « Valider mon choix ».
Renvoie : `{ "mode":"decision", "choice":"<id>", "choices":[...], "comment":"..." }`

### Mode EXPLAIN
Header = le concept. **Schema** (SVG inline de preference ; Mermaid via CDN si complexe), sections annotees. Feedback : « C'est clair ✅ » / « J'ai une question 💬 » + commentaire.
Renvoie : `{ "mode":"explain", "verdict":"clear|question", "comment":"..." }`

## Procedure (a chaque fois)

1. **Port libre** : `python3 -c 'import socket;s=socket.socket();s.bind(("127.0.0.1",0));print(s.getsockname()[1]);s.close()'`
2. **Generer** `"${TMPDIR:-/tmp}/claude-canvas/<slug>/page.canvas"` (extension non-html) depuis le scaffold, en remplacant `__PORT__`. Adapter header/cartes/schema. Garder le `<script>`.
3. **Serveur (arriere-plan) + navigateur** :
```bash
# (a) run_in_background: true — bloque jusqu'au submit puis sort seul
python3 ~/.claude/skills/canvas/serve.py \
  --html "$DIR/page.canvas" --out "$DIR/result.json" --port __PORT__ --timeout 3600 \
  --focus-app "Claude"
```
```bash
# (b) ouvrir le navigateur (foreground)
sleep 0.8 && open "http://127.0.0.1:__PORT__/"
```
Annoncer « page ouverte, je t'attends » puis rendre la main.
4. **Lire `result.json`** → **rappeler le choix de Vincent en tete de reponse** (contrainte #5) → continuer.
5. **Nettoyer** : `rm -rf "$DIR"`. Jamais commit.

## Regles
- **Never kill** : `serve.py` s'auto-ferme (submit/timeout). Jamais `kill`/`pkill`. Port pris → en changer.
- **Surgical** : page jetable, un fichier, pas de framework.
- **Fallback** : serveur injoignable → le scaffold copie le payload et affiche « colle dans Claude ».

## Scaffold (remplacer __PORT__ + adapter le contenu, garder le `<script>`)

```html
<!doctype html>
<html lang="fr">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Canvas</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;600;700&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@500&display=swap" rel="stylesheet">
<style>
  :root{
    --font-sans:'Inter',system-ui,-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;
    --font-display:'DM Sans','Inter',system-ui,sans-serif;
    --font-mono:'JetBrains Mono',ui-monospace,SFMono-Regular,Menlo,Monaco,monospace;
    --bg:#f2ead8; --fg:#1a1812; --muted:#857461; --border:#d7c9a8;
    --card:#f7f1e3; --fill:#ece2cd; --primary:#3f5a2a; --primary-fg:#f2ead8; --accent:#b85436;
    --radius:8px; color-scheme:light;
  }
  *{box-sizing:border-box} html,body{margin:0}
  body{background:var(--bg); color:var(--fg); font-family:var(--font-sans); -webkit-font-smoothing:antialiased;
    padding:56px 24px 120px; max-width:720px; margin:0 auto;}
  .kicker{font-family:var(--font-mono); font-size:11px; letter-spacing:.14em; text-transform:uppercase; color:var(--accent); margin:0 0 12px}
  h1{font-family:var(--font-display); font-size:23px; font-weight:600; letter-spacing:-.01em; margin:0 0 8px; line-height:1.25}
  .sub{color:var(--muted); margin:0 0 32px; font-size:14px}
  .grid{display:flex; flex-direction:column; gap:10px}
  .card{background:var(--card); border:1px solid var(--border); border-radius:var(--radius); padding:16px;
    cursor:pointer; transition:border-color .12s, background .12s; display:flex; gap:13px; align-items:flex-start}
  .card:hover{border-color:var(--primary)}
  .card.sel{border-color:var(--primary); background:var(--fill); box-shadow:inset 0 0 0 1px var(--primary)}
  .tick{flex:0 0 16px; width:16px; height:16px; border:1px solid var(--border); border-radius:4px; margin-top:2px; position:relative; background:var(--bg)}
  .card.sel .tick{border-color:var(--primary); background:var(--primary)}
  .card.sel .tick::after{content:""; position:absolute; left:4.5px; top:1.5px; width:4px; height:8px; border:solid var(--primary-fg); border-width:0 2px 2px 0; transform:rotate(45deg)}
  .body{flex:1}
  .card h3{font-family:var(--font-display); margin:0 0 5px; font-size:15px; font-weight:600; display:flex; align-items:center; gap:10px}
  .badge{font-family:var(--font-mono); font-size:10px; letter-spacing:.1em; text-transform:uppercase; color:var(--accent); border:1px solid var(--accent); border-radius:4px; padding:2px 6px; font-weight:500}
  .card p{margin:0; color:var(--muted); font-size:13.5px; line-height:1.5}
  label.cmt{display:block; font-size:13px; color:var(--muted); margin:26px 0 8px}
  textarea{width:100%; background:var(--card); color:var(--fg); border:1px solid var(--border); border-radius:var(--radius); padding:11px 12px; font:inherit; font-size:14px; resize:vertical; min-height:64px}
  textarea:focus, .card:focus-visible{outline:2px solid var(--primary); outline-offset:2px}
  .bar{position:fixed; left:0; right:0; bottom:0; background:var(--bg); border-top:1px solid var(--border); padding:14px 24px; display:flex; gap:10px; justify-content:flex-end; align-items:center}
  .bar .hint{margin-right:auto; color:var(--muted); font-size:13px; font-family:var(--font-mono)}
  button{font:inherit; font-size:14px; font-weight:500; border-radius:var(--radius); padding:10px 16px; border:1px solid var(--border); background:var(--card); color:var(--fg); cursor:pointer}
  button:hover{border-color:var(--fg)}
  button.primary{background:var(--primary); color:var(--primary-fg); border-color:var(--primary)}
  button.primary:disabled{opacity:.4; cursor:not-allowed}
  .overlay{position:fixed; inset:0; display:none; place-items:center; background:var(--bg); text-align:center; padding:24px}
  .overlay.on{display:grid}
  .check{width:46px; height:46px; border:1.5px solid var(--primary); border-radius:50%; display:grid; place-items:center; margin:0 auto 16px}
  .check::after{content:""; width:9px; height:17px; border:solid var(--primary); border-width:0 2px 2px 0; transform:rotate(45deg); margin-top:-4px}
  .overlay p{color:var(--muted); font-size:14px; margin:4px 0}
  .fb{display:none; margin-top:18px; border:1px solid var(--border); border-radius:var(--radius); padding:14px; background:var(--fill)}
  .fb.on{display:block}
  .fb pre{font-family:var(--font-mono); font-size:12px; background:var(--card); border:1px solid var(--border); border-radius:4px; padding:10px; overflow:auto; margin:10px 0 0; white-space:pre-wrap}
</style>
</head>
<body>
  <!-- ADAPTER header + cartes (mode decision ci-dessous) -->
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

  <div class="overlay" id="ok"><div><div class="check"></div><p><strong style="color:var(--fg)">Envoyé à Claude.</strong></p><p>Retour sur Claude…</p></div></div>

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
Autre nom de commande ? Renommer le dossier + `name:` + l'entree dans `install.sh`, puis `./install.sh`.
</content>
