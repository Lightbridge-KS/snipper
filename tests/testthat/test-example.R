test_that("snipper_example() works", {

  # Check list file
  expect_type(snipper_example(), "character")
  expect_type(snipper_example("vscode"), "character")

  # Check Example file
  expect_true(file.exists(snipper_example("vscode/meet.code-snippets")))

})
