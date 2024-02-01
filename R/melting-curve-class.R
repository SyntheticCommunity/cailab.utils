#### Class defination ####

#' a S4 class for storing melting curve data
#'
#' @slot experiment_date experiment date
#' @slot plate plate setting
#' @slot primer primer name
#' @slot data curve data
#' @name mc-class
#' @rdname melting-curve
setClass("MeltingCurve",
         slots = list(
           experiment_date = "ANY",
           plate = "ANY",
           primer = "ANY",
           data = "ANY"
           )
)

#' Convert a quantstudio result to MeltingCurve object
#'
#' @param x a quantstudio result file or object
#' @param experiment_date default is `Sys.Date()`
#' @param plate default is "NA"
#' @param primer default is "NA"
#' @param col_data keep necessary columns
#'
#' @return a MeltingCurve object
#' @export
#' @md
#' @rdname melting-curve
quantstudio2mc = function(x,
                          experiment_date = get_quantstudio_run_time(x),
                          plate = NULL,
                          primer = NULL,
                          col_data = c("well_position","temperature","derivative")){
  if (!inherits(x, "QuantStudioRaw")) stop("x is not a valid QuantStudioRaw object")
  melting_curve = get_quantstudio_melting_curve(x)
  object = methods::new("MeltingCurve",
      experiment_date = experiment_date,
      plate = plate,
      primer = primer,
      data = melting_curve[, col_data])
  return(object)
}


####### Accessory methods #######

#' @export
#' @rdname melting-curve
setGeneric("getDate", function(object) standardGeneric("getDate"))

#' @export
#' @rdname melting-curve
setMethod("getDate", "MeltingCurve", function(object) object@experiment_date)

#' @export
#' @rdname melting-curve
setGeneric("getPlate", function(object) standardGeneric("getPlate"))

#' @export
#' @rdname melting-curve
setMethod("getPlate", "MeltingCurve", function(object) object@plate)

#' @export
#' @rdname melting-curve
setGeneric("getPrimer", function(object) standardGeneric("getPrimer"))

#' @export
#' @rdname melting-curve
setMethod("getPrimer", "MeltingCurve", function(object) object@primer)

#' @export
#' @rdname melting-curve
setGeneric("getData", function(object) standardGeneric("getData"))

#' @export
#' @rdname melting-curve
setMethod("getData", "MeltingCurve", function(object) object@data)

#' @export
#' @rdname melting-curve
setGeneric("transformData", function(object, ...) standardGeneric("transformData"))

#' @export
#' @rdname melting-curve
setMethod("transformData", "MeltingCurve", function(object,
                                                    limit = tempRange(object),
                                                    step = 0.03,
                                                    method = "spline") {
  mc_data = getData(object)
  mc_data = curve_resample(mc_data, from = floor(limit[[1]]), to = ceiling(limit[[2]]),
                           by = step, variable = "derivative", method = method)
  object@data = mc_data
  return(object)
})

#' Filter data by temperature and well positions
#'
#' @export
#' @rdname melting-curve
setGeneric("filterData", function(object, from = NULL, to = NULL, well_position = NULL, ...) standardGeneric("filterData"))

#' @export
#' @rdname melting-curve
setMethod("filterData", "MeltingCurve", function(object, from, to, well_position) {
  mc_data = getData(object)
  if (!is.null(from)) mc_data = dplyr::filter(mc_data, .data$temperature >= from)
  if (!is.null(to)) mc_data = dplyr::filter(mc_data, .data$temperature <= to)
  if (!is.null(well_position)) mc_data = dplyr::filter(mc_data, .data$well_position %in% !!well_position)
  object@data = mc_data
  return(object)
})

#' get temperature range
#' @export
#' @rdname melting-curve
#' @method tempRange MeltingCurve
setGeneric("tempRange", function(object, ...) standardGeneric("tempRange"))

#' @export
#' @rdname melting-curve
setMethod("tempRange", "MeltingCurve", function(object, na.rm = TRUE) {
  range(getData(object) |> dplyr::pull("temperature"), na.rm = na.rm)
})

######## Generic function #####

#### show-method

#' Print user-friendly information of object
#'
#' @param object a S4 class object
#' @export
#' @method show MeltingCurve
#' @importFrom methods show slotNames slot
#' @rdname show-method
setMethod("show", c(object = "MeltingCurve"),
          function(object){
            cat("An object of class 'MeltingCurve':\n")
            cat("   Slots: ", paste0(slotNames(object), collapse = ", "), ";\n", sep = "")
          })


####### Functions ######

#' @title Transform a MeltingCurve object to tibble
#'
#' @param x a MeltingCurve object
#' @export
#' @rdname melting-curve
mc2tbl = function(mc){
  if (!inherits(mc, "MeltingCurve")) stop("mc is not a \"MeltingCurve\" object")
  date = getDate(mc); primer = getPrimer(mc); plate = getPlate(mc);
  tbl = getData(mc)
  if (!is.null(date)) tbl = dplyr::mutate(tbl, date = date)
  if (!is.null(primer)) tbl = dplyr::mutate(tbl, primer = primer)
  if (!is.null(plate)) tbl = dplyr::left_join(tbl, plate, by = "well_position")
  tbl = tbl |>
    tidyr::unite(col = "well_position", tidyr::any_of(c("date","primer","plate","well_position")))
  return(tbl)
}


#' Plot a MeltingCurve object
#'
#' @param x MeltingCurve object
#'
#' @return ggplot object
#' @export
plot_mc = function(mc, y = "derivative", show_tm = FALSE){
  if (!inherits(mc, "MeltingCurve")) stop("mc is not a \"MeltingCurve\" object")
  plate = getPlate(mc)
  df = getData(mc)
  if (!is.null(plate)) df = dplyr::left_join(df, plate, by = "well_position")
  plot_quantstudio_melting_curve(df, y = y, show_tm = show_tm)
}



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
  if (!is.null(plate)) tbl = tbl |> dplyr::left_join(plate, by = "well_position") |>
    dplyr::select(!dplyr::starts_with("T"), dplyr::starts_with("T")) # sort columns
  return(tbl)
}


#' PCA analysis of MeltingCurve object
#'
#' @param object MeltingCurve object
#' @inheritParams vegan::rda
#'
#' @return PCA result
#' @export
mc_pca = function(object, scale = FALSE){
  if (!inherits(object, "MeltingCurve")) stop("Object is not a MeltingCurve class object.")
  tbl = mc_tbl2wider(object)
  mat = as.matrix(tbl |> dplyr::select(dplyr::starts_with("T")))
  rownames(mat) = tbl$well_position
  pca = vegan::rda(mat, scale = scale)
  return(pca)
}

#' @title plot PCA result with extra data (Plate/Sample table)
#'
#' @param object pca result
#' @param extra extra data table (join by 'well_position')
#' @param color color mapping
#' @param shape shape mapping
#' @param show_temperature show temperature arrow
#' @param temp_n limit for temperature arrows
#'
#' @export
#' @return ggplot
mc_pca_plot = function(pca,
                      extra = NULL,
                      color = NULL,
                      shape = NULL,
                      label = "well_position",
                      show_temperature = FALSE,
                      temp_n = 3) {
  sites = .pca_site_score(pca, site_table = extra)
  species = .pca_species_score(pca, temp_n = temp_n)

  p = ggplot2::ggplot()
  site_cols = colnames(sites)
  sample_mapping = list(x = ggplot2::sym("PC1"), y = ggplot2::sym("PC2"))
  if (!is.null(color) && color %in% site_cols) sample_mapping$color = ggplot2::sym(color)
  if (!is.null(shape) && shape %in% site_cols) sample_mapping$shape = ggplot2::sym(shape)
  if (!is.null(label) && label %in% site_cols) sample_mapping$label = ggplot2::sym(label)
  sample_mapping = do.call(ggplot2::aes, sample_mapping)
  p = p + ggplot2::geom_point(do.call(ggplot2::aes, sample_mapping[c("x","y","color","shape")]), sites) +
    ggrepel::geom_text_repel(do.call(ggplot2::aes,sample_mapping[c("x","y","color","label")]), sites)

  if (show_temperature) {
    p = p + ggplot2::geom_segment(data = species,
                         mapping = ggplot2::aes(x = 0, y = 0, xend = .data$PC1, yend = .data$PC2),
                         arrow = ggplot2::arrow(length = ggplot2::unit(0.1,"cm")), show.legend = F) +
      ggrepel::geom_text_repel(mapping = ggplot2::aes(x = .data$PC1, y = .data$PC2, label = .data$temperature),
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
