# Bioconductor mirror
options(BioC_mirror = "https://packagemanager.posit.co/bioconductor/2024-11-04")
options(BIOCONDUCTOR_CONFIG_FILE = "https://packagemanager.posit.co/bioconductor/2024-11-04/config.yaml")

# CRAN mirror
options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/noble/2024-11-04"))

# For use with VSCode
# Helpful info / inspiration: https://renkun.me/2020/04/14/writing-r-in-vscode-working-with-multiple-r-sessions/

# Runs VS Code R extension script and sets plot options
# May have to use httpgd::hgd() before plotting if they don't show up
# automatically. E.g., with Remote SSH hgd() there are settings for
# using a remote URL for httpgd viewer
if (file.exists(file.path(
  Sys.getenv(if (.Platform$OS.type == "windows") "USERPROFILE" else "HOME"),
  ".vscode-R",
  "init.R"
))) {
  source(file.path(
    Sys.getenv(if (.Platform$OS.type == "windows") "USERPROFILE" else "HOME"),
    ".vscode-R",
    "init.R"
  ))
  options(
    vsc.plot = FALSE,
    vsc.use_httpgd = FALSE,
    httpgd.zoom = 1.39,
    httpgd.bg = "transparent",
    bitmapType = "cairo",
    device = function(...) {
      httpgd::hgd(silent = TRUE)
      .vsc.browser(httpgd::hgd_url(history = FALSE), viewer = "Two")
      # .vsc.browser(httpgd::hgd_url(history = TRUE), viewer = FALSE)
    }
  )
} else {
  options(
    vsc.plot = FALSE,
    vsc.use_httpgd = TRUE,
    httpgd.bg = "transparent"
  )
}
