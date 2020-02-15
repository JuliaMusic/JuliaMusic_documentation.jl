# Introduction
This documentation describes how to use packages of the [JuliaMusic](https://github.com/JuliaMusic), which are about reading, manipulating and saving data related with music, and are written in the [Julia](https://julialang.org/) programming language.
Most of the functionality comes in the form of the [MIDI](https://en.wikipedia.org/wiki/MIDI) format which is described later on this page.

!!! info "Latest News"
    Segmentation of notes: [`segment`](@ref)! Repetition of notes: [`repeat`](@ref)!


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
using [Literate.jl](https://github.com/fredrikekre/Literate.jl) and [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl/).
The documentation is written and maintained by George Datseris.

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

You can get an idea of the scientific projects that these software are used here: https://www.nature.com/articles/s41598-019-55981-3

## Overview

### MIDI

[MIDI.jl](https://github.com/JuliaMusic/MIDI.jl) is a module that defines
fundamental types like tracks, reading/writing functionality, note functionality and other
basic stuff.

1. [Basic MIDI structures](@ref) : The API of basic types like midi files and tracks, as well as IO. Various utility functions are included as well.
2. [Notes](@ref) : The [`Note`](@ref) construct describes a music note. Many convenience tools are also provided in the same page, like e.g. turning a note pitch to a string like `A♯3`.

### MusicManipulations

The [MusicManipulations.jl](https://github.com/JuliaMusic/MusicManipulations.jl) package has more advanced functionality about note processing, data extraction, quantizing and other similar processes that related to music data.

1. [Note Tools](@ref) for easy handling of notes.
1. [Quantizing](@ref) for quantizing and classifying notes on a given grid.
2. [Music data extraction](@ref).

### MusicVisualizations
This functionality allows you to either print MIDI data into a music score using [`musescore`](@ref), or plot notes directly like a "piano roll" with the customizable function [`noteplotter`](@ref).


### MotifSequenceGenerator

[MotifSequenceGenerator.jl](https://github.com/JuliaMusic/MotifSequenceGenerator.jl) is a very simple module that does a very simple thing: based on a pool of motifs with specified lengths, it makes a random sequence out of them so that the sequence also has a specified length!

1. [Motif sequence generation](@ref) introduces the module and has a basic usage example.
2. [Music motifs](@ref) applies this to notes.

### Becoming a better drummer blog
This section of the documentation is more like a blog than a documentation. In these  pages I describe how I use the packages of JuliaMusic, and the programming language Julia, to help myself become a better drummer.
