#' BioCyc 富集分析
#'
#' 使用 BioCyc 的 SmartTables 服务进行富集分析
#'
#' @param session httr::handle对象，表示已建立的BioCyc会话
#' @param table_id 字符串，SmartTable 标识符（仅在 method="GET" 时使用）
#' @param orgid 字符串，指定生物体的 BioCyc ID，例如 "ECOLI" 代表大肠杆菌
#' @param values 字符向量，包含要分析的基因列表
#' @param method 字符串，指定使用的方法，可选 "GET" 或 "PUT"（默认为 "GET"）
#' @param key 字符串，富集分析类型，可选值包括 "enrich-all-gen", "enrich-go-cc", "enrich-go-bp", "enrich-go-mf", "enrich-genes-regulators-indirect", "enrich-genes-regulators", "enrich-cpds-pwys", 或 "enrich-genes-pwys"
#' @param type 字符串，分析类型，可选 "enrichment"、"depletion" 或 "enrichment-and-depletion"（默认为 "enrichment"）
#' @param threshold 数值，P 值阈值，介于 0 和 1 之间（默认为 0.1）
#' @param statistic 字符串，统计方法，可选 "fisher-exact"（默认）、"parent-child-union" 或 "parent-child-intersection"
#' @param correction 字符串，多重检验校正方法，可选 "none"（默认）、"bonferroni"、"bh"（Benjamini-Hochberg）或 "by"（Benjamini-Yekutieli）
#' @param format 字符串，上传数据的格式，可选 "json"、"xml" 或 "tsv"（仅在 method="PUT" 时使用）
#' @param class 字符串，数据类型，可选 "Genes" 或 "Compounds"（仅在 method="PUT" 且 format="tsv" 时使用）
#'
#' @return 数据框，包含富集分析结果
#' @export
#' 
#' @details With the GET method, runs an enrichment analysis on the first column of an existing SmartTable. To upload a file of genes or compounds and run an enrichment analysis on it in one step, use the PUT method, and also supply the args needed for the st-create service.
#' 
#' **Mode Arguments:**
#' 
#' - Both: key, type, threshold, statistic, correction
#' - With GET: id
#' - With PUT: orgid, class, values
#' 
#' **Arguments:**
#' 
#' - key: one value from enrich-all-gen, enrich-go-cc, enrich-go-bp, enrich-go-mf, enrich-genes-regulators-indirect, enrich-genes-regulators, enrich-cpds-pwys, or enrich-genes-pwys (Both)
#' - type: enrichment, depletion, or enrichment-and-depletion (Both)
#' - threshold: a number between 0 and 1; only include results with P-value less than this number (default = 0.1) (Both)
#' - statistic: fisher-exact (default), parent-child-union, or parent-child-intersection
#' - correction: none (default), bonferroni, bh (Benjamini-Hochberg), or by (Benjamini-Yekutieli)
#' - id: SmartTable ID (GET only)
#' - class: Genes or Compounds (PUT only)
#' - orgid: the identifier for the organism database (PUT only)
#' - values: an array of strings, which will be coerced into objects for the SmartTable in a single column (PUT only)
#' 
#' @md
#' @importFrom httr POST GET content authenticate
#' @importFrom jsonlite fromJSON
#' @examples \dontrun{
#' # 使用 GET 方法
#' result_get = biocyc_enrichment(method = "GET", table_id = "your_table_id", key = "enrich-all-gen", organism_id = "ECOLI", session = session)
#' print(result_get)
#'
#' # 使用 PUT 方法
#' gene_list = c("gene1", "gene2", "gene3")
#' result_put = biocyc_enrichment(method = "PUT", gene_list = gene_list, key = "enrich-genes-pwys", organism_id = "ECOLI", session = session, format = "tsv", class = "Genes")
#' print(result_put)
#' }
biocyc_enrichment = function(session, 
                             method = c("GET", "PUT"), table_id = NULL, 
                             key = "enrich-genes-pwys", 
                             type = "enrichment", threshold = 0.1, 
                             statistic = "fisher-exact", correction = "none", 
                             class = "Genes",
                             orgid = "ECOLI", values = c("trpA", "trpB")) {
  # BioCyc API 基础 URL
  base_url = "https://websvc.biocyc.org/st-enrichment"
  # 匹配method参数
  method = match.arg(method)
  # 根据method参数选择请求方式
  response = switch(method,
    "GET" = {
      # 准备请求体
      body = list(
        id = table_id,
        key = key,
        type = type,
        threshold = threshold,
        statistic = statistic,
        correction = correction
      )
      # 发送GET请求
      response = httr::GET(
        url = base_url,
        handle = session,
        query = body,
      ) 
      response
    },
    "PUT" = {
      body = list(
        orgid = orgid, 
        pgdb = orgid,
        class = class, 
        key = key, 
        type = type, 
        values = values,
        threshold = threshold, 
        statistic = statistic, 
        correction = correction
      )
      url = paste0(base_url, "?format=json")
      # 发送PUT请求
      response = httr::PUT(
        url = url,
        handle = session,
        body = jsonlite::toJSON(body, auto_unbox = TRUE),
        httr::add_headers("Content-Type" = "application/json", "Accept" = "application/json")
      )
      response
    }
  )
  
  # 检查响应状态
  if (httr::status_code(response) %in% c(200, 201)) {
    message("API 请求成功")
    content = jsonlite::fromJSON(httr::content(response, "text", encoding = "UTF-8"))
    return(content$id)
  } else {
    content = jsonlite::fromJSON(httr::content(response, "text", encoding = "UTF-8"))
    stop("API 请求失败：", content$error)
  }

}


#' 获取富集分析结果
#'
#' 此函数用于获取BioCyc富集分析的结果
#'
#' @param session httr::handle对象，表示已建立的BioCyc会话
#' @param enrichment_result_id 字符串，富集分析结果的唯一标识符
#'
#' @return 数据框，包含富集分析结果
#' @export
#'
#' @importFrom httr GET content status_code
#' @importFrom readr read_delim
#'
#' @examples
#' \dontrun{
#' session <- establish_biocyc_session("your_email@example.com", "your_password")
#' enrichment_result_id <- "your_enrichment_result_id"
#' result <- biocyc_get_enrichment_result(session, enrichment_result_id)
#' print(result)
#' }
biocyc_get_enrichment_result = function(session, enrichment_result_id) {
# BioCyc API 基础 URL
  base_url <- "https://websvc.biocyc.org/st-get"
  
  # 返回格式为json
  url = paste0(base_url, "?format=tsv&id=", enrichment_result_id)
  
  # 发送 GET 请求
  response <- httr::GET(
    url = url,
    handle = session
  )
  
  # 检查响应状态
  if (httr::status_code(response) == 200) {
    content <- httr::content(response, "text", encoding = "UTF-8")
    data = readr::read_delim(content, delim = "\t", col_names = TRUE, show_col_types = FALSE)
    return(data)
  } else {
    stop("检索富集分析结果失败: ", httr::content(response, "text"))
  }
}
