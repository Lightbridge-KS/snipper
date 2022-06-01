

# Generic: Convert to Snippet Tibble -----------------------------------------------------------------


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
#' @param x A list to be convert to snippets tibble (see @details and @examples)
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
as_snippets_tbl <- function(x) {
  UseMethod("as_snippets_tbl")
}


# List Method -------------------------------------------------------------

#' @export
as_snippets_tbl.list <- function(x) {

  # Validate
  validate_as_snippets_tbl.list(x)

  # If "scope" is not provided set to `NA`
  scope_x <- purrr::map(x, "scope")
  noscope_lgl <- purrr::map_lgl(scope_x, is.null)
  scope_x[noscope_lgl] <- NA_character_
  # If "description" is not provided set to `NA`
  desc_x <- purrr::map(x, "description")
  nodesc_lgl <- purrr::map_lgl(desc_x, is.null)
  desc_x[nodesc_lgl] <- NA_character_

  tbl <- tibble::tibble(
    snippet_name = names(x),
    scope = as.character(scope_x), # scope always length 1
    prefix = purrr::map(x, "prefix"),
    body = purrr::map(x, "body"),
    description = desc_x
  )
  # Set Class
  new_snippets_tbl(tbl)

}

