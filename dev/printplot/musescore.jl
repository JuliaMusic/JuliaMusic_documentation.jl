# # Printing into a Score using MuseScore

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



# ## Creating a Score out of some Notes

using MusicManipulations # tools for manipulating notes in Julia
using MusicVisualizations # tools for visualizing these notes
cd(@__DIR__) #src

# We first load the test MIDI file "Doxy".
# The third track has the notes of the Bass:
midi = readMIDIFile() # read the "test" Doxy MIDI recording.
bass = getnotes(midi, 3)
basstrim = bass[1:50]
# Because the notes of the Bass are already quantized we can already
# print them into a staff using MuseScore:

musescore("bass.png", basstrim) #src
# ```julia
# musescore("bass.png", basstrim)
# ```

# ![Bass score](bass-1.png)

# Amazingly MuseScore deduces automatically the clef and even the key of
# the piece!

# ## Creating a full Score out of a MIDI file
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

# and then save the full thing as `.pdf` or `.png`:
musescore("doxy.png", smidi) #src

#md # ```julia
#md # musescore("doxy.pdf", smidi)
#md # ```

# The first page looks like this:
# ![Full score](doxy-1.png)

# When given multiple tracks MuseScore displays the name of the track ([`trackname`](@ref)),
# as well as the instrument it automatically chose to represent it.

# ## Drum Notation
# It is also possible to use MuseScore to create drum notation.
# The process for this is almost identical with the above, with two differences.
# Firstly, the pitch of each note must have a specific value that maps
# the the actual drum instrument, and secondly all notes must be written on channel `9`.

# The function [`DrumNote`](@ref) simplifies this process:

# ```@docs
# DrumNote
# ```

# And this is the drum key we use:

DRUMKEY

# Here is an example where we create the "basic rock groove" in drum notation:

tpq = 960; e = 960÷2 # eigth note = quarter note ÷ 2
bass = "Acoustic Bass Drum"
snare = "Acoustic Snare"
hihat = "Closed Hi-Hat"

# We make the 8 hihat notes
rock = [DrumNote(hihat, i*e, e) for i in 0:7]

# add 2 bass drums
push!(rock, DrumNote(bass, 0, e), DrumNote(bass, 4e, e))

# and add 2 snare drums
push!(rock, DrumNote(snare, 2e, e), DrumNote(snare, 6e, e))

# and finally bundle the notes with the ticks per quarter note
rock = Notes(rock, tpq)

# and then call MuseScore to actually make the score
cd(@__DIR__) #src
musescore("rock.png", rock) #src
# ```julia
# musescore("rock.png", rock)
# ```
# ![](rock-1.png)
