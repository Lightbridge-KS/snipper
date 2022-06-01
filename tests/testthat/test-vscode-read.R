

test_that("read_snip_vscode() works", {

  # Error: Invalid File
  expect_error(read_snip_vscode("hello"))

  path_vs <- snipper::snipper_example("vscode", return_path = T)
  snp_tbl <- read_snip_vscode(path_vs)

  # Check Class
  expect_s3_class(snp_tbl, c("snippets_tbl", "tbl_df"))

})
