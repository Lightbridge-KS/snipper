


test_that("as_snippets_tbl() works", {

  l1 <- list(
    hello = list(
      scope = "markdown",
      prefix = "hello",
      body = c("hello, there", "$0"),
      description = "Say Hello"
    ),
    world = list(
      prefix = "world",
      body = "Welcome to a new world!"
    )
  )

  res <- as_snippets_tbl(l1)

  # Check Class
  expect_s3_class(res, c("snippets_tbl", "tbl_df"))
  # Check Column Names
  expect_named(res, c("snippet_name","scope", "prefix", "body", "description"))
  # Check Rows
  expect_equal(nrow(res), 2)
  # Check Column Types
  expect_type(res$prefix, "list")
  expect_type(res$body, "list")
  expect_type(res$description, "list")


})
