#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
#' @param lhs A value or the magrittr placeholder.
#' @param rhs A function call using the magrittr semantics.
#' @return The result of calling `rhs(lhs)`.
NULL


# 定义 drop_inf 函数
drop_inf <- function(data, ...) {

  # 检查参数
  dots <- rlang::enquos(...)
  if (length(dots) == 0) {
    vars <- colnames(data)
  } else {
    vars <- purrr::map_chr(dots, rlang::as_string)
  }

  # 过滤掉包含 Inf 的行
  data %>%
    dplyr::filter_at(vars, dplyr::all_vars(!is.infinite(.)))
}
