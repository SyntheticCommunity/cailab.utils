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
#'
#' @return
#' @export
#' @md
#'
#' @examples
quantstudio2mc = function(x,
                          experiment_date = format(Sys.Date(), "%Y%m%d"),
                          plate = "NA",
                          primer = "V4"){
  if (inherits(x, "QuantStudioRaw")) {
    all_data = x
  } else if (file.exists(x)) {
    all_data = read_quantstudio(x)
  } else {
    stop("Unrecognized x supplied.")
  }
  melting_curve = get_quantstudio_melting_curve(all_data)
  object = methods::new("MeltingCurve",
      experiment_date = experiment_date,
      plate = plate,
      primer = primer,
      data = melting_curve)
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


mc2tbl = function(x){
  if (!inherits(x, "MeltingCurve")) stop("x is not a \"MeltingCurve\" object")
  tbl = getData(x) |>
    dplyr::mutate(date = getDate(x),
                  plate = getPlate(x),
                  primer = getPlate(x)) |>
    tidyr::unite(well_position, tidyr::all_of(c("date","primer","plate","well_position")))
  return(tbl)
}
