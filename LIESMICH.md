# Elospeed StemTagger 1.0.1

**von Elospeed**

🇬🇧 **English guide:** [README.md](README.md)

Setzt Titel, Interpret, Album, Genre, Jahr, Label, Kommentar und Cover in **Traktor-Stem-Dateien (`*.stem.mp4`)**, also das, was Traktor und Mixxx anzeigen und wonach man dort sucht. Auch für viele Dateien auf einmal, in einem dunklen, kompakten Fenster.

**Warum ein eigenes Programm?** Normale Tag-Editoren schreiben eine Stem-Datei beim Speichern manchmal so um, dass Traktor sie danach nur noch als normalen Track lädt. Der StemTagger ändert nur die Tag-Liste in der Datei. Die 5 Audiospuren und die Stem-Daten (Namen und Farben der Stems) bleiben Byte für Byte gleich. Vor dem Ersetzen wird die neue Datei geprüft (gleiche Spurenzahl, gleiche Stem-Daten). Klappt etwas nicht, bleibt das Original unverändert. Getestet in Traktor Pro 4 und Mixxx 2.6 Beta.

Der StemTagger gehört zur Familie von [Elospeed StemMaker](https://github.com/Elospeed/StemMaker): StemMaker macht aus eigener Musik Stem-Dateien und hat den StemTagger schon als AddOn dabei (`AddOns\StemTagger.exe`). Dieses Repository ist das Zuhause des StemTagger selbst; StemMaker übernimmt die fertige Exe aus den Releases hier.

## Was er kann

- **Viele Dateien auf einmal:** Dateien oder ganze Ordner hineinziehen (mit Unterordnern), mehrere Zeilen markieren und z. B. Album oder Cover für alle setzen. Felder mit unterschiedlichen Werten zeigen „<verschieden>“ und bleiben pro Datei erhalten, solange man sie nicht ändert.
- **Cover bequem:** Bild aufs Fenster ziehen, im Browser kopieren und mit Strg+V einfügen oder Datei wählen. JPEG und PNG bleiben unverändert, BMP und GIF werden zu JPEG. Bilder über 1000 Pixel lassen sich verkleinern. Das Cover lässt sich auch wieder als Bild speichern.
- **Genre mit Auswahlliste:** rund 50 Musikstile oder selbst eintippen (wird beim Tippen ergänzt).
- **Fehlendes auf einen Blick:** Die Spalte Status zeigt „Ohne Tags“ oder „Ohne Cover“, Klick auf eine Spaltenüberschrift sortiert.
- **Interpret/Titel aus Dateiname:** `Kungs - Clap Your Hands.stem.mp4` ergibt Interpret und Titel.
- Auf Wunsch Sicherungskopie `<Datei>.bak` vor dem ersten Speichern.
- Deutsch, Englisch und Spanisch.

BPM und Tonart ermitteln Traktor und Mixxx beim Analysieren selbst; Werte, die schon in der Datei stehen, bleiben erhalten.

Die ausführliche Bedienungsanleitung liegt dem ZIP als `LIESMICH.txt` bei (Quelle: [src/LIESMICH.txt](src/LIESMICH.txt)).

## Herunterladen

`StemTagger-<Version>.zip` von der [Release-Seite](https://github.com/Elospeed/StemTagger/releases) laden, entpacken und `StemTagger.exe` starten. Der Ordner `lang\` muss daneben bleiben. Keine Installation, keine Zusatzbibliotheken.

Windows SmartScreen warnt eventuell, weil die Exe nicht signiert ist: „Weitere Informationen“ → „Trotzdem ausführen“.

## Geplant

MP3-Dateien (ID3v2-Tags, Traktors eigene Daten in der Datei bleiben erhalten) kommen mit Version 1.1, siehe [ROADMAP.md](ROADMAP.md).

## Selbst bauen

Lazarus 3.8 (Free Pascal 3.2.2), keine Zusatzpakete:

```
lazbuild -B --os=win64 --cpu=x86_64 --ws=win32 src/StemTagger.lpi
```

Die Exe landet in `bin\`. Sprachdateien: `python lang-tools/i18n.py src src/lang` (Übersetzungen in `lang-tools/en.json` und `es.json`). Jeder Push und jeder Pull Request wird von GitHub Actions automatisch gebaut (`.github/workflows/build.yml`).

Für Entwickler: [CHANGELOG](CHANGELOG.md), [ROADMAP](ROADMAP.md), [TODO](TODO.md), [Entwicklungsregeln](docs/ENTWICKLUNGSREGELN.md), [Entwicklungslog](docs/ENTWICKLUNGSLOG.md), [Testversionen](docs/TESTVERSIONEN.md), [Ideen](docs/IDEEN.md).

## Unterstützen

Der StemTagger ist ein Ein-Personen-Hobbyprojekt. Wenn er dir Zeit spart, kannst du mir auf [Ko-fi einen Kaffee spendieren](https://ko-fi.com/elospeed) ☕. Ganz freiwillig, das Programm bleibt so oder so kostenlos.

## Lizenz

MIT, siehe [LICENSE](LICENSE). Keine Fremdbibliotheken ausser Free Pascal / Lazarus.
