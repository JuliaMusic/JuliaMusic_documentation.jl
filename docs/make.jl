using Documenter, JuliaMusic_documentation

makedocs(modules=[JuliaMusic_documentation], doctest=false)

deploydocs(
    deps   = Deps.pip("Tornado>=4.0.0,<5.0.0", "mkdocs",
    "mkdocs-material" ,"python-markdown-math", "pygments", "pymdown-extensions"),
    repo   = "github.com/JuliaMusic/JuliaMusic_documentation.jl.git",
    julia  = "0.6",
    osname = "linux"
)
