#' Convert local exposure results to an sf object
#'
#' @param segregation_results a \code{segreg} object returned by
#'     \code{\link{measure_segregation}}.
#'
#' @return a spatial sf object with columns \code{id}, \code{bw},
#'     \code{group_a}, \code{group_b}, and \code{exposure}.
#'
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
#' exposure <- exposure_to_sf(segregation)
#'
#' if (requireNamespace("ggplot2", quietly = TRUE)) {
#'   ggplot2::ggplot(data = exposure) +
#'     ggplot2::geom_sf(ggplot2::aes(fill = exposure), color = NA) +
#'     ggplot2::scale_fill_distiller(palette = "Spectral") +
#'     ggplot2::facet_grid(group_a ~ group_b) +
#'     ggplot2::theme_void()
#' }
exposure_to_sf <- function(segregation_results) {
  return(
    segregation_results$areal_units |>
      dplyr::select(id) |>
      dplyr::inner_join(segregation_results$p, by = c("id"))
  )
}
