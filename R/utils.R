

#' Unique if all element is the same
#'
#' @noRd
#' @examples
#'
#' unique_if_all_same(c(1, 1, 1))
#' unique_if_all_same(c(1, 1, 2))
unique_if_all_same <- function(x) {

  xu <- unique(x)
  if(length(xu) == 1L) {
    xu
  } else {
    x
  }

}

#' Is only one value duplicated
#'
#'
#' @noRd
#' @examples
#' is_one_val_rep(c(1))
#' is_one_val_rep(c(1, 1))
#' is_one_val_rep(c(1, 2))
#' is_one_val_rep(c(1, 1, 2))
is_one_val_rep <- function(x) {

  if(length(x) > 1L && length(unique(x)) == 1L) TRUE else FALSE

}
