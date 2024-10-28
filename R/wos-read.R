#' 读取 WebofScience 导出的 Fast5000 文件
#'
#'
#' @param file 字符串, Fast5000 文件的路径。
#' @param remove 字符串,指定是否移除某些数据。默认为 "auto"。
#'
#' @return 返回处理后的数据(具体返回类型取决于实现)
#' @export
#'
#' @examples
#' \dontrun{
#' data = read_fast5k("path/to/file.fast5")
#' }
read_fast5k = function(file, remove = "auto") {
  # 检查文件是否存在
  if (!file.exists(file)) {
    stop("文件不存在: ", file)
  }
  
  data = readr::read_tsv(file, col_names = TRUE, show_col_types = FALSE, quote = "")
  
  # 处理 remove 参数
  if (remove == "auto") {
    # 自动移除整列全是 NA 的列
    data = data[, colSums(is.na(data)) < nrow(data)]
  }
  
  # 返回处理后的数据
  return(data)
}
