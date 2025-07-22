# Set CRAN repo
options(repos = c(CRAN = "https://cloud.r-project.org"))

# ------------------ Bioconductor Packages ------------------ #
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

# Required Bioconductor packages
bioc_packages <- c(
  "Biostrings", "BiocGenerics", "ComplexHeatmap", "circlize", "GenomeInfoDb", "GenomeInfoDbData",
  "IRanges", "S4Vectors", "XVector", "zlibbioc"
)

# Install missing Bioconductor packages
for (pkg in bioc_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    BiocManager::install(pkg, ask = FALSE, update = TRUE)
  }
}

# ---------------------- CRAN Packages ---------------------- #
# Set CRAN repo
options(repos = c(CRAN = "https://cloud.r-project.org"))

cran_packages <- c(
  "xfun", "dplyr", "tibble", "ggplot2", "readr", "fastqcr", "knitr",
  "rmarkdown", "kableExtra", "stringr", "systemfonts", "scales",
  "xml2", "vctrs", "withr", "yaml", "data.table", "rvest", "jsonlite",
  "grid", "gridExtra", "textshaping", "devtools", "png", "tidyr",
  "purrr", "httpuv", "httr", "httr2", "curl", "gert", "labeling",
  "magrittr", "openssl", "prettyunits", "sessioninfo", "fansi",
  "RColorBrewer", "fansi", "svglite", "ragg", "later", "lattice",
  "ini", "selectr", "usethis", "pkgdown", "pkgbuild", "pkgload",
  "remotes", "desc", "commonmark", "clipr", "whisker", "downlit",
  "pkgconfig", "rlang", "rstudioapi", "utf8", "bit", "bit64", "brio",
  "rcmdcheck", "testthat", "crayon", "zip", "vroom", "isoband",
  "gh", "gitcreds", "askpass", "sys", "xopen", "profvis", "shiny",
  "miniUI", "BiocVersion", "brew", "colorspace", "cpp11", "credentials",
  "diffobj", "generics",	"gtable", "hms", "htmlwidgets", "mgcv",	"munsell", "nlme",
  "pheatmap", "pillar",	"praise", "progress", "promises", "Rcpp", "roxygen2", "rprojroot",
  "rversions", "sourcetools", "stringi", "tidyselect", "tzdb", "urlchecker", "viridisLite",	
  "waldo", "xtable"

)


# Install CRAN packages only if missing
for (pkg in cran_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}

# ------------------ Install TinyTeX ------------------ #
if (!requireNamespace("tinytex", quietly = TRUE))
  install.packages("tinytex")

if (!tinytex::is_tinytex()) {
  message("TinyTeX or LaTeX not found. Installing TinyTeX...")
  tinytex::install_tinytex()
} else {
  message("LaTeX is already installed. Skipping installation.")
}



# ------------------ Done ------------------ #
message("✅ All R and Bioconductor packages installed successfully.")
