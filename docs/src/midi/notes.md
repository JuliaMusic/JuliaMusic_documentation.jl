# Notes

Note information in MIDI files is typically encoded using `NOTEON` and `NOTEOFF` events.
A music note however contains more information besides the start and end; we bundle this information into the types [`Note`](@ref) and [`Notes`](@ref).
These two structures are central to the way JuliaMusic operates.
In addition, all note events of a [`MIDITrack`](@ref) can be obtained with the function [`getnotes`](@ref).

```@docs
Note
Notes
getnotes
```
---

If you have some notes and you want to add them to a track, use
```@docs
addnotes!
```

---

Finally, you can use the function `getnotnotes(track)` to get all `TrackEvents`
that are *not* `NOTEON` or `NOTEOFF`.

## Write Example

```julia
using MIDI
C = Note(60, 96, 0, 192)
E = Note(64, 96, 48, 144)
G = Note(67, 96, 96, 96)

inc = 192
file = MIDIFile()
track = MIDITrack()
notes = Notes() # tpq automatically = 960

push!(notes, C)
push!(notes, E)
push!(notes, G)

# Notes one octave higher
C = Note(60 + 12, 96, C.position+inc, 192)
E = Note(64 + 12, 96, E.position+inc, 144)
G = Note(67 + 12, 96, G.position+inc, 96)

addnotes!(track, notes)
addtrackname!(track, "simple track")
push!(file.tracks, track)
writeMIDIFile("test.mid", file)
```

## Read Example
```@example midi
using MIDI
midi = readMIDIFile(testmidi())
```

```@example midi
# Track number 3 is a quantized bass MIDI track
bass = midi.tracks[3]
notes = getnotes(bass, midi.tpq)
println("Notes of track $(trackname(bass)):")
notes
```


## Conversions
```@docs
name_to_pitch
pitch_to_name
note_to_fundamental
hz_to_pitch
pitch_to_hz
is_octave
```

## Iteration

`Notes` is iterable. 

There is a single-line easy way to get highest/lowest `Note` from `Notes`:

```julia
notes = testnotes()
max_pitch_note, index = findmax(n -> n.pitch, notes)
```