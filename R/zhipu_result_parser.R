# 智谱 AI 任务结果解析

#' 解析智谱 AI 任务结果中的聊天任务结果
#' 
#' @param result 智谱 AI 聊天模型的任务结果
#' @return 返回一个数据框
#' @export
zhipuai_result_chat_parser <- function(result) {
  # 解析外层 JSON
  outer_json <- tryCatch(jsonlite::fromJSON(result, simplifyVector = FALSE, encoding = "UTF-8"),
                         error = function(e) {
                           message("解析外层 JSON 失败: ", e)
                           return(NULL)
                         })
  
  # 提取 content 中的 JSON 字符串
  content <- outer_json$response$body$choices[[1]]$message$content
  result <- tryCatch(extract_from_content_json(content),
                     error = function(e) {
                       message("解析内容中的 JSON 失败: ", e)
                       return(NULL)
                     })
  
  # 转换为数据框
  dplyr::as_tibble(result)
}

# 处理不规范的 JSON 字符串
extract_from_content_json = function(content) {
  valid = valid_json(content)
  while (!valid) {
    content = remove_markdown_code_block(content)
    valid = valid_json(content)
    if (valid) {
      break
    }
    content = escape_double_quote(content)
    valid = valid_json(content)
    if (valid) {
      break
    }
    message("解析 JSON 失败，请检查输入内容")
    break
  }

  result = jsonlite::fromJSON(content)
  return(result)
}

valid_json = function(content) {
  tryCatch({
    jsonlite::fromJSON(content, simplifyVector = FALSE, encoding = "UTF-8")
    return(TRUE)
  },
  error = function(e) {
    return(FALSE)
  })
}

remove_markdown_code_block = function(content) {
  gsub(pattern = "```json\\s*|```", replacement = "", content, perl = TRUE)
}

escape_double_quote = function(content) {
  content |> 
    # 将键名两侧的双引号替换为分隔符
    gsub(pattern = '"([a-zA-Z0-9_]+)":\\s*', replacement = "__SEP__\\1__SEP__:", perl = TRUE) |> 
    # 将键值左侧的双引号替换为分隔符
    gsub(pattern = '(:\\s*)"', replacement = "\\1__SEP__", perl = TRUE) |> 
    # 将键值右侧的双引号替换为分隔符
    gsub(pattern = '"([,\n])', replacement = "__SEP__\\1", perl = TRUE) |> 
    # 将其余的双引号替换为二次转义的双引号
    gsub(pattern = '"', replacement = '\\\\"', perl = TRUE) |> 
    # 将分隔符换回双引号
    gsub(pattern = "__SEP__", replacement = '"', fixed = TRUE)
}

#' 解析智谱 AI 任务结果中的嵌入任务结果
#' 
#' @param result 智谱 AI 嵌入模型的任务结果
#' @return 返回一个数据框
#' @export
zhipuai_result_embedding_parser <- function(result) {
  # 解析外层 JSON
  outer_json <- jsonlite::fromJSON(result, simplifyVector = FALSE, encoding = "UTF-8")
  
  # 转换为数据框
  dplyr::as_tibble(outer_json)
}
