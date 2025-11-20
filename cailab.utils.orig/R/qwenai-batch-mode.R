
#' Title
#'
#' @param result
#'
#' @returns
#' @export
#'
#' @examples
qwenai_result_chat_parser = function(result) {
  # 解析外层 JSON
  outer_json <- tryCatch(jsonlite::fromJSON(result, simplifyVector = FALSE, encoding = "UTF-8"),
                         error = function(e) {
                           message("解析外层 JSON 失败: ", e)
                           return(NULL)
                         })
  if (!is.null(outer_json)) {
    # 提取 content 中的 JSON 字符串
    content <- outer_json$response$body$choices[[1]]$message$content
    inter_json_result <- tryCatch(extract_from_content_json(content),
                                  error = function(e) {
                                    message("解析内容中的 JSON 失败: ", e)
                                    return(NULL)
                                  })
    if (!is.null(inter_json_result)) {
      # 转换为数据框
      tbl <- dplyr::as_tibble(inter_json_result) |>
        dplyr::mutate(custom_id = outer_json$custom_id, .before = 1)
      return(tbl)
    }
  }
  return(NULL)
}

