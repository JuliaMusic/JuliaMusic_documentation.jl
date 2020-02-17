```@meta
EditURL = "<unknown>/../JuliaMusic_documentation.jl/docs/src/blog/drumpatterns.jl"
```

# Mixing basic drum patterns
!!! note
    This page is also available as a YouTube video here: [https://youtu.be/Oog_aunpVms](https://youtu.be/Oog_aunpVms)


---

Let's say that we have some basic drum patterns that we want to be
able to combine freely at random combinations. For example,

![Basic drum patterns](basic_motifs.PNG)

where the note E means right hand, while A means left hand.
These patterns can be easily combined to fill a bar, for
example `5b -> 5b -> 3 -> 3` or
`5a -> 4 -> 4 -> 3`, etc. They can also be combined to fill two bars and so on.
Notice that some sequences, like e.g. the `5a -> 4 -> 4 -> 3`, result in
*alternating hands*: each time the sequence is played the hand that "leads"
is swapped. This will be important later on.

The goal is to be able to play arbitrary sequences of them for arbitrary lengths.
How does one practice that? We will use [`random_notes_sequence`](@ref) to create
longer 8-bar sequences faster with the help of Julia.

## Defining the `Notes`
We first have to define the `Notes` instances that will correspond
to those four basic patterns.

```@example drumpatterns
using MusicManipulations, MusicVisualizations

tpq = 960 # ticks per quarter note
sixt = 240 # duration of sixteenth note
left = name_to_pitch("A5")
right = name_to_pitch("E6")
```

Reminder: `Note(pitch, intensity, start, duration)`

```@example drumpatterns
motif1 = [ # motif 5a
Note(right, 100, 0, sixt),
Note(left, 50, sixt, sixt),
Note(right, 100, 2sixt, sixt),
Note(left, 50, 3sixt, sixt),
Note(left, 50, 4sixt, sixt)
]

motif2 = [ # motif 5b
Note(right, 100, 0, sixt),
Note(left, 50, sixt, sixt),
Note(left, 50, 2sixt, sixt),
Note(right, 50, 3sixt, sixt),
Note(right, 50, 4sixt, sixt)
]

motif3 = [ # motif 3
Note(right, 100, 0, sixt),
Note(left, 50, sixt, sixt),
Note(left, 50, 2sixt, sixt),
]

motif4 = [ # motif 4
Note(right, 100, 0, sixt),
Note(left, 50, sixt, sixt),
Note(right, 50, 2sixt, sixt),
Note(right, 50, 3sixt, sixt),
]

motifs = Notes.([motif1, motif2, motif3, motif4], tpq)
```

Now `motifs` stands for a pool of note sequences we can draw random samples from.
Let's generate sequences that are 8-bars long (i.e. 32 quarter notes)

```@example drumpatterns
q = tpq*32

notes, seq = random_notes_sequence(motifs, q)
notes
```

and now we can write these to a MIDI file simply by doing
`writeMIDIFile("drums_patterns.mid", notes)` if we want to.
We can also use [MuseScore](https://musescore.org), to visualize and print
the result. The function [`musescore`](@ref) provides this interface.
```julia
musescore("drums_patterns.png", notes)
```

![32-bar pattern sequence](drums_patterns-1.png)

*this is a pre-made figure - your random sequence will probably differ*

This worked nicely, but there is a problem: The sequence does not respect
the fact that some specific patterns (`5b` and `4`) swap the leading hand.
This is what we tackle in the next section.

## Adding alternating hands and Lyrics
Notice that `random_note_sequence` also returns the indices of the motifs
that were used to create the sequence:

```@example drumpatterns
seq
```

We can use this information to put the correct "stickings".
To alternate hands we simply need to replace the necessary E notes with A and
vice versa. Let's define some "meta-data" like structures

```@example drumpatterns
accent1 = ("5a", false)
accent2 = ("5b", true)
accent3 = ("3", false)
accent4 = ("4", true)
accents = [accent1, accent2, accent3, accent4]
```

The first entry of each tuple is simply the name of the pattern which
we will also show in our music score as "lyrics". The second entry
of the tuple simply denotes whether the pattern swaps the leading hand.

The function that will "inverse" a note sticking is:

```@example drumpatterns
inverse!(n::Note) = (n.pitch = (n.pitch == left ? right : left));
nothing #hide
```

The function that will "count" how long is each pattern, so that we
put the lyrics on the correct positions in the score, will be:

```@example drumpatterns
note_length(s::String) = parse(Int, s[1]);
nothing #hide
```

(remember: `sixt` is the duration of one sixteenth note).
We now initialize an empty [`MIDITrack`](@ref) and add all events to it!

```@example drumpatterns
track = MIDITrack()
ℓ = 0
right_leads = true

for i in 1:length(seq)

    s = accents[seq[i]][1]
    le = textevent(:lyric, s)
    addevent!(track, ℓ*sixt, le)

    if !right_leads # Invert notes
        for j in ℓ+1:ℓ+note_length(s)
            inverse!(notes[j])
        end
    end

    global ℓ += note_length(s)

    change = accents[seq[i]][2]
    global right_leads = xor(right_leads, change)
end

addnotes!(track, notes)
notes
```

Finally, to visualize, we use [`musescore`](@ref) again, using a midi file as an
input
```julia
musescore("drums_patterns_with_names.png", MIDIFile(1, 960, [track]))
```

![Correct 32-bar pattern sequence](drums_patterns_with_names-1.png)

Isn't it cool that even the lyrics text was displayed so seamlessly?

