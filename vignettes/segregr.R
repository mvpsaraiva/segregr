## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 4
)


## ----eval = FALSE-------------------------------------------------------------
# # Install from GitHub
# devtools::install_github("mvpsaraiva/segregr")


## ----setup--------------------------------------------------------------------
library(sf)
library(segregr)

marilia_sf <- st_read(
  system.file("extdata/marilia_2010.gpkg", package = "segregr"),
  quiet = TRUE
)

head(marilia_sf)


## ----aspatial-----------------------------------------------------------------
seg <- measure_segregation(marilia_sf)


## ----global-d-h---------------------------------------------------------------
# Global Dissimilarity index (one row per bandwidth)
seg$D

# Global Entropy
seg$E

# Global Information Theory index H
seg$H


## ----global-matrix------------------------------------------------------------
exposure_isolation_matrix(seg)


## ----global-df----------------------------------------------------------------
global_metrics_to_df(seg)


## ----local-dissimilarity------------------------------------------------------
d_sf <- dissimilarity_to_sf(seg)
head(d_sf[, c("id", "bw", "dissimilarity")])


## ----local-entropy------------------------------------------------------------
e_sf <- entropy_to_sf(seg)
head(e_sf[, c("id", "bw", "entropy")])


## ----local-h------------------------------------------------------------------
h_sf <- h_to_sf(seg)
head(h_sf[, c("id", "bw", "h")])


## ----local-isolation----------------------------------------------------------
q_sf <- isolation_to_sf(seg)
head(q_sf[, c("id", "bw", "group", "isolation")])


## ----local-exposure-----------------------------------------------------------
p_sf <- exposure_to_sf(seg)
head(p_sf[, c("id", "bw", "group_a", "group_b", "exposure")])


## ----local-all----------------------------------------------------------------
local_sf <- local_metrics_to_sf(seg)
names(local_sf)


## ----spatial------------------------------------------------------------------
seg_spatial <- measure_segregation(marilia_sf, bandwidths = c(0, 500, 1000, 2000))

# Global D at each spatial scale
seg_spatial$D


## ----spatial-global-df--------------------------------------------------------
global_metrics_to_df(seg_spatial)


## ----maps, eval = requireNamespace("ggplot2", quietly = TRUE)-----------------
library(ggplot2)

d_spatial <- dissimilarity_to_sf(seg_spatial, bandwidths = c(0, 1000))

ggplot(d_spatial) +
  geom_sf(aes(fill = dissimilarity), colour = NA) +
  scale_fill_distiller(palette = "Spectral") +
  facet_wrap(~bw, labeller = label_both) +
  theme_void() +
  labs(title = "Local Dissimilarity index — Marília (2010)",
       fill = "d")


## ----maps-h, eval = requireNamespace("ggplot2", quietly = TRUE)---------------
h_spatial <- h_to_sf(seg_spatial, bandwidths = c(0, 1000))

ggplot(h_spatial) +
  geom_sf(aes(fill = h), colour = NA) +
  scale_fill_distiller(palette = "RdYlGn") +
  facet_wrap(~bw, labeller = label_both) +
  theme_void() +
  labs(title = "Local H index — Marília (2010)", fill = "h")


## ----step---------------------------------------------------------------------
seg_step <- measure_segregation(marilia_sf, bandwidths = 1000,
                                weight_function = "step")
seg_step$D


## ----session------------------------------------------------------------------
sessionInfo()

