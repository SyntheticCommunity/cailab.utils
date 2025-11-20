#' Convert BioCyc SmartTable
#'
#' This function is used to perform specified conversion operations on BioCyc SmartTable.
#'
#' @param session httr::handle object, representing the established BioCyc session
#' @param table_id string, unique identifier of SmartTable
#' @param transform_id string, the ID of the transformation operation to be performed
#' @param index integer, specifying the index of the column to be converted, the default is 0
#' 
#' @details There are a total of 104 transformation operations, 
#' which can be obtained through `cailab.utils:::biocyc_get_transformations()`. Users can view the details of them
#' in the `transformations` data by `data("transformations")`.
#' 
#' @return No return value, a success message will be printed when the function is executed successfully
#' @export
#'
#' @importFrom httr GET content status_code
#'
#' @examples
#' \dontrun{
#' session <-biocyc_session("your_email@example.com", "your_password")
#' biocyc_transform(session, "your_table_id", "your_transform_id")
#' }
#'
#' @seealso For details on available transformation operations, see https://biocyc.org/st-transformations-table
biocyc_transform = function(session, table_id, transform_id, index = 0) {
  # 构建 API URL
  base_url <- "https://websvc.biocyc.org/st-transform"
  url <- paste0(base_url, "?id=", table_id, "&transformid=", transform_id, "&index=", index)
  
  # 发送 GET 请求
  response <- httr::GET(url, handle = session)
  
  # 检查响应状态
  if (httr::status_code(response) %in% 200:299) {
    message("Transformation completed successfully")
    return(invisible(TRUE))
  } else {
    stop("Transformation failed: ", httr::content(response, "text"))
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