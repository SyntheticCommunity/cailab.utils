#' Install missing package and retry
#'
#' I always encounter package not found error when I run `render_book()` for
#' the first time. Normally, I check the error message and then rerun the command,
#' and this make me annoy when I have to do it again and again. Therefore,
#' I create this function to automate this operation.
#'
#' @param expr an expression or command, i. e. bookdown::render_book()
#' @param retry how many times should I retry. default is 30
#'
#' @return a message or a error that is not a 'packageNotFoundError'
#' @export
install_missing_packages = function(expr = bookdown::render_book(), retry = 30){
  if (retry < 1){
    stop("No retry times.")
  }
  tryCatch(expr = expr, error = function(e){
    if (inherits(e$error, "packageNotFoundError")) {
      package = e$error$package
      message("This package is missing: ", package, ". I will retry after have it installed.")
      pak::pak(package)
      install_missing_packages(expr = expr, retry = retry - 1)
    } else {
      stop(e)
    }
  }, finally = print("This is the end."))
}
