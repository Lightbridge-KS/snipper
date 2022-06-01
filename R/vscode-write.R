
#' Write Visual Studio Code Snippet
#'
#' Write VS Code snippet to a file.
#'
#' @param snp (snippets_tbl) A snippet tibble to write to disk.
#' @param file Snippet file to write to. If provided only file name, file extension will be appended from `ext`.
#' @param ext File extension to append to `file`. The default is `.code-snippets` (Multi-language, user-defined snippets).
#' @param overwrite Whether to overwrite the existing file.
#'
#' @return An "json" object (invisibly)
#' @export
#' @seealso
#' [VS Code Snippets](https://code.visualstudio.com/docs/editor/userdefinedsnippets#_create-your-own-snippets)
#'
#' @examples
#' .old_wd <- setwd(tempdir())
#'
#' snip_tbl <- list(
#'  hello = list(
#'    scope = "markdown",
#'    prefix = "hello",
#'    body = c("hello, there", "$0"),
#'    description = "Say Hello"
#'   )
#' ) %>%
#'  as_snippets_tbl()
#'
#' write_snip_vscode(snip_tbl, "hello")
#'
#' setwd(.old_wd)
#'
write_snip_vscode <- function(snp,
                              file,
                              ext = "code-snippets",
                              overwrite = FALSE
) {


  file_ext <- fs::path_ext(file)
  if(file_ext == ""){
    # Not provided extension
    file <- fs::path(file, ext = ext)
  }

  validate_write_file(file, overwrite)

  json <- show_snip_vscode(snp)
  writeLines(json, file)

  cli::cli_alert_success("Write VS code snippet file at {.file {file}}")
  return(invisible(json))

}

# Show --------------------------------------------------------------------


#' Show Visual Studio Code Snippet
#'
#' Show VS Code snippet as JSON.
#'
#' @param snp (snippets_tbl) A snippet tibble
#'
#' @return An "json" object
#' @export
#'
#' @examples
#' list(
#'  hello = list(
#'    scope = "markdown",
#'    prefix = "hello",
#'    body = c("hello, there", "$0"),
#'    description = "Say Hello"
#'    )
#'  ) %>%
#'  as_snippets_tbl() %>%
#'  show_snip_vscode()
show_snip_vscode <- function(snp) {

  ls <- as.list.snippets_tbl(snp)
  jsonlite::toJSON(ls, pretty = TRUE, auto_unbox = TRUE)

}
