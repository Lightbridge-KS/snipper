

# Read VS Code Snippets (Wrapper) -----------------------------------------


#' Read Visual Studio Code Snippets files
#'
#' @description
#' Read [VS code snippets](https://code.visualstudio.com/docs/editor/userdefinedsnippets#_snippet-syntax) into a tibble.
#'
#' @details
#' This function read VS code snippets from a JSON format into a tibble, each rows corresponding to each snippets.
#'
#' @param paths Path to VS code snippet files or directory containing those files.
#' @param recurse If `paths` contain directory, `recurse = TRUE` recurse into directory fully, if a positive number the number of levels to recurse.
#' @param regexp A regular expression passed on to `grep()` to filter paths. The default is to search *user-defined snippets* with suffix `.code-snippets` (Multi-language) or `.json` (language-specific)
#' @param ... passed to `fs::dir_ls()`
#'
#' @return A tibble with subclass "snippets_tbl" containing 6 columns, as per [VS code snippet syntax](https://code.visualstudio.com/docs/editor/userdefinedsnippets#_snippet-syntax):
#' * \strong{`file_name`:} snippet file names
#' * \strong{`snippet_name`:} names of each snippets
#' * \strong{`scope`:} scope property that takes one or more [language identifiers](https://code.visualstudio.com/docs/languages/identifiers), which makes the snippet available only for those specified languages.
#' * \strong{`prefix`:} one or more trigger words that display the snippet in IntelliSense.
#' * \strong{`body`:} one or more lines of content, which will be joined as multiple lines upon insertion.
#' * \strong{`description`:} an optional description of the snippet displayed by IntelliSense.
#' @export
#'
#' @examples
#' path_vs_meet <- snipper::snipper_example("vscode/meet.code-snippets")
#' read_vscode_snippets(path_vs_meet)
read_vscode_snippets <- function(paths,
                                 recurse = FALSE,
                                 regexp = "\\.(code-snippets)|(json)$",
                                 ...
) {

  if(!all(fs::file_exists(paths))) cli::cli_abort("{.code paths} must point to files or directory.", call. = F)
  # Get File Paths
  is_files <- fs::is_file(paths)
  files_chr <- names(is_files[is_files])
  # Get Dir Paths
  is_dir <- fs::is_dir(paths)
  dir_chr <- names(is_dir[is_dir])
  # Combine to Absolute file paths
  dir_files <- fs::dir_ls(dir_chr, recurse = recurse, regexp = regexp, ...)
  abs_paths <- c(files_chr, dir_files)

  tbl <- read_vscode_snippets_files(abs_paths)
  # Add "snippets_tbl" subclass
  new_snippets_tbl(tbl)
}



# Read Multiple Files -----------------------------------------------------



#' Read VS Code Snippets form A Multiple file paths
#'
#' @param files multiple file paths
#'
#' @return a tibble with column: `file_name` added
#' @noRd
#'
read_vscode_snippets_files <- function(files) {

  # Validate All `files` must be files
  stopifnot(all(fs::is_file(files)))

  file_names <- fs::path_file(files)
  names(files) <- file_names

  purrr::map_dfr(files, ~as_snippets_tbl(jsonlite::fromJSON(.x)),
                 .id = "file_name")

}

