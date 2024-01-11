# 计算两个熔解曲线之间的相似性


#' Tibble to wider matrix-like format
#'
#' @param tbl a tibble storing melting curve data
#' @param column_names_from column names
#' @param column_values_from column values
#'
#' @return a wider tibble
#' @export
mc_tbl2wider = function(tbl,
                        column_names_from = "temperature",
                        column_values_from = "derivative") {
  tidyr::pivot_wider(tbl, names_from = column_names_from, names_prefix = "T", values_from = column_values_from)
}
