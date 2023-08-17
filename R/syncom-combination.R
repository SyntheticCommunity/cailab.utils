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


#' Test whether community a is the subset of community b
#'
#' @param parent parent community
#' @param child child community
#' @param sep separator of community string
#' @param strict if TRUE only child will be considered
#'
#' @return TRUE or FALSE
#' @example is_child("A/B/C/D", "A/B/C")
is_child = function(parent, child, sep = "/", strict = TRUE){
  parent_member = str_split(parent, pattern = sep, simplify = TRUE)
  child_member = str_split(child, pattern = sep, simplify = TRUE)
  # only keep child
  if (!strict) {
    return(all(child_member %in% parent_member))
  } else {
    return(all(child_member %in% parent_member,
               length(child_member) == length(parent_member) - 1))
  }
}

#' Test whether community a is the relative of community b
#'
#' @param item1 a string
#' @param item2 a string
#'
#' @return logcial
#' @export
#'
#' @example is_relative("A/B/C","A/B")
is_relative = function(item1, item2){
  if (is_child(item1, item2, strict = FALSE)) return(TRUE)
  if (is_child(item2, item1, strict = FALSE)) return(TRUE)
  return(FALSE)
}


#' Find n depth children of a synthetic community
#'
#' @param x a string like "A/B/C/D"
#' @param sep separator
#' @param depth if 0 all children will be retured
#'
#' @return string
#' @export
#'
#' @examples
#' sub_community("A/B/C/D", depth = 1)
sub_community = function(x, sep = "/", depth = 0){
  strains = str_split(x, pattern = sep, simplify = TRUE)
  comb_id = ggVennDiagram:::combinations(length(strains))
  if (depth != 0){
    keep = sapply(comb_id, function(x) length(strains) - length(x) <= depth)
    comb_id = comb_id[keep]
  }
  comb_str = sapply(comb_id, function(i) paste(strains[i], collapse = sep))
  return(comb_str)
}
