## 进行（文献）网络分析的函数


## 简化网络
## 限制 node 数目和edge.weight


#' Construct Networks of Different Tags
#'
#' @param M  bibliometrix data frame
#' @param from start of PY
#' @param to  end of PY
#' @param nNode Maximum number of nodes presented in the network
#' @param edge_weight_cutoff  edge weight cutoff
#' @param analysis type of analysis
#' @param network type of network
#' @param field data column for network construction
#' @param remove_keyword regex used to filter data
#' @param ... pass to `biblio_network()`
#'
#' @return visNetwork object
#' @export
#'
#' @name simplified_network
#'
#' @examples
#' library("bibliometrixData")
#' data("garfield")
#' author_network(garfield)
simplified_network <- function(M, from = NULL, to = NULL, nNode = 30,
                               remove_keyword = NULL,
                               edge_weight_cutoff = 1,
                               analysis,
                               network,
                               field,
                               delete_isolate = TRUE,
                               graph = FALSE,
                               ...
){
  if (!field %in% colnames(M)) stop(paste0("M doesn't have ", field))
  M$PY <- as.numeric(M$PY)
  PY_from <- min(M$PY, na.rm = TRUE)
  PY_to   <- max(M$PY, na.rm = TRUE)
  if (is.null(from)) from <- PY_from
  if (is.null(to)) to <- PY_to
  if (from > to) stop(paste0("from is bigger than to."))

  m <- M %>% dplyr::filter(PY >= from, PY <= to)
  net_mat <- bibliometrix::biblioNetwork(m,
                           analysis = analysis,
                           network = network, sep = ";", ...)

  if (is.na(field)) stop("must specify Field tag (ID, AU, etc).")

  members <- unlist(strsplit(m[,field], split = ";")) %>%
    trimws() %>%
    table() %>%
    sort(decreasing = T) %>%
    tibble::enframe(name = "field",value = "nRecord")
  if (!is.null(remove_keyword)) {
    members <- members %>%
      dplyr::filter(!stringr::str_detect(field, remove_keyword))
  }
  idx <- rownames(net_mat) %in% head(members$field,nNode)
  net_mat_s <- net_mat[idx,idx]

  net <- igraph::graph.adjacency(net_mat_s, weighted = TRUE, mode = "undirected")

  g <- net
  igraph::vertex.attributes(g)$size <- igraph::degree(g)
  g <- igraph::delete.edges(g,igraph::E(g)[igraph::edge.attributes(g)$weight < edge_weight_cutoff])
  g <- igraph::simplify(g)
  if (delete_isolate) g <- bibliometrix:::delete.isolates(g)

  if(graph == TRUE) return(g)

  # 聚类结果
  member <- igraph::membership(igraph::cluster_louvain(g)) %>%
    tibble::enframe(name = "id", value = "cluster")
  color <-  grDevices::colorRampPalette(RColorBrewer::brewer.pal(8,"Paired"))(length(unique(member$cluster)))
  names(color) <- unique(member$cluster)
  member$color <- color[member$cluster]

  visData <- visNetwork::toVisNetworkData(g)
  visData$nodes <- visData$nodes %>%
    dplyr::left_join(igraph::degree(g) %>% tibble::enframe(name = "id")) %>%
    dplyr::left_join(member)
  visData$edges$value <- visData$edges$weight
  visNetwork::visNetwork(visData$nodes, visData$edges,physics=FALSE) %>%
    visNetwork::visLayout(randomSeed = 20200721) %>%
    visNetwork::visOptions(manipulation = FALSE,
               highlightNearest = list(enabled = TRUE, degree = 1, hover = TRUE))
}


#' @export
#' @rdname simplified_network
country_network <- function(M,
                            analysis = "collaboration",
                            network = "countries",
                            field = "AU_CO_NR",
                            edge_weight_cutoff = 5,
                            nNode = 20,
                            graph = FALSE,
                            ...){
  simplified_network(M,
                     analysis = analysis,
                     network = network,
                     field = field,
                     nNode =  nNode,
                     edge_weight_cutoff = edge_weight_cutoff,
                     graph = graph,
                     ...)
}



#' @export
#' @rdname simplified_network
author_network <- function(M,
                           analysis = "collaboration",
                           network = "authors",
                           field = "AU",
                           edge_weight_cutoff = 5,
                           nNode = 200,
                           graph = FALSE,
                           ...){
  simplified_network(M,
                     analysis = analysis,
                     network = network,
                     field = field,
                     nNode =  nNode,
                     edge_weight_cutoff = edge_weight_cutoff,
                     graph = graph,
                     ...)
}


#' @export
#' @rdname simplified_network
university_network <- function(M,
                               analysis = "collaboration",
                               network = "universities",
                               field = "AU_UN_NR",
                               edge_weight_cutoff = 10,
                               nNode = 30,
                               graph = FALSE,
                               ...){
  simplified_network(M,
                     analysis = analysis,
                     network = network,
                     field = field,
                     nNode =  nNode,
                     edge_weight_cutoff = edge_weight_cutoff,
                     graph = graph,
                     ...)
}


#' @export
#' @rdname simplified_network
keyword_network <- function(M,
                            nNode = 100,
                            edge_weight_cutoff = 3,
                            field = "ID",
                            analysis = "co-occurrences",
                            network = "keywords",
                            graph = FALSE,
                            ...){
  simplified_network(M=M,
                     nNode=nNode,
                     field = field,
                     edge_weight_cutoff = edge_weight_cutoff,
                     analysis=analysis,
                     network = network,
                     graph = graph,
                     ...)
}


## 网络相关的函数

range01 <- function(x){(x-min(x))/(max(x)-min(x))}


#' Modification of igraph Object
#'
#' @param g igraph object
#'
#' @return  a new igraph object
#' @export
#'
#' @name graph_add_node
graph_add_node_pagerank <- function(g){
  V(g)$pagerank <- page.rank(g)[["vector"]]
  return(g)
}

#' @export
#' @rdname graph_add_node
graph_add_node_degree <- function(g){
  V(g)$degree <- degree(g)
  return(g)
}

#' 添加节点属性
graph_add_node_attr <- function(g, data, id = "id", cols = colnames(data)){
  # 依据 id 的对应关系将 data 中的属性加入到graph中，
  # id 是 data 中 node id 的列名, cols 是 data 中用到的列名
  # ToDO: 跳过已有的属性还是覆盖？
  g.id <- names(V(g))
  data <- as.data.frame(data)
  rownames(data) <- data[,id]
  cols <- cols[!cols %in% id]
  for (i in 1:length(cols)){
    vertex_attr(g, name =  cols[[i]]) <- data[g.id, cols[[i]]]
  }
  return(g)
}


#' set node size
graph_set_node_size <- function(g, by = "degree", scale01 = TRUE, max_size = 10){
  value <- vertex_attr(g, name = by)
  if (isTRUE(scale01)){
    value <- range01(value)
  }
  size <- (value * max_size) + 1
  V(g)$size <- size
  return(g)
}



graph_set_node_color <- function(g, by = "year", decreasing = FALSE, scale01 = FALSE, palette_name = "YlOrRd"){
  ## 为 graph 设置节点颜色
  ## 默认按年份着色，或者其它 node 属性着色
  value <- igraph::vertex_attr(g, name = by)
  if (isTRUE(scale01)) {
    value <- range01(value)
  }
  uniq_value <- sort(unique(value),decreasing = decreasing)
  my_palette <- RColorBrewer::brewer.pal(n = 7, name = palette_name)

  nColor <- 100
  if (length(uniq_value) < 100 ) nColor <- length(uniq_value)
  colors <- grDevices::colorRampPalette(my_palette)(nColor)
  names(colors) <- uniq_value

  igraph::V(g)$color <- colors[as.character(value)]

  return(g)
}



graph_subgraph <- function(g, by = "degree", slice = "PY", topN = 10, ratio = 0.1){
  if (!by %in% igraph::vertex_attr_names(g)) stop(by, " is not a graph attribute.\n")
  if (!slice %in% igraph::vertex_attr_names(g)) stop(slice, " is not a graph attribute.\n")
  data <- visNetwork::toVisNetworkData(g)
  nodes <- data$nodes %>% dplyr::group_by(.data$PY) %>%
    dplyr::arrange(dplyr::desc(degree)) %>%
    dplyr::filter(dplyr::row_number() <= topN)
  igraph::induced.subgraph(g, vids = nodes$id)
}



vis_histNet <- function(g,
                        node.title = "title",
                        node.size = "size",
                        node.color = "color",
                        edge.color = "color",
                        layout = "layout_with_fr"){
  data <- visNetwork::toVisNetworkData(g)

  visNetwork::visNetwork(nodes = data$nodes,
             edges = data$edges) %>%
    visNetwork::visIgraphLayout(physics = FALSE, layout = layout) %>%
    visNetwork::visNodes(size = node.size, color = node.color, title = node.title) %>%
    visNetwork::visEdges(color = edge.color) %>%
    visNetwork::visOptions(highlightNearest = list(enabled = TRUE, hover = FALSE)) %>%
    visNetwork::visExport()

}


