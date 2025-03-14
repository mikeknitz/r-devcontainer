# Mirrors
options(
  repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/noble/2025-03-11"),
  BioC_mirror = "https://packagemanager.posit.co/bioconductor/__linux__/noble/2025-03-11",
  BIOCONDUCTOR_CONFIG_FILE = "https://packagemanager.posit.co/bioconductor/2025-03-11/config.yaml"
)
Sys.setenv("R_BIOC_VERSION" = "3.20")

# If need source installs use:
  # https://packagemanager.posit.co/cran/2025-03-11
  # https://packagemanager.posit.co/bioconductor/2025-03-11

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
