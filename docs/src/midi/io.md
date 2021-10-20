# Basic MIDI structures
MIDI files are loaded to/from disc and transformed into a Julia structure `MIDIFile`, which contains `MIDITrack`s.


## MIDI IO
To read and write a MIDI file, the `load` and `save` functions can be used. These extend the `FileIO` interface. The syntax is

    load(filename) -> midi::MIDIFile

Load the midi file contained in `filename` (which **must** end in ".mid") and return
it as a [`MIDIFile`](@ref).

    save(filename, data::MIDIFile)

Write a `MIDIFile` as a ".mid" file to the given `filename`.

    save(filename, notes::Notes)

Create a `MIDIFile` directly from `notes`, using format 1, and then save it.

## `MIDIFile`
```@docs
MIDIFile
```

## `MIDITrack`
The most important field of a `MIDIFile` is the `tracks` field. It contains as
many tracks as the user wants. The tracks themselves contain all "musical" information
in the form of the "events" we mentioned in [MIDI: The least you need to know](@ref).
```@docs
MIDITrack
TrackEvent
```

The `TrackEvent` themselves can be broken into three types.
```julia
abstract type MIDIEvent <: TrackEvent end

abstract type MetaEvent <: TrackEvent end

struct SysexEvent <: TrackEvent
    dT::Int
    data::Array{UInt8,1}
end
```

The various midi and meta events found in a midifile have their own types. More information can be found at the [Meta Events](@ref) and [MIDI Events](@ref) sections below.  

Typically the most relevant information of a `MIDITrack` are the notes contained within.
For this reason, special functions [`getnotes`](@ref) and [`addnotes!`](@ref) exist, which can be found in the [Notes](@ref) page.

## Meta Events
```
MIDI.SequenceNumberEvent
MIDI.TextEvent
MIDI.CopyrightNoticeEvent
MIDI.TrackNameEvent
MIDI.InstrumentNameEvent
MIDI.LyricEvent
MIDI.MarkerEvent
MIDI.CuePointEvent
MIDI.MIDIChannelPrefixEvent
MIDI.EndOfTrackEvent
MIDI.SetTempoEvent
MIDI.TimeSignatureEvent
MIDI.KeySignatureEvent
```

## MIDI Events
```
MIDI.NoteOffEvent
MIDI.NoteOnEvent
MIDI.AftertouchEvent
MIDI.ControlChangeEvent
MIDI.ProgramChangeEvent
MIDI.ChannelPressureEvent
MIDI.PitchBendEvent
```

## Utility functions
```@docs
qpm
bpm
ms_per_tick
addevent!
addevents!
trackname
addtrackname!
findtextevents
tempochanges
```


## Low-Level API
In this section we show the low-level API that allows one to actually read
bytes from a file and transform them into Julia structures.

```@docs
readvariablelength
```
Other useful functions that are not exported are
```julia
writeevent
readMIDIevent
readmetaevent
readsysexevent
get_abs_pos
```

---

Lastly, see the file `MIDI/src/constants.jl` for message types, event types, etc.

## MIDI: The least you need to know
*This section serves as a crash-course on the MIDI format. For more info
see the [wikipedia](https://en.wikipedia.org/wiki/MIDI) page,
read the [official MIDI specifications](https://www.midi.org/specifications) or
have a look at the comprehensive tutorial [at recordingblogs.com](http://www.recordingblogs.com/wiki/musical-instrument-digital-interface-midi)*.

A MIDI file typically comes in pieces called tracks that play simultaneously. Each track can have 16 different channels, numbered 0-15. Each channel can be thought of as a single instrument, though that instrument can be changed throughout that track. A track contains events. The three types of events are MIDI events, META events, and system exclusive (SYSEX) events.
All events begin with the time since the last event (dT) in ticks. The number of ticks per quarter note is given by the `tpq` of the midi file, `MIDIFile.tpq` (see [`MIDIFile`](@ref)).

* MIDI events handle things related to the actual notes as well as sound texture, such as playing a note or moving the pitch-wheel.

* META events take care of things like adding copyright text, authorship information,
  track naming etc.

* SYSEX events are used to transmit arbitrary data. Their contents depend on the intended recipient.
