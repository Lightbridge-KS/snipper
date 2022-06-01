

#' Validate List Converstion to Snippet Tibble
#'
#' @param x list
#'
#' @return SE: Error Msg (if any)
#' @noRd
validate_as_snippets_tbl.list <- function(x) {

  x_sym <- dplyr::ensym(x)

  # Validate List of List
  if(!(is.list(x) && purrr::every(x, is.list))){
    cli::cli_abort("{.code {x_sym}} must be a list containing list of snippets")
  }
  # Element must has names
  not_valid_names <- any(is.null(names(x)), names(x) == "")
  if(not_valid_names) cli::cli_abort("Elements in {.code {x_sym}} must have names for {.field snippet_name}.")
  # Must has "prefix" and "body"
  has_prefix_n_body <- purrr::every(x, ~all(c("prefix", "body") %in% names(.x)))
  if(!has_prefix_n_body) cli::cli_abort("Snippets must contain {.field prefix} and {.field body} fields.")

  x

}

#' Validate Snippet Tibble Column names
#'
#' @param x snippet tibble
#'
#' @return SE: Error Msg (if any)
#' @noRd
validate_snippets_tbl_colnms <- function(x) {

  colnms <- c("snippet_name", "scope", "prefix", "body", "description")
  x_sym <- dplyr::ensym(x)
  # Validate Colnames
  if(!all(colnms %in% colnames(x))) cli::cli_abort("{.code {x_sym}} Must have column names: {colnms}")
  x
}


#' Validate Write Snippet File
#'
#' @param file path to file
#' @param overwrite whether to overwrite
#'
#' @noRd
validate_write_file <- function(file, overwrite = FALSE) {

  if(!overwrite && fs::file_exists(file)) cli::cli_abort("Snippet file already exist at {.file {file}}, set {.code overwrite = FALSE} to overwrite.")
  file

}
