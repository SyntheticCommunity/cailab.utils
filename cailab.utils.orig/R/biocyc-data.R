#' BioCyc 数据库属性说明
#'
#' BioCyc 数据库中可用的属性列表及其说明
#'
#' @format 一个 tibble 数据框,包含以下列:
#' \describe{
#'   \item{id}{属性的唯一标识符}
#'   \item{description}{属性的详细说明}
#' }
#' @source BioCyc 数据库文档
#' @name properties
NULL

#' BioCyc 服务可用转换类型
#'
#' BioCyc 数据库中可用的网络转换类型及其说明,包括化合物、反应和通路之间的关系
#'
#' @format 一个 tibble 数据框,包含以下列:
#' \describe{
#'   \item{name}{转换类型的描述性名称}
#'   \item{id}{转换类型的唯一标识符}
#'   \item{description}{转换类型的详细说明}
#' }
#' @source BioCyc 数据库文档
#' @name transformations
NULL
