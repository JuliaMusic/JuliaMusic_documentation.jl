using JuliaMusic_documentation

using Documenter, Literate
#%% Literate Conversions

docdir = @__DIR__
docdir *= "/src/"

# all files in `tobe` will be converted
tobe = [
"printplot/musescore.jl"
"motif/musicexample.jl"
]

for file in tobe
    f = docdir*file
    Literate.markdown(f, dirname(f); credit = false)
    # Literate.notebook(f, dirname(f))
    # Literate.script(f, dirname(f);name = f[1:end-3]*"_script")
end

makedocs(modules=[JuliaMusic_documentation], doctest=false)

#%% Deploy

deploydocs(
    deps   = Deps.pip("mkdocs-material", "mkdocs",
    "python-markdown-math", "pygments", "pymdown-extensions"),
    repo   = "github.com/JuliaMusic/JuliaMusic_documentation.jl.git",
    julia  = "nightly",
    osname = "linux"
)
