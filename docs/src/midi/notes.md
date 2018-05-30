# Notes

Note information in MIDI files is typically encoded using `NOTEON` and `NOTEOFF` events.
A music note however contains more information besides the start and end; we bundle this information with the following two types:
```@docs
Note
Notes
```

To get all the notes in a [`MIDITrack`](@ref), you can use
```@docs
getnotes
```
If you have some notes and you want to add them to a track, use
```@docs
addnotes!
```
Finally, you can use the function `getnotnotes(track)` to get all `TrackEvents`
that are *not* `NOTEON` or `NOTEOFF`.

## Small Example

```julia
using MIDI
C = Note(60, 96, 0, 192)
E = Note(64, 96, 48, 144)
G = Note(67, 96, 96, 96)

inc = 192
file = MIDIFile()
track = MIDITrack()
notes = Notes()

push!(notes, C)
push!(notes, E)
push!(notes, G)

# Notes one octave higher
C = Note(60 + 12, 96, C.position+inc, 192)
E = Note(64 + 12, 96, E.position+inc, 144)
G = Note(67 + 12, 96, G.position+inc, 96)
i += 1

addnotes!(track, notes)
addtrackname!(track, "simple track")
push!(file.tracks, track)
writeMIDIfile("test.mid", file)
```

## Pitch to `Int` convertion
To get the pitch number for a specific note, multiply 12 by the octave number, and add it to one of the following

- C  = 0
- C♯ = 1
- D♭ = 1
- D  = 2
- D♯ = 3
- E♭ = 3
- E  = 4
- F  = 5
- F♯ = 6
- Gb = 6
- G  = 7
- G♯ = 8
- A♭ = 8
- A  = 9
- A♯ = 10
- B♭ = 10
- B  = 11
- C♭ = 11
