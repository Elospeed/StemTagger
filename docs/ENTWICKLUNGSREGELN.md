# Entwicklungsregeln – Elospeed StemTagger

🇬🇧 *This file is kept in German. English readers: see the [README](../README.md).*

Diese Regeln gelten für jede Änderung im Repository. Sie entsprechen den Regeln von [Elospeed/StemMaker](https://github.com/Elospeed/StemMaker).

## Versionen

- Jede Änderung am Programm hebt die Versionsnummer im selben PR an.
- Die Version steht an allen Stellen gleich: `APP_VER` in `src/taggerform.pas`, Versionsinfo in `src/StemTagger.lpi` (`ProductVersion`, `MajorVersionNr`, `MinorVersionNr`, `RevisionNr`), erste Zeile von `src/LIESMICH.txt` und `src/README.txt`, Überschrift in `README.md`/`LIESMICH.md` und oberster Abschnitt im `CHANGELOG.md`.
- `tools/versionen-pruefen.sh` prüft das bei jedem Build; ein roter Build heisst: irgendwo steht noch die alte Nummer.
- Jede Änderung bekommt einen Eintrag im `CHANGELOG.md` (Deutsch, für Benutzer verständlich). Technische Hintergründe gehören ins [Entwicklungslog](ENTWICKLUNGSLOG.md).

## Windows-Skalierung (DPI)

Alle Fenster müssen bei **100 %, 125 %, 150 % und 200 %** Windows-Skalierung korrekt aussehen.

- Keine festen Pixelwerte im eigenen Code. Immer mit der Skalierung umrechnen (`Scale96ToForm`, `ScaleDesignToForm`, Hilfen aus `src/uskalierung.pas`) und nichts doppelt skalieren.
- Bei Fenstern, die im Code aufgebaut werden: gleich nach `inherited CreateNew` `StelleAufBildschirmDPI(Self)` aufrufen, sonst rechnet `Scale96ToForm` mit 96 dpi und eigene Werte (Spaltenbreiten, Bildlisten) bleiben bei 100 %.
- Fenster öffnen nie grösser als der freie Bildschirm (ohne Taskleiste). Mindestgrössen sind kleiner als die Startgrösse und passen auf den Bildschirm.
- Elemente wachsen mit der Fenstergrösse mit. Vergrössern/Maximieren nur erlauben, wo Inhalte wirklich mitwachsen; Ansichten mit festem Layout bekommen eine feste Grösse ohne Maximieren-Knopf.
- Vor jedem PR mit Änderungen an der Oberfläche und vor jedem Release bei 100 % und 150 % testen (bei Platzproblemen auch 200 %), mit Screenshots zur Kontrolle.

## Sprachen

- Oberfläche auf Deutsch im Quelltext, Übersetzungen Englisch und Spanisch.
- Jeder sichtbare Text läuft über `_('...')`. Danach `python lang-tools/i18n.py src src/lang` ausführen und die Übersetzung in `lang-tools/en.json` und `lang-tools/es.json` ergänzen. Der Build bricht ab, wenn eine Übersetzung fehlt oder `src/lang` nicht aktuell ist.
- Programmlogik nie auf übersetzten Text stützen (z. B. nie auf eine Beschriftung vergleichen).

## Code

- Kommentare auf Deutsch, verständlich erklärt; auch Variablendeklarationen kurz dokumentieren.
- Keine Fremdbibliotheken mit unklarer Lizenz. Der StemTagger kommt mit Free Pascal / Lazarus allein aus; Tag-Formate (MP4, ID3v2) werden selbst gelesen und geschrieben.
- Dateien der Benutzer nie direkt überschreiben: immer in eine Zwischendatei schreiben, prüfen und erst dann das Original ersetzen. Unbekannte Daten in der Datei (z. B. Traktors eigene Frames) bleiben unverändert erhalten.
- Gemeinsame Units sind Kopien aus StemMaker (siehe [Entwicklungslog](ENTWICKLUNGSLOG.md)). Fixes dort hier nachziehen und umgekehrt.
- Der Ko-fi-Knopf unten rechts bleibt (`DrawKofiButton` aus `src/ustatusdraw.pas`). Spenden-Hinweise nie im CHANGELOG oder in Release-Notizen.

## Git und GitHub

- Commits als `Elospeed <295193091+Elospeed@users.noreply.github.com>`, ohne Co-Author- oder Attributionszeilen.
- Sprechende Branch-Namen, z. B. `elospeed/mp3-tags`.
- Keine Exes, ZIPs oder andere Build-Ergebnisse einchecken. Testversionen gibt es als Workflow-Artefakt (siehe [Testversionen](TESTVERSIONEN.md)).
- Jede Aufgabe trägt sich im selben PR in `TODO.md` ein bzw. aus.
- Speedy merged PRs, legt Releases an und ändert die Repo-Einstellungen selbst.

## Projektseite

- Die Projektseite liegt in `site/` (Englisch `index.html`, Deutsch `de/index.html`), veröffentlicht von `.github/workflows/pages.yml`.
- Bei jedem Release die Seite vollständig nachführen: Texte, „Neu in“-Abschnitt, alle Screenshots DE und EN (Versionsnummer in der Fensterleiste), `softwareVersion` im JSON-LD und die OG-Bilder, falls sie sich geändert haben.
- Beide Sprachen immer gleich halten; was auf der einen Seite steht, steht auch auf der anderen.
