# Data Extraction & Manipulation
The functions described in this page allow for easier extraction of data from music recordings (in the form of MIDI).
A highlight of JuliaMusic is the [`timeseries`](@ref) function, which allows one to directly get gridded timeseries from arbitrary `Notes` structures.

## Basic Data Extraction


```@docs
firstnotes
filterpitches
separatepitches
combine
relpos
```

## Advanced Data Extraction
```@docs
estimate_delay
estimate_delay_recursive
```

## Timeseries

```@docs
timeseries
```

---

Here is an example:
```@example
using MusicManipulations, PyPlot, Statistics
midi = readMIDIFile(testmidi())
notes = getnotes(midi, 4)

swung_8s = [0, 2//3, 1]
t, vel = timeseries(notes, :velocity, mean, swung_8s)

notmiss = findall(!ismissing, vel)

fig, (ax1, ax2) = subplots(2,1)
ax1.scatter(t[notmiss], vel[notmiss])
ax1.set_ylabel("velocity")

t, mtd = timeseries(notes, :position, mean, swung_8s)
ax2.scatter(t[notmiss], mtd[notmiss], color = "C1")
ax2.set_ylabel("timing deviations")
ax2.set_xlabel("ticks")
tight_layout() # hide
savefig("timeseries.png"); nothing # hide
```
![](timeseries.png)

---

An example code that obtains the velocity of the notes with highest pitch in each bin is this one:
```julia
notes = getnotes(midi, 4)

function f(notes)
    m, i = findmax(pitches(notes))
    notes[i].velocity
end

grid = 0:1//3:1
tvec2, ts2 = timeseries(notes, f, grid)
```

## Segmentation
```@docs
segment
```
