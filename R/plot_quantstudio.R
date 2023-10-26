#' Plot real-time PCR melting curve
#'
#' @param data 
#' @param y 
#'
#' @return
#' @export
#'
#' @examples
plot_quantstudio_melting_curve = function(data, y = c("fluorescence", "derivative")){
  y = match.arg(y)
  data %>% 
    ggplot2::ggplot(ggplot2::aes_string("temperature", y, color = "well_position")) +
    ggplot2::geom_line(show.legend = FALSE) 
}

#' Plot real-time amplification curve
#'
#' @param data 
#' @param y 
#'
#' @return
#' @export
#'
#' @examples
plot_quantstudio_amplification_curve = function(data, y = c("rn", "delta_rn")){
  y = match.arg(y)
  data %>%
    ggplot2::ggplot(ggplot2::aes_string("cycle", y, color = "well")) +
    ggplot2::geom_line(show.legend = FALSE)
}