conda_lib <- Sys.getenv("R_LIBS_USER")
if (nzchar(conda_lib)) {
  .libPaths(conda_lib)
} else {
  user <- Sys.getenv("USER")
  .libPaths(paste0("/home/", user, "/miniconda3/envs/ganga/lib/R/library"))
}
cat("Using library path:", .libPaths(), "\n")

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

# Check which packages are missing
missing_bioc <- bioc_packages[!bioc_packages %in% rownames(installed.packages())]

# Install all missing packages at once in the Conda env library
if (length(missing_bioc) > 0) {
  BiocManager::install(
    missing_bioc,
    version = "3.18",
    ask = FALSE,
    update = FALSE,
    lib = .libPaths()[1]  # ensures installation in the correct library
  )
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
  "miniUI", "brew", "colorspace", "cpp11", "credentials",
  "diffobj", "generics", "ggsci",	"gtable", "hms", "htmlwidgets", "mgcv",	"munsell", "nlme",
  "pheatmap", "pillar",	"praise", "progress", "promises", "Rcpp", "roxygen2", "rprojroot",
  "rversions", "sourcetools", "stringi", "tidyselect", "tzdb", "urlchecker", "viridisLite",	
  "waldo", "xfun", "xtable"

)


# Install CRAN packages only if missing
for (pkg in cran_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}

# ------------------ Install TinyTeX ------------------ #
suppressPackageStartupMessages({
  if (!requireNamespace("tinytex", quietly = TRUE)) {
    install.packages("tinytex", repos = "https://cloud.r-project.org")
  }
  library(tinytex)
})

# Single, robust rule:
# - If pdflatex exists (system TeX Live from apt), do NOT install TinyTeX
# - If not found, install TinyTeX (useful for non-Ubuntu cases)
if (nzchar(Sys.which("pdflatex"))) {
  message("System LaTeX found (pdflatex). Skipping TinyTeX installation.")
} else {
  message("No system LaTeX found. Installing TinyTeX for this user...")
  tinytex::install_tinytex(force = TRUE)
}


# ------------------ Done ------------------ #
message("✅ All R and Bioconductor packages installed successfully.")
