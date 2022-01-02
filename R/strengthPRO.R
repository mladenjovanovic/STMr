#' Runs the strengthPRO using Shiny
#' @export
strengthPRO <- function() {
  appDir <- system.file("strengthPRO", package = "STM")
  if (appDir == "") {
    stop("Could not find strengthPRO directory. Try re-installing `STM` package.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
