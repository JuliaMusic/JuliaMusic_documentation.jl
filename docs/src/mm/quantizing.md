# Quantizing & Humanizing

## Quantization
*Quantization* is the process of moving all note starting positions to a specified
and periodic grid. This "grid" does not have the be equi-spaced but it
has to be periodic per quarter note.

```@docs
quantize
```

---

Here are some examples
```@example
using MusicManipulations
midi = readMIDIFile(testmidi())
notes = getnotes(midi, 4)

sixteens = 0:1//4:1

notes16 = quantize(notes, sixteens)

swung_8s = [0, 2//3, 1]

swung_notes = quantize(notes, swung_8s)
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

## Humanizing
```@docs
humanize!
```
