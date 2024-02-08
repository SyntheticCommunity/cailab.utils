#' Methods for QuantStudioRaw class object
#'
#' **Input**
#'
#' The QuantStudioRaw object is a S3 class object by `read_quantstudio()` function.
#'
#' **Output**
#'
#' * `plot(object)` - plot object
#'
#' @name QuantStudioRaw-class
#' @rdname quantstudioraw-class
#' @docType class
NULL

#' Print user-friendly information of a object
#'
#' @param x a QuantStudioRaw object
#' @inheritDotParams print
#' @method print QuantStudioRaw
#' @name print
#' @rdname quantstudioraw-class
#' @docType methods
#' @export
print.QuantStudioRaw = function(x, ...){
  cat("An object of class 'QuantStudioRaw':\n")
  cat("   Slots: ", paste0(names(x), collapse = ", "), ";\n", sep = "")
}
