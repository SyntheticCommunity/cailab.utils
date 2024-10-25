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

#' 检索 BioCyc SmartTable
#'
#' 此函数用于检索 BioCyc SmartTable 的内容
#'
#' @param session httr::handle对象，表示已建立的BioCyc会话
#' @param table_id 字符串，SmartTable的唯一标识符
#'
#' @return 根据指定格式返回SmartTable的内容
#' @export
#'
#' @importFrom httr GET content status_code
#' @importFrom jsonlite fromJSON
#'
#' @examples
#' \dontrun{
#' session <- establish_biocyc_session("your_email@example.com", "your_password")
#' table_id <- "your_smart_table_id"
#' result <- retrieve_smart_table(session, table_id)
#' print(result)
#' }
#' @rdname biocyc_retrieve_smart_table
biocyc_retrieve_smart_table <- function(session, table_id) {
  # BioCyc API 基础 URL
  base_url <- "https://websvc.biocyc.org/st-get"
  
  # 返回格式为json
  url = paste0(base_url, "?format=json")

  # 构建查询参数
  query_params <- list(
    id = table_id
  )
  
  # 发送 GET 请求
  response <- httr::GET(
    url = url,
    handle = session,
    query = query_params,
    httr::add_headers("Accept" = "application/json")
  )
  
  # 检查响应状态
  if (httr::status_code(response) == 200) {
    content <- httr::content(response, "text", encoding = "UTF-8")
    data = jsonlite::fromJSON(content)
    return(data)
  } else {
    stop("检索 SmartTable 失败: ", httr::content(response, "text"))
  }
}

#' @export
#' @rdname biocyc_retrieve_smart_table
biocyc_get_smart_table = biocyc_retrieve_smart_table

#' 创建 BioCyc SmartTable
#'
#' 此函数用于创建一个新的 BioCyc SmartTable
#'
#' @param session httr::handle对象，表示已建立的BioCyc会话
#' @param pgdb 字符串，生物体数据库标识符，即 orgid（如 "ECOLI"）
#' @param type 字符串，第一列对象所属的类，如 'Genes'、'Compounds'。默认 "Genes"
#' @param name 字符串，SmartTable的名称（可选）
#' @param description 字符串，SmartTable的描述（可选）
#' @param values 字符串向量，取值
#'
#' @return 字符串，创建的SmartTable的 ID
#' @export
#' 
#' @details 
#' 
#' For json input files, parameters are encoded as part of the file format. 
#' 
#' **JSON Structure for SmartTable Data Retrieval and Creation**
#' 
#' JSON file structure:
#' 
#' - name (optional) - name field of SmartTable
#' - description (optional) - description field of SmartTable
#' 
#' Contents of the short form, which is for creating a single column of values only:
#' 
#' - type: an object class that values will be coerced into for the given database into the SmartTable
#' - pgdb: an org id for the database in which SmartTable objects will reside and be coerced with the given type
#' - values: an array of strings, which will be coerced into objects for the SmartTable in a single column
#' 
#' Contents of the long form, which is for creating multiple columns of values:
#' 
#' - columns: a list (JSON array) of columns, each of which is:
#' - name (optional): a string that will be the name of the column
#' - type: an object class that values will be coerced into for the SmartTable
#' - rows: a JSON array, each element is a dictionary mapping column ids to values. Each value corresponds to one cell in the SmartTable and contains:
#' - value: a string, number, or {frameid: , pgdb: } which will be coerced into an object for the SmartTable
#' 
#' JSON examples:
#' ```json
#' // Short form
#' {"name": "sample short-form group",
#' "description": "sample short-form description",
#' "pgdb": "ECOLI",
#' "type": "Genes",
#' "values": ["trpA", "trpB"]
#' }
#' 
#' // long form (2 columns)
#' {"name": "sample long-form group",
#'  "description": "This is a longer form of JSON used with a SmartTable.",
#'  "columns": [{"name": "Gene", "type": "Genes"}, {"name": "Expression Level"}]
#'  "rows": [{{"frameid": "EG11204", "pgdb": "ECOLI"}, "1.3"}, 
#'           {{"frameid": "EG11205", "pgdb": "ECOLI"}, "-2.2"}]
#' }
#' ```
#' @md 
#' @importFrom httr PUT content
#' @importFrom readr read_file
#' @examples \dontrun{
#' session <- establish_biocyc_session("your_email_address", "your_password")
#' smart_table_id <- create_smart_table(session, '/path/to/data.json')
#' print(paste("创建的SmartTable ID:", smart_table_id))
#' }
biocyc_create_smart_table = function(session, 
                              orgid = "ECOLI", 
                              name = "test",
                              type = c("Genes", "Compounds"),
                              description = NULL,
                              values = c("trpA", "trpB")) {
  base_url = "https://websvc.biocyc.org/st-create"
  type = match.arg(type)
  # 构建URL
  url = paste0(base_url, "?format=json")

  # 准备请求体
  data = list(name = name, type = type, pgdb = orgid, values = values, description = description)
  body = jsonlite::toJSON(data, auto_unbox = TRUE)

  # 发送PUT请求
  response = httr::PUT(
    url = url,
    handle = session,
    body = body,
    httr::add_headers("Content-Type" = "application/json")
  )
  
  # 检查响应状态
  if (httr::status_code(response) %in% c(200, 201)) {
    message("创建成功")
    # 处理响应内容
    content = httr::content(response, "text", encoding = "UTF-8")
    table_id = jsonlite::fromJSON(content)$id
    return(table_id)
  } else {
    content = httr::content(response, "text", encoding = "UTF-8")
    message = jsonlite::fromJSON(content)$error
    stop("创建失败: ", message)
  }
}

#' 建立BioCyc会话
#'
#' 此函数用于建立与BioCyc网站的会话连接。
#'
#' @param email 字符串，BioCyc账户的电子邮箱
#' @param password 字符串，BioCyc账户的密码
#' @param base_url 字符串，BioCyc API的基础URL，默认为"https://websvc.biocyc.org/"
#'
#' @return httr::handle对象，表示已建立的会话
#' @export
#'
#' @importFrom httr handle_pool POST status_code content
#' @examples
#' \dontrun{
#' session <- establish_biocyc_session("your_email@example.com", "your_password")
#' }
biocyc_session <- function(email = readline("请输入您的BioCyc注册邮箱: "), 
                           password = readline("请输入您的BioCyc密码: "), 
                           base_url = "https://websvc.biocyc.org/") {
  login_url <- paste0(base_url, "credentials/login/")
  
  session <- httr::handle(base_url)
  
  response <- httr::POST(
    url = login_url,
    handle = session,
    body = list(email = email, password = password),
    encode = "form"
  )
  
  if (httr::status_code(response) == 200) {
    message("登录成功")
    return(session)
  } else {
    stop("登录失败: ", httr::content(response, "text", encoding = "UTF-8"))
  }
}

#' 获取所有基因
#'
#' 此函数用于获取指定生物体数据库中的所有基因
#'
#' @param session httr::handle对象，表示已建立的BioCyc会话
#' @param pgdb 字符串，生物体数据库标识符（如 "ECOLI"）
#'
#' @return 数据框，包含所有基因信息
#' @export
#' @importFrom httr GET content status_code
#' @importFrom readr read_delim
#' @examples \dontrun{
#' session <- establish_biocyc_session("your_email@example.com", "your_password")
#' genes <- biocyc_get_all_genes(session, "ECOLI")
#' print(genes)
#' }    
biocyc_get_all_genes = function(session, orgid = "ECOLI") {
  url = paste0("https://websvc.biocyc.org/st-get?format=tsv&id=:ALL-GENES&orgid=", orgid)
  response = httr::GET(url, handle = session)
  if (httr::status_code(response) == 200) {
    content = httr::content(response, "text", encoding = "UTF-8")
    data = readr::read_delim(content, delim = "\t", col_names = TRUE, show_col_types = FALSE)
    return(data)
  } else {
    stop("获取所有基因失败: ", httr::content(response, "text", encoding = "UTF-8"))
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

#' 获取所有通路
#'
#' 此函数用于获取指定生物体数据库中的所有通路
#'
#' @param session httr::handle对象，表示已建立的BioCyc会话
#' @param orgid 字符串，生物体数据库标识符（如 "ECOLI"）
#'
#' @return 数据框，包含所有通路信息
#' @export
#' @importFrom httr GET content status_code
#' @importFrom readr read_delim
biocyc_get_all_pathways = function(session, orgid = "ECOLI") {
  url = paste0("https://websvc.biocyc.org/st-get?format=tsv&id=:ALL-PATHWAYS&orgid=", orgid)
  response = httr::GET(url, handle = session)
  if (httr::status_code(response) == 200) {
    content = httr::content(response, "text", encoding = "UTF-8")
    data = readr::read_delim(content, delim = "\t", col_names = TRUE, show_col_types = FALSE)
    return(data)
  } else {
    stop("获取所有通路失败: ", httr::content(response, "text"))
  }
}

#' 给 BioCyc SmartTable 添加属性列
#'
#' 此函数用于给现有的 BioCyc SmartTable 添加一个新的属性列
#'
#' @param session httr::handle对象，表示已建立的BioCyc会话
#' @param table_id 字符串，SmartTable的唯一标识符
#' @param property_id 字符串，要添加的属性名称
#' @param index 整数，基于哪一列添加新的转换列，从0开始计数（默认0）
#'
#' @return 布尔值，表示操作是否成功
#' @export
#'
#' @importFrom httr GET content status_code
#'
#' @examples
#' \dontrun{
#' session <- establish_biocyc_session("your_email@example.com", "your_password")
#' table_id <- "your_smart_table_id"
#' result <- biocyc_add_property_column(session, table_id, "common-name", 0)
#' print(result)
#' }
biocyc_add_property_column <- function(session, table_id, property_id = c("COMMON-NAME", "REACTION-LIST"), index = 0) {
  # BioCyc API 基础 URL
  base_url <- "https://websvc.biocyc.org/st-property"
  
  # 如果property_id是多个，则用逗号分隔
  if (length(property_id) > 1) {
    property_id = paste(property_id, collapse = ",")
  }
  # 构建查询参数
  query_params <- list(
    id = table_id,
    propertyid = property_id,
    index = index
  )
  
  # 发送 GET 请求
  response <- httr::GET(
    url = base_url,
    handle = session,
    query = query_params
  )
  
  # 检查响应状态
  if (httr::status_code(response) %in% c(200, 201)) {
    message("成功添加属性列")
    return(TRUE)
  } else {
    warning("添加属性列失败: ", httr::content(response, "text"))
    return(FALSE)
  }
}



#' 删除BioCyc SmartTable
#'
#' 此函数用于删除指定的BioCyc SmartTable。
#'
#' @param session httr::handle对象，表示已建立的BioCyc会话
#' @param table_id 字符串，要删除的SmartTable的唯一标识符
#'
#' @return 布尔值，表示操作是否成功（隐式返回）
#' @export
#'
#' @importFrom httr GET status_code content
#'
#' @examples
#' \dontrun{
#' session <- biocyc_session("your_email@example.com", "your_password")
#' result <- biocyc_delete_smart_table(session, "your_smart_table_id")
#' print(result)
#' }
biocyc_delete_smart_table <- function(session, table_id) {
  # BioCyc API 基础 URL
  base_url <- "https://websvc.biocyc.org/st-delete"
  
  # 构建查询参数
  query_params <- list(id = table_id)
  
  # 发送 GET 请求
  response <- httr::GET(
    url = base_url,
    handle = session,
    query = query_params
  )
  
  # 检查响应状态
  if (httr::status_code(response) %in% c(200, 201)) {
    message("成功删除SmartTable: ", table_id)
    invisible(TRUE)
  } else {
    warning("删除SmartTable失败: ", httr::content(response, "text", encoding = "UTF-8"))
    invisible(FALSE)
  }
}

