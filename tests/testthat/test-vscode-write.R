

# Test: Write VS Code File ------------------------------------------------


test_that("write_snip_vscode() works", {

  snip_tbl <- list(
    hello = list(
      scope = "markdown",
      prefix = "hello",
      body = c("hello, there", "$0"),
      description = "Say Hello"
    )
  ) %>%
    as_snippets_tbl()

  tmp_path <- tempfile("Hello_")
  # Write File
  write_snip_vscode(snip_tbl, tmp_path, overwrite = TRUE)
  # Check File Exist
  expect_true(file.exists(paste0(tmp_path, ".code-snippets")))

})
