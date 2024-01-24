


# horizontal bar plot
#' @import ggplot2 forcats
hbarplot <- function(d, n=NULL, show = c("rank","name"), sort = TRUE, decreasing = TRUE){
  show <- match.arg(show)
  if (is.factor(d)) d <- fct_count(d)
  if (is.vector(d)) d <- table(d)
  if (is.table(d) & sort)  d <- sort(d, decreasing = decreasing)
  if (is.table(d)) d <- as.data.frame(d)
  if (ncol(d) != 2) stop("data must have only two columns.")
  if (is.numeric(n)) d <- head(d, n)
  colnames(d) <- c("name","value")
  d <- d %>%
    mutate(no = dplyr::row_number()) %>%
    mutate(no = factor(.data$no, levels = rev(.data$no)),
           name = fct_rev(.data$name))
  v <- max(d$value)/2
  v_label <- (max(d$value) - min(d$value)) / 40
  p <- ggplot(d)
  if (show == "rank") p <- p + aes(.data$no, .data$value, label = .data$name)
  if (show == "name") p <- p + aes(.data$name, .data$value, label = .data$value)
  p + geom_col() +
    scale_y_continuous(expand = expansion(mult = c(0,.02))) +
    geom_text(aes(y = .data$value - v_label), size = 3,
              vjust = 0.3, hjust = 1, data = function(d) d[d$value > v, ], color = "white", fontface = "bold") +
    geom_text(aes(y = value + v_label), size = 3,
              vjust = 0.5, hjust = 0, data = function(d) d[d$value <= v, ]) +
    coord_flip() +
    theme_light() +
    theme(axis.text.y = element_text(face = "bold",
                                     margin = margin(t = 1, r = 0, b = 0, l = 0, unit = "pt")))
}

# 对向量 x 或 table x 绘制饼状图
ggpie <- function(x, sort = TRUE, decreasing = FALSE){
  if (is.factor(x)) x <- as.character(x)
  if (is.vector(x)) x <- table(x)
  if (!is.table(x)) stop("Give me a table, please.")
  if (sort) x <- sort(x, decreasing = decreasing)
  df <- as.data.frame(x) %>%
    dplyr::as_tibble()
  n <- length(x)
  colnames(df) <- c("name","freq")
  df <- df %>%
    dplyr::mutate(name = forcats::fct_rev(.data$name)) %>%
    dplyr::mutate(percent = paste0(round(.data$freq / sum(.data$freq) * 100, 1), "%"))
  ggplot2::ggplot(df, ggplot2::aes(x = factor(1), .data$freq, fill = .data$name)) +
    ggplot2::geom_col(width = 1, color = "white") +
    shadowtext::geom_shadowtext(aes(label = .data$percent, bg.colour = "white", color = .data$name),
                    size = 4,
                    hjust = 0.5,
                    position = ggplot2::position_stack(0.5),
                    show.legend = FALSE) +
    ggplot2::coord_polar("y") +
    ggplot2::theme_void() +
    ggplot2::guides(fill = ggplot2::guide_legend(reverse = T))
}


#' tableTag downstream plot
#'
#' @param M bibliometrix dataframe
#' @param Tag passed to tableTag()
#' @param n top n
#'
#' @return a ggplot object
#' @export
#'
#' @examples
#' library("bibliometrixData")
#' data("garfield")
#' tableTag_barplot(garfield, Tag = "AU")
tableTag_barplot <- function(M, Tag = "AU", n = 30){
  d <- tableTag(M,Tag = Tag) %>%
    tibble::enframe() %>%
    dplyr::filter(name != "NA") %>%
    dplyr::mutate(name = forcats::as_factor(as.character(.data$name))) %>%
    utils::head(n)
  v <- max(d$value)/2
  title <- paste0("文章数量Top",n)
  hbarplot(d) +
    ggplot2::labs(x = NULL, y = "No. of record", title = title)
}

# 对一批论文进行四维分析，显示国家、机构、人员和期刊
four_dimension_barplot <- function(M, tags = c("AU","AU_CO_NR","AU_UN_NR","J9")){
  plots <- lapply(tags, function(x){
    tableTag_barplot(M, Tag = x, n = 10) + labs(title = "")
  })
  cowplot::plot_grid(plotlist = plots, labels = "AUTO")
}
