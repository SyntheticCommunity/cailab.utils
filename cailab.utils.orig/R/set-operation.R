#' Get all possible combinations of n sets
#'
#' @param n dim
#' @export
#'
#' @importFrom utils combn
combinations <- function(n){
  l <- lapply(seq_len(n), function(x){
    m <- combn(n,x)
    matrix2list(m)
  })
  unlist(l, recursive = F)
}

matrix2list <- function(matrix){
  lapply(seq_len(ncol(matrix)), function(i) matrix[,i])
}

#' @importFrom purrr reduce
overlap = function(list, idx){
  slice1 = list[idx]
  slice2 = list[-idx]

  if (length(slice1) > 1L){
    overlap = slice1 |> purrr::reduce(intersect)
  } else if (length(slice1) == 1L){
    overlap = unlist(slice1)
  } else {
    overlap = NULL
  }

  if (length(slice2) > 1L){
    outmember = slice2 |> purrr::reduce(union)
  } else if (length(slice2) == 1L){
    outmember = unlist(slice2)
  } else {
    outmember = NULL
  }

  setdiff(overlap, outmember)
}
