#' 获取 GPT-4 响应
#'
#' 该函数通过 ChatAnywhere API 发送请求并获取 GPT-4 模型的响应。
#'
#' @param user_prompt 字符串，用户输入的提示。
#' @param system_prompt 字符串，系统提示，默认为 "You are a helpful assistant."。
#' @param model 字符串，指定使用的模型，默认为 "gpt-4o-mini"。
#' @param api_key 字符串，ChatAnywhere API 密钥，默认从环境变量 "CHATANYWHERE_API_KEY" 获取。
#' @param base_url 字符串，API 的基础 URL，默认为 "https://api.chatanywhere.tech"。
#' @param output_format 字符串，输出格式，默认为 "json_object"。
#'
#' @return 字符串，GPT-4 模型生成的响应内容。
#'
#' @examples
#' \dontrun{
#' response <- get_gpt4_response("你好，请介绍一下自己。")
#' print(response)
#' }
#'
#' @export
get_gpt4_response = function(user_prompt = NULL,
                             system_prompt = "You are a helpful assistant.",
                             model = "gpt-4o-mini",
                             api_key = Sys.getenv("CHATANYWHERE_API_KEY"),
                             base_url = "https://api.chatanywhere.tech",
                             output_format = "json_object") {
  # 设置请求头
  headers = c(
    "Content-Type" = "application/json",
    "User-Agent" = "R/0.1",
    "Authorization" = paste("Bearer", api_key)
  )
  
  # 设置请求体
  body = list(
    model = model,
    messages = list(
      list(role = "system", content = system_prompt),
      list(role = "user", content = user_prompt)
    ),
    response_format = list(type = output_format)
  )
  
  # 发送 POST 请求
  response = httr::POST(
    url = paste0(base_url, "/v1/chat/completions"),
    httr::add_headers(.headers = headers),
    body = jsonlite::toJSON(body, auto_unbox = TRUE),
    encode = "json"
  )
  
  # 检查响应状态
  if (httr::status_code(response) != 200) {
    stop("API 请求失败：", httr::content(response, "text"))
  }
  
  # 解析响应
  result = httr::content(response, "parsed")
  
  # 返回生成的文本
  return(result$choices[[1]]$message$content)
}
