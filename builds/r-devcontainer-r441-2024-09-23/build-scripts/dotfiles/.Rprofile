# Bioconductor mirror
options(BioC_mirror = "https://packagemanager.posit.co/bioconductor/2024-09-23")
options(BIOCONDUCTOR_CONFIG_FILE = "https://packagemanager.posit.co/bioconductor/2024-09-23/config.yaml")

# CRAN mirror
options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/jammy/2024-09-23"))

# For use with VSCode
# Helpful info / inspiration: https://renkun.me/2020/04/14/writing-r-in-vscode-working-with-multiple-r-sessions/

# For tmux inside VS Code, manually set the TERM_PROGRAM variable:
# Sys.setenv(TERM_PROGRAM = "vscode")

# Runs VS Code R extension script and sets plot options
# May have to use httpgd::hgd() before plotting if they don't show up
# automatically. E.g., with Remote SSH hgd() there are settings for
# using a remote URL for httpgd viewer
init_file <- file.path(Sys.getenv(
  if (.Platform$OS.type == "windows") "USERPROFILE" else "HOME"),
  ".vscode-R", "init.R")
if (file.exists(init_file)) {
  source(init_file)
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
rm(init_file)
