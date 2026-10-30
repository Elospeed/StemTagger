# Changelog – Elospeed StemTagger

🇬🇧 *This file is kept in German. English readers: see the [README](README.md).*

Was erledigt ist, pro Version, neueste oben.
Die technischen Hintergründe (Fehler und wie sie gelöst wurden) stehen im [Entwicklungslog](docs/ENTWICKLUNGSLOG.md).
Bis Version 1.0.1 wurde der StemTagger als AddOn im Repository [Elospeed/StemMaker](https://github.com/Elospeed/StemMaker) entwickelt (Verlauf dort im CHANGELOG).

---

## 1.1.0 – MP3-Dateien (noch nicht veröffentlicht)

### Neu
- **MP3-Dateien:** MP3s lassen sich wie Stem-Dateien laden (auch beim Durchsuchen von Ordnern) und bekommen dieselben Felder: Titel, Interpret, Album, Album-Interpret, Genre, Jahr, Track-Nr., BPM, Tonart, Label, Kommentar und Cover.
- **Traktors Daten bleiben erhalten:** Der StemTagger hat eigenen Code für ID3v2 und ersetzt nur die Einträge der geänderten Felder. Traktors eigener Eintrag (`PRIV` bzw. bei älteren Versionen `GEOB` „TRAKTOR4“ mit Beatgrid, Cue-Punkten, Loops und Analyse), weitere Bilder und alle anderen unbekannten Einträge bleiben Byte für Byte gleich, die Audiodaten sowieso. Vor dem Ersetzen prüft der StemTagger die neue Datei.
- **Spalte „Traktor“:** zeigt in der Dateiliste auf einen Blick, welche MP3s schon Traktor-Daten (Cue-Punkte, Beatgrid, Analyse) enthalten („ja“) und welche nicht („-“). Wie jede Spalte sortierbar.
- **Status für MP3:** „MP3 OK, mit Traktor-Daten“ zeigt, welche Dateien Traktor schon analysiert hat. Sehr alte (ID3v2.2) oder beschädigte Tags werden angezeigt, aber nicht verändert („Nur lesen“).
- Geschrieben wird in der ID3-Version der Datei (2.3 oder 2.4); MP3s ohne Tags bekommen ID3v2.3. Fehlt ein Feld im ID3v2-Tag, zeigt der StemTagger den Wert aus einem alten ID3v1-Tag an.

### Fenster
- Die Eingabefelder unten (Titel bis Kommentar) wachsen jetzt mit, wenn das Fenster breiter oder maximiert wird.
- Die schmalen Spalten Cover und Traktor sind nie schmaler als ihre Überschrift (bei 150 % und 200 % war „TRAKTOR“ abgeschnitten).

### Entwicklung
- Praxistest mit Traktor Pro 4: MP3 mit Cue-Punkten, Markern und Loop getaggt (Titel, Interpret, Album, Cover u. a.), danach als neue Datei in Traktor geladen: alles noch da.
- Selbsttest `tests/Id3Test.lpr` (ID3v2.3, ID3v2.4, Unsynchronisation, ID3v1, Traktor-Eintrag), läuft bei jedem Build.

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
