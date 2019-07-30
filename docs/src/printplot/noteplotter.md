# Plotting Notes
With `MusicManipulations` it is possible to plot [`Notes`](@ref) similarly to a "piano roll" that DAW like Cubase use. This is achieved with the [`noteplotter`](@ref) function, which becomes available only when `using PyPlot`.

```@docs
noteplotter
```
---

## Piano notes
```@example noteplot
using MusicManipulations, PyPlot

testdir = joinpath(pathof(MusicManipulations), "..", "..", "test")
midi = readMIDIFile(joinpath(testdir, "mfi_grapevine_1.mid"))

piano = getnotes(midi, 4)
grid = 0:1//4:1

noteplotter(piano; st = 15300, grid = grid)
tight_layout() # hide
savefig("pianoroll.png"); nothing # hide
```
![](pianoroll.png)

## Drum notes
The nice thing about [`noteplotter`](@ref) is that it is fully customizable, via its argument `plotnote!`. In this section we show an example of how [`noteplotter`](@ref) can be used to plot drum notes in drum notation, similarly to Cubase's GM Map.

The first step is defining a specific function for `plotnote!`. Since the duration of the notes does not have meaning in this case, we can just scatter plot their position. Also, we can use different symbols for different drum parts, e.g. circles for snare and bass drum and Xs for hihat and cymbals.

```@example noteplot
function plotdrumnote!(ax, note, cmap)
    p = note.pitch
    if p == 0x24 # kick
        v, m = 1, "o"
    elseif p ∈ (0x26, 0x28) # snare
        v, m = 3, "o"
    elseif p ∈ (0x16, 0x1a) # hihat rim
        v, m = 5, "X"
    elseif p ∈ (0x2e, 0x2a) # hihat head
        v, m = 5, "x"
    elseif p == 0x35 # ride bell
        v, m = 6, "D"
    elseif p == 0x33 # ride head
        v, m = 6, "x"
    elseif p == 0x3b # ride rim
        v, m = 6, "X"
    elseif p ∈ (0x30, 0x32) # tom 1
        v, m = 4, "s"
    elseif p ∈ (0x2b, 0x3a) # tom 3
        v, m = 2, "s"
    elseif p ∈ (0x31, 0x37, 0x34, 0x39)
        v, m = 7, "X"
    elseif p == 0x2c # hihat foot
        v, m = 1, "x"
    else
        error("Unknown pitch $(UInt8(p))")
    end
    ax.scatter(note.position, v, marker = m, s = 250,
        color = cmap(min(note.velocity, 127)/127))
    return v
end
```
(notice that the above function is hand-tailored for a specific e-drumset)

To make things even prettier, one can also use custom names for the notes:
```@example noteplot
TD50_PLOT = Dict(
    1 => "kick",
    3 => "snare",
    5 => "hihat",
    6 => "ride",
    4 => "tom1",
    2 => "tom3",
    7 => "crash",
)
```

And now here is how plotting some drum notes looks like:
```@example noteplot
drums = getnotes(midi, 3)

noteplotter(drums; st = 15300, grid = grid,
                   names=TD50_PLOT, plotnote! = plotdrumnote!)
tight_layout() # hide
savefig("drumroll.png"); nothing # hide
```
![](drumroll.png)
