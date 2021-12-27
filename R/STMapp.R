#' Runs the STMapp using Shiny
#' @export
STMapp <- function() {
  appDir <- system.file("STMapp", package = "STM")
  if (appDir == "") {
    stop("Could not find STMapp directory. Try re-installing `STM` package.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
