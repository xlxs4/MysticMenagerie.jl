using MysticMenagerie
using Documenter

DocMeta.setdocmeta!(MysticMenagerie, :DocTestSetup, :(using MysticMenagerie);
                    recursive = true)

makedocs(;
         modules = [MysticMenagerie],
         authors = "Orestis Ousoultzoglou <orousoultzoglou@gmail.com> and contributors",
         repo = "https://github.com/xlxs4/MysticMenagerie.jl/blob/{commit}{path}#{line}",
         sitename = "MysticMenagerie.jl",
         format = Documenter.HTML(;
                                  prettyurls = get(ENV, "CI", "false") == "true",
                                  canonical = "https://xlxs4.github.io/MysticMenagerie.jl",
                                  edit_link = "main",
                                  assets = String[]),
         pages = [
             "Home" => "index.md",
         ])

deploydocs(;
           repo = "github.com/xlxs4/MysticMenagerie.jl",
           devbranch = "main")
