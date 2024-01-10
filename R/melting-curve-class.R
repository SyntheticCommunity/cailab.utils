#' a S4 class for storing melting curve data
#'
#' @slot experiment_date experiment date
#' @slot plate plate
#' @slot primer primer
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
#' @return
#' @export
#' @md
quantstudio2mc = function(x,
                          experiment_date = format(Sys.Date(), "%Y%m%d"),
                          plate = "NA",
                          primer = "NA",
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


# Accessor methods
setGeneric("getDate", function(object) standardGeneric("getDate"))
setMethod("getDate", "MeltingCurve", function(object) object@experiment_date)

setGeneric("getPlate", function(object) standardGeneric("getPlate"))
setMethod("getPlate", "MeltingCurve", function(object) object@plate)

setGeneric("getPrimer", function(object) standardGeneric("getPrimer"))
setMethod("getPrimer", "MeltingCurve", function(object) object@primer)

setGeneric("getData", function(object) standardGeneric("getData"))
setMethod("getData", "MeltingCurve", function(object) object@data)

setGeneric("transformData", function(object, ...) standardGeneric("transformData"))
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

# filter data by temperature and well positions
setGeneric("filterData", function(object, ...) standardGeneric("filterData"))
setMethod("filterData", "MeltingCurve", function(object,
                                                 from = 78,
                                                 to = 85,
                                                 well_position = NULL) {
  data = getData(object) |> dplyr::filter(temperature > from, temperature < to)
  if (!is.null(well_position)) {
    data = data |> dplyr::filter(well_position %in% well_position)
  }
  object@data = data
  return(object)
})

# temperature range
setGeneric("tempRange", function(object, ...) standardGeneric("tempRange"))
setMethod("tempRange", "MeltingCurve", function(object, na.rm = TRUE) {
  range(getData(object) |> dplyr::pull(temperature), na.rm = na.rm)
})

#' Print user-friendly information of object
#'
#' @param object a S4 class object
#' @export
#' @method show MeltingCurve
#' @importFrom methods show slotNames slot
#' @rdname melting-curve
setMethod("show", c(object = "MeltingCurve"),
          function(object){
            cat("An object of class 'MeltingCurve':\n")
            cat("   Slots: ", paste0(slotNames(object), collapse = ", "), ";\n", sep = "")
          })

#' @title Transform a MeltingCurve object to tibble
#'
#' @param x a MeltingCurve object
mc2tbl = function(x){
  if (!inherits(x, "MeltingCurve")) stop("x is not a \"MeltingCurve\" object")
  tbl = getData(x) |>
    dplyr::mutate(date = getDate(x),
                  plate = getPlate(x),
                  primer = getPlate(x)) |>
    tidyr::unite(well_position, tidyr::all_of(c("date","primer","plate","well_position")))
  return(tbl)
}
