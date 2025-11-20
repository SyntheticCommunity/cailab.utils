#######################
######   NOTE   #######
#######################
#
# This file stores xfun-like functions which may have enhanced features
# as compared with their original forms. For example, `paste2()` can
# ignore NA and empty strings, and it can be used as a alternative
# elegant form of `paste()`.
#

#' Paste which can ignore NA and empty strings
#'
#' Acts the same as regular paste, unless na.rm = TRUE,
#' in which case empty strings and NA are removed.
#'
#' Due to the contents of vectors passed to this function,
#' elements in vectors may be removed without warning. Sometimes, even the
#' whole vector is omitted. see @examples.
#'
#' @param ... the list of strings to paste
#' @param sep the separator string, " " by default
#' @param collapse the collapse string, NULL by default
#' @param na.rm whether to remove NA and empty strings
#'
#' @return string
#' @export
#'
#' @examples
#' s1 = c("","a",NA,TRUE)
#' s2 = c("b","",NA,NULL)
#' s3 = c(NULL,NA)
#' paste(s1, s2, s3, sep = ',', collapse = "/")
#' paste(s1, s2, s3, sep = ',', collapse = "/", na.rm = TRUE)
#' paste2(s1, s2, s3, sep = ',', collapse = "/")
#' paste2(s1, s2, s3, sep = ',', collapse = "/", na.rm = TRUE)
paste2 <- function(..., sep = " ", collapse = NULL, na.rm = TRUE) {
  dots <- list(...)  # 这个 paste2 会改变向量长度，引起意想不到的结果

  # get rid of empty strings
  dots <- lapply(dots, function(x) {
    if(na.rm){
      x = x[!is.na(x)]
    }
    x <- x[nchar(x, type = "bytes") > 0]
    return(x)
  })

  # remove empty element
  idx = sapply(dots, function(x){ length(x) > 0 })
  dots = dots[idx]

  # pass back
  args = dots
  args$sep = sep
  args$collapse = collapse

  # run paste with new args
  res = do.call(paste, args)
  return(res)
}
