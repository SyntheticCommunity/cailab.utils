# 计算两个熔解曲线之间的相似性


#' Tibble to wider matrix-like format
#'
#' @param mc object
#' @param column_names_from column names
#' @param column_values_from column values
#'
#' @return a wider tibble
#' @export
mc_tbl2wider = function(mc,
                        column_names_from = "temperature",
                        column_values_from = "derivative") {
  tbl = getData(mc) |>
    tidyr::pivot_wider(names_from = column_names_from, names_prefix = "T", values_from = column_values_from)
  plate = getPlate(mc)
  if (is.data.frame(plate)) tbl = tbl |> dplyr::left_join(plate, by = "well_position")
  return(tbl)
}


mc_pca = function(object, scale){
  if (!inherits(object, "MeltingCurve")) stop("Object is not a MeltingCurve class object.")
  tbl = getData(object) |> mc_tbl2wider()
  mat = as.matrix(tbl |> dplyr::select(dplyr::starts_with("T")))
  rownames(mat) = tbl$well_position
  pca = vegan::rda(mat, scale = scale)
  return(pca)
}

#' @import ggplot2
plot_pca = function(object, scale = FALSE,
                    sample_table = NULL,
                    sample_color = "conc",
                    sample_shape = "label",
                    show_temperature = FALSE,
                    temp_n = 3) {
  pca = mc_pca(object, scale = scale)
  sites = .pca_site_score(pca, site_table = sample_table)
  species = .pca_species_score(pca, temp_n = temp_n)

  p = ggplot()
  if (is.null(sample_table)) {
    p = p + geom_point(data = sites, mapping = aes(x = .data$PC1, y = .data$PC2))
  } else {
    p = p + geom_point(data = sites, mapping = aes(x = .data$PC1, y = .data$PC2, shape = .data[[sample_shape]], color = .data[[sample_color]]))
  }

  if (show_temperature) {
    p = p + geom_segment(data = species,
                         mapping = aes(x = 0, y = 0, xend = .data$PC1, yend = .data$PC2),
                         arrow = arrow(length = unit(0.1,"cm")), show.legend = F) +
      ggrepel::geom_text_repel(mapping = aes(x = .data$PC1, y = .data$PC2, label = .data$temperature),
                               max.overlaps = 30,
                               inherit.aes = FALSE,
                               data = species, show.legend = F)
  }

  return(p)
}

.pca_site_score = function(pca, site_table = NULL) {
  pca.df = vegan::scores(pca, choices = 1:2, display = "all", tidy = TRUE)
  sites = pca.df |> dplyr::filter(.data$score == "sites") |>
    dplyr::select(dplyr::starts_with("PC")) |>
    tibble::rownames_to_column("well_position") |>
    dplyr::as_tibble()
  if (!is.null(site_table)) sites = sites |> dplyr::left_join(site_table, by = "well_position")
  return(sites)
}

.pca_species_score = function(pca, temp_n) {
  pca.df = vegan::scores(pca, choices = 1:2, display = "all", tidy = TRUE)
  species = pca.df |> dplyr::filter(.data$score == "species") |>
    dplyr::select(dplyr::starts_with("PC")) |>
    tibble::rownames_to_column("temperature") |>
    dplyr::as_tibble() |>
    dplyr::rowwise() |>
    dplyr::mutate(distance = .data$PC1 ^ 2 + .data$PC2 ^ 2,
                  quadrant = get_quadrant(.data$PC1, .data$PC2)) |>
    dplyr::ungroup()
  if (is.numeric(temp_n)) species = species |> dplyr::slice_max(.data$distance, n = temp_n, by = "quadrant")
  return(species)
}

# get quadrant of a 2D vector
get_quadrant <- function(x, y) {
  if (x > 0 && y > 0) {
    quadrant <- 1
  } else if (x < 0 && y > 0) {
    quadrant <- 2
  } else if (x < 0 && y < 0) {
    quadrant <- 3
  } else if (x > 0 && y < 0) {
    quadrant <- 4
  } else {
    quadrant <- 0  # 如果在坐标轴上，也可以考虑返回0或NA，根据需要调整
  }
  return(quadrant)
}
