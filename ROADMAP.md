# Roadmap – Elospeed StemTagger

🇬🇧 *This file is kept in German. English readers: see the [README](README.md).*

Was als Nächstes kommt. Erledigtes steht im [CHANGELOG](CHANGELOG.md), lose Ideen in [docs/IDEEN.md](docs/IDEEN.md).

## 1.1 – MP3-Dateien

- MP3-Dateien laden und Tags schreiben, mit eigenem ID3v2-Code (keine Fremdbibliothek).
- Traktors eigene Daten in der MP3 bleiben erhalten: der Frame `GEOB` mit `TRAKTOR4` (Beatgrid, Cue-Punkte, Analyse) und alle anderen unbekannten Frames werden unverändert übernommen.
- Gleiche Felder wie bei Stem-Dateien (Titel, Interpret, Album, Album-Interpret, Genre, Jahr, Track-Nr., BPM, Tonart, Label, Kommentar, Cover).
- Gleiche Sicherheit wie bei Stem-Dateien: über eine Zwischendatei schreiben, Audiodaten vorher und nachher vergleichen, erst dann das Original ersetzen.

## Danach

- StemMaker übernimmt die fertige `StemTagger.exe` aus dem Release dieses Repositorys als AddOn, statt sie selbst zu bauen.
