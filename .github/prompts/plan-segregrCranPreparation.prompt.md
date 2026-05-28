# Plan: Prepare `segregr` R Package for CRAN

## TL;DR
The package calculates spatial segregation metrics (Dissimilarity, Entropy/H, Exposure, Isolation) and is functionally complete, but has multiple blockers for CRAN: placeholder Maintainer, missing formal tests, incomplete documentation for 2 functions, unqualified function calls (NAMESPACE violations), ggplot2 used in examples but not declared, and LazyData set with no data/ directory. The plan follows the order recommended in guia_publicacao_cran_pacote_r.md: metadata → documentation → tests → portability/checks.

---

## Audit Findings (Blockers by severity)

### CRITICAL — Will fail R CMD check
1. `Maintainer` is placeholder — correct value: `Marcus Saraiva <marcus.saraiva@gmail.com>`
2. No testthat test files exist (`tests/testthat/` directory doesn't even exist)
3. `global_metrics_to_df`: title is "Title", no description, no @param, no @return, no @examples
4. `local_metrics_to_sf`: title is "Title", @bandwidths empty, @return empty, no @examples
5. `filter()` used unqualified in `dissimilarity_to_sf.R`, `entropy_to_sf.R`, `h_to_sf.R` — not imported from dplyr
6. `st_set_geometry()` called unqualified in `measure_segregation.R` — not imported from sf
7. `ggplot2` used in all exported function examples but NOT in Suggests — examples will fail during check
8. `%>%` used throughout but not importFrom-imported (declared in globalVariables but not actually imported via roxygen)
9. `weight_function` param present in function signature but missing from @params in `measure_segregation.R`

### WARNINGS/NOTES — Will generate check warnings
10. `LazyData: true` in DESCRIPTION but no `data/` directory → NOTE
11. `Version: 0.0.0.9000` — not appropriate for CRAN (should be 0.1.0)
12. `Title: Spatial segregation metrics in R` — not title case ("In" should be lowercase, or rephrase)
13. `Description` starts with "This package" — discouraged
14. `Description` contains markdown `*generalised*` — not valid in DESCRIPTION
15. `@param bandwidths` empty in `entropy_to_sf`, `dissimilarity_to_sf`, `h_to_sf`, `local_metrics_to_sf`
16. `measure_segregation.Rd` shows `bandwidth` in @param but function uses `bandwidths` — mismatch
17. `assign_population()` in helpers is dead code (never called)
18. `.onLoad` uses `requireNamespace()` unnecessarily — should be removed
19. No `NEWS.md` file (strongly recommended)

### RECOMMENDED — Good practices
20. Add vignette showing full workflow
21. Update README.md (outdated example output, no GitHub URL confirmed)
22. Empty `_pkgdown.yml`
23. `exposure_isolation_matrix.Rd` imports ggplot2 but doesn't use it in the example

---

## Decisions (confirmed with user)
- **Pipe**: Migrate all `%>%` → `|>` (native pipe, R ≥ 4.1); remove `magrittr` from Imports; add `Depends: R (>= 4.1.0)` to DESCRIPTION
- **assign_population()**: Keep but comment as "reserved for future use"
- **gla.gpkg**: Remove from `inst/extdata/` — not used in any public example or test
- **Vignette**: Include a basic workflow vignette (`vignettes/segregr.Rmd`); add knitr + rmarkdown to Suggests; add `VignetteBuilder: knitr` to DESCRIPTION

---

## Implementation Plan

### Phase 1 — DESCRIPTION & metadata *(parallel with Phase 2)*
1. Fix `Maintainer`: `Marcus Saraiva <marcus.saraiva@gmail.com>`
2. Change `Version` to `0.1.0`
3. Rewrite `Title` in proper title case (e.g., "Spatial Segregation Metrics for Areal Data")
4. Rewrite `Description`: remove "This package", remove markdown asterisks, use clean prose
5. Remove `LazyData: true` (no data/ directory)
6. Add `Depends: R (>= 4.1.0)` for native pipe support
7. Remove `magrittr` from `Imports`
8. Add `ggplot2`, `knitr`, `rmarkdown` to `Suggests`
9. Add `VignetteBuilder: knitr`

**Files:** `DESCRIPTION`

### Phase 2 — Imports & pipe migration *(parallel with Phase 1)*
1. Migrate all `%>%` → `|>` in all `R/` files
2. Qualify `sf::st_set_geometry()` in `measure_segregation.R` (or add `@importFrom sf st_set_geometry`)
3. Add `@importFrom dplyr filter` in the files that call `filter()` unqualified (`dissimilarity_to_sf.R`, `entropy_to_sf.R`, `h_to_sf.R`)
4. Remove unnecessary `requireNamespace()` calls from `.onLoad` in `zzz.R`
5. Remove `%>%` and `%like%` from `globalVariables()` list in `zzz.R`

**Files:** `R/zzz.R`, `R/measure_segregation.R`, `R/measure_segregation_helpers.R`, `R/dissimilarity_to_sf.R`, `R/entropy_to_sf.R`, `R/h_to_sf.R`, `R/global_metrics_to_df.R`, `R/local_metrics_to_sf.R`, `R/exposure_isolation_matrix.R`, `R/exposure_to_sf.R`, `R/isolation_to_sf.R`

### Phase 3 — Documentation fixes *(depends on Phase 2)*
1. **`global_metrics_to_df.R`**: Write complete title, description, `@param segregation_results`, `@param bandwidths`, `@return`, `@examples`
2. **`local_metrics_to_sf.R`**: Write complete title, description, fill `@param bandwidths`, `@return`, `@examples`
3. **`measure_segregation.R`**: Add `@param weight_function`, fix `@param bandwidth` → `bandwidths`
4. **`entropy_to_sf.R`, `dissimilarity_to_sf.R`, `h_to_sf.R`**: Fill empty `@param bandwidths` descriptions
5. **All examples using ggplot2**: Wrap ggplot2 parts in `if (requireNamespace("ggplot2", quietly = TRUE))` or use `\donttest{}`
6. **`exposure_isolation_matrix.R`**: Remove unused `library("ggplot2")` from example
7. Regenerate `.Rd` files with `roxygen2::roxygenise()`

**Files:** `R/global_metrics_to_df.R`, `R/local_metrics_to_sf.R`, `R/measure_segregation.R`, `R/entropy_to_sf.R`, `R/dissimilarity_to_sf.R`, `R/h_to_sf.R`, `R/exposure_isolation_matrix.R`

### Phase 4 — Tests *(depends on Phase 3)*
1. Create `tests/testthat/test-measure_segregation.R`: test with `marilia_2010.gpkg` data
   - Test with bandwidth = 0 (aspatial): result is a list with named elements D, E, H, d, h, P, Q, p, q
   - Test with bandwidth > 0 (spatial): same structure
   - Test D is between 0 and 1
   - Test H is between 0 and 1
   - Test row count of local results matches input (295 areal units)
2. Create `tests/testthat/test-output_functions.R`: test all "to_sf" and "to_df" functions
   - `dissimilarity_to_sf()` returns an sf object with column `dissimilarity`
   - `entropy_to_sf()` returns an sf with column `entropy`
   - `h_to_sf()` returns an sf with column `h`
   - `isolation_to_sf()` and `exposure_to_sf()` return sf objects
   - `global_metrics_to_df()` returns a data.frame with column `bw`
   - `local_metrics_to_sf()` returns an sf
   - `exposure_isolation_matrix()` returns a data.frame with groups as columns

**Files:** `tests/testthat/test-measure_segregation.R` (new), `tests/testthat/test-output_functions.R` (new)

### Phase 5 — Vignette *(parallel with Phase 4)*
1. Create `vignettes/segregr.Rmd` with a complete workflow:
   - Load `marilia_2010.gpkg` sample data
   - Run `measure_segregation()` with bw = 0 and bw > 0
   - Inspect global results (`D`, `H`, `exposure_isolation_matrix()`, `global_metrics_to_df()`)
   - Visualise local results with ggplot2 (`dissimilarity_to_sf()`, `h_to_sf()`, `entropy_to_sf()`, `isolation_to_sf()`, `exposure_to_sf()`)

**Files:** `vignettes/segregr.Rmd` (new)

### Phase 6 — Limpeza & NEWS *(parallel with Phase 4)*
1. Comment out `assign_population()` in `measure_segregation_helpers.R` with a note: "reserved for future use"
2. Remove `inst/extdata/gla.gpkg`
3. Create `NEWS.md` with initial entry for v0.1.0 listing all implemented metrics
4. Update `README.Rmd`: fix outdated example output (`segregation$D` returns a data.frame, not a scalar); confirm GitHub URL
5. Regenerate `README.md` from `README.Rmd`

**Files:** `R/measure_segregation_helpers.R`, `NEWS.md` (new), `README.Rmd`

### Phase 7 — Verification
1. `roxygen2::roxygenise()` — verify all `.Rd` files regenerated correctly
2. `testthat::test_dir("tests/testthat")` — all tests pass
3. `R CMD build .` — generates tarball
4. `R CMD check --as-cran segregr_0.1.0.tar.gz` — zero errors, zero warnings, justify any NOTEs
5. Submit to win-builder (https://win-builder.r-project.org/) for Windows + R-devel check

---

## Relevant Files
| File | Status / Action needed |
|------|------------------------|
| `DESCRIPTION` | Fix Maintainer, Version, Title, Description, LazyData, Depends, Imports, Suggests |
| `NAMESPACE` | Regenerated by roxygen2; do not edit by hand |
| `R/zzz.R` | Remove requireNamespace(); clean globalVariables(); add any remaining importFrom |
| `R/measure_segregation.R` | Qualify st_set_geometry(); add @param weight_function; fix @param bandwidth→bandwidths; migrate pipe |
| `R/measure_segregation_helpers.R` | Comment assign_population(); migrate pipe |
| `R/global_metrics_to_df.R` | CRITICAL: write complete roxygen docs; migrate pipe |
| `R/local_metrics_to_sf.R` | CRITICAL: write complete roxygen docs; migrate pipe |
| `R/dissimilarity_to_sf.R` | Add @importFrom dplyr filter; fill @param bandwidths; wrap ggplot2 example; migrate pipe |
| `R/entropy_to_sf.R` | Add @importFrom dplyr filter; fill @param bandwidths; wrap ggplot2 example; migrate pipe |
| `R/h_to_sf.R` | Add @importFrom dplyr filter; fill @param bandwidths; wrap ggplot2 example; migrate pipe |
| `R/exposure_isolation_matrix.R` | Remove library("ggplot2") from example; migrate pipe |
| `R/exposure_to_sf.R` | Wrap ggplot2 example; migrate pipe |
| `R/isolation_to_sf.R` | Wrap ggplot2 example; migrate pipe |
| `tests/testthat/test-measure_segregation.R` | Create new |
| `tests/testthat/test-output_functions.R` | Create new |
| `vignettes/segregr.Rmd` | Create new |
| `NEWS.md` | Create new |
| `README.Rmd` | Fix example output |
| `inst/extdata/gla.gpkg` | Remove |
