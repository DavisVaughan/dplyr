test_that("can pick columns from the data", {
  df <- tibble(x1 = 1, y = 2, x2 = 3, z = 4)
  out <- mutate(df, sel = pick(z, starts_with("x")))
  expect_identical(out$sel, df[c("z", "x1", "x2")])
})

test_that("works with grouped data frames", {
  fn <- function(x) {
    x[["x"]] + mean(x[["z"]])
  }

  df <- tibble(g = c(1, 1, 2, 2, 2), x = 1:5, y = 6:10, z = 11:15)
  gdf <- group_by(df, g)

  out <- mutate(gdf, res = fn(pick(x, z)))
  expect <- mutate(gdf, res = x + mean(z))

  expect_identical(out, expect)
})

test_that("returns a tibble", {
  df <- data.frame(x = 1)
  out <- mutate(df, y = pick(x))
  expect_s3_class(out$y, "tbl_df")
})

test_that("returns a list-col with `rowwise()` data (#5951, #6264)", {
  # This replaces the `across(.fns = NULL)` behavior on rowwise-dfs
  df <- tibble(x = list(1, 2:3, 4:5), y = 1:3)
  rdf <- rowwise(df)
  out <- mutate(rdf, z = pick(x, y))
  expect_identical(out$z, df)
})

test_that("doesn't select grouping columns", {
  df <- tibble(g = 1, x = 2)
  gdf <- group_by(df, g)

  out <- mutate(gdf, y = pick(everything()))
  expect_named(out$y, "x")

  skip("This should be failing, I don't understand how `g` can be selected?")
  expect_snapshot(error = TRUE, {
    mutate(gdf, y = pick(g))
  })
})

test_that("works with `group_cols()`", {
  skip("Until we can figure this out")

  df <- tibble(g = 1, x = 2)
  out <- mutate(df, y = pick(everything(), -group_cols()))
  expect_named(out$y, "x")
})

test_that("errors correctly outside mutate context", {
  expect_snapshot(error = TRUE, {
    pick()
  })
})

test_that("requires at least one input", {
  expect_snapshot(error = TRUE, {
    mutate(data.frame(), pick())
  })
})

test_that("doesn't allow renaming", {
  expect_snapshot(error = TRUE, {
    mutate(data.frame(x = 1), pick(y = x))
  })
})

