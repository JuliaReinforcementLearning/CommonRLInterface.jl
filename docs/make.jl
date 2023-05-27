using CommonRLInterface
using Documenter

makedocs(;
    modules=[CommonRLInterface],
    authors="Zachary Sunberg <sunbergzach@gmail.com> and contributors",
    repo="https://github.com/JuliaReinforcementLearning/CommonRLInterface.jl/blob/{commit}{path}#L{line}",
    sitename="CommonRLInterface.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JuliaReinforcementLearning.github.io/CommonRLInterface.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "required.md",
        "multiplayer.md",
        "optional.md",
        "interacting.md",
        "wrappers.md",
        "faqs.md"
    ],
)

deploydocs(;
    repo="github.com/JuliaReinforcementLearning/CommonRLInterface.jl",
)
