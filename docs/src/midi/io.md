# Basic MIDI Structures

## `MIDIFile`
```@docs
MIDIFile
```

To read and write a MIDI file, use
```julia
midi = readMIDIfile("test.mid") # Reads a file into a MIDIFile data type
writeMIDIfile("filename.mid", midi) # Writes a MIDI file to the given filename
```

## `MIDITrack`
The most important field of a `MIDIFile` is the `tracks` field. It contains as
many tracks as the user wants. The tracks themselves contain all "musical" information
in the form of the "events" we mentioned in the introduction:
```@docs
MIDITrack
TrackEvent
```
The `TrackEvent` themselves can be one of three types:
```julia
struct MIDIEvent <: TrackEvent
    dT::Int
    status::UInt8
    data::Array{UInt8,1}
end

struct MetaEvent <: TrackEvent
    dT::Int
    metatype::UInt8
    data::Array{UInt8,1}
end

struct SysexEvent <: TrackEvent
    dT::Int
    data::Array{UInt8,1}
end
```
## Utility functions




## Low-Level API
In this section we show the low-level API that allows one to actually read
bytes from a file and transform them into Julia structures.

```@docs
readvariablelength
```
