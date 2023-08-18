###################
# STRUCTURES
###################
# - note
# - experimental table generation
# - combination relationship
####################

###################
##    NOTE
###################
#
# COMBINATION SEPARATOR
#
# I used a backslash separator (i.e. "/") to join different strain into a
# synthetic combination. For example, when combined strains A1, B11, C2,
# the combination id is "A1/B11/C2". Please note the separator should not
# be contained in any strain id/names.
#

#######################################
## (PART) Experimental Table Generation
#######################################

#' The composition of community in a 8x8 plate (64 SynComs)
#'
#' We use a fast, extensible method to generate multiple SynComs in every
#' possible composition. The smallest unit is a 8x8 plate with 64 SynComs,
#' which are all the combinations of six different strains. Based on this,
#' one can generate as many as plates, and in that cases the combination
#' of SynComs could be 64x2, 64x2x2, 64x2x2, and so on. For each time we
#' add an extra strain, the number of total plates will double to fulfill
#' all additional strain combinations. In other words, the possible
#' combination of $n$ strain equals to $2^n$.
#'
#' @param plate_id a prefix in combination id
#' @param base_strain the base strain or community in a single plate
#' @param add_strain the id of added strains, which should contains 6 members
#' @param dim c(8,8)
#' @param return_array return an array if TRUE
#'
#' @return a tibble or an array
#' @export
#'
#' @examples
#'   one_plate(plate_id="",base_strain="",add_strain=LETTERS[1:6])
one_plate = function(plate_id = "P1",
                     base_strain = "",
                     add_strain = LETTERS[1:6],
                     dim = c(8, 8),
                     sep = "/",
                     return_array = FALSE){
  if (length(add_strain) != 6) stop("Number of added strains must be 6.")
  base = array(rep(base_strain, times = 64), dim)
  add1 = array(rep(c(add_strain[[1]], ""), each = 32), dim)
  add2 = array(rep(c(add_strain[[2]], ""), each = 16, times = 2), dim)
  add3 = array(rep(c(add_strain[[3]], ""), each = 8, times = 4), dim)
  add4 = array(rep(c(add_strain[[4]], ""), each = 4, times = 8), dim)
  add5 = array(rep(c(add_strain[[5]], ""), each = 2, times = 16), dim)
  add6 = array(rep(c(add_strain[[6]], ""), each = 1, times = 32), dim)

  add_all = list(base, add1, add2, add3, add4, add5, add6)
  combination = purrr::reduce(add_all, paste, sep = sep) |>
    gsub(pattern = paste0(sep, "+"), replacement = sep) |>
    trimws(whitespace = sep)
  well = paste0(rep(LETTERS[1:8],times=8),rep(1:8,each=8))
  data = tibble::tibble(
    combination_id = paste0(plate_id, well),
    well = well,
    combination = combination
  )
  if (return_array){
    data = data %>%
      dplyr::mutate(row=substring(well, 1,1),col=substr(well,2,2)) %>%
      dplyr::select(row, col, combination) %>%
      tidyr::pivot_wider(names_from = col, values_from = combination) %>%
      tibble::column_to_rownames(var = "row")
  } else {
    data = data %>% dplyr::select(-well)
  }

  return(data)
}


#######################################
## (PART) Combination Relationship
#######################################


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
    str_split(s, sep, simplify = TRUE) %>%
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
#' @examples
#' # example code
#'  is_child("A/B/C/D", "A/B/C")
is_child = function(parent, child, sep = "/", strict = TRUE){
  parent_member = stringr::str_split(parent, pattern = sep, simplify = TRUE)
  child_member = stringr::str_split(child, pattern = sep, simplify = TRUE)
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
#' @param sep separator of community string
#'
#' @return logcial
#' @export
#'
#' @examples
#' # example code
#'  is_relative("A/B/C","A/B")
is_relative = function(item1, item2, sep = "/"){
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
  comb_id = combinations(length(strains))
  if (depth != 0){
    keep = sapply(comb_id, function(x) length(strains) - length(x) <= depth)
    comb_id = comb_id[keep]
  }
  comb_str = sapply(comb_id, function(i) paste(strains[i], collapse = sep))
  return(comb_str)
}
