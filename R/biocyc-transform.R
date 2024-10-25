#' 对BioCyc SmartTable进行转换操作
#'
#' 此函数用于对BioCyc SmartTable执行指定的转换操作。
#'
#' @param session httr::handle对象，表示已建立的BioCyc会话
#' @param table_id 字符串，SmartTable的唯一标识符
#' @param transform_id 字符串，要执行的转换操作的ID
#' @param index 整数，指定要转换的列的索引，默认为0
#' 
#' @details 一共有 104 种转换操作，可以通过 `biocyc_get_transformations` 获取
#' 
#' @return 无返回值，函数执行成功时会打印成功消息
#' @export
#'
#' @importFrom httr GET content status_code
#'
#' @examples
#' \dontrun{
#' session <- biocyc_session("your_email@example.com", "your_password")
#' biocyc_transform(session, "your_table_id", "your_transform_id")
#' }
#'
#' @seealso 有关可用转换操作的详细信息，请参阅 https://biocyc.org/st-transformations-table
biocyc_transform = function(session, table_id, transform_id, index = 0) {
  # 构建 API URL
  base_url <- "https://websvc.biocyc.org/st-transform"
  url <- paste0(base_url, "?id=", table_id, "&transformid=", transform_id, "&index=", index)
  
  # 发送 GET 请求
  response <- httr::GET(url, handle = session)
  
  # 检查响应状态
  if (httr::status_code(response) == 200) {
    content <- httr::content(response, "text", encoding = "UTF-8")
    message("转换成功完成")
    return(invisible(NULL))
  } else {
    stop("转换失败: ", httr::content(response, "text"))
  }
}


biocyc_get_transformations = function(session) {
  base_url <- "https://websvc.biocyc.org/st-transformations-table"
  response <- httr::GET(base_url, handle = session)
  content <- httr::content(response, "text", encoding = "UTF-8")
  # 从 JavaScript 中提取数据源
  js_data <- stringr::str_extract(content, "let transformData=(\\[[^=]+\\])") |> 
    stringr::str_remove("let transformData=")
  
  # 解析 JSON 数据
  transform_table <- jsonlite::fromJSON(js_data) |> dplyr::as_tibble()
  
  # 设置列名
  return(transform_table)
}

biocyc_get_properties = function(session) {
  base_url <- "https://websvc.biocyc.org/st-transformations-table"
  response <- httr::GET(base_url, handle = session)
  content <- httr::content(response, "text", encoding = "UTF-8")
  # 从 JavaScript 中提取数据源
  js_data <- stringr::str_extract(content, "slotData=\\[.+\\]") |> 
    stringr::str_remove("slotData=")
  
  # 解析 JSON 数据
  slot_table <- jsonlite::fromJSON(js_data) |> dplyr::as_tibble()
  
  # 设置列名
  return(slot_table)
}