using JuliaMusic_documentation

using Pkg
pkg"add Documenter Literate"
pkg"precompile"

using Documenter, Literate

makedocs(modules=[JuliaMusic_documentation], doctest=false)

deploydocs(
    deps   = Deps.pip("Tornado>=4.0.0,<5.0.0", "mkdocs",
    "mkdocs-material" ,"python-markdown-math", "pygments", "pymdown-extensions"),
    repo   = "github.com/JuliaMusic/JuliaMusic_documentation.jl.git",
    julia  = "nightly",
    osname = "linux"
)
