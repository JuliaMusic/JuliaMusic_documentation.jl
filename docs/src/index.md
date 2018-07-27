# Introduction
This documentation describes how to use packages of the [JuliaMusic](https://github.com/JuliaMusic). They are about reading, manipulating
and saving data related with music. Most of the functionality
comes in the form of the [MIDI](https://en.wikipedia.org/wiki/MIDI) format
which is described later on this page.

The current documentation was built with the following versions
```@eval
using Pkg.API: installed # hide
ins = installed()
for pkg in ["MIDI", "MotifSequenceGenerator", "MusicManipulations"]
  println("- $(pkg): $(ins[pkg])")
end
```

## Overview

[MIDI.jl](https://github.com/JuliaMusic/MIDI.jl) is a module that defines
fundamental types like tracks, reading/writing functionality, note functionality and other
basic stuff.

1. [Basic MIDI API](midi/io) : The API of basic types like midi files and tracks, as well as IO. Various utility functions are included as well.
2. [Notes](midi/notes) : The [`Note`](@ref) construct describes a music note. Many convenience tools are also provided in the same page, like e.g. turning a not pitch to a string like `A♯3`.

The [MusicManipulations.jl](https://github.com/JuliaMusic/MusicManipulations.jl) package has more advanced functionality about note processing, data extraction, quantizing and other similar processes that related to music data.

1. [Quantizing & Classifying Notes](mm/quantizing) on a given grid.
2. [Music Data Extraction](mm/extraction)
3. More coming soon.

## MIDI: The least you need to know
*This section serves as a crash-course on the MIDI format. For more info
see the [wikipedia](https://en.wikipedia.org/wiki/MIDI) page,
read the [official MIDI specifications](https://www.midi.org/specifications) or
have a look at the comprehensive tutorial [at recirdingblogs.com](http://www.recordingblogs.com/wiki/musical-instrument-digital-interface-midi)*.

A MIDI file typically comes in pieces called tracks that play simultaneously. Each track can have 16 different channels, numbered 0-15. Each channel can be thought of as a single instrument, though that instrument can be changed throughout that track. A track contains events. The three types of events are MIDI events, META events, and system exclusive (SYSEX) events.
All events begin with the time since the last event (dT) in ticks. The number of ticks per quarter note is given by the `tpq` of the midi file, `MIDIFile.tpq` (see [`MIDIFile`](@ref)).

* MIDI events handle things related to the actual notes as well as sound texture, such as playing a note or moving the pitch-wheel.

* META events take care of things like adding copyright text, authorship information,
  track naming etc.

* SYSEX events are used to transmit arbitrary data. Their contents depend on the intended recipient.
