#' Get path to snipper example
#'
#' snipper comes bundled with a number of sample files in its `inst/extdata`
#' directory. This function make them easy to access
#'
#' @param path Path to file or folder relative to `inst/extdata`.If `NULL` or `path` is a folder, list the file contents.
#' If it is a file, return absolute file path.
#' @param return_path If `TRUE`, force to return absolute path of file or folder of `path`.
#'
#' @return A Character vector of list files or absolute path
#' @export
#' @examples
#' library(snipper)
#' # List Example Directory
#' snipper_example()
#' # Path of VS Code Snippet folder: `inst/extdata/vscode`
#' snipper_example("vscode", return_path = TRUE)
#' # Path of VS Code Snippet file
#' snipper_example("vscode/meet.code-snippets")
snipper_example <- function(path = NULL, return_path = FALSE) {

  if(is.null(path)) {

    path_extdata <- system.file("extdata", package = "snipper")

    if(return_path) {
      return(path_extdata)
    } else {
      return(dir(path_extdata))
    }
  }

  path_real <- system.file("extdata", path, package = "snipper", mustWork = TRUE)

  if(return_path) return(path_real)

  if (dir.exists(path_real)) {

    dir(path_real)

  } else {

    path_real

  }
}
