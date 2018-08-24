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
    deps   = Deps.pip("mkdocs==0.17.5", "mkdocs-material==2.9.4",
    "python-markdown-math", "pygments", "pymdown-extensions"),
    repo   = "github.com/JuliaMusic/JuliaMusic_documentation.jl.git",
    julia  = "1.0",
    osname = "linux"
)
