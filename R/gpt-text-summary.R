
#' 生成视频摘要
#'
#' 使用 ChatGPT API 为视频内容生成摘要
#'
#' @param text 字符串,要总结的文本内容,不能为空。作为 user_prompt 使用。
#' @param base_url 字符串,API 基础 URL,默认为 "https://api.chatanywhere.tech"
#' @param api_key 字符串,API 密钥,默认从环境变量 CHATANYWHERE_API_KEY 获取
#' @param model 字符串,使用的模型名称,默认为 "gpt-4o-mini"
#' @param system_prompt 字符串,系统提示词,默认为 NULL
#' @param language 字符串,摘要语言,默认为 "zh"(中文)
#'
#' @return 字符串,生成的摘要
#' @export
gpt_text_summary <- function(
    text, 
    base_url = "https://api.chatanywhere.tech/v1",
    api_key = Sys.getenv("CHATANYWHERE_API_KEY"), 
    model = "gpt-4o-mini",
    system_prompt = NULL,
    language = "zh") {
  
  if (nchar(text) == 0) {
    stop("输入文本为空")
  }
  
  if (is.null(api_key) || nchar(api_key) == 0) {
    stop("API 密钥未设置")
  }
  
  # 这里需要添加 OpenAI API 的依赖
  if (!requireNamespace("httr", quietly = TRUE)) {
    stop("请安装 httr 包")
  }
  
  # 生成系统提示词
  if (is.null(system_prompt)) {
    system_prompt <- sprintf("Please summarize the provided text. Reply in %s", language)
  }
  
  # 调用 OpenAI API
  response <- httr::POST(
    url = paste0(base_url, "/chat/completions"),  # 修正 API 端点
    httr::add_headers(
      "Authorization" = paste("Bearer", api_key),
      "Content-Type" = "application/json"
    ),
    body = list(
      model = model,
      messages = list(
        list(
          role = "system",
          content = system_prompt
        ),
        list(
          role = "user",
          content = text
        )
      )
    ),
    encode = "json"
  )
  
  # 检查响应状态
  if (httr::http_error(response)) {
    stop("API 调用失败: ", httr::http_status(response)$message)
  }
  
  # 解析响应
  content <- httr::content(response)
  
  # 添加错误检查
  if (is.null(content) || is.null(content$choices) || length(content$choices) == 0) {
    stop("API 响应格式错误")
  }
  
  summary <- content$choices[[1]]$message$content
  
  if (is.null(summary) || nchar(summary) == 0) {
    stop("生成的摘要为空")
  }
  
  return(summary)
}