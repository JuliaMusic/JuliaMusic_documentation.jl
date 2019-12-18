# Introduction
This documentation describes how to use packages of the [JuliaMusic](https://github.com/JuliaMusic), which are about reading, manipulating and saving data related with music, and are written in the [Julia](https://julialang.org/) programming language.
Most of the functionality comes in the form of the [MIDI](https://en.wikipedia.org/wiki/MIDI) format which is described later on this page.

!!! info "Latest News"
    Segmentation of notes: [`segment`](@ref)!


The current documentation was built with the following package versions
```@setup versions
using Pkg.API: installed
ins = installed()
function f()
for pkg in ["MIDI", "MotifSequenceGenerator",
            "MusicManipulations", "MusicVisualizations"]
  println(rpad(" * $(pkg) ", 30, "."), " $(ins[pkg])")
end
end
```
```@example versions
f() # hide
```
using [Material+MkDocs](https://squidfunk.github.io/mkdocs-material/),  [Literate.jl](https://github.com/fredrikekre/Literate.jl) and [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl/).

## Getting Started
The current documentation assumes that you are already familiar with the MIDI format and the [Julia](https://julialang.org/) language. After you have installed Julia, you can install the packages you'd like by pressing `]` in the Julia REPL (to access the package manager mode) and then `add MIDI MusicManipulations`. To learn a bit more about the MIDI format you can see the [MIDI: The least you need to know](@ref) section. The [Overview](@ref) section displays the offered functionality of JuliaMusic.

## Citing

If you used **MIDI.jl** or **MusicManipulations.jl** in research that resulted in publication, then please cite our paper using the following BibTeX entry:
```latex
@article{Datseris2019,
  doi = {10.21105/joss.01166},
  url = {https://doi.org/10.21105/joss.01166},
  year  = {2019},
  month = {mar},
  publisher = {The Open Journal},
  volume = {4},
  number = {35},
  pages = {1166},
  author = {George Datseris and Joel Hobson},
  title = {{MIDI}.jl: Simple and intuitive handling of MIDI data.},
  journal = {The Journal of Open Source Software}
}
```


## Overview

### MIDI

[MIDI.jl](https://github.com/JuliaMusic/MIDI.jl) is a module that defines
fundamental types like tracks, reading/writing functionality, note functionality and other
basic stuff.

1. [Basic MIDI API](midi/io) : The API of basic types like midi files and tracks, as well as IO. Various utility functions are included as well.
2. [Notes](midi/notes) : The [`Note`](@ref) construct describes a music note. Many convenience tools are also provided in the same page, like e.g. turning a note pitch to a string like `A♯3`.

### MusicManipulations

The [MusicManipulations.jl](https://github.com/JuliaMusic/MusicManipulations.jl) package has more advanced functionality about note processing, data extraction, quantizing and other similar processes that related to music data.

1. [Convenience tools](midi/notes/#convenience-tools).
1. [Quantizing & Classifying Notes](mm/quantizing) on a given grid.
2. [Advanced Music Data Extraction](mm/extraction).
3. [Printing notes into a Score](printplot/musescore)
3. More coming soon.

### MotifSequenceGenerator

[MotifSequenceGenerator.jl](https://github.com/JuliaMusic/MotifSequenceGenerator.jl) is a very simple module that does a very simple thing: based on a pool of motifs with specified lengths, it makes a random sequence out of them so that the sequence also has a specified length!

1. [Motif Sequences](motif/basic.md) introduces the module and has a basic usage example.
2. [Music Motifs Example](motif/musicexample.md) shows a real-world use case where the module is used to produce music sequences.


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
