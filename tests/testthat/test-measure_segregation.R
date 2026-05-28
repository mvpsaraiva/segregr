library(sf)

marilia_sf <- st_read(
  system.file("extdata/marilia_2010.gpkg", package = "segregr"),
  quiet = TRUE
)

# ---- aspatial (bw = 0) -------------------------------------------------------

test_that("measure_segregation returns a list with expected names", {
  seg <- measure_segregation(marilia_sf)
  expect_type(seg, "list")
  required <- c("areal_units", "groups", "bandwidth",
                "D", "E", "H", "d", "h", "P", "Q", "p", "q")
  expect_true(all(required %in% names(seg)))
})

test_that("global Dissimilarity index is between 0 and 1", {
  seg <- measure_segregation(marilia_sf)
  expect_true(all(seg$D$D >= 0 & seg$D$D <= 1))
})

test_that("global Information Theory index H is between 0 and 1", {
  seg <- measure_segregation(marilia_sf)
  expect_true(all(seg$H$H >= 0 & seg$H$H <= 1))
})

test_that("global Entropy E is positive", {
  seg <- measure_segregation(marilia_sf)
  expect_gt(seg$E, 0)
})

test_that("local dissimilarity has one row per areal unit", {
  seg <- measure_segregation(marilia_sf)
  n_units <- nrow(marilia_sf)
  expect_equal(nrow(seg$d), n_units)
})

test_that("areal_units geometry is preserved in result", {
  seg <- measure_segregation(marilia_sf)
  expect_s3_class(seg$areal_units, "sf")
  expect_equal(nrow(seg$areal_units), nrow(marilia_sf))
})

# ---- spatial (bw > 0) --------------------------------------------------------

test_that("measure_segregation with bandwidth > 0 returns same structure", {
  seg <- measure_segregation(marilia_sf, bandwidths = 1000)
  expect_type(seg, "list")
  expect_true(all(c("D", "H", "d", "h") %in% names(seg)))
})

test_that("D index is between 0 and 1 for bandwidth = 1000", {
  seg <- measure_segregation(marilia_sf, bandwidths = 1000)
  expect_true(all(seg$D$D >= 0 & seg$D$D <= 1))
})

test_that("multiple bandwidths produce one D row per bandwidth", {
  seg <- measure_segregation(marilia_sf, bandwidths = c(0, 500, 1000))
  expect_equal(nrow(seg$D), 3)
})

test_that("step weight_function produces valid D index", {
  seg <- measure_segregation(marilia_sf, bandwidths = 1000,
                             weight_function = "step")
  expect_true(all(seg$D$D >= 0 & seg$D$D <= 1))
})
