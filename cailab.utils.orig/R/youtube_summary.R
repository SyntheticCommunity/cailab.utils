#' 检查 URL 是否为播放列表
#'
#' @param url 字符串,YouTube URL
#' @return 逻辑值,是否为播放列表
#' @keywords internal
#' @export
yt_is_playlist <- function(url) {
  grepl("playlist\\?list=|&list=", url)
}

#' 获取播放列表中的视频 URL
#'
#' @param playlist_url 字符串,播放列表 URL
#' @return 字符向量,包含所有视频的 URL
#' @keywords internal
yt_playlist_videos <- function(playlist_url) {
  # 使用 yt-dlp 获取播放列表信息
  cmd <- sprintf('yt-dlp --flat-playlist --get-id "%s"', playlist_url)
  video_ids <- system(cmd, intern = TRUE)
  
  # 构建完整的视频 URL
  video_urls <- paste0("https://www.youtube.com/watch?v=", video_ids)
  return(video_urls)
}

#' 下载 YouTube 视频字幕
#'
#' 使用 yt-dlp 下载指定 YouTube 视频的字幕文件
#'
#' @param url 字符串,YouTube 视频的 URL
#' @param lang 字符串,字幕语言代码,默认为 "en"
#' @param output_dir 字符串,输出目录路径,默认为临时目录
#' @param verbose 逻辑值,是否显示详细信息,默认为 FALSE
#' 
#' @return 字符串,下载的字幕文件路径
#' @export
yt_sub_download <- function(url, lang = "en", output_dir = NULL, output_file = NULL, verbose = FALSE) {
  # 检查 yt-dlp 是否已安装
  if (system("which yt-dlp", ignore.stdout = TRUE) != 0) {
    stop("请先安装 yt-dlp")
  }
  
  # 创建输出目录
  if (is.null(output_dir)) {
    output_dir <- tempdir()
  }
  
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
  
  # 提取视频 ID
  video_id <- gsub(".*v=|.*be/|\\?.*", "", url)
  
  # 构建输出文件名
  if (is.null(output_file)) {
    output_file <- file.path(output_dir, video_id)
  }
  
  # 构建命令
  cmd <- sprintf(
    'yt-dlp --write-subs --sub-lang %s --skip-download --convert-subs vtt "%s" -o "%s"',
    lang, url, output_file
  )
  
  # 执行命令
  ret <- system(cmd, ignore.stdout = !verbose, ignore.stderr = !verbose)
  if (ret != 0) {
    stop("字幕文件下载失败")
  }
  
  # 检查文件是否存在。文件会自动添加 en.vtt 后缀，这里要补全。
  output_file_path <- sprintf("%s.%s.vtt", output_file, lang)
  if (!file.exists(output_file_path)) {
    stop("未找到字幕文件")
  }
  
  # 返回字幕文件路径
  return(output_file_path)
}

#' 解析字幕文件
#'
#' 读取并解析 .srt 或 .vtt 格式的字幕文件
#'
#' @param file_path 字符串,字幕文件路径
#'
#' @return 字符串,清理后的字幕文本
#' @export
yt_sub_clean <- function(file_path) {
  # 读取文件
  lines <- readLines(file_path, warn = FALSE)
  
  # 移除时间戳和数字行
  text_lines <- lines[!grepl("^[0-9]+$", lines) & 
                     !grepl("^[0-9]{2}:[0-9]{2}:[0-9]{2}", lines) &
                     !grepl("^WEBVTT", lines) &
                     nzchar(lines)]
  
  # 合并文本行
  clean_text <- paste(text_lines, collapse = " ")
  
  # 清理多余的空格
  clean_text <- gsub("\\s+", " ", clean_text)
  clean_text <- trimws(clean_text)
  
  return(clean_text)
}


#' 处理单个视频并生成摘要
#' 
#' @param url 字符串,视频的 URL
#' @param base_url 字符串,API 基础 URL
#' @param api_key 字符串,API 密钥
#' @param lang 字符串,字幕语言代码
#' @param summary_lang 字符串,摘要语言
#' @param output_dir 字符串,输出目录
#' @param model 字符串,使用的模型名称
#' @param verbose 逻辑值,是否显示详细信息
#' 
#' @return list 包含视频标题、URL和摘要的列表
#' @export
yt_summarize_video <- function(url,
                               base_url,
                               api_key,
                               lang,
                               summary_lang,
                               output_dir,
                               model,
                               verbose = TRUE) {
  video_title <- yt_video_title(url)
  if (verbose) {
    cli::cli_h2("正在处理视频: {video_title}")
  }

  # 下载字幕
  subtitle_file <- yt_sub_download(url = url, lang = lang, output_dir = output_dir)
  if (!file.exists(subtitle_file)) {
    stop("字幕文件下载失败: ", url)
  }
  
  text <- yt_sub_clean(subtitle_file)
  if (nchar(text) == 0) {
    stop("字幕文本为空: ", subtitle_file)
  }

  if (verbose) {
    cli::cli_alert_info("字幕文本长度: {nchar(text)}")
  }
  system_prompt <- switch(summary_lang,
    "zh" = sprintf("请根据我提供的视频字幕为视频写一个简洁的中文摘要"),
    "en" = sprintf("Please write a concise summary for the provided video caption"),
    stop("不支持的语言")
  )
  summary <- gpt_text_summary(
    text = text,
    base_url = base_url,
    api_key = api_key,
    model = model,
    system_prompt = system_prompt,
    language = summary_lang
  )
  
  # 检查摘要结果
  if (is.null(summary) || nchar(summary) == 0) {
    stop("生成摘要失败")
  }

  # 返回带标题的摘要
  list(
    title = video_title,
    url = url,
    summary = summary
  )
}

#' 一键生成 YouTube 视频摘要
#'
#' 下载字幕、解析内容并生成摘要的便捷函数。支持单个视频和播放列表。
#'
#' @param url 字符串,YouTube 视频或播放列表的 URL
#' @param base_url 字符串,API 基础 URL,默认为 "https://api.chatanywhere.tech"
#' @param api_key 字符串,API 密钥,默认从环境变量 CHATANYWHERE_API_KEY 获取
#' @param lang 字符串,字幕语言代码,默认为 "en"
#' @param summary_lang 字符串,摘要语言,默认为 "zh"
#' @param rettype 字符串,返回类型,默认为 "list"
#' @param model 字符串,使用的模型名称,默认为 "gpt-4o-mini"
#'
#' @return 如果是单个视频,返回字符串(摘要);
#'         如果是播放列表,返回列表(每个视频的摘要)或字符串(合并的摘要)
#' @export
yt_summary <- function(url, 
                       base_url = "https://api.chatanywhere.tech/v1",
                       api_key = Sys.getenv("CHATANYWHERE_API_KEY"), 
                       lang = "en", 
                       summary_lang = "zh", 
                       rettype = c("list", "data.frame", "tibble"),
                       output_dir = tempdir(),
                       model = "gpt-4o-mini") {
  
  # 参数检查
  if (missing(url) || !is.character(url) || length(url) != 1) {
    stop("url 必须是单个字符串")
  }
  
  # 创建输出目录
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  if (yt_is_playlist(url)) {
    # 如果是播放列表，则输出提示信息
    playlist_title <- yt_playlist_title(url) # nolint: object_usage_linter.
    cli::cli_h1("正在处理播放列表: {playlist_title}")
    
    # 获取播放列表中的所有视频 URL
    video_urls <- yt_playlist_videos(url)
    
    if (length(video_urls) == 0) {
      stop("播放列表中没有找到视频")
    }
    
    # 创建进度条
    pb <- cli::cli_progress_bar(
      total = length(video_urls),
      format = "Processing {cli::pb_bar} {cli::pb_percent} | {cli::pb_current}/{cli::pb_total}",
      current = FALSE
    )
    
    # 为每个视频生成摘要
    summaries <- lapply(video_urls, function(video_url) {
      tryCatch({
        yt_summarize_video(
          url = video_url,
          base_url = base_url,
          api_key = api_key,
          lang = lang,
          summary_lang = summary_lang,
          output_dir = output_dir,
          model = model,
          verbose = FALSE
        )
      }, error = function(e) {
        cli::cli_alert_danger("处理视频失败: {video_url}\n错误信息: {e$message}")
        return(list(
          title = NA,
          url = video_url,
          summary = paste("处理出错:", e$message)
        ))
      })
      cli::cli_progress_update(id = pb)

    })
  
  } else {
    # 处理单个视频
    summaries <- yt_summarize_video(
      url = url,
      base_url = base_url,
      api_key = api_key,
      lang = lang,
      summary_lang = summary_lang,
      output_dir = output_dir,
      model = model
    )
  }

  # 根据返回类型处理结果
  rettype <- match.arg(rettype)
  if (rettype %in% c("data.frame", "tibble")) {
    summaries <- dplyr::bind_rows(summaries) |> 
      dplyr::as_tibble()
  }
  
  return(summaries)
} 

#' 获取播放列表标题
#'
#' 使用 yt-dlp 获取播放列表的标题
#'
#' @param url 字符串,播放列表的 URL
#' @return 字符串,播放列表的标题
#' @export
yt_playlist_title <- function(url) {
  if (!yt_is_playlist(url)) {
    cli::cli_alert_danger("这个地址不是播放列表： {url}")
  }
  cmd <- sprintf('yt-dlp --dump-json "%s" --playlist-start 1 --playlist-end 1', url)
  content <- system(cmd, intern = TRUE)
  info <- jsonlite::fromJSON(content)
  return(info$playlist_title)
}

#' 获取视频标题
#'
#' 使用 yt-dlp 获取视频的标题
#'
#' @param url 字符串,视频的 URL
#' @return 字符串,视频的标题
#' @export
yt_video_title <- function(url) {
  cmd <- sprintf('yt-dlp --get-title "%s"', url)
  title <- system(cmd, intern = TRUE)
  return(title)
}