

test_that("unique_if_all_same() works", {

  v1 <- c(1, 1, 1)
  v2 <- c(1, 1, 2)
  expect_equal(unique_if_all_same(v1), 1)
  expect_equal(unique_if_all_same(v2), v2)

})


test_that("is_one_val_rep() works", {

  expect_false(is_one_val_rep(c(1)))
  expect_true(is_one_val_rep(c(1, 1)))
  expect_false(is_one_val_rep(c(1, 2)))
  expect_false(is_one_val_rep(c(1, 1, 2)))
})
