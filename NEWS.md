# News and Updates

## `cailab.utils` 0.5

**新功能**

- 添加了 `gpt_text_summary()` 函数，用于使用 ChatGPT API 生成文本摘要
- 添加了一系列 YouTube 视频处理函数:
  - `yt_is_playlist()`: 检查 URL 是否为播放列表
  - `yt_playlist_videos()`: 获取播放列表中的视频 URL
  - `yt_sub_download()`: 下载 YouTube 视频字幕
  - `yt_sub_clean()`: 解析字幕文件
  - `yt_summarize_video()`: 处理单个视频并生成摘要
  - `yt_summary()`: 一键生成 YouTube 视频摘要
  - `yt_playlist_title()`: 获取播放列表标题
  - `yt_video_title()`: 获取视频标题

## `cailab.utils` 0.4

**新功能**

- 添加了智谱 AI 相关函数:
  - 批处理任务相关:
    - `zhipuai_batch_build()`: 构建批处理任务请求
    - `zhipuai_batch_create()`: 创建批处理任务
    - `zhipuai_batch_status_get()`: 获取任务状态
    - `zhipuai_batch_status_check()`: 持续检查任务状态
    - `zhipuai_batch_results_download()`: 下载任务结果
    - `zhipuai_batch_list()`: 列出批处理任务
    - `zhipuai_batch_list_all()`: 获取所有批处理任务
    - `zhipuai_batch_results_parse()`: 解析任务结果
  - 文件管理相关:
    - `zhipuai_file_upload()`: 上传文件
    - `zhipuai_file_download()`: 下载文件
    - `zhipuai_file_delete()`: 删除文件
  - 结果解析相关:
    - `zhipuai_result_chat_parser()`: 解析聊天任务结果
    - `zhipuai_result_embedding_parser()`: 解析嵌入任务结果
