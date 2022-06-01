
# Validate: Convert List to Snippet Tbl ----------------------------------------------------------------


test_that("validate_as_snippets_tbl.list() works", {

  # Validate List of List
  l1 <- list(1:2, c("a","b"))
  expect_error(validate_as_snippets_tbl.list(c("a", "b")))
  expect_error(validate_as_snippets_tbl.list(l1))
  # Element must has names
  l2 <- list(
    list(
      prefix = "world",
      body = "Welcome to a new world!"
    )
  )
  expect_error(validate_as_snippets_tbl.list(l2))
  # Must has "prefix" and "body"
  l3 <- list(
    world = list(
      scope = "markdown",
      description = "Say Welcome"
    )
  )
  expect_error(validate_as_snippets_tbl.list(l3))

})
