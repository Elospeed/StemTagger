# Changelog – Elospeed StemTagger

🇬🇧 *This file is kept in German. English readers: see the [README](README.md).*

Was erledigt ist, pro Version, neueste oben.
Die technischen Hintergründe (Fehler und wie sie gelöst wurden) stehen im [Entwicklungslog](docs/ENTWICKLUNGSLOG.md).
Bis Version 1.0.1 wurde der StemTagger als AddOn im Repository [Elospeed/StemMaker](https://github.com/Elospeed/StemMaker) entwickelt (Verlauf dort im CHANGELOG).

---

## 1.0.1 – eigenes Repository (30. Oktober 2026)

### Umzug
- **Eigenes Repository Elospeed/StemTagger:** Quelltext aus StemMaker (`src/AddOns/StemTagger`) übernommen, dazu Kopien der gemeinsamen Units: der Tag-Teil von `ustemmp4.pas` (jetzt `src/ump4tags.pas`), `djcontrols.pas` und `djextra.pas` (dunkle Bedienelemente wie im StemPlayer), `ustatusdraw.pas` (Ko-fi-Knopf), `ulang.pas` mit `lang-tools/i18n.py` (Sprachdateien) und `uskalierung.pas` (Windows-Skalierung).
- **Eigene Sprachdateien:** `src/lang/en.po` und `es.po` enthalten nur noch die Texte des StemTagger.
- **Automatischer Build:** GitHub Actions baut bei jedem Pull Request und Push auf `main` die Exe und das Release-ZIP.
- Am Programm selbst ändert sich nichts gegenüber dem StemTagger 1.0.1 aus StemMaker 2.1.1.

### Stand 1.0.1 (aus StemMaker 2.1.1)
- Spaltenbreiten und Zeilenhöhe der Liste passen sich der Windows-Skalierung an (vorher blieben sie bei 100 %, und Spalten wie „Cover“ waren abgeschnitten). Etwas breiteres Startfenster, Mindestbreite so, dass Jahr, Label, Kommentar und der Namens-Knopf ganz sichtbar bleiben.

## 1.0 – erste Version (29. Oktober 2026, mit StemMaker 2.1)

- Titel, Interpret, Album, Album-Interpret, Genre, Jahr, Track-Nr., Label, Kommentar und Cover in `.stem.mp4`-Dateien setzen. BPM und Tonart bleiben erhalten, wenn sie schon in der Datei stehen.
- Viele Dateien auf einmal, „<verschieden>“ bei unterschiedlichen Werten.
- Cover per Ziehen, Strg+V oder Datei, Verkleinern auf 1000 px, BMP/GIF zu JPEG, Cover als Bild speichern.
- Genre mit Auswahlliste und Ergänzen beim Tippen, Tooltip an jedem Feld, Status „Ohne Tags“/„Ohne Cover“, Sortieren per Klick auf die Spaltenüberschrift, Interpret/Titel aus Dateiname.
- Nur die Tag-Liste wird neu geschrieben, die neue Datei wird vor dem Ersetzen geprüft. Sicherungskopie `.bak` einschaltbar.
- Dunkles Design wie der StemPlayer.
- Deutsch, Englisch und Spanisch.
