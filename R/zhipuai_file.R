# 智谱 AI 文件管理 API

#' 上传文件到智谱AI平台
#' 
#' 此函数用于将本地文件上传到智谱AI平台,用于后续的批处理任务
#'
#' @param file_path 需要上传的本地文件路径
#' @param purpose 文件用途,默认为"batch",可选值为"batch"或"file-extraction"
#' @param api_key 智谱AI的API密钥,默认从环境变量ZHIPUAI_API_KEY中获取
#' @return 返回上传成功后的文件ID
#' @export
zhipuai_file_upload <- function(file_path, purpose = "batch", api_key = Sys.getenv("ZHIPUAI_API_KEY")) {
  req <- httr2::request("https://open.bigmodel.cn/api/paas/v4/files") %>%
    httr2::req_headers(
      "Authorization" = paste("Bearer", api_key)
    ) %>%
    httr2::req_body_multipart(
      file = curl::form_file(file_path),
      purpose = purpose
    ) %>%
    httr2::req_method("POST")
  
  resp <- httr2::req_perform(req)
  file_id <- jsonlite::fromJSON(rawToChar(resp$body))$id
  cli::cli_alert_success("文件 {file_path} 上传成功! 文件ID: {file_id}")
  return(file_id)
}

#' 下载智谱AI平台上的文件
#'
#' 此函数用于下载智谱AI平台上的文件
#'
#' @param file_id 文件的ID
#' @param output_path 结果保存的路径
#' @param api_key 智谱AI的API密钥,默认从环境变量ZHIPUAI_API_KEY中获取
#' @return 返回结果保存的路径
#' @export
#'
#' @examples
#' \dontrun{
#' zhipuai_download_file("file_id", "output_path")
#' }
zhipuai_file_download <- function(file_id, output_path, api_key = Sys.getenv("ZHIPUAI_API_KEY")) {
  req <- httr2::request(paste0("https://open.bigmodel.cn/api/paas/v4/files/", file_id, "/content")) %>%
    httr2::req_headers(
      "Authorization" = paste("Bearer", api_key)
    ) %>%
    httr2::req_method("GET")
  resp <- httr2::req_perform(req)
  writeBin(resp$body, output_path)
  cli::cli_alert_success("文件 {file_id} 已保存到 {output_path}")
  invisible(output_path)
}


#' 删除文件
#' 
#' 此函数用于删除智谱AI平台上的文件
#'
#' @param file_id 文件的ID
#' @param api_key 智谱AI的API密钥,默认从环境变量ZHIPUAI_API_KEY中获取
#' @return 返回删除文件的结果
#' @export
zhipuai_file_delete <- function(file_id, api_key = Sys.getenv("ZHIPUAI_API_KEY")) {
  req <- httr2::request(paste0("https://open.bigmodel.cn/api/paas/v4/files/", file_id)) %>%
    httr2::req_headers(
      "Authorization" = paste("Bearer", api_key)
    ) %>%
    httr2::req_method("DELETE")
  
  resp <- httr2::req_perform(req)
  cli::cli_alert_success("文件 {file_id} 删除成功!")
  invisible(jsonlite::fromJSON(rawToChar(resp$body)))
}