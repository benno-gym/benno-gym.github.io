#!/usr/bin/env bash
# =============================================================================
#  Schriften selbst hosten – wunschgaeste.de
#  ---------------------------------------------------------------------------
#  Lädt "Bricolage Grotesque" und "Inter" einmalig von Google herunter und legt
#  sie in assets/fonts/ ab. Danach lädt die Website keine externen Ressourcen
#  mehr – das ist die datenschutzfreundlichste Variante (kein Google-Kontakt
#  beim Besucher, keine IP-Übertragung).
#
#  Beide Schriften stehen unter der SIL Open Font License und dürfen
#  selbst gehostet werden.
#
#  Aufruf im Ordner der Website:
#      chmod +x fonts-selbst-hosten.sh
#      ./fonts-selbst-hosten.sh
#
#  Danach noch drei Handgriffe (das Skript erinnert am Ende daran):
#    1. In index.html die drei <link>-Zeilen zu fonts.googleapis.com /
#       fonts.gstatic.com löschen.
#    2. In assets/css/style.css den auskommentierten @font-face-Block
#       ganz oben aktivieren (die Zeilen mit .woff2).
#    3. In index.html den Google-Fonts-Absatz aus der Datenschutzerklärung
#       entfernen und in .htaccess die beiden Google-Domains aus der
#       Content-Security-Policy streichen.
# =============================================================================
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="$DIR/assets/fonts"
mkdir -p "$OUT"

UA='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0 Safari/537.36'
API='https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,400..800&family=Inter:wght@400..700&display=swap'

echo "→ Schrift-Definitionen abrufen …"
CSS="$(curl -sSL -A "$UA" "$API")"

hole() {                       # $1 = Familienname im CSS, $2 = Zieldatei
  local url
  url="$(printf '%s' "$CSS" \
        | awk -v fam="$1" 'BEGIN{RS="@font-face"} $0 ~ fam && $0 ~ /latin/ && $0 !~ /latin-ext/ {print}' \
        | grep -o 'https://fonts.gstatic.com[^)]*' | head -n1)"
  if [ -z "$url" ]; then
    echo "   ! Konnte $1 nicht finden – bitte manuell von fonts.google.com laden." >&2
    return 1
  fi
  echo "→ $2"
  curl -sSL -A "$UA" "$url" -o "$OUT/$2"
}

hole "Bricolage Grotesque" "bricolage-grotesque-latin.woff2"
hole "Inter"               "inter-latin.woff2"

echo
echo "Fertig. Dateien liegen in: $OUT"
ls -lh "$OUT"/*.woff2
echo
echo "Jetzt noch:"
echo "  1) index.html  – die <link>-Zeilen zu fonts.googleapis.com/fonts.gstatic.com löschen"
echo "  2) assets/css/style.css – den @font-face-Block ganz oben einkommentieren"
echo "  3) index.html  – Google-Fonts-Absatz aus der Datenschutzerklärung entfernen"
echo "     .htaccess   – die beiden Google-Domains aus der CSP streichen"
