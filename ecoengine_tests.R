## Source ecoengine R scripts (so I can make modifications)
(ecoengine_scripts <- list.files(path="/GitHub/ecoengine/ecoengine-master/R/", pattern=".R$", full.names=TRUE))
invisible(sapply(ecoengine_scripts, source))

## Load dependent packages required by ecoengine
pkgs_ee <- c("magrittr", "data.table", "httr", "plyr", "assertthat", "dplyr", "whisker", "jsonlite", "lubridate")
(pkgs_missing <- pkgs_req[!sapply(pkgs_req, function(p) require(p, character.only=T))])
if (length(pkgs_missing)) install.packages(pkgs_missing, dependencies=TRUE)

Artemisia <- ee_observations(scientific_name = "Artemisia douglasiana")
