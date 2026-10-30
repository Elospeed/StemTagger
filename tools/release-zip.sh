#!/usr/bin/env bash
# Baut das ZIP für die Release-Seite (läuft im Workflow build.yml, geht aber
# auch lokal mit Git Bash):
#
#   tools/release-zip.sh <StemTagger.exe> <Ausgabeordner>
#
# Inhalt (Ordner StemTagger\):
#   StemTagger.exe, LIESMICH.txt (DE), README.txt (EN), LICENSE.txt,
#   lang\*.po (alle Übersetzungen; Deutsch steckt in der Exe)
# Die Version kommt aus APP_VER in src/taggerform.pas.
#
# Ergebnis: <Ausgabeordner>/StemTagger-<Version>.zip
# Dasselbe ZIP übernimmt StemMaker als AddOn (StemTagger.exe nach AddOns\).
set -euo pipefail

EXE=$(realpath "$1"); mkdir -p "$2"; AUS=$(realpath "$2")
REPO=$(realpath "$(dirname "$0")/..")
VERSION=$(sed -n "s/^ *APP_VER *= *'\(.*\)';.*/\1/p" "$REPO/src/taggerform.pas" | head -n 1 | tr -d '\r')
[ -n "$VERSION" ] || { echo "APP_VER in src/taggerform.pas nicht gefunden"; exit 1; }

ARBEIT=$(mktemp -d)
trap 'rm -rf "$ARBEIT"' EXIT
ZIEL="$ARBEIT/StemTagger"
mkdir -p "$ZIEL/lang"

# Textdateien mit Windows-Zeilenenden (Notepad)
crlf() { sed 's/\r$//; s/$/\r/' "$1" > "$2"; }
cp "$EXE" "$ZIEL/StemTagger.exe"
crlf "$REPO/src/LIESMICH.txt" "$ZIEL/LIESMICH.txt"
crlf "$REPO/src/README.txt"   "$ZIEL/README.txt"
crlf "$REPO/LICENSE"          "$ZIEL/LICENSE.txt"
cp "$REPO"/src/lang/*.po "$ZIEL/lang/"

ZIP="$AUS/StemTagger-$VERSION.zip"
rm -f "$ZIP"
(cd "$ARBEIT" && { python -c "import sys, shutil; shutil.make_archive(sys.argv[1], 'zip', '.', 'StemTagger')" "${ZIP%.zip}" 2>/dev/null ||
  python3 -c "import sys, shutil; shutil.make_archive(sys.argv[1], 'zip', '.', 'StemTagger')" "${ZIP%.zip}"; })
ls -l "$ZIP"
