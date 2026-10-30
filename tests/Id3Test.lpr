{ ============================================================================
  Id3Test  -  Selbsttest für uId3Tags (MP3-Tags lesen und schreiben)

  Baut kleine Test-MP3s im Speicher (ID3v2.3, ID3v2.4, ohne Tag, mit
  Unsynchronisation, mit ID3v1, mit Traktor-Frame PRIV bzw. GEOB "TRAKTOR4"),
  schreibt Tags hinein und prüft:
    - die geschriebenen Werte lassen sich wieder lesen
    - Traktors Frame und andere unbekannte Frames sind unverändert
    - die "Audiodaten" hinter dem Tag sind Byte für Byte gleich

  Aufruf:  Id3Test.exe [Ordner für Testdateien]
           Id3Test.exe --datei <Kopie.mp3>   (echte Datei: Titel ändern und
                                              zurücksetzen, Traktor-Daten prüfen)
  Ergebnis: Exit-Code 0 = alles in Ordnung, sonst Anzahl Fehler.
  ============================================================================ }
program Id3Test;

{$mode objfpc}{$H+}

uses
  Classes, SysUtils, uMp4Tags, uId3Tags;

var
  Fehler: Integer = 0;   // Anzahl fehlgeschlagener Prüfungen
  Ordner: string;        // hier entstehen die Testdateien
  TraktorErwartet: RawByteString; // Traktor-Frame des aktuellen Falls

procedure Pruefe(Ok: Boolean; const Was: string);
begin
  if Ok then
    WriteLn('  ok    ', Was)
  else
  begin
    WriteLn('  FEHLER ', Was);
    Inc(Fehler);
  end;
end;

{ --- Bausteine für Testdateien ------------------------------------------- }

procedure Add(var B: TBytes; const S: RawByteString);
var
  N: SizeInt;
begin
  N := Length(B);
  SetLength(B, N + Length(S));
  if Length(S) > 0 then
    Move(S[1], B[N], Length(S));
end;

function Size4(V: LongWord; Safe: Boolean): RawByteString;
begin
  if Safe then
    Result := Chr((V shr 21) and $7F) + Chr((V shr 14) and $7F) + Chr((V shr 7) and $7F) + Chr(V and $7F)
  else
    Result := Chr(V shr 24) + Chr((V shr 16) and $FF) + Chr((V shr 8) and $FF) + Chr(V and $FF);
end;

function Frame(Major: Integer; const ID, Data: RawByteString): RawByteString;
begin
  Result := ID + Size4(Length(Data), Major = 4) + #0#0 + Data;
end;

{ Unsynchronisation anwenden: nach jedem $FF ein $00 einfügen }
function UnSync(const S: RawByteString): RawByteString;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(S) do
  begin
    Result := Result + S[I];
    if S[I] = #$FF then Result := Result + #0;
  end;
end;

{ Fake-Audio: "MP3-Rahmen" mit $FF-Bytes, damit Unsynchronisation greift }
function Audio: RawByteString;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to 3000 do
    Result := Result + #$FF#$FB + Chr(I and $FF) + Chr((I * 7) and $FF);
end;

function TraktorFrame: RawByteString;
begin
  { GEOB: Kodierung 0, MIME '', Dateiname '', Beschreibung 'TRAKTOR4', Daten }
  Result := Frame(4, 'GEOB', #0 + #0 + #0 + 'TRAKTOR4'#0 + 'DMRT'#1#2#3#$FF#0#$FF'Beatgrid');
end;

function TraktorPrivFrame: RawByteString;
begin
  { PRIV, wie Traktor Pro 3/4 schreibt: Besitzer 'TRAKTOR4', danach Daten }
  Result := Frame(3, 'PRIV', 'TRAKTOR4'#0 + 'DMRT'#1#2#3#$FF#0#$FF'Cues und Loops');
end;

procedure SchreibeDatei(const Name: string; const B: TBytes);
var
  F: TFileStream;
begin
  F := TFileStream.Create(Name, fmCreate);
  try
    if Length(B) > 0 then F.WriteBuffer(B[0], Length(B));
  finally
    F.Free;
  end;
end;

function LiesDatei(const Name: string): TBytes;
var
  F: TFileStream;
begin
  Result := nil;
  F := TFileStream.Create(Name, fmOpenRead);
  try
    SetLength(Result, F.Size);
    if F.Size > 0 then F.ReadBuffer(Result[0], F.Size);
  finally
    F.Free;
  end;
end;

{ Kommt Teil irgendwo in B vor? }
function Enthaelt(const B: TBytes; const Teil: RawByteString): Boolean;
var
  I: SizeInt;
begin
  for I := 0 to Length(B) - Length(Teil) do
    if CompareMem(@B[I], @Teil[1], Length(Teil)) then
      Exit(True);
  Result := False;
end;

{ Endet B mit Teil? (Audio hinter dem Tag unverändert) }
function EndetMit(const B: TBytes; const Teil: RawByteString): Boolean;
begin
  Result := (Length(B) >= Length(Teil)) and
    CompareMem(@B[Length(B) - Length(Teil)], @Teil[1], Length(Teil));
end;

function KleinesJpeg: TBytes;
var
  I: Integer;
begin
  Result := nil;
  SetLength(Result, 300);
  for I := 0 to High(Result) do Result[I] := I and $FF;
  Result[0] := $FF; Result[1] := $D8; Result[2] := $FF; Result[3] := $E0;
end;

{ --- ein Testfall ---------------------------------------------------------- }

procedure Fall(const Name: string; const Datei: TBytes; const AudioTeil: RawByteString;
  MitTraktor: Boolean; ErwarteMajor: Integer);
var
  Fn, Err: string;
  T, T2: TMp4Tags;
  Info: TMp3Info;
  Nachher: TBytes;
begin
  WriteLn(Name);
  Fn := IncludeTrailingPathDelimiter(Ordner) + Name + '.mp3';
  SchreibeDatei(Fn, Datei);
  Pruefe(ReadMp3Tags(Fn, T, Info, Err), 'lesen ' + Err);
  Pruefe(Info.HasTraktor = MitTraktor, 'Traktor-Daten erkannt');
  T.Text[tfTitle] := 'Neuer Titel äöü';
  T.Text[tfArtist] := 'Interpret ✓ Unicode';
  T.Text[tfAlbum] := '';
  T.Text[tfGenre] := 'Tech House';
  T.Text[tfYear] := '2026';
  T.Text[tfBpm] := '124';
  T.Text[tfKey] := '8A';
  T.Text[tfComment] := 'Kommentar';
  T.Cover := KleinesJpeg;
  Pruefe(WriteMp3Tags(Fn, T, [tfTitle, tfArtist, tfAlbum, tfGenre, tfYear, tfBpm, tfKey, tfComment, tfCover], Err),
    'schreiben ' + Err);
  Pruefe(ReadMp3Tags(Fn, T2, Info, Err), 'wieder lesen ' + Err);
  Pruefe(T2.Text[tfTitle] = 'Neuer Titel äöü', 'Titel: ' + T2.Text[tfTitle]);
  Pruefe(T2.Text[tfArtist] = 'Interpret ✓ Unicode', 'Interpret: ' + T2.Text[tfArtist]);
  Pruefe(T2.Text[tfGenre] = 'Tech House', 'Genre');
  Pruefe(T2.Text[tfYear] = '2026', 'Jahr');
  Pruefe(T2.Text[tfBpm] = '124', 'BPM');
  Pruefe(T2.Text[tfKey] = '8A', 'Tonart');
  Pruefe(T2.Text[tfComment] = 'Kommentar', 'Kommentar');
  Pruefe((Length(T2.Cover) = 300) and (T2.Cover[299] = 299 and $FF), 'Cover');
  Pruefe(Info.Id3Major = ErwarteMajor, Format('ID3v2.%d geschrieben', [Info.Id3Major]));
  Pruefe(Info.HasTraktor = MitTraktor, 'Traktor-Daten noch da');
  Nachher := LiesDatei(Fn);
  Pruefe(EndetMit(Nachher, AudioTeil), 'Audiodaten unverändert');
  if MitTraktor then
    Pruefe(Enthaelt(Nachher, TraktorErwartet), 'Traktor-Frame Byte für Byte gleich');
  Pruefe(Enthaelt(Nachher, Frame(ErwarteMajor, 'PRIV', 'firma'#0'geheim')) or not Enthaelt(Datei, 'firma'),
    'unbekannter Frame PRIV erhalten');
  { Cover und Titel wieder entfernen }
  T2.Text[tfTitle] := '';
  T2.Cover := nil;
  Pruefe(WriteMp3Tags(Fn, T2, [tfTitle, tfCover], Err), 'Felder leeren ' + Err);
  Pruefe(ReadMp3Tags(Fn, T, Info, Err) and (Length(T.Cover) = 0) and (T.Text[tfArtist] = 'Interpret ✓ Unicode'),
    'Cover weg, Interpret bleibt');
  Pruefe(EndetMit(LiesDatei(Fn), AudioTeil), 'Audiodaten immer noch unverändert');
end;

procedure Selbsttest;
var
  B: TBytes;
  Frames, A, V1: RawByteString;
begin
  A := Audio;

  { ID3v2.4 mit Traktor-Frame, UTF-8-Titel, PRIV, Füllbytes }
  Frames := Frame(4, 'TIT2', #3'Alter Titel') + TraktorFrame + Frame(4, 'PRIV', 'firma'#0'geheim') +
            Frame(4, 'TCON', #3'(17)');
  B := nil;
  Add(B, 'ID3'#4#0#0 + Size4(Length(Frames) + 200, True) + Frames + StringOfChar(#0, 200) + A);
  TraktorErwartet := TraktorFrame;
  Fall('v24-traktor', B, A, True, 4);

  { ID3v2.3 mit Traktor-Daten als PRIV (so wie Traktor Pro 3/4 speichert) }
  Frames := Frame(3, 'TIT2', #0'Alter Titel') + TraktorPrivFrame;
  B := nil;
  Add(B, 'ID3'#3#0#0 + Size4(Length(Frames) + 100, True) + Frames + StringOfChar(#0, 100) + A);
  TraktorErwartet := TraktorPrivFrame;
  Fall('v23-traktor-priv', B, A, True, 3);

  { ID3v2.3, Latin-1, mit Unsynchronisation des ganzen Blocks }
  Frames := Frame(3, 'TIT2', #0'Titel'#$FF'x') + Frame(3, 'TPE1', #1#$FF#$FE'A'#0'B'#0) +
            Frame(3, 'PRIV', 'firma'#0'geheim');
  Frames := UnSync(Frames);
  B := nil;
  Add(B, 'ID3'#3#0#$80 + Size4(Length(Frames), True) + Frames + A);
  Fall('v23-unsync', B, A, False, 3);

  { ohne ID3v2, aber mit ID3v1 am Ende }
  V1 := 'TAG' + 'V1 Titel' + StringOfChar(#0, 22) + 'V1 Artist' + StringOfChar(#0, 21) +
        StringOfChar(#0, 30) + '1999' + StringOfChar(#0, 28) + #0#5 + #17;
  B := nil;
  Add(B, A + V1);
  Fall('nur-v1', B, A + V1, False, 3);
end;

{ --- echte Datei (Kopie!) -------------------------------------------------- }

procedure EchteDatei(const Fn: string);
var
  T, T2: TMp4Tags;
  Info, Info2: TMp3Info;
  Err, Alt: string;
  Vorher: TBytes;
begin
  WriteLn(Fn);
  Pruefe(ReadMp3Tags(Fn, T, Info, Err), 'lesen ' + Err);
  WriteLn(Format('  ID3v2.%d, Traktor-Daten: %s, schreibbar: %s %s',
    [Info.Id3Major, BoolToStr(Info.HasTraktor, True), BoolToStr(Info.CanWrite, True), Info.Problem]));
  WriteLn('  Titel: ', T.Text[tfTitle], ' | Interpret: ', T.Text[tfArtist], ' | Genre: ', T.Text[tfGenre],
    ' | BPM: ', T.Text[tfBpm], ' | Tonart: ', T.Text[tfKey], ' | Cover: ', Length(T.Cover), ' Byte');
  if not Info.CanWrite then Exit;
  Vorher := LiesDatei(Fn);
  Alt := T.Text[tfTitle];
  T.Text[tfTitle] := Alt + ' (Test)';
  Pruefe(WriteMp3Tags(Fn, T, [tfTitle], Err), 'Titel ändern ' + Err);
  Pruefe(ReadMp3Tags(Fn, T2, Info2, Err) and (T2.Text[tfTitle] = Alt + ' (Test)'), 'Titel gelesen');
  Pruefe(Info2.HasTraktor = Info.HasTraktor, 'Traktor-Daten unverändert vorhanden');
  T.Text[tfTitle] := Alt;
  Pruefe(WriteMp3Tags(Fn, T, [tfTitle], Err), 'Titel zurück ' + Err);
  { grösser werden darf die Datei nur, wenn im alten Block kein Platz war
    (dann kommen 4 KB Reserve dazu) }
  Pruefe(Length(LiesDatei(Fn)) <= Length(Vorher) + 4096 + 64, 'Dateigrösse plausibel');
end;

{ Alle Felder einer Kopie mit Testwerten füllen (danach z.B. mit ffmpeg
  oder einem anderen Tag-Programm gegenlesen) }
procedure AllesSchreiben(const Fn: string);
var
  T: TMp4Tags;
  Info: TMp3Info;
  Err: string;
begin
  WriteLn(Fn);
  Pruefe(ReadMp3Tags(Fn, T, Info, Err), 'lesen ' + Err);
  T.Text[tfTitle] := 'Titel äöü ✓';
  T.Text[tfArtist] := 'Interpret';
  T.Text[tfAlbum] := 'Album';
  T.Text[tfAlbumArtist] := 'Album-Interpret';
  T.Text[tfGenre] := 'Tech House';
  T.Text[tfYear] := '2026';
  T.Text[tfTrack] := '3/12';
  T.Text[tfBpm] := '128';
  T.Text[tfKey] := 'Am';
  T.Text[tfLabel] := 'Label';
  T.Text[tfComment] := 'Kommentar';
  T.Cover := KleinesJpeg;
  Pruefe(WriteMp3Tags(Fn, T, [Low(TMp4TagField)..High(TMp4TagField)], Err), 'alles schreiben ' + Err);
end;

begin
  if (ParamCount >= 2) and (ParamStr(1) = '--datei') then
    EchteDatei(ParamStr(2))
  else if (ParamCount >= 2) and (ParamStr(1) = '--alles') then
    AllesSchreiben(ParamStr(2))
  else
  begin
    if ParamCount >= 1 then Ordner := ParamStr(1) else Ordner := GetTempDir;
    ForceDirectories(Ordner);
    Selbsttest;
  end;
  WriteLn;
  if Fehler = 0 then WriteLn('Alles in Ordnung.') else WriteLn(Fehler, ' Fehler.');
  ExitCode := Fehler;
end.
