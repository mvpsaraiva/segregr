#' Convert global exposure and isolation to tabular form
#'
#' @param segregation_results a \code{segreg} object returned by
#'     \code{\link{measure_segregation}}.
#'
#' @return a data frame with one row per group and one column per group,
#'     where off-diagonal cells are pairwise Exposure indices and diagonal
#'     cells are Isolation indices.
#' @export
#'
#' @examples
#'
#' library(sf)
#' library(segregr)
#'
#' marilia_sf <- st_read(system.file("extdata/marilia_2010.gpkg",
#'                                   package = "segregr"))
#' segregation <- measure_segregation(marilia_sf)
#' exposure_isolation_matrix(segregation)
exposure_isolation_matrix <- function(segregation_results) {
  bw_val <- segregation_results$bandwidth[[1]]
  P <- segregation_results$P[segregation_results$P$bw == bw_val, ]
  Q <- segregation_results$Q[segregation_results$Q$bw == bw_val, ]

  iso_exp <- rbind(
    Q |> dplyr::select(group_a = group, group_b = group, iso_exp = isolation),
    P |> dplyr::select(group_a, group_b, iso_exp = exposure)
  )

  return(
    iso_exp |>
      tidyr::pivot_wider(names_from = group_b, values_from = iso_exp) |>
      dplyr::rename(group = group_a)
  )
}
