

test_that("read_vscode_snippets() works", {

  # Error: Invalid File
  expect_error(read_vscode_snippets("hello"))

  path_vs <- snipper::snipper_example("vscode", return_path = T)
  snp_tbl <- read_vscode_snippets(path_vs)

  # Check Class
  expect_s3_class(snp_tbl, c("snippets_tbl", "tbl_df"))

})
