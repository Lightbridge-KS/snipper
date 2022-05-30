#' Convert List to Snippet Tibble
#'
#' @describeIn Convert list to a snippets tibble where each elements of list represent each snippets.
#'
#' @details Names of elements in list will convert to \strong{`snippet_name`}, and each elements
#' are sub-list containing character vectors:
#' * \strong{`scope`:} scope property that takes one or more [language identifiers](https://code.visualstudio.com/docs/languages/identifiers), which makes the snippet available only for those specified languages.
#' * \strong{`prefix`:} one or more trigger words that display the snippet in IntelliSense.
#' * \strong{`body`:} one or more lines of content, which will be joined as multiple lines upon insertion.
#' * \strong{`description`:} an optional description of the snippet displayed by IntelliSense.
#'
#'
#' @param ls A list to be convert to snippets tibble (see @details and @examples)
#'
#' @return A tibble with subclass "snippets_tbl" containing 6 columns, as per [VS code snippet syntax](https://code.visualstudio.com/docs/editor/userdefinedsnippets#_snippet-syntax)
#' @export
#'
#' @examples
#' ls_ex <- list(
#'   hello = list(
#'    scope = "markdown",
#'    prefix = "hello",
#'    body = c("hello, there", "$0"),
#'    description = "Say Hello"
#'   ),
#'   world = list(
#'    prefix = "world",
#'    body = "Welcome to a new world!"
#'   )
#' )
#' as_snippets_tbl(ls_ex)
as_snippets_tbl <- function(ls) {

  # Validate
  as_snippets_tbl_validate(ls)

  # If "scope" is not provided set to `NA`
  scope_ls <- purrr::map(ls, "scope")
  noscope_lgl <- purrr::map_lgl(scope_ls, is.null)
  scope_ls[noscope_lgl] <- NA_character_
  # If "description" is not provided set to `NA`
  desc_ls <- purrr::map(ls, "description")
  nodesc_lgl <- purrr::map_lgl(desc_ls, is.null)
  desc_ls[nodesc_lgl] <- NA_character_

  tbl <- tibble::tibble(
    snippet_name = names(ls),
    scope = as.character(scope_ls), # scope always length 1
    prefix = purrr::map(ls, "prefix"),
    body = purrr::map(ls, "body"),
    description = desc_ls
  )
  # Set Class
  new_snippets_tbl(tbl)

}


# Helper: Validate List ---------------------------------------------------



as_snippets_tbl_validate <- function(ls) {

  # Validate List of List
  if(!(is.list(ls) && purrr::every(ls, is.list))){
    stop("`ls` must be a list containing list of snippets", call. = FALSE)
  }
  # Element must has names
  not_valid_names <- any(is.null(names(ls)), names(ls) == "")
  if(not_valid_names) stop("Elements in `ls` must have names for `snippet_name`.", call. = FALSE)
  # Must has "prefix" and "body"
  has_prefix_n_body <- purrr::every(ls, ~all(c("prefix", "body") %in% names(.x)))
  if(!has_prefix_n_body) stop("Snippets must contain 'prefix' and 'body' fields.", call. = FALSE)

  ls

}
