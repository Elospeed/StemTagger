# Entwicklungslog – Elospeed StemTagger

🇬🇧 *This file is kept in German. English readers: see the [README](../README.md).*

Bugs, Lehren und Stolperfallen, neueste oben. Was für Benutzer neu ist, steht im [CHANGELOG](../CHANGELOG.md).
Ältere Einträge zum StemTagger (bis 1.0.1) stehen im Entwicklungslog von [Elospeed/StemMaker](https://github.com/Elospeed/StemMaker/blob/main/docs/ENTWICKLUNGSLOG.md).

## Skalierungstest 1.1.0 (30. Oktober 2026)

- Test bei 100/125/150/200 %: Die neue Spalte „Traktor“ war mit 60 px (96 dpi) zu knapp für die fette Überschrift samt Platz für den Sortierpfeil; ab 150 % abgeschnitten. Jetzt bekommen Cover und Traktor mindestens die gemessene Textbreite der Überschrift (`HeadTextWidth`), statt sich auf eine feste Pixelzahl zu verlassen.
- Die Eingabefelder standen fest auf 196 px und liessen beim Maximieren rechts viel Leerraum. `FieldsResize` verteilt sie jetzt auf zwei gleich breite Spalten.

## Traktor speichert Cues in PRIV, nicht in GEOB (30. Oktober 2026)

- Praxistest mit Traktor Pro: Cue-Punkte, Marker und Loop stehen in einem Frame `PRIV` mit Besitzer „TRAKTOR4“ (hier rund 80 KB), nicht im `GEOB`-Frame älterer Versionen. Der Frame blieb beim Speichern schon vorher Byte für Byte gleich (unbekannte Frames werden nie angefasst), aber der Status zeigte nur „MP3 OK“. `IsTraktorFrame` erkennt jetzt PRIV und GEOB; der Selbsttest hat dafür einen eigenen Fall (`v23-traktor-priv`).

## Umzug in ein eigenes Repository (30. Oktober 2026)

- Der StemTagger brauchte aus StemMaker: den Tag-Teil von `ustemmp4.pas`, `djcontrols.pas` (StemPlayer), `ulang.pas`, `ustatusdraw.pas` und `uskalierung.pas`. Das sind jetzt **Kopien** in `src/`. Ändert sich eine davon in StemMaker (z. B. ein DPI-Fix in `uskalierung.pas`), muss sie hier von Hand nachgezogen werden und umgekehrt.
- `ump4tags.pas` ist `ustemmp4.pas` ohne das Erzeugen der Stem-Datei (`InjectStemMetadata`, `BuildStemJSON`, `DefaultStemInfo`). Das Lesen der `stem`-Box (`ReadStemJSON`) und `CountTracks` bleiben, weil der StemTagger damit vor und nach dem Schreiben prüft.
- Die Sprache kommt weiter zuerst aus `StemMaker.ini`, wenn der StemTagger als AddOn neben StemMaker liegt (`ulang.AppBaseDir` erkennt den Unterordner `AddOns\`). Allein gestartet gilt `lang\` neben der Exe und sonst die Windows-Sprache.
- Auf dem Entwicklungs-PC ist nur ein 32-Bit-FPC installiert (kein Win64-Crosscompiler). Ein Probebuild ohne `--os/--cpu` geht trotzdem; die offizielle 64-Bit-Exe baut GitHub Actions.
