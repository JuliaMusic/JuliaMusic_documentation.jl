using JuliaMusic_documentation
using MIDI, MotifSequenceGenerator, MusicManipulations
using Documenter, Literate
#%% Literate Conversions

docdir = @__DIR__
docdir *= "/src/"

# all files in `tobe` will be converted
tobe = [
"motif/musicexample.jl"
]

for file in tobe
    f = docdir*file
    Literate.markdown(f, dirname(f))
    # Literate.notebook(f, dirname(f))
end

makedocs(modules=[JuliaMusic_documentation], doctest=false)

#%% Deploy

deploydocs(
    deps   = Deps.pip("Tornado>=4.0.0,<5.0.0", "mkdocs",
    "mkdocs-material" ,"python-markdown-math", "pygments", "pymdown-extensions"),
    repo   = "github.com/JuliaMusic/JuliaMusic_documentation.jl.git",
    julia  = "nightly",
    osname = "linux"
)
