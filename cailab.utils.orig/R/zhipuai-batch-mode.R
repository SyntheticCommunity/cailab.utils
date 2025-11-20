
# 智谱 AI 批处理任务 API

#' 构建智谱AI批处理任务
#'
#' 此函数用于构建智谱AI的批处理任务请求
#'
#' @param ... 批处理任务的数据参数
#' @param request_id 字符串,请求的唯一标识符,默认为NULL时会根据数据自动生成
#' @param model 字符串,使用的模型名称,默认为"glm-4-plus"
#' @param system_prompt 字符串,系统提示语,默认为"请根据提供的数据执行批处理任务"
#' @param user_prompt 字符串,用户提示语,默认为NULL时会将数据转换为JSON字符串
#' @param temperature 数值,采样温度,控制输出的随机性,默认为0
#' @param endpoint 字符串,API端点,默认为"/v4/chat/completions"
#'
#' @return 返回JSON格式的请求体字符串
#' @export
#'
#' @examples
#' \dontrun{
#' task <- zhipuai_build_batch_task(
#'   data1 = "示例数据1",
#'   data2 = "示例数据2",
#'   model = "glm-4-plus"
#' )
#' }
zhipuai_batch_build <- function(
  ..., 
  request_id = NULL,
  model = "glm-4-plus", 
  system_prompt = "请根据提供的数据执行批处理任务", 
  user_prompt = NULL, 
  temperature = 0, 
  endpoint = "/v4/chat/completions"
) {
  data = list(...)

  if (is.null(request_id)) {
    request_id <- digest::digest(data)
  }

  if (is.null(user_prompt)) {
    user_prompt <- jsonlite::toJSON(data, auto_unbox = TRUE, pretty = FALSE)
  }

  request <- list(
    custom_id = request_id,
    method = "POST",
    url = endpoint,
    body = list(
      model = model, 
      messages = list(
        list(role = "system", content = system_prompt), 
        list(role = "user", content = user_prompt)
      ), 
      temperature = temperature
    )
  )

  return(jsonlite::toJSON(request, pretty = FALSE, auto_unbox = TRUE))
}


#' 创建批处理任务
#' 
#' 此函数用于在智谱AI平台上创建一个新的批处理任务
#'
#' @param file_id 已上传文件的ID
#' @param api_key 智谱AI的API密钥,默认从环境变量ZHIPUAI_API_KEY中获取
#' @param job_description 字符串,批处理任务的描述,默认为"Batch Task"
#' @param endpoint 字符串,API端点,默认为"/v4/chat/completions"
#' @return 返回创建成功的批处理任务ID
#' @export
#' @name zhipuai_batch_create
zhipuai_batch_create <- function(
  file_id, 
  job_description = "Batch Task", 
  endpoint = "/v4/chat/completions", 
  api_key = Sys.getenv("ZHIPUAI_API_KEY")
) {
  req <- httr2::request("https://open.bigmodel.cn/api/paas/v4/batches") %>%
    httr2::req_headers(
      "Authorization" = paste("Bearer", api_key)
    ) %>%
    httr2::req_body_json(list(
      input_file_id = file_id,
      endpoint = endpoint,
      auto_delete_input_file = TRUE,
      metadata = list(
        description = job_description
      )
    )) %>%
    httr2::req_method("POST")
  
  resp_data <- jsonlite::fromJSON(rawToChar(httr2::req_perform(req)$body))
  batch_id <- resp_data$id
  cli::cli_alert_success("批处理任务 {batch_id} 创建成功!")
  return(batch_id)
}

#' @export
#' @rdname zhipuai_batch_create
zhipuai_batch_submit = zhipuai_batch_create

#' 检查 Batch 批处理任务的状态
#' 
#' 此函数用于检查批处理任务的状态
#'
#' @param batch_id 批处理任务的ID
#' @param api_key 智谱AI的API密钥,默认从环境变量ZHIPUAI_API_KEY中获取
#' @return 返回批处理任务的状态
#' @export
zhipuai_batch_status_get <- function(batch_id, api_key = Sys.getenv("ZHIPUAI_API_KEY")) {
  req <- httr2::request(paste0("https://open.bigmodel.cn/api/paas/v4/batches/", batch_id)) %>%
    httr2::req_headers(
      "Authorization" = paste("Bearer", api_key)
    ) %>%
    httr2::req_method("GET")
  resp <- httr2::req_perform(req)
  return(jsonlite::fromJSON(rawToChar(resp$body)))
}


#' 持续检查批处理任务的状态
#' 
#' 此函数用于持续检查批处理任务的状态
#'
#' @param batch_id 批处理任务的ID
#' @param interval 检查间隔时间,默认5秒
#' @param timeout 查询任务超时时间,默认30秒
#' @param api_key 智谱AI的API密钥,默认从环境变量ZHIPUAI_API_KEY中获取
#' @return 返回批处理任务的状态
#' @export
zhipuai_batch_status_check <- function(batch_id, interval = 5, timeout = 30, api_key = Sys.getenv("ZHIPUAI_API_KEY")) {
  cli::cli_h1("开始持续检查批处理任务 {batch_id} 的状态（{interval}秒检查一次）...")
  cli::cli_alert_info("按 Ctrl+C 停止")
  status_data <- zhipuai_batch_status_get(batch_id = batch_id, api_key = api_key)
  # 初始化状态
  current_status <- last_status <- status_data$status
  cli::cli_h2("当前状态: {current_status}")
  last_progress_bar <- cli::cli_progress_bar(
    name = current_status,
    total = status_data$request_counts$total,
    current = FALSE
  )
  last_progress <- 0
  start_time <- Sys.time()
  # 循环检查任务状态
  while (TRUE) {
    # 检查是否超时
    if (difftime(Sys.time(), start_time, units = "secs") > timeout) {
      cli::cli_alert_danger("查询任务超时。请稍后再试或者增加timeout参数的值。")
      break
    }
    # 获取当前状态
    status_data <- zhipuai_batch_status_get(batch_id = batch_id, api_key = api_key)
    current_status <- status_data$status
    # 如果状态发生变化
    if (current_status != last_status) {
      # 更新状态
      cli::cli_h2("当前状态: {current_status}")
      last_status <- current_status
      # 更新进度条
      last_progress_bar <- cli::cli_progress_bar(
        name = current_status,
        total = status_data$request_counts$total,
        current = FALSE
      )
    }
    # 视情况更新进度条
    if (current_status %in% c("validating", "in_progress", "finalizing")) {
      # 更新进度
      progress <- status_data$request_counts$completed + status_data$request_counts$failed
      if (progress != last_progress) {
        last_progress <- progress
        cli::cli_progress_update(id = last_progress_bar, set = progress)
      }
    } else if(status_data$status == "completed") {
      cli::cli_alert_success("任务成功完成!")
      break
    } else if (status_data$status == "failed") {
      cli::cli_alert_danger("任务失败!")
      break
    } else if (status_data$status == "expired") {
      cli::cli_alert_danger("任务已过期!")
      break
    } else if (status_data$status == "cancelled") {
      cli::cli_alert_warning("任务已取消!")
      break
    } else {
      cli::cli_alert_danger("任务状态: Unknown")
      break
    }
    Sys.sleep(interval)
  }
  file = list(
    batch_id = status_data$id,
    output = status_data$output_file_id,
    error = status_data$error_file_id
  )
  invisible(file)
}



#' 下载 Batch 批处理任务的结果
#' 
#' 此函数用于下载批处理任务的结果
#'
#' @param batch_id 批处理任务的ID
#' @param output_path 结果保存的路径
#' @param file_names 需要下载的文件名,默认c("output", "error")，还可选 “input”
#' @param api_key 智谱AI的API密钥,默认从环境变量ZHIPUAI_API_KEY中获取
#' @return 返回结果保存的路径
#' @export
zhipuai_batch_results_download <- function(
  batch_id, 
  output_path, 
  file_names = c("output", "error"), 
  api_key = Sys.getenv("ZHIPUAI_API_KEY")
) {
  file_names = match.arg(file_names, several.ok = TRUE)
  keys = paste0(file_names, "_file_id")
  cli::cli_h1("开始下载批处理任务 {batch_id} 的结果...")
  batch_status <- zhipuai_batch_status_get(batch_id = batch_id, api_key = api_key)
  file_list <- batch_status[keys]
  for (i in seq_along(file_list)) {
    zhipuai_file_download(file_list[[i]], 
                          gsub("\\.jsonl$", paste0("_", file_names[i], ".jsonl"), output_path), 
                          api_key)
  }
  invisible(output_path)
}


#' 列出 Batch 任务
#' 
#' 此函数用于列出智谱AI平台上的批处理任务
#'
#' @param limit 每页返回的数量,默认20
#' @param after 分页游标,指定从特定对象ID之后开始检索
#' @param api_key 智谱AI的API密钥,默认从环境变量ZHIPUAI_API_KEY中获取
#' @return 返回一个包含批处理任务列表的数据框
#' @export
zhipuai_batch_list <- function(limit = 20, after = NULL, api_key = Sys.getenv("ZHIPUAI_API_KEY")) {
  # 构建基础URL
  base_url <- "https://open.bigmodel.cn/api/paas/v4/batches"
  
  # 构建查询参数
  query_params <- list(limit = limit)
  if (!is.null(after)) {
    query_params$after <- after
  }
  
  # 构建请求
  req <- httr2::request(base_url) %>%
    httr2::req_headers(
      "Authorization" = paste("Bearer", api_key)
    ) %>%
    httr2::req_url_query(!!!query_params) %>%
    httr2::req_method("GET")
  
  # 执行请求
  resp <- httr2::req_perform(req)
  result <- jsonlite::fromJSON(rawToChar(resp$body))
  
  return(result)
}

#' 迭代获取所有 Batch 任务
#' 
#' 此函数用于迭代获取智谱AI平台上的所有批处理任务
#'
#' @param limit 每页返回的数量,默认20
#' @param api_key 智谱AI的API密钥,默认从环境变量ZHIPUAI_API_KEY中获取
#' @return 返回一个包含所有批处理任务的数据框
#' @export
zhipuai_batch_list_all <- function(limit = 20, api_key = Sys.getenv("ZHIPUAI_API_KEY")) {
  all_batches <- list()
  current_after <- NULL
  
  repeat {
    # 获取当前页的数据
    current_page <- zhipuai_batch_list(limit = limit, after = current_after, api_key = api_key)
    
    # 添加到结果列表
    all_batches <- c(all_batches, list(current_page$data))
    
    # 检查是否有下一页
    if (is.null(current_page$has_more) || !current_page$has_more) {
      break
    }
    
    # 更新after参数
    current_after <- current_page$data[length(current_page$data)]$id
  }
  
  # 合并所有结果
  result <- do.call(rbind, all_batches)
  return(result)
}

# 读取 JSONL 文件并解析
#' 解析智谱AI批处理任务的结果文件
#'
#' 此函数用于解析从智谱AI平台下载的批处理任务结果文件（JSONL格式）
#'
#' @param file_path 字符串，批处理任务结果文件的路径
#' @param type 字符串，批处理任务类型,默认为"chat",可选值为"chat"或"embedding"
#' @return 返回一个tibble数据框，包含解析后的结果
#' @export
#'
#' @examples
#' \dontrun{
#' results <- zhipuai_parse_batch_results("batch_results.jsonl")
#' }
zhipuai_batch_results_parse <- function(file_path, type = "chat") {
  # 读取行
  lines <- readLines(file_path, encoding = "UTF-8")

  parser <- switch(type,
    chat = zhipuai_result_chat_parser,
    embedding = zhipuai_result_embedding_parser
  )
  # 解析每一行 JSON
  results <- lapply(lines, parser)  |> 
    dplyr::bind_rows()
  
  return(results)
}

