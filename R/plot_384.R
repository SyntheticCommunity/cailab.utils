#' Plot 384 well community structure with pie chart
#'
#' @param data a wider data.frame giving the (relative) quantity of each species, the key column is **well_position**
#' @param cols specify the columns, which give the quantity of two or more species
#'
#' @return a ggplot object
#' @export
#'
plot_384_community_structure = function(data, cols = dplyr::starts_with("concentration")){
  p = plot_384(data)
  df = p$data %>%
    tidyr::pivot_longer(cols = cols,
                 names_to = "species",
                 values_to = "quantity")
  p +
    ggforce::geom_arc_bar(aes(x0 = .data$col, y0 = .data$row, r0 = 0, r = 0.4, amount = .data$quantity, fill = .data$species),
                 stat = "pie",
                 data = df,
                 inherit.aes = FALSE)
}


#' Plot 384 well species quantity of a single species
#'
#' @param data definition of 384 plate
#' @param species species name
#' @param trans transformation of species abundance
#' @param palette fill palette
#' @param na.value color of NA values
#'
#' @return a ggplot object
#' @export
plot_384_single_concentration = function(data, species, trans = "log2", palette = "Blues", na.value = "white"){
  p = plot_384(data)
  p = p + ggplot2::aes_string(color = species) +
    ggplot2::geom_point(size = 5) +
    ggplot2::scale_color_distiller(trans = trans,
                          palette = palette,
                          direction = 1,
                          na.value = na.value)
  p
}

#' @import ggplot2
plot_384 = function(data = NULL){
  plate = plate384()
  if (!is.null(data)) plate = plate %>% dplyr::left_join(data)
  ggplot(plate, aes(col, row)) +
    scale_x_continuous(position = "top", breaks = 1:24, limits = c(0, 25), expand = expansion()) +
    scale_y_reverse(label = function(x) LETTERS[x], breaks = 1:16, limits = c(17, 0), expand = expansion()) +
    labs(x = "", y = "") +
    theme_bw() +
    theme(panel.grid.minor = element_blank())
}

plate384 = function(){
  dplyr::tibble(
    row = rep(1:16, each = 24),
    col = rep(1:24, times = 16)
  ) %>%
    dplyr::mutate(well_position = paste0(LETTERS[row], col))
}
