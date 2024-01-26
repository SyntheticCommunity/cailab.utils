authorProdOverTime2 <- function(M, k = 10, graph = TRUE) {
  # 修改 bibliometrix 的函数
  M$TC = as.numeric(M$TC)
  M$PY = as.numeric(M$PY)
  AU = names(tableTag(M, "AU"))
  k = min(k, length(AU))
  AU = AU[1:k]
  Y = as.numeric(substr(Sys.time(), 1, 4))
  if (!("DI" %in% names(M))) {
    M$DI = "NA"
  }

  list <- lapply(1:length(AU), function(i){
    ind = which(regexpr(AU[i], M$AU, fixed = TRUE) > -1)
    TCpY = M$TC[ind] / (Y - M$PY[ind] + 1)
    dplyr::tibble( Author = rep(AU[i], length(ind)),
            year = M$PY[ind],
            TI = M$TI[ind],
            SO = M$SO[ind],
            DOI = M$DI[ind],
            TC = M$TC[ind],
            TCpY = TCpY )
  })
  df <- do.call("rbind", list)
  df2 <- dplyr::group_by(df, .data$Author, .data$year) %>%
    dplyr::summarise(
      freq = length(.data$year),
      TC = sum(.data$TC),
      TCpY = sum(.data$TCpY)
    )
  df2 = as.data.frame(df2)
  df2$Author = factor(df2$Author, levels = AU[k:1])
  g <- ggplot2::ggplot(df2, aes(.data$year,.data$Author)) +
    ggplot2::geom_point(ggplot2::aes(alpha = .data$TCpY, size = .data$freq),
               color = "dodgerblue4") +
    ggplot2::scale_size(range = c(2, 6)) +
    ggplot2::scale_alpha(range = c(0.3, 1)) +
    ggplot2::scale_x_continuous(breaks = function(x) seq(min(x),max(x),by = 2)) +
    ggplot2::guides(size = ggplot2::guide_legend(order = 1,
                               "N.Articles"),
           alpha = ggplot2::guide_legend(order = 2,
                                "TC/Year")) +
    ggplot2::labs(title = "Top-Authors' Production over the Time") +
    ggplot2::geom_line(
      ggplot2::aes(group = .data$Author),
      size = 1,
      color = "firebrick",
      alpha = 0.3
    )
  df$DOI = as.character(df$DOI)
  res <- list(dfAU = df2,
              dfPapersAU = df,
              graph = g)
  if (isTRUE(graph)) {
    return(g)
  } else{
    return(res)
  }

}

#' @export
tableTag <- function (M, Tag = "CR", sep = ";") {
  if (Tag %in% c("AB", "TI")) {
    M = bibliometrix::termExtraction(M, Field = Tag, stemming = F, verbose = FALSE)
    i = dim(M)[2]
  }
  else {
    i <- which(names(M) == Tag)
  }
  if (Tag == "C1") {
    M$C1 = gsub("\\[.+?]", "", M$C1)
  }
  Tab <- unlist(strsplit(as.character(M[, i]), sep))
  # Tab <- trimws(trimES(gsub("\\.|\\,", " ", Tab)))
  Tab <- Tab[Tab != ""]
  Tab <- sort(table(Tab), decreasing = TRUE)
  return(Tab)
}


# 提取历史引证网络中的论文

#' @export
extract_from_hist_graph <- function(M=NULL, g=NULL){
  name <- igraph::V(g)$name
  doi <- stringr::str_extract_all(name, "10\\.[0-9]+\\/\\S+")
  doi <- unlist(doi)
  M %>% dplyr::filter(toupper(.data$DI) %in% toupper(doi))
}

#' @export
DT_output <- function(M, caption = "",
                      filename = knitr::fig_path(),
                      column = c("TI","DI","TC")){
  columns <- colnames(M)
  if ("SR" %in% columns) rownames(M) <- M$SR
  M$link <- permanent_link(type = "html",id = M$DI, title = M$TI, alt = "")
  DT::datatable(M %>% select(dplyr::all_of(c("link","TC"))),
                colnames = c("Title","Cited times"),
                escape = FALSE,
                rownames = TRUE,
                filter = "top",
                width = "95%",
                caption = caption,
                extensions = c("Buttons","FixedColumns"),
                options=list(dom = 'Bfrtip',
                             scrollX = TRUE,
                             fixedColumns = TRUE,
                             pageLength = 10,
                             buttons=list(
                               'pageLength',
                               list(extend='copy'),
                               list(extend="excel",
                                    filename=filename,
                                    header=TRUE,
                                    title="")
                             ),
                             columnDefs=list(
                               list(width="80%",targets=1),
                               list(width="10%",targets="_all")
                             ),
                             lengthMenu=list(c(10,20,50,100,200,-1),
                                             c("10","20","50","100","200","All")),
                             autoWidth=TRUE)) %>%
    DT::formatStyle(fontSize="9pt",columns = 0:4)
}

permanent_link <- function(base_url="https://doi.org/",
                           type=c("markdown","html"),
                           id=NULL,title=NULL,alt=NULL){
  type <- match.arg(type)
  if (type == "markdown") s <- paste0("[",title,"](",base_url,id," \"",alt,"\")")
  if (type == "html") s <- paste0('<a href="',base_url,id,'" alt="',alt,'">',title,'</a>')
  return(s)
}

# 在指定项中查找
grep_in_field <- function(M, pattern, Field = "C1"){

}


# content analysis functions


# 整合多个关键词为一个关键词
keywords_from <- function(..., list = NULL, name = "primary"){
  keyword_list <- list(...)
  if (!is.null(list)) keyword_list <- c(keyword_list, list)
  result <- lapply(keyword_list, function(x){
    x[[name]]
  })
  paste0(unlist(result), collapse = "|")
}

# 根据检索词对文献进行分类

#' Tag record by regular expression search
#'
#' @param x character
#' @param name the name of new column
#' @param pattern regex
#' @param pattern.names pattern names
#' @param sep default is ";"
#'
#' @return a table
#' @export
tag_by_regex <- function(x, pattern, pattern.names = names(pattern), sep = ";"){
  nRecord <- length(x)
  result <- vector("list", length = nRecord)
  nPattern <- length(pattern)
  for (i in 1:nRecord){
    this_record <- x[[i]]
    idx <- vector(length = nPattern)
    for (j in 1:nPattern){
      this_pattern <- pattern[[j]]
      if (!is.na(this_record) & stringr::str_detect(this_record, this_pattern)) idx[[j]] <- TRUE
    }
    result[[i]] <- paste0(pattern.names[idx], collapse = sep)
  }
  return(unlist(result))
}


# 将排在后面的项目合并成 others
shrink_lvl <- function(x, sort = TRUE, keep = 9, other = "Other"){
  if (is.factor(x)) x <- as.character(x)
  lvl <- names(sort(table(x), decreasing = TRUE))
  lvl_new <- head(lvl, n = keep)
  ret <- rep(other, times = length(x))
  idx <- x %in% lvl_new
  ret[idx] <- x[idx]
  ret <- factor(ret, levels = c(lvl_new, other))
  return(ret)
}

# 对问卷中的选择题进行可视化
# 适用于问卷星的导出数据
summarise_plot <- function(data,
                           question = "Q1",
                           plot = c("pie","bar"),
                           multi_choice = FALSE,
                           row_split = "┋"  ){
  plot <- match.arg(plot)
  if (multi_choice) data <- data %>% separate_rows(question,sep = row_split)
  x <- data[[question]]
  x <- stringr::str_wrap(x, width = 24, exdent = 4)
  if (plot == "pie") p <- ggpie(x, sort = FALSE) +
    ggplot2::guides(fill = ggplot2::guide_legend(reverse = TRUE)) +
    ggplot2::theme(legend.text = ggplot2::element_text(margin = margin(t = 2, b = 2)))
  if (plot == "bar") p <- hbarplot(x, show = "name", sort = FALSE)
  return(p)
}


# 根据问题，获取数据子集（多个列）
subset_question_data <- function(data, question){
  colname <- colnames(data)
  idx <- which(stringr::str_detect(colname, question))
  data[idx]
}

# 搜索问题，根据问题的类型自动选择绘制饼图或条形图
# (如果是单选题且选项数目＜3，则绘制饼图；否则为柱状图)
# 适用于蜂鸟问卷的导出数据
plot_this_question <- function(data, question,
                               multi_choice = "auto",
                               plot = c("auto","pie","bar"), ...){
  plot <- match.arg(plot)
  colname <- colnames(data)
  idx <- which(stringr::str_detect(colname, question))
  if (multi_choice == "auto"){
    multi_choice <- FALSE
    if (length(idx) > 2) multi_choice <- TRUE
    if (any(stringr::str_detect(colname[idx], "多选"))) multi_choice <- TRUE
  }
  if (multi_choice) {
    x <- unlist(data[idx]) %>% as.character()
  } else {
    x <- data[[idx[[1]]]]
  }

  if (plot == "auto"){
    if (multi_choice | length(unique(x)) > 3) {
      plot <- "bar"
    } else {
      plot <- "pie"
    }
  }
  if (plot == "pie") p <- ggpie(x, ...)
  if (plot == "bar") p <- hbarplot(x, ...)
  return(p + ggplot2::labs(x = "", y = "", fill = ""))
}


# 搜索问题，获得问题题干
# 适用于蜂鸟问卷的导出数据
get_question_name <- function(data, question){
  colname <- colnames(data)
  idx <- which(str_detect(colname, question))
  name <- str_extract(colname[idx][[1]], "([^\\.]+\\？)")
  return(name)
}

# read WoS export analysis summary
read_wos_tsv <- function(file){
  data <- read.delim(file = file, header = TRUE, comment.char = "(", encoding = "UTF-8")
  colnames <- colnames(data)
  field <- colnames[[1]]
  colnames(data) <- c("Group","Record","Percent")
  list(data = data, field = field)
}

# just a optimized ggplotly()
plot.ly <- function(g, tooltip = c("text"), ...) {
  plotly::ggplotly(g, tooltip = tooltip, ...) %>%
    plotly::config(displaylogo = FALSE,
           modeBarButtonsToRemove = c("sendDataToCloud", "pan2d",
                                      "select2d", "lasso2d", "toggleSpikelines",
                                      "hoverClosestCartesian", "hoverCompareCartesian")) %>%
    plotly::layout(xaxis = list(fixedrange = TRUE)) %>% plotly::layout(yaxis = list(fixedrange = TRUE))
}

# determine wheter it is part of China
is.part_of_china <- function(x) {
  stringr::str_detect(x,
             pattern = stringr::regex("CHINA|TAIWAN|HONG KONG|MACAO",
                                      ignore_case = T))
}


# only keep Article and Review in DT field
simplify_document_type <- function(x){
  article_review <- regex("^Review|Article$", ignore_case = TRUE)
  x[!stringr::str_detect(x, article_review)] <- "Others"
  return(x)
}

