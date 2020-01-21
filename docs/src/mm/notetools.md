# Note Tools

This page describes functions that allow you to very conveniently work with
and manipulate `Note`, `Notes`, and similar for example you can easily
[`translate`](@ref) in time or [`transpose`](@ref) them in pitch.

The functions `velocities, positions, pitches, durations` return
the respective property when given some [`Notes`](@ref).

Other functions follow:
```@docs
translate
transpose
louden
repeat
timesort!
```

---

And for getting default notes:

```@docs
testmidi
testnotes
randomnotes
```
