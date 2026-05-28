# segregr 0.1.0

## Initial release

* `measure_segregation()`: calculates aspatial and spatial segregation metrics
  for areal data. Supports Gaussian and step spatial kernels with arbitrary
  bandwidths in metres.
* Global indices returned: Dissimilarity (D), Entropy (E), Information Theory
  index H, pairwise Exposure (P), and Isolation (Q).
* Local (per areal unit) indices returned: d, h (entropy + H), p, q.
* Helper functions to join local results back to sf geometries:
  `dissimilarity_to_sf()`, `entropy_to_sf()`, `h_to_sf()`,
  `exposure_to_sf()`, `isolation_to_sf()`.
* `local_metrics_to_sf()`: combines all local metrics into a single wide sf
  object.
* `global_metrics_to_df()`: collects all global metrics into a single data
  frame, with one row per bandwidth.
* `exposure_isolation_matrix()`: formats global Exposure and Isolation as a
  cross-tabulation matrix.
* Sample dataset: census-tract population by race/colour for Marília, São Paulo
  (Brazil), 2010 Census (`inst/extdata/marilia_2010.gpkg`).
