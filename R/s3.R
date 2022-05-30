#' New `snippets_tbl` class
#'
#' @param x a tibble
#'
#' @return a `snippets_tbl` tibble
#' @noRd
new_snippets_tbl <- function(x = tibble::tibble()) {

  stopifnot(inherits(x, "tbl_df"))
  if(inherits(x, "snippets_tbl")) return(x) # Already Has Class

  class(x) <- c("snippets_tbl", class(x))
  x
}
