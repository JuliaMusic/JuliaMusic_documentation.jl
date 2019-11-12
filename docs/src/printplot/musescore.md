# Printing into a Score using MuseScore

[MuseScore](https://musescore.org) is a wonderful and open source professional
music score editor. `MusicVisualizations`
provides a convenient interface that can print any [`Notes`](@ref)
or [`MIDIFile`](@ref) structure via MuseScore.

```@docs
musescore
```

!!! tip "Quantize your notes!"
    Keep in mind that the score creation capabilities of MuseScore rely upon
    having well-defined notes. This means that you should use the function
    [`quantize`](@ref) to quantize both the position and duration of your notes!

## Creating a Score out of some Notes

We first load the test MIDI file "Doxy".
The third track has the notes of the Bass:

```@example musescore
using MusicManipulations, MusicVisualizations
midi = readMIDIFile() # read the "test" Doxy MIDI recording.
bass = getnotes(midi, 3)
basstrim = bass[1:50]
```

Because the notes of the Bass are already quantized we can already
print them into a staff using MuseScore:

```julia
musescore(bass, notes)
```

![Bass score](bass-1.png)

Amazingly MuseScore deduces automatically the clef and even the key of
the piece!

## Creating a full Score out of a MIDI file
You can also pass a full MIDI file to [`musescore`](@ref).

```@example musescore
piano = getnotes(midi, 4)
```

However, MuseScore has decent results only with quantized notes.
Let's quantize on a triplet grid using [`quantize`](@ref).

```@example musescore
qpiano = quantize(piano, [0, 1//3, 2//3, 1])
```

and save both tracks into a midi file:

```@example musescore
ptrack = MIDITrack()
addnotes!(ptrack, qpiano)
addtrackname!(ptrack, "Doxy")
smidi = MIDIFile(1, 960, [midi.tracks[3], ptrack])
```

and then save the full thing as `.pdf`:

```julia
musescore("doxy.pdf", smidi)
```

You can find the produced `.pdf` file
[here](https://github.com/JuliaMusic/JuliaMusic_documentation.jl/tree/master/docs/src/printplot/doxy.pdf).
The first page looks like this:
![Full score](doxy-1.png)
When given multiple tracks MuseScore displays the name of the track ([`trackname`](@ref)),
as well as the instrument it automatically chose to represent it.

## Drum notation

To export directly into drum notation you need to make two changes to your notes:

1. Create your notes into channel `9` instead of the default `0`.
2. Use the appropriate pitches that correspond to the drum instruments. For this you can use the dictionary `MuseScore.drumkey` (which follows the GM mapping).

For example, let's make a standard rock drums pattern:
```@example musescore
bass = musescore_drumkey["Acoustic Bass Drum"]
snare = musescore_drumkey["Acoustic Snare"]
hihat = musescore_drumkey["Closed Hi-Hat"]
midichannel = 9

tpq = 960
ei = tpq//2 # 8-th notes

rock = [Note(hihat, iseven(i) ? 100 : 60, ei*i, ei, midichannel) for i in 0:7]
for i in 1:2
    push!(rock, Note(bass, 100, 4(i-1)ei, 2ei, midichannel))
    push!(rock, Note(snare, 100, 4(i-1)ei + 2ei, 2ei, midichannel))
end
rock = Notes(rock, tpq)
```
```julia
musescore("rock.png", rock)
```

![drums](rock-1.png)
