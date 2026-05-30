#!/usr/bin/env python3
"""
canvas-serve — Serveur local ephemere pour le skill /canvas.

Sert UN fichier HTML sur localhost, attend que l'utilisateur POST son choix /
ses commentaires sur /submit, ecrit le resultat en JSON, puis s'auto-ferme.

- Stdlib uniquement, zero dependance.
- Bind 127.0.0.1 seulement (jamais expose au reseau).
- S'arrete tout seul au submit OU apres --timeout secondes. Personne n'a a le
  tuer (respecte la regle "never kill processes").

Usage (le port est choisi par l'appelant pour eviter de lire stdout) :
  python3 serve.py --html /tmp/.../page.html --out /tmp/.../result.json --port 54321 [--timeout 3600]
"""
import argparse
import json
import subprocess
import sys
import threading
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--html", required=True, help="Chemin du fichier HTML a servir")
    ap.add_argument("--out", required=True, help="Chemin du JSON resultat a ecrire")
    ap.add_argument("--port", type=int, default=0, help="Port (0 = auto)")
    ap.add_argument("--timeout", type=int, default=3600, help="Secondes avant auto-arret")
    ap.add_argument("--focus-app", default=None,
                    help="App macOS a ramener au premier plan apres submit (ex: Claude)")
    args = ap.parse_args()

    html_bytes = Path(args.html).read_bytes()
    out_path = Path(args.out)
    focus_app = args.focus_app
    done = threading.Event()

    class Handler(BaseHTTPRequestHandler):
        def log_message(self, *_):  # silence les logs HTTP
            return

        def _cors(self):
            self.send_header("Access-Control-Allow-Origin", "*")

        def do_GET(self):
            if self.path in ("/", "/index.html"):
                self.send_response(200)
                self.send_header("Content-Type", "text/html; charset=utf-8")
                self.send_header("Content-Length", str(len(html_bytes)))
                self.end_headers()
                self.wfile.write(html_bytes)
            else:  # favicon, etc.
                self.send_response(204)
                self.end_headers()

        def do_OPTIONS(self):
            self.send_response(204)
            self._cors()
            self.send_header("Access-Control-Allow-Methods", "POST, OPTIONS")
            self.send_header("Access-Control-Allow-Headers", "Content-Type")
            self.end_headers()

        def do_POST(self):
            if self.path != "/submit":
                self.send_response(404)
                self.end_headers()
                return
            length = int(self.headers.get("Content-Length", 0) or 0)
            raw = self.rfile.read(length) if length else b"{}"
            try:
                data = json.loads(raw.decode("utf-8"))
            except Exception:
                data = {"raw": raw.decode("utf-8", "replace")}
            out_path.write_text(
                json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8"
            )
            resp = json.dumps({"ok": True}).encode("utf-8")
            self.send_response(200)
            self._cors()
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(resp)))
            self.end_headers()
            self.wfile.write(resp)
            # ramene Claude (ou l'app demandee) au premier plan — l'utilisateur
            # revient direct dans Claude apres avoir valide dans le navigateur
            if focus_app:
                try:
                    subprocess.Popen(["open", "-a", focus_app],
                                     stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                except Exception:
                    pass
            done.set()

    server = ThreadingHTTPServer(("127.0.0.1", args.port), Handler)
    port = server.server_address[1]
    print(f"http://127.0.0.1:{port}/", flush=True)

    threading.Thread(target=server.serve_forever, daemon=True).start()
    submitted = done.wait(timeout=args.timeout)
    server.shutdown()
    if submitted:
        return 0
    sys.stderr.write("canvas-serve: timeout — aucune soumission recue\n")
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
