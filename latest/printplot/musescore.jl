# # Printing into a Score

# ## MuseScore
# [MuseScore](https://musescore.org) is a wonderful and open source _professional_
# music score editor with a huge amount of capabilities. `MusicManipulations`
# provides a convenient interface that can instantly print any [`Notes`](@ref)
# or [`MIDIFile`](@ref) structure via MuseScore.

#md # ```@docs
#md # musescore
#md # ```

# !!! tip "Quantize your notes!"
#     Keep in mind that the score creation capabilities of MuseScore rely upon
#     having well-defined notes. This means that you should use the function
#     [`quantize`](@ref) to quantize both the position and duration of your notes!



# ### Creating a Score out of some Notes

using MusicManipulations
cd(@__DIR__) #src

# We first load the test MIDI file "Doxy".
# The third track has the notes of the Bass:
midi = readMIDIfile() # read the "test" Doxy MIDI recording.
bass = getnotes(midi, 3)
basstrim = bass[1:50]
# Because the notes of the Bass are already quantized we can already
# print them into a staff using MuseScore:

musescore("bass.png", basstrim) #src
#md # ```julia
#md # musescore(bass, notes)
#md # ```
#nb musescore(bass, notes)

# ![Bass score](bass-1.png)

# Amazingly MuseScore deduces automatically the clef and even the key of
# the piece!

# ### Creating a full Score out of a MIDI file
# You can also pass a full MIDI file to [`musescore`](@ref).

piano = getnotes(midi, 4)

# However, MuseScore has decent results only with quantized notes.
# Let's quantize on a triplet grid using [`quantize`](@ref).
qpiano = quantize(piano, [0, 1//3, 2//3, 1])

# and save both tracks into a midi file:
ptrack = MIDITrack()
addnotes!(ptrack, qpiano)
addtrackname!(ptrack, "Doxy")
smidi = MIDIFile(1, 960, [midi.tracks[3], ptrack])

# and then save the full thing as `.pdf`:
musescore("doxy.pdf", smidi) #src
musescore("doxy.png", smidi) #src

#md # ```julia
#md # musescore("doxy.pdf", smidi)
#md # ```
#nb score("doxy.pdf", smidi)

# You can find the produced `.pdf` file
# [here](https://github.com/JuliaMusic/JuliaMusic_documentation.jl/tree/master/docs/src/printplot/doxy.pdf).
# The first page looks like this:
# ![Full score](doxy-1.png)
# When given multiple tracks MuseScore displays the name of the track ([`trackname`](@ref)),
# as well as the instrument it automatically chose to represent it.
