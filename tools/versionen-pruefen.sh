#!/usr/bin/env bash
# Prüft, ob die Versionsnummer des StemTagger überall gleich ist:
#   - APP_VER in src/taggerform.pas (die Version, die das Fenster zeigt)
#   - Versionsinfo der Exe in src/StemTagger.lpi (ProductVersion, Major, Minor, Revision)
#   - erste Zeile von src/LIESMICH.txt und src/README.txt
#   - oberster Versionsabschnitt im CHANGELOG.md
# Läuft bei jedem PR und jedem Push auf main (build.yml).
# Regel: jede Änderung am Programm hebt die Version im selben PR an.
set -u
cd "$(dirname "$0")/.."
FEHLER=0

fehler() { echo "::error::$1"; FEHLER=1; }

# Wert eines .lpi-Eintrags wie <MinorVersionNr Value="8"/>; fehlt er, gilt 0
lpi_nr() {
  local v
  v=$(sed -n "s/.*<$2 Value=\"\([0-9]*\)\".*/\1/p" "$1" | head -n 1)
  echo "${v:-0}"
}

VER=$(sed -n "s/^ *APP_VER *= *'\([0-9.]*\)';.*/\1/p" src/taggerform.pas | head -n 1 | tr -d '\r')
[ -n "$VER" ] || { echo "::error::APP_VER in src/taggerform.pas nicht gefunden"; exit 1; }

LPI=src/StemTagger.lpi
grep -q "ProductVersion=\"$VER\"" "$LPI" || fehler "$LPI hat nicht ProductVersion=\"$VER\""
MAJOR=${VER%%.*}; REST=${VER#*.}; MINOR=${REST%%.*}
if [ "$REST" = "$MINOR" ]; then REV=0; else REV=${REST#*.}; fi
[ "$(lpi_nr "$LPI" MajorVersionNr)" = "$MAJOR" ] || fehler "$LPI: MajorVersionNr passt nicht zu $VER"
[ "$(lpi_nr "$LPI" MinorVersionNr)" = "$MINOR" ] || fehler "$LPI: MinorVersionNr passt nicht zu $VER"
[ "$(lpi_nr "$LPI" RevisionNr)" = "$REV" ]       || fehler "$LPI: RevisionNr passt nicht zu $VER"

for TXT in src/LIESMICH.txt src/README.txt; do
  head -n 1 "$TXT" | grep -q " $VER\b" || fehler "$TXT: erste Zeile nennt nicht Version $VER"
done

# oberster Abschnitt "## <Version> – ..." im CHANGELOG
OBEN=$(sed -n 's/^## \([0-9.]*\) .*/\1/p' CHANGELOG.md | head -n 1)
[ "$OBEN" = "$VER" ] || fehler "CHANGELOG.md: oberster Abschnitt ist $OBEN, Programm ist $VER"

[ $FEHLER = 0 ] && echo "StemTagger $VER ok"
exit $FEHLER
