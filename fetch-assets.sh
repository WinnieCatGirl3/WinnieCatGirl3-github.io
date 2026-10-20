#!/usr/bin/env bash
# Einmalig ausführen, solange LinkStack lokal läuft (https://localhost:10443).
# Holt alle Dateien, die index.html noch braucht, in die passende Ordnerstruktur.
set -euo pipefail
BASE="https://localhost:10443"
cd "$(dirname "$0")"
grep -oE '(src|href)="\./assets/[^"]+"|url\(\./assets/[^) ]+' index.html \
  | sed -E 's/^(src|href)="//; s/^url\(//; s/"$//; s#^\./##' | sort -u \
| while read -r f; do
    [ -e "$f" ] && continue
    mkdir -p "$(dirname "$f")"
    echo "→ $f"
    curl -fsSk "$BASE/$f" -o "$f" || echo "   !! nicht gefunden: $f"
  done
echo "Fertig."
