

# Generic: Convert to Snippet Tibble -----------------------------------------------------------------


#' Convert List or Data Frame to Snippet Tibble
#'
#' @describeIn Generic function to convert list or data frame to a snippets tibble.
#'
#' @details
#' **List Input**
#'
#' If the input is a list, each sub-list will map to each snippets.
#' Names of sub-list will convert to \strong{`snippet_name`}, and the named value in the sub-list
#' are "snippet fields" (`scope`, `prefix`, `body`, `description`) as described below.
#'
#' @details
#' **Data Frame Input**
#'
#' If the input is a data frame, **row-wise mapping** to snippets will be performed.
#' The data frame must has columns names: `snippet_name`, `scope`, `prefix`, `body`, and `description` as "snippet fields".
#'
#' @details
#' **Snippet fields**
#'
#' * \strong{`snippet_name`:} name of snippet
#' * \strong{`scope`:} scope property that takes one or more [language identifiers](https://code.visualstudio.com/docs/languages/identifiers), which makes the snippet available only for those specified languages.
#' * \strong{`prefix`:} one or more trigger words that display the snippet in IntelliSense.
#' * \strong{`body`:} one or more lines of content, which will be joined as multiple lines upon insertion.
#' * \strong{`description`:} an optional description of the snippet displayed by IntelliSense.
#'
#' @param x A `list` or `data.frame` to be convert to a snippets tibble (see details and examples)
#'
#' @return A tibble with subclass "snippets_tbl" containing 6 columns, based on [VS code snippet syntax](https://code.visualstudio.com/docs/editor/userdefinedsnippets#_snippet-syntax)
#' @export
#'
#' @examples
#' # List Input
#'
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
#'
#' as_snippets_tbl(ls_ex)
#'
#' # Data Frame Input
#'
#' tbl_ex <- tibble::tibble(
#'   snippet_name = c(rep("hello", 2), rep("world", 2)),
#'   scope = "markdown",
#'   prefix = snippet_name,
#'   body = c("hello", "how are you", "Welcome !", "To a new world!"),
#'   description = NA
#' )
#' tbl_ex
#'
#' ## Body of each snippets will expand 2 lines.
#' as_snippets_tbl(tbl_ex)
as_snippets_tbl <- function(x) {

  UseMethod("as_snippets_tbl")

}


# Method: List -------------------------------------------------------------

#' @export
as_snippets_tbl.list <- function(x) {

  # Validate
  validate_snippets_list(x)

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


# Method: Data Frame ------------------------------------------------------

#' @export
as_snippets_tbl.data.frame <- function(x) {

  colnms <- c("snippet_name", "scope", "prefix", "body", "description")
  # Validate that must have at least these 5 column names
  validate_snippets_tbl_colnms(x)
  # Flatten
  tbl_flat <- x %>%
    # Select 5 columns
    dplyr::select(dplyr::all_of(colnms)) %>%
    # Unnest list columns (not effect non-list column)
    tidyr::unnest(c(prefix, body, description))

  # Packing
  ## Group by snippet_name` and `scope`
  tbl_grp <- tbl_flat %>% dplyr::group_by(snippet_name, scope)

  ## Check One-value Duplicate At Body and Warn
  tbl_grp_mod <- tbl_grp %>%
    dplyr::mutate(is_body_dubs = is_one_val_rep(body))

  is_body_dubs_all <- any(tbl_grp_mod[["is_body_dubs"]])
  dup_value_in_body <- unique(dplyr::filter(tbl_grp_mod, is_body_dubs)[["body"]])

  if(is_body_dubs_all) {
    cli::cli_alert_warning("Found repeating one value in {.field body}, I will choose only one of {.val {dup_value_in_body}}.")
  }

  ## Summarized
  tbl_uniq_name  <- tbl_grp %>%
    dplyr::summarise(
      dplyr::across(
        c(prefix, body, description), ~list(unique_if_all_same(.x))),
      .groups = "drop"
    )

  tbl <- tbl_uniq_name %>%
    # Set Names of elemental rows
    purrr::modify(~stats::setNames(.x, tbl_uniq_name[["snippet_name"]]))

  # Add Class
  new_snippets_tbl(tbl)

}



# Convert: Snippet tbl -> List --------------------------------------------



#' List Conversion from Snippet Tibble
#'
#' S3 method for convert "snippets_tbl" object to list
#'
#'
#' @param x "snippets_tbl" object to convert
#' @param ... For compatibility, not in use
#'
#' @return A List
#' @export
#'
#' @examples
#' path_vs_r <- snipper::snipper_example("vscode/r.code-snippets")
#'
#' l <- as.list(read_snip_vscode(path_vs_r))
#' str(l)
as.list.snippets_tbl <- function(x, ...) {

  colnms <- c("snippet_name", "scope", "prefix", "body", "description")
  # Validate Column Names
  validate_snippets_tbl_colnms(x)
  # Check Duplicated Values
  if(any(duplicated(x[["snippet_name"]]))) cli::cli_abort("{.code snippet_name} must not have duplicated values.")


  ls_tp <- x %>%
    # Select 5 columns
    dplyr::select(dplyr::all_of(colnms[-1])) %>%
    # Set Names of elemental rows
    purrr::modify(~stats::setNames(.x, x[["snippet_name"]])) %>%
    # To list & Transpose
    as.list.data.frame() %>%
    purrr::transpose()

  # Remove `NA`
  lv1_has_na_lgl <- ls_tp %>% purrr::map_lgl(~any(is.na(.x)))
  if (!any(lv1_has_na_lgl)) {
    # No any `NA`
    ls_tp
  } else {
    # Has any `NA`
    ## Remove sub-list that has `NA`
    for (i in names(which(lv1_has_na_lgl))) {

      lv2_has_na_lgl <- is.na(ls_tp[[i]])

      for (j in names(which(lv2_has_na_lgl))) {

        ls_tp[[i]][j] <- NULL

      }
    }
    ls_tp
  }

}
