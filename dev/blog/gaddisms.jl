# # 32nd note Gaddisms
# ## Introduction

# Steve Gadd is famous for being one of the first people to popularize playing fast
# 32nd notes between the hihat, snare and bass drum, typically using a combination
# of rudiments, like inverted doubles and paradiddles.
# Some people refer to these as "Flutter Licks", but I will be using the name "Gaddisms" here.

# I was originally introduced to this from a [YouTube video by Jungleritter](https://www.youtube.com/watch?v=HKtHGLvVSHk),
# but many other drum educators have approached this, for example [Austin Burcham](https://www.youtube.com/watch?v=lS3G6woh9T8).
# To get an idea you can watch the following Steve Gadd performances:

# [![](https://img.youtube.com/vi/iupLvcpV3eU/0.jpg)](https://www.youtube.com/watch?v=iupLvcpV3eU&t=196)

# [![](https://img.youtube.com/vi/yikq4JZaNOk/0.jpg)](https://www.youtube.com/watch?v=yikq4JZaNOk&t=4)

# The most basic version of these Gaddisms is definitely the following:

# ![](standard-1.png)

# In this tutorial I'll be going through the process I followed, in order to create
# exercises that allow me to study these Gaddisms, without having to write any combination
# I come with one by one, and also allowing me to easily add more or print less
# of them into a score.

# The final output of this tutorial will be something like this:

# ![](random1-1.png)

# and something like this:

# ![](gaddmatrix_1234x123.png)


# ## Creating the Gaddisms with Julia code

# Let's first load some basic packages and define some handy commands

using MusicManipulations # tools for handling MIDI data
using MusicVisualizations # to be able to access MuseScore
using Random; Random.seed!(1234) #src
cd(@__DIR__) #src
channel = 9 # this is the dedicated drum channel for MuseScore
mdk = musescore_drumkey # for typing less

# and then configure the subdivision of our notes

tpq = 960          # Duration of a quarter note in ticks
subdiv = tpq÷8     # note subdivision duration (32nd notes)
patlen = 8*subdiv  # pattern length

# Then we define the types of notes that will be part of the 32nd note
# patterns we will create:

A = Note(mdk["Acoustic Snare"], 100, 0, subdiv, channel)
R = Note(mdk["Closed Hi-Hat"], 70, 0, subdiv, channel)
L = Note(mdk["Side Stick"], 70, 0, subdiv, channel)
K = Note(mdk["Low Floor Tom"], 90, 0, subdiv, channel)

# I've made the "kick" note `K` to be a floor tom simply because MuseScore
# writes bass drum notes on a different voice than the rest of the notes,
# which makes the final score hard to read. You could use the "real" bass
# drum note by using `mdk["Acoustic Bass Drum"]` instead.

# In any case, the goal is to combine these four notes to make "Gaddisms",
# keeping in mind the following simple rules (to stay as close to the original
# Steve Gadd style as possible):
# 1. Each Gaddism has 16 32nd notes (2 quarter notes)
# 2. The first half starts with a kick `K` and cannot end with a right hand
# 3. The second class starts with a right hand accent `A`
# 3. `R, L, K` can be repeated up to two times sequentially

# For example, the most "standard" pattern is `KLLRRLLK ALLRRLLK`:
# ![](standard-1.png)

# As we have defined the notes `A, ... K`, the simplest way to do make this pattern from
# notes programmatically is to combine them into a vector, e.g.
[K, L, L, R, R, L, L, K]

# The problem unfortunately is that all of these notes start at the _same_ time, so
# if we made them into a score, you'd have 8 32nd notes all in the first 32nd note of the bar...

# To be able to transform this vector of notes into notes that start sequentially we
# define the following function:

"""
Combine the given notes into a notes that start sequentially.
"""
function make_pattern(v::Vector{<:AbstractNote})
    n = Notes([v[1]], 960)
    for i in 2:length(v)
        push!(n, translate(v[i], (i-1)*subdiv))
    end
    return n
end

p1 = make_pattern([K, L, L, R, R, L, L, K])
p2 = make_pattern([A, L, L, R, R, L, L, K])

# And we can easily combine them and put them into MuseScore and see the output:
x = combine([p1, translate(p2, patlen)])
musescore("standard.png", x) #src
# ```julia
# musescore("standard.png", x)
# ```

# ![](standard-1.png)

# Notice the use of the [`translate`](@ref) function, which ensures that the second part
# `p2` doesn't start at the same time as `p1`.

# Alright, now it is only a matter of just writing down all "Gaddisms" that we would like
# to practice:

first_half = make_pattern.([
    [K, L, L, R, R, L, L, K],
    [K, L, L, K, R, L, L, K],
    [K, R, L, K, R, L, L, K],
    [K, R, L, K, R, L, K, L],
    [K, L, R, R, L, L, R, L],
    [K, L, R, R, L, R, R, L],
    [K, L, L, R, R, L, K, K],
    [K, R, L, R, R, L, L, K],
    [K, L, L, R, K, L, K, L],
    [K, L, R, R, L, R, L, L],
    [K, L, L, K, A, L, L, K],
])

second_half = make_pattern.([
    [A, L, L, R, R, L, L, K],
    [A, L, L, K, R, L, L, K],
    [A, L, K, L, R, L, L, K],
    [A, L, L, R, K, R, L, L],
    [A, L, R, R, L, R, L, L],
    [A, L, R, R, L, R, R, L],
    [A, L, L, R, R, K, L, L],
    [A, L, K, R, L, K, R, L],
    [A, L, R, L, L, R, L, L],
    [A, L, R, L, L, R, L, K],
    [A, K, R, L, K, R, L, K],
    [A, K, R, L, L, R, R, K],
    [A, L, A, L, L, R, L, K],
])

second_half[3]

# ## Combining Gaddisms into a sequence

# By now every component we need is ready, and we could use any arbitrary
# Gaddisms to make a sequence, for example

x = combine([first_half[5], translate(second_half[8], patlen)])

musescore("another.png", x) #src
# ```julia
# musescore("another.png", x) #src
# ```

# ![](another-1.png)

# The recipe is simple enough and we define a function that will just produce a
# sequence of arbitrary many gaddisms

# %% #src
function random_gaddisms(n = 1)
    @assert n ≤ min(length(first_half), length(second_half))
    r1, r2 = randperm(length(first_half)), randperm(length(second_half))
    final = Vector{Notes}()
    c = 0
    for i in 1:n
        push!(final, translate(first_half[r1[i]],  c*patlen))
        push!(final, translate(second_half[r2[i]], (c+1)*patlen))
        c += 8 # this adds a bar of rest, for better layouting
    end
    return combine(final)
end

musescore("random1.png", random_gaddisms(4)) #src
# ```julia
# musescore("random1.png", random_gaddisms(4))
# ```
# ![](random1-1.png)

musescore("random2.png", random_gaddisms(8)) #src
# ```julia
# musescore("random2.png", random_gaddisms(8))
# ```
# ![](random2-1.png)

# One can run this command arbitrary times to make arbitrary amount of random
# combinations, e.g. `[musescore("randgadd_$i.pdf", random_gaddisms(8)) for i in 1:4]`.

# ## Gaddism Matrix

# If you print and try to study many of these comdinations, as e.g. shown in the last
# section of this page, you will quickly
# realize that there _must_ be some more efficient ways to present all this information.
# Well, the answer is a **matrix**! A matrix looks like this:

# ![](gaddmatrix_1234x123.png)

# How do you make such a matrix? with the following function:

# %% #src
using PyPlot

function gaddism_matrix(first, second; dx = 2.6, dy = 1.2) # inches per pattern
    patternimg(path) = matplotlib.image.imread(path)[:, 640:2880, :]
    Lf, Ls = length.((first, second))
    fig, axs = subplots(Lf+1, Ls+1, figsize = ((Ls+1)*dx, (Lf+1)*dy))

    for (fi, f) in enumerate(first)
        musescore("f$(f).png", first_half[f], display = false)
        fimg = patternimg("f$(f)-1.png")
        axs[fi+1, 1].imshow(fimg)
        rm("f$(f)-1.png")
        for y in ((1 - fi/(Lf+1)), (1 - (fi+1)/(Lf+1)))
            line = matplotlib.lines.Line2D([0, 1], [y, y], color="k", transform=fig.transFigure)
            fig.add_artist(line)
        end
    end
    for (si, s) in enumerate(second)
        musescore("s$(s).png", second_half[s], display = false)
        simg = patternimg("s$(s)-1.png")
        axs[1, si+1].imshow(simg)
        rm("s$(s)-1.png")
        for x in (si/(Ls+1), (si+1)/(Ls+1))
            line = matplotlib.lines.Line2D([x, x], [0, 1], color="k", transform=fig.transFigure)
            fig.add_artist(line)
        end
    end
    axs[1,1].text(0.5,0.5, "Gaddism Matrix\n(flutter licks)\n"*
                  "by George Datseris\nusing JuliaMusic", va="center", ha="center", size=12)
    for ax in axs; ax.axis("off"); end
    fig.tight_layout()
    fig.savefig("gaddmatrix_$(join(first))x$(join(second)).png", dpi = 1200)
end

# This function is given two vectors of integer indices, each denoting which patterns from the
# first and second half to include into the matrix:

gaddism_matrix(1:4, 1:3) #src
gaddism_matrix([1, 2, 4, 5, 7], [1, 8, 5]) #src
# ```julia
# gaddism_matrix([1, 2, 4, 5, 7], [1, 8, 5])
# ```

# ![](gaddmatrix_12457x185.png)

# For example, the standard pattern shown in the introduction was made with this code:

# ```julia
# gaddism_matrix(1:4, 1:3)
# ```

# I won't go too deep into details about `gaddism_matrix`, because most of the code is plotting.
# In essence what the function does is saves each pattern by itself via MuseScore,
# then loads the image as numeric data (see `patternimg`) and plots this image
# using PyPlot. The rest of the code is just layouting and adding straight lines.

# This function is *awesome* because it is scalable to arbitrary amounts of
# first and second half patterns! For example:

gaddism_matrix([6, 8], 1:6) #src
# ```julia
# gaddism_matrix([6, 8], 1:6)
# ```

# ![](gaddmatrix_68x123456.png)

# The way I studied this is creating 3x3 matrices and really focusing on learning the
# individual patterns to the point I could arbitrarily combine most of them.

# ## Putting all possible Gaddism combinations into a PDF

# %% #src
# Putting all possible Gaddism combinations into a PDF
# is straightforward with the following simple function:
function allgaddisms(first_half, second_half)
    final = Vector{Notes}()
    c = 0
    for i in 1:length(first_half)
        for j in 1:length(second_half)
            push!(final, translate(first_half[i], c*patlen))
            push!(final, translate(second_half[j], (c+1)*patlen))
            c += 8
        end
    end
    return combine(final)
end

# ```julia
# musescore("all.pdf", allgaddisms(first_half, second_half));
# ```

# Notice that this will make a huge pdf file. You can of course do:

# ```julia
# musescore("all_from_1.pdf", allgaddisms([first_half[1]], second_half));
# ```

# to only combine the first combination with all the others.
