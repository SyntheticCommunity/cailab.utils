# 计算两个熔解曲线之间的相似性


#' Tibble to wider matrix-like format
#'
#' @param tbl a tibble storing melting curve data
#' @param resample resample before transformation
#' @param resample_method method used in resample
#' @param resample_from start temperature in resample
#' @param resample_to stop temperature in resample
#' @param resample_by step temperature in resample
#' @param resample_variable variable in resample
#' @param column_names_from column names
#' @param column_values_from column values
#'
#' @return a wider tibble
#' @export
mc_tbl2wider = function(tbl,
                        resample = TRUE,
                        resample_method = "spline",
                        resample_from = 75,
                        resample_to = 90,
                        resample_by = 0.5,
                        resample_variable = "derivative",
                        column_names_from = "temperature",
                        column_values_from = "derivative") {
  if (isTRUE(resample)) {
    tbl = curve_resample(tbl,
                         from = resample_from,
                         to = resample_to,
                         variable = resample_variable,
                         by = resample_by)
  }
  tidyr::pivot_wider(tbl, names_from = names_from, values_from = values_from)
}
