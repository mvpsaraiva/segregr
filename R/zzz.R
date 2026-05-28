# nocov start
utils::globalVariables(c(
  # data.table / NSE
  ".", ":=", "%chin%", "set",
  # measure_segregation internals
  "group", "population", "group_proportion_city", "total_population",
  "id", "i.population", "intensity", "proportion", "inv_proportion",
  "partial_I", "bw", "i.group_proportion_city", "proportion_abs_diff",
  "group_proportion_locality", "dm", "population_locality", "d",
  "group_entropy", "h", "e", "population_group_city",
  "population_intensity_locality", "i.intensity",
  "proportion_group_city", "proportion_group_locality",
  "i.proportion_group_city", "i.proportion_group_locality",
  "isolation_exposure", "proportion_group_city_a",
  "proportion_group_locality_b", "group_a", "group_b",
  # output helpers
  "groups", "metric", "value", "isolation", "exposure"
))

#' @importFrom data.table := %between% fifelse %chin% set
NULL

# nocov end
