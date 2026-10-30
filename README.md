# Elospeed StemTagger 1.2

**by Elospeed**

🇩🇪 **Deutsche Anleitung:** [LIESMICH.md](LIESMICH.md)

Sets title, artist, album, genre, year, label, comment and cover art in **Traktor stem files (`*.stem.mp4`)** and **MP3 files**, the things Traktor and Mixxx show and search for. Many files at once, with a dark, compact window.

**Why a separate tool?** Regular tag editors sometimes rewrite a stem file in a way that makes Traktor load it as a normal track afterwards. StemTagger only changes the tag list inside the file. The 5 audio tracks and the stem data (names and colours of the stems) stay byte for byte the same. The new file is checked before it replaces the original (same track count, same stem data). If anything goes wrong, the original stays untouched. Tested in Traktor Pro 4 and Mixxx 2.6 beta.

StemTagger is part of the [Elospeed StemMaker](https://github.com/Elospeed/StemMaker) family: StemMaker creates stem files from your own music and already ships StemTagger as an AddOn (`AddOns\StemTagger.exe`). This repository is the home of StemTagger itself; StemMaker takes the finished exe from the releases here.

## Features

- **MP3 too (since 1.1):** own ID3v2 code, only the changed fields are replaced. Audio and everything else in the tag stay byte for byte the same, including Traktor's own data (beatgrid, cue points, analysis in the `TRAKTOR4` entry). The status shows which MP3s Traktor has already analysed.
- **Many files at once:** drop files or whole folders (subfolders included), select several rows and set e.g. album or cover for all of them. Fields with different values show `<different>` and stay per file as long as you don't change them.
- **Cover made easy:** drop an image on the window, paste one copied in the browser (Ctrl+V) or pick a file. JPEG and PNG are kept as they are, BMP and GIF become JPEG. Images above 1000 px can be scaled down. The cover can be saved as an image again.
- **Genre list** with about 50 styles, or type your own (auto-complete).
- **Missing data at a glance:** the Status column shows "No tags" or "No cover"; click a column header to sort.
- **Artist/title from file name:** `Kungs - Clap Your Hands.stem.mp4` gives artist and title.
- Optional backup copy `<file>.bak` before the first save.
- German, English and Spanish; since 1.2 also French, Portuguese (Brazil), Italian, Japanese, Dutch and Polish (machine drafts, not yet proofread by native speakers).

BPM and key are detected by Traktor and Mixxx during analysis; values that are already in the file are kept.

## Download

Get `StemTagger-<version>.zip` from the [releases page](https://github.com/Elospeed/StemTagger/releases), unzip it and start `StemTagger.exe`. Keep the `lang\` folder next to it. No installation, no extra libraries.

Windows SmartScreen may warn because the exe is not signed: "More info" → "Run anyway".

## Building

Lazarus 3.8 (Free Pascal 3.2.2), no extra packages:

```
lazbuild -B --os=win64 --cpu=x86_64 --ws=win32 src/StemTagger.lpi
```

The exe lands in `bin\`. Language files: `python lang-tools/i18n.py src src/lang` (translations in `lang-tools/en.json` and `es.json`). Self-test for the MP3 code: `fpc -Mobjfpc -Sh -Fusrc -FUlib/test -FEbin tests/Id3Test.lpr`, then run `bin\Id3Test.exe`. Every push and pull request is built and tested automatically by GitHub Actions (`.github/workflows/build.yml`).

Developer documents (in German): [CHANGELOG](CHANGELOG.md), [ROADMAP](ROADMAP.md), [TODO](TODO.md), [development rules](docs/ENTWICKLUNGSREGELN.md), [development log](docs/ENTWICKLUNGSLOG.md), [test builds](docs/TESTVERSIONEN.md), [ideas](docs/IDEEN.md).

## Support

StemTagger is a one-person hobby project. If it saves you some time, you can [buy me a coffee on Ko-fi](https://ko-fi.com/elospeed) ☕. Entirely optional, the tool stays free either way.

## License

MIT, see [LICENSE](LICENSE). No third-party libraries besides Free Pascal / Lazarus.
