# Motif sequence generation

```@docs
MotifSequenceGenerator
random_sequence
```

## Simple Example

This example illustrates how the module [`MotifSequenceGenerator`](@ref) works using
a simple `struct`. For a more realistic, and much more complex example, see the
[example using music notes](musicexample.md).

---

Let's say that we want to create a random sequence of "shouts", which
are described by the `struct`
```@example shout
struct Shout
  shout::String
  start::Int
end
```

Let's first create a vector of shouts that will be used as the pool of
possible motifs that will create the random sequence:
```@example shout
using Random
shouts = [Shout(uppercase(randstring(rand(3:5))), rand(1:100)) for k in 1:5]
```
Notice that at the moment the values of the `.start` field of `Shout` are irrelevant. `MotifSequenceGenerator` will translate all motifs to start point 0 while operating.

Now, to create a random sequence, we need to define two concepts:
```@example shout
shoutlimits(s::Shout) = (s.start, s.start + length(s.shout) + 1);

shouttranslate(s::Shout, n) = Shout(s.shout, s.start + n);
```
This means that we accept that the temporal length of a `Shout` is `length(s.shout) + 1`.

We can now create random sequences of shouts that have total length of
*exactly* `q`:
```@example shout
using MotifSequenceGenerator
q = 30
sequence, idxs = random_sequence(shouts, q, shoutlimits, shouttranslate)
sequence
```
```@example shout
sequence, idxs = random_sequence(shouts, q, shoutlimits, shouttranslate)
sequence
```
Notice that it is impossible to create a sequence of length e.g. `7` with the above pool. Doing `random_sequence(shouts, 7, shoutlimits, shouttranslate)` would throw an error.

## Floating point lengths
The lengths of the motifs do not have to be integers. When using motifs with floating lengths, it is advised to give a non-0 `δq` to [`random_sequence`](@ref). The following example modifies the `Shout` struct and shows how it can be done with floating length.

```@example shout
struct FloatShout
  shout::String
  dur::Float64
  start::Float64
end

rs(x) = uppercase(randstring(x))

shouts = [FloatShout(rs(rand(3:5)), rand()+1, rand()) for k in 1:5]
shoutlimits(s::FloatShout) = (s.start, s.start + s.dur);
shouttranslate(s::FloatShout, n) = FloatShout(s.shout, s.dur, s.start + n);

q = 10.0
δq = 1.0

r, s = random_sequence(shouts, q, shoutlimits, shouttranslate, δq)

r
```
```@example shout
s
```
