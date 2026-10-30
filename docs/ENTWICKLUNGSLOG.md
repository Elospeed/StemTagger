# Entwicklungslog – Elospeed StemTagger

🇬🇧 *This file is kept in German. English readers: see the [README](../README.md).*

Bugs, Lehren und Stolperfallen, neueste oben. Was für Benutzer neu ist, steht im [CHANGELOG](../CHANGELOG.md).
Ältere Einträge zum StemTagger (bis 1.0.1) stehen im Entwicklungslog von [Elospeed/StemMaker](https://github.com/Elospeed/StemMaker/blob/main/docs/ENTWICKLUNGSLOG.md).

## Umzug in ein eigenes Repository (30. Oktober 2026)

- Der StemTagger brauchte aus StemMaker: den Tag-Teil von `ustemmp4.pas`, `djcontrols.pas` (StemPlayer), `ulang.pas`, `ustatusdraw.pas` und `uskalierung.pas`. Das sind jetzt **Kopien** in `src/`. Ändert sich eine davon in StemMaker (z. B. ein DPI-Fix in `uskalierung.pas`), muss sie hier von Hand nachgezogen werden und umgekehrt.
- `ump4tags.pas` ist `ustemmp4.pas` ohne das Erzeugen der Stem-Datei (`InjectStemMetadata`, `BuildStemJSON`, `DefaultStemInfo`). Das Lesen der `stem`-Box (`ReadStemJSON`) und `CountTracks` bleiben, weil der StemTagger damit vor und nach dem Schreiben prüft.
- Die Sprache kommt weiter zuerst aus `StemMaker.ini`, wenn der StemTagger als AddOn neben StemMaker liegt (`ulang.AppBaseDir` erkennt den Unterordner `AddOns\`). Allein gestartet gilt `lang\` neben der Exe und sonst die Windows-Sprache.
- Auf dem Entwicklungs-PC ist nur ein 32-Bit-FPC installiert (kein Win64-Crosscompiler). Ein Probebuild ohne `--os/--cpu` geht trotzdem; die offizielle 64-Bit-Exe baut GitHub Actions.
