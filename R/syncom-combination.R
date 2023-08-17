#' Sort combination in a string
#'
#' String is used as combination name. However, the combination of A and B can be
#' "A/B" or "B/A", this would make it difficult in comparison of combination names.
#' By using this function, the name of strains included in a combination will be sorted
#' alphabetically, so that the combination names can be identical and human-friendly.
#'
#' @param x a string or a character vector
#' @param sep separator
#'
#' @return a string
#' @export
#'
#' @importFrom stringr str_sort str_split_1
#'
#' @examples
#'   sort_combination("A1/A11/A2/B3/D5/C11")
#'   sort_combination(c("A1/A11/A2/B3/D5/C11","A1/A11/A25/B3/D18/C11") )
sort_combination = function(x, sep = "/"){
  l = lapply(x, function(s){
    str_split_1(s, sep) %>%
      str_sort(numeric = TRUE) %>%
      paste0(collapse = sep)
  })
  unlist(l)
}
