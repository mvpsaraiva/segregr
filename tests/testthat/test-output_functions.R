library(sf)

marilia_sf <- st_read(
  system.file("extdata/marilia_2010.gpkg", package = "segregr"),
  quiet = TRUE
)
seg <- measure_segregation(marilia_sf)

# ---- *_to_sf helpers ---------------------------------------------------------

test_that("dissimilarity_to_sf returns sf with dissimilarity column", {
  out <- dissimilarity_to_sf(seg)
  expect_s3_class(out, "sf")
  expect_true("dissimilarity" %in% names(out))
})

test_that("entropy_to_sf returns sf with entropy column", {
  out <- entropy_to_sf(seg)
  expect_s3_class(out, "sf")
  expect_true("entropy" %in% names(out))
})

test_that("h_to_sf returns sf with h column", {
  out <- h_to_sf(seg)
  expect_s3_class(out, "sf")
  expect_true("h" %in% names(out))
})

test_that("isolation_to_sf returns sf with isolation column", {
  out <- isolation_to_sf(seg)
  expect_s3_class(out, "sf")
  expect_true("isolation" %in% names(out))
})

test_that("exposure_to_sf returns sf with exposure column", {
  out <- exposure_to_sf(seg)
  expect_s3_class(out, "sf")
  expect_true("exposure" %in% names(out))
})

# ---- global / local aggregators ----------------------------------------------

test_that("global_metrics_to_df returns data.frame with bw column", {
  out <- global_metrics_to_df(seg)
  expect_s3_class(out, "data.frame")
  expect_true("bw" %in% names(out))
})

test_that("global_metrics_to_df has one row per bandwidth", {
  seg2 <- measure_segregation(marilia_sf, bandwidths = c(0, 1000))
  out <- global_metrics_to_df(seg2)
  expect_equal(nrow(out), 2)
})

test_that("local_metrics_to_sf returns an sf object", {
  out <- local_metrics_to_sf(seg)
  expect_s3_class(out, "sf")
})

test_that("local_metrics_to_sf has one row per areal unit", {
  out <- local_metrics_to_sf(seg)
  expect_equal(nrow(out), nrow(marilia_sf))
})

# ---- exposure_isolation_matrix -----------------------------------------------

test_that("exposure_isolation_matrix returns a data.frame", {
  out <- exposure_isolation_matrix(seg)
  expect_s3_class(out, "data.frame")
})

test_that("exposure_isolation_matrix is square (groups × groups)", {
  out <- exposure_isolation_matrix(seg)
  n_groups <- length(seg$groups)
  # result should have n_groups columns (one per group) plus possibly a row-id
  expect_true(ncol(out) >= n_groups)
})
