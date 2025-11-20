
#' 检索 BioCyc SmartTable
#'
#' 此函数用于检索 BioCyc SmartTable 的内容
#'
#' @param session httr::handle对象，表示已建立的BioCyc会话
#' @param table_id 字符串，SmartTable的唯一标识符
#' @param format 字符串，返回格式，可选 "json" 或 "tsv"，默认 "json"
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
biocyc_retrieve_smart_table <- function(session, table_id, format = c("json", "tsv")) {
  # BioCyc API 基础 URL
  base_url <- "https://websvc.biocyc.org/st-get"
  
  # 返回格式为json
  format = match.arg(format)
  url = paste0(base_url, "?format=", format)

  # 构建查询参数
  query_params <- list(
    id = table_id
  )
  
  # 发送 GET 请求
  response <- httr::GET(
    url = url,
    handle = session,
    query = query_params
  )
  
  # 检查响应状态
  if (httr::status_code(response) == 200) {
    content <- httr::content(response, "text", encoding = "UTF-8")
    if (format == "json") {
      data = jsonlite::fromJSON(content)
    } else {
      data = readr::read_delim(content, delim = "\t", col_names = TRUE, show_col_types = FALSE)
    }
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
#' @param orgid 字符串，生物体数据库标识符，即 orgid（如 "ECOLI"）
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
biocyc_create_smart_table = function(
  session, 
  orgid = "ECOLI", 
  name = "test",
  type = c("Genes", "Compounds", "Reactions", "Pathways", "Proteins", "Transcription-Units", "Attenuators"),
  description = NULL,
  values = c("trpA", "trpB")
) {
  base_url = "https://websvc.biocyc.org/st-create"
  #type = match.arg(type)
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
    # 处理响应内容
    content = httr::content(response, "text", encoding = "UTF-8")
    table_id = jsonlite::fromJSON(content)$id
    message("创建成功，返回的 SmartTable ID 为: ", table_id)
    return(table_id)
  } else {
    content = httr::content(response, "text", encoding = "UTF-8")
    message = jsonlite::fromJSON(content)$error
    stop("创建失败: ", message)
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
  
  # 如果property_id是多个，则分别添加
  if (length(property_id) > 1) {
    cli::cli_progress_bar("添加多个属性列: ", total = length(property_id))  
    for (i in seq_along(property_id)) {
      cli::cli_progress_update()
      biocyc_add_property_column(session, table_id, property_id[[i]], index)
    }
  } else {
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
      message("成功向SmartTable ", table_id, " 添加属性列: ", property_id)
      invisible(TRUE)
    } else {
      warning("向SmartTable ", table_id, " 添加属性列 ", property_id, " 失败: ", httr::content(response, "text", encoding = "UTF-8"))
      invisible(FALSE)
    }
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

