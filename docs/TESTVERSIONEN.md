# Testversionen

🇬🇧 *This file is kept in German. English readers: see the [README](../README.md).*

Testversionen sind fertig gebaute Programme zum **Ausprobieren**, bevor sie in ein offizielles Release kommen.
Sie werden automatisch von **GitHub Actions** gebaut, aber **nicht öffentlich auf GitHub veröffentlicht** (keine Vor-Releases).
Der Workflow steht in [`.github/workflows/build.yml`](../.github/workflows/build.yml).

## Wie es abläuft

1. Jeder Pull Request und jeder Push auf `main` baut `StemTagger.exe` (64 Bit) und das ZIP für die Release-Seite. Vorher prüft der Workflow, dass die Version überall gleich ist (`tools/versionen-pruefen.sh`) und die Sprachdateien vollständig und aktuell sind (`lang-tools/i18n.py`). Schlägt etwas fehl, ist der PR rot.
2. Exe, ZIP und `SHA256SUMS.txt` hängen als **Artefakt** am Build-Lauf unter *Actions* (nur mit GitHub-Login, 14 Tage).
3. Wer testet, bekommt das ZIP mit kurzer Anleitung im privaten Projektordner. Vorher: Build grün abwarten, Artefakt herunterladen, SHA-256 prüfen und das Programm kurz starten (bei 100 % und 150 % Windows-Skalierung, siehe [Entwicklungsregeln](ENTWICKLUNGSREGELN.md)).

## So testen

- ZIP entpacken und `StemTagger.exe` starten, der Ordner `lang\` bleibt daneben.
- Als AddOn: `StemTagger.exe` in einer Kopie der StemMaker-Installation nach `AddOns\` legen. Die Sprache kommt dann aus den StemMaker-Einstellungen.
- Immer mit **Kopien** von Stem-Dateien testen und danach in Traktor bzw. Mixxx prüfen, dass sie weiter als Stem laden.

Die Exe ist nicht signiert. Windows SmartScreen warnt deshalb: „Weitere Informationen“ → „Trotzdem ausführen“.

## Offizielles Release

- Speedy legt Releases selbst an (Tag `v<Version>`). Als Anhang dient das ZIP `StemTagger-<Version>.zip` aus dem Build-Artefakt des Merge-Commits, die SHA-256 kommt in den Release-Text.
- Testversionen gehören nicht ins Repository: jede eingecheckte Exe bliebe für immer im Git-Verlauf.
