# # Music Motif Examples
# In this page [`MotifSequenceGenerator`](@ref) is applied in a real world
# case using the function [`random_notes_sequence`](@ref):

#md # ```@docs
#md # random_notes_sequence
#md # ```

#nb ?random_notes_sequence

# ## Motifs: Basic drum patterns
# Let's say that we have some basic drum patterns that we want to be
# able to combine freely at random combinations. For example,
#
# ![Basic drum patterns](basic_motifs.png)
#
# where the note E means right hand, while A means left hand.
# These patterns can be easily combined to fill a bar, like for
# example `5b -> 5b -> 3 -> 3` or
# `5a -> 4 -> 4 -> 3`, etc. They can also be combined to fill two bars and so on.
# Notice that some sequences, like e.g. the `5a -> 4 -> 4 -> 3`, result in
# *alternating hands*: each time the sequence is played the hand that "leads"
# is swapped. This will be important later on.


# The goal is to be able to play arbitrary sequences of them for arbitrary lengths.
# How does one practice that? We will use [`random_notes_sequence`] to create
# longer 8-bar sequences faster with the help of Julia.
#
# ## Defining the `Notes`
# We first have to define the `Notes` instances that will correspond
# to those four basic patterns.

using MusicManipulations # re-exports MIDI
cd(@__DIR__)

tpq = 960
sixt = subdivision(16, tpq)
left = name_to_pitch("A5")
right = name_to_pitch("E6")

motif1 = [
Note(right, 100, 0, sixt),
Note(left, 50, sixt, sixt),
Note(right, 100, 2sixt, sixt),
Note(left, 50, 3sixt, sixt),
Note(left, 50, 4sixt, sixt)
]

motif2 = [
Note(right, 100, 0, sixt),
Note(left, 50, sixt, sixt),
Note(left, 50, 2sixt, sixt),
Note(right, 50, 3sixt, sixt),
Note(right, 50, 4sixt, sixt)
]

motif3 = [
Note(right, 100, 0, sixt),
Note(left, 50, sixt, sixt),
Note(left, 50, 2sixt, sixt),
]

motif4 = [
Note(right, 100, 0, sixt),
Note(left, 50, sixt, sixt),
Note(right, 50, 2sixt, sixt),
Note(right, 50, 3sixt, sixt),
]

motifs = Notes.([motif1, motif2, motif3, motif4], tpq)

# Now `motifs` stands for a pool of note sequences we can draw random samples from.
# Let's generate sequences that are 8-bars long (i.e. 32 quarter notes)

q = tpq*32

notes, seq = random_notes_sequence(motifs, q)
notes

# and now we can write these to a MIDI file simply by doing
writeMIDIfile("drums_patterns.mid", notes)

# Afterwards we can drag-n-drop the midi file into a music score editor,
# like e.g. [MuseScore](https://musescore.org/en), to visualize and print
# the result:

# ![32-bar pattern sequence](drums_patterns.png)

# *this is a pre-made figure - your random sequence will probably differ*

# This worked nicely, but there is a problem: The sequence does not respect
# the fact that some specific patterns (`5a` and `4`) swap the leading hand.
# This is what we tackle in the next section.

# ## Adding alternating hands and Lyrics
# Notice that `random_note_sequence` also returns the indices of the motifs
# that were used to create the sequence:
seq

# We can use this information to put the correct "stickings".
# To alternate hands we simply need to replace the necessary E notes with A and
# vice versa. Let's define some "meta-data" like structures

accent1 = ("5a", false)
accent2 = ("5b", true)
accent3 = ("3", false)
accent4 = ("4", true)
accents = [accent1, accent2, accent3, accent4]

# The first entry of each tuple is simply the name of the pattern which
# we will also show in our music score as "lyrics". The second entry
# of the tuple simply denotes whether the pattern swaps the leading hand.

# The function that will "inverse" a note sticking is:
inverse!(n::Note) = (n.pitch = (n.pitch == left ? right : left));

# The function that will "count" how long is each pattern, so that we
# put the lyrics on the correct positions in the score, will be:
note_length(s::String) = parse(Int, s[1]);

# (remember: `sixt` is the duration of one sixteenth note).
# We now initialize an empty [`MIDITrack`](@ref) and add all events to it!

track = MIDITrack()
ℓ = 0 # where to put the lyrics
right_lead = true # what hand leads?
prev_note = 1

for i in 1:length(seq)
    s = accents[seq[i]][1]
    le = textevent(:lyric, s)
    addevent!(track, ℓ, le)
    global ℓ += note_length(s)*sixt
    if !right_lead # Invert notes if necessary
        for j in prev_note:prev_note+note_length(s)-1
            inverse!(notes[j])
        end
    end

    global prev_note += note_length(s)

    change = accents[seq[i]][2]
    global right_lead = xor(right_lead, change)
end
!right_lead && inverse!(notes[end])

addnotes!(track, notes)

# Finally, we write the track as a midi file

writeMIDIfile("drums_patterns_with_names.mid", MIDIFile(0, tpq, [track]))

# then we drag-n-drop the midi file into [MuseScore](https://musescore.org/en)
# once again, and we get:

# ![Correct 32-bar pattern sequence](drums_patterns_with_names.png)
