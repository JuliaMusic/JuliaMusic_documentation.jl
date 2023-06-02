#=
Notice that because this documentation requires MuseScore to be build, it can't
be done on travis. one has to do it locally and push the result to the gh-pages branch.
=#
using Pkg
Pkg.activate(@__DIR__)
CI = get(ENV, "CI", nothing) == "true" || get(ENV, "GITHUB_TOKEN", nothing) !== nothing
CI && Pkg.instantiate()
using MIDI, MusicManipulations, MotifSequenceGenerator, MusicVisualizations
using Documenter, Literate, PyPlot, Statistics

# %% Literate Conversions
tobe = [
    "printplot/musescore.jl"
    "blog/drumpatterns.jl"
    "blog/garibaldi_dragadiddle.jl"
    "blog/gaddisms.jl"
]

for file in tobe
    f = joinpath(@__DIR__, "src", file)
    Literate.markdown(f, dirname(f); credit = false)
    # Literate.notebook(f, dirname(f))
    # Literate.script(f, dirname(f);name = f[1:end-3]*"_script")
end

for w in ("light", "dark")
    header = read(joinpath(@__DIR__, "style.scss"), String)
    theme = read(joinpath(@__DIR__, "$(w)defs.scss"), String)
    write(joinpath(@__DIR__, "$(w).scss"), header*"\n"*theme)
end
using DocumenterTools: Themes
Themes.compile(joinpath(@__DIR__, "light.scss"), joinpath(@__DIR__, "src/assets/themes/documenter-light.css"))
Themes.compile(joinpath(@__DIR__, "dark.scss"), joinpath(@__DIR__, "src/assets/themes/documenter-dark.css"))

# %% actually make the docs
PyPlot.ioff()
makedocs(
    modules=[MIDI, MusicVisualizations,
    MusicManipulations, MotifSequenceGenerator],
    sitename= "JuliaMusic",
    authors = "George Datseris.",
    format = Documenter.HTML(
        prettyurls = CI,
        assets = [
            "assets/logo.ico",
            asset("https://fonts.googleapis.com/css?family=Montserrat|Source+Code+Pro&display=swap", class=:css),
            ],
        collapselevel = 2,
        ),
    doctest=false,
    pages = [
        "Introduction" => "index.md",
        "Basic MIDI structures" => "midi/io.md",
        "Notes" => "midi/notes.md",
        "Note Tools" => "mm/notetools.md",
        "Named Note"=>"mm/namednote.md",
        "Quantizing & Humanizing" => "mm/quantizing.md",
        "Music data extraction" => "mm/extraction.md",
        "Visualization" => Any[
            "Plotting notes" => "printplot/noteplotter.md",
            "Printing notes into a score" => "printplot/musescore.md"
            ],
        "Motif sequence" => Any[
            "Motif sequence generator" => "motif/basic.md",
            "Music motifs" => "motif/musicexample.md"
            ],
        "Becoming a better drummer blog" => Any[
            "Ep. 1 - Mixing drum patterns" => "blog/drumpatterns.md",
            "Ep. 2 - Garibaldi inspired dragaddidle" => "blog/garibaldi_dragadiddle.md",
            "Ep. 3 - Gaddisms" => "blog/gaddisms.md",
            ],
        ]
)
PyPlot.close("all")
PyPlot.ion()

if CI
    deploydocs(
        repo = "github.com/JuliaMusic/JuliaMusic_documentation.jl.git",
        target = "build",
        push_preview = true
    )
end
