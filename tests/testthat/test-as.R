

# Example Data ------------------------------------------------------------

### Ex 1
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

snp_tbl1 <- as_snippets_tbl(l1) # To snippelt tbl

l1_again <- as.list.snippets_tbl(snp_tbl1) # Back to list

### Ex 2
l2 <- list(
  hello = list(
    scope = "markdown",
    prefix = "hi",
    body = c("hi, ", "${1:yall}"),
    description = "Say Hi"
  )
)

snp_tbl2 <- as_snippets_tbl(l2) # To snippelt tbl

# List to Snippet Tbl -----------------------------------------------------


test_that("as_snippets_tbl() works", {

  # Check Class
  expect_s3_class(snp_tbl1, c("snippets_tbl", "tbl_df"))
  expect_s3_class(snp_tbl2, c("snippets_tbl", "tbl_df"))
  # Check Column Names
  expect_named(snp_tbl1, c("snippet_name","scope", "prefix", "body", "description"))
  expect_named(snp_tbl2, c("snippet_name","scope", "prefix", "body", "description"))
  # Check Rows
  expect_equal(nrow(snp_tbl1), 2)
  expect_equal(nrow(snp_tbl2), 1)
  # Check Column Types
  expect_type(snp_tbl1$prefix, "list")
  expect_type(snp_tbl1$body, "list")
  expect_type(snp_tbl1$description, "list")


})



# Snippet Tbl to List -----------------------------------------------------


test_that("as.list.snippets_tbl() works", {

  expect_type(l1_again, "list")
  expect_named(l1_again, c("hello", "world"))

  expect_equal(l1, l1_again)

})

