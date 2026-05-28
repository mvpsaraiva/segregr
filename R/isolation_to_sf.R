#' Convert local isolation results to an sf object
#'
#' @param segregation_results a \code{segreg} object returned by
#'     \code{\link{measure_segregation}}.
#'
#' @return a spatial sf object with columns \code{id}, \code{bw},
#'     \code{group}, and \code{isolation}.
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
#' isolation <- isolation_to_sf(segregation)
#'
#' if (requireNamespace("ggplot2", quietly = TRUE)) {
#'   ggplot2::ggplot(data = isolation) +
#'     ggplot2::geom_sf(ggplot2::aes(fill = isolation)) +
#'     ggplot2::scale_fill_distiller(palette = "Spectral") +
#'     ggplot2::facet_wrap(~group) +
#'     ggplot2::theme_void()
#' }
isolation_to_sf <- function(segregation_results) {
  return(
    segregation_results$areal_units |>
      dplyr::select(id) |>
      dplyr::left_join(segregation_results$q, by = c("id"))
  )
}
