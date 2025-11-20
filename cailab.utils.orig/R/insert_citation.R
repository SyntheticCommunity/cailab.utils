#' Insert Citation
#'
#' 根据 DOI 或 PubMed ID 插入引用
#'
#' @param id 文献的 DOI 或 PubMed ID
#' @param bib_file BibTeX 文件的路径，默认为项目根目录下的 "reference.bib"
#'
#' @return 插入的引用的 BibTeX 引用键
#' @export
#'
#' @importFrom httr GET add_headers content
#' @importFrom xml2 read_xml xml_find_first xml_text
#' @importFrom purrr map_dfr
insert_citation = function(id, bib_file = "reference.bib") {
  # 获取 ID 类型
  id_type = type_of_id(id)
  
  # 根据 ID 类型获取引用信息
  citation = switch(id_type,
    "pubmed" = get_pubmed_record(id),
    "doi" = get_doi_record(id),
    stop("无效的 ID 类型")
  )

  cite_key = citation$citekey
  
  # 获取项目根目录
  root_dir = tryCatch(
    rprojroot::find_root(rprojroot::is_rstudio_project),
    error = function(e) getwd()
  )
  
  # 构建完整的 BibTeX 文件路径
  bib_file_path = file.path(root_dir, bib_file)
  
  # 将 BibTeX 条目追加到文件
  cat(citation, file = bib_file_path, append = TRUE)
  
  # 返回 BibTeX 引用键
  return(cite_key)
}

#' 判断 ID 的类型
#'
#' 该函数自动判断输入的 ID 是 DOI 还是 PubMed ID。
#'
#' @param id 字符串，输入的 ID。
#'
#' @return 字符串，"doi" 或 "pubmed"。
#' @export

#' @examples
#' type_of_id("10.1000/xyz123")  # 返回 "doi"
#' type_of_id("12345678")        # 返回 "pubmed"
type_of_id = function(id) {
  if (grepl("^10\\.[0-9]{4,9}/[-._;()/:A-Z0-9]+$", id, ignore.case = TRUE)) {
    return("doi")
  } else if (grepl("^\\d+$", id)) {
    return("pubmed")
  } else {
    stop("无法识别的 ID 类型")
  }
}

#' 从 PubMed 获取文献记录
#'
#' 该函数使用 PubMed ID 从 PubMed 数据库获取文献信息。
#'
#' @param pubmed_id 字符串，PubMed ID。
#'
#' @return 列表，包含文献的详细信息。
#' @export
#' @examples
#' \dontrun{
#' record = get_pubmed_record("12345678")
#' print(record)
#' }
#'
get_pubmed_record = function(pubmed_id) {
  base_url = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi"
  query = list(
    db = "pubmed",
    id = pubmed_id,
    retmode = "xml"
  )
  
  # 发送请求
  response = httr::GET(base_url, query = query)
  
  # 检查请求是否成功
  if (httr::status_code(response) != 200) {
    stop("无法从 PubMed 获取记录")
  }
  
  xml_content = httr::content(response, "text", encoding = "UTF-8")
  xml_doc = xml2::read_xml(xml_content)
  
  title = xml2::xml_text(xml2::xml_find_first(xml_doc, "//ArticleTitle"))
  authors = xml2::xml_text(xml2::xml_find_first(xml_doc, "//AuthorList"))
  journal = xml2::xml_text(xml2::xml_find_first(xml_doc, "//Journal/Title"))
  year = xml2::xml_text(xml2::xml_find_first(xml_doc, "//PubDate/Year"))
  volume = xml2::xml_text(xml2::xml_find_first(xml_doc, "//JournalIssue/Volume"))
  issue = xml2::xml_text(xml2::xml_find_first(xml_doc, "//JournalIssue/Issue"))
  pages = xml2::xml_text(xml2::xml_find_first(xml_doc, "//MedlinePgn"))
  doi = xml2::xml_text(xml2::xml_find_first(xml_doc, "//ArticleId[@IdType='doi']"))
  
  bibtex_key = paste0(
    tolower(authors[[1]]),
    substr(year, 3, 4)
  )

  bibtex = paste0(  
    "@article{", bibtex_key, ",\n",
    "  title = {", title, "},\n",
    "  author = {", authors, "},\n",
    "  journal = {", journal, "},\n",
    "  year = {", year, "},\n",
    "  volume = {", volume, "},\n",
    "  issue = {", issue, "},\n",
    "  pages = {", pages, "},\n",
    "  doi = {", doi, "}\n",
    "}\n"
  )

  return(list(citekey = bibtex_key, citation = bibtex))
}

#' 从 doi.org 获取文献引用信息
#'
#' @param doi 字符串，文献的 DOI
#' @return 包含文献引用信息的列表
#' @export
#'
#' @examples
#' \dontrun{
#' record = get_doi_record("10.1038/nature12373")
#' print(record)
#' }
get_doi_record = function(doi) {
  # 使用 rcrossref 包获取 DOI 记录
  record = rcrossref::cr_cn(doi, format = "bibtex")
  cite_key = strsplit(record, ",")[[1]][1] |> 
    gsub(pattern = "^.*\\{", replacement = "")
  return(list(citekey = cite_key, citation = record))
}
