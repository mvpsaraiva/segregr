#' Convert local dissimilarity results to an sf object
#'
#' @param segregation_results a \code{segreg} object returned by
#'     \code{\link{measure_segregation}}.
#' @param bandwidths numeric vector. Optional subset of bandwidths to include.
#'     When empty (default), all bandwidths are returned.
#'
#' @return a spatial sf object with columns \code{id}, \code{bw}, and
#'     \code{dissimilarity}.
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
#' dissimilarity <- dissimilarity_to_sf(segregation)
#'
#' if (requireNamespace("ggplot2", quietly = TRUE)) {
#'   ggplot2::ggplot(data = dissimilarity) +
#'     ggplot2::geom_sf(ggplot2::aes(fill = dissimilarity)) +
#'     ggplot2::scale_fill_distiller(palette = "Spectral")
#' }
dissimilarity_to_sf <- function(segregation_results, bandwidths = c()) {

  result <- segregation_results$areal_units |>
    dplyr::left_join(segregation_results$d, by = c("id")) |>
    dplyr::select(id, bw, dissimilarity = d)

  if (length(bandwidths) != 0) {
    result <- dplyr::filter(result, bw %in% bandwidths)
  }

  return(result)
}
