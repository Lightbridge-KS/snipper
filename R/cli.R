### Everything CLI except Error Msg

#' Helper message when write snippet success
#'
#' @param which which type of snippet
#' @param file file path
#' @noRd
#'
cli_write_snippet_success <- function(which, file) {

  cli::cli_alert_success("Write {which} snippet file at {.file {file}}")

}
