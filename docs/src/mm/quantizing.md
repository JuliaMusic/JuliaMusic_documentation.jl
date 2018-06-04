# Quantizing
*Quantization* is the process of moving all note starting positions to a specified
and periodic grid. This "grid" does not have the be equi-spaced but it
has to be periodic per quarter note.

```@docs
quantize
```

Here are some examples
```julia
using MusicManipulations
cd(Pkg.dir("MusicManipulations")*"/test")
midi = readMIDIfile("serenade_full.mid")
notes = getnotes(midi, 4)

sixteens = 0:1//4:1

notes16 = quantize(notes, sixteens)

swung_8s = [0, 2//3, 1]

swung_notes = quantize(notes, swung_8s)
```
```
640 Notes with tpq=960
 Note C6   | vel = 86  | pos = 16000, dur = 292
 Note G4   | vel = 61  | pos = 16000, dur = 291
 Note G♯4  | vel = 50  | pos = 16000, dur = 260
 Note C5   | vel = 34  | pos = 16000, dur = 218
 Note F5   | vel = 66  | pos = 16960, dur = 274
 Note G♯4  | vel = 40  | pos = 17280, dur = 1762
 Note G4   | vel = 47  | pos = 17280, dur = 1760
 Note C6   | vel = 87  | pos = 17280, dur = 1639
 Note C5   | vel = 36  | pos = 17280, dur = 1760
 Note F5   | vel = 54  | pos = 18880, dur = 220
  ⋮
```
The first quantization quantized the notes on the 16-th subdivision. The second one
did something a bit more specialized, as it separated the notes to "quarter notes"
and swung 8th notes, the typical way a Jazz standard (like Serenade To A Cuckoo)
is played.

## Classification
[`quantize`](@ref) works in two steps. In the first step, each note is "classified",
according to which is the closest grid point to this note (modulo the quarter note).
```@docs
classify
```
After the notes have been classified, this classification vector is used to simply
relocate all notes to the closest grid point (modulo the quarter note).
