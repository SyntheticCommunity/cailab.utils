#' a S4 class for storing melting curve data
#'
#' @slot experiment_date experiment date
#' @slot plate plate
#' @slot primer primer
#' @slot data curve data
#' @name mc-class
#' @rdname melting-curve
setClass("Melting_Curve",
         slots = list(
           experiment_date = "character",
           plate = "character",
           primer = "ANY",
           data = "ANY"
           )
)

quantstudio2mc = function(file,
                          experiment_date = "",
                          plate = "",
                          primer = ""){
  all_data = read_quantstudio(file)
  melting_curve = get_quantstudio_melting_curve(all_data)
  new("Melting_Curve",
      experiment_date = experiment_date,
      plate = plate,
      primer = primer,
      data = melting_curve)
}


# Accessor methods
setGeneric("getDate", function(object) standardGeneric("getDate"))
setMethod("getDate", "Melting_Curve", function(object) object@date)

setGeneric("getPlate", function(object) standardGeneric("getPlate"))
setMethod("getPlate", "Melting_Curve", function(object) object@plate)

setGeneric("getPrimer", function(object) standardGeneric("getPrimer"))
setMethod("getPrimer", "Melting_Curve", function(object) object@primer)

#' Print user-friendly information of object
#'
#' @param object a S4 class object
#' @export
#' @method show Melting_Curve
#' @importFrom methods show slotNames slot
#' @rdname melting-curve
setMethod("show", c(object = "Melting_Curve"),
          function(object){
            cat("An object of class 'Melting_Curve':\n")
            cat("   Slots: ", paste0(slotNames(object), collapse = ", "), ";\n", sep = "")
          })
