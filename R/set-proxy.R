#' Set http(s) proxy in the current R session
#'
#' This function is useful when you network is not able to access needed content by default.
#' For instance, when you are install package from GitHub, but you are blocked by firewalls.
#'
#' Try to find the port automatically.
#'
#'
#' @param url proxy IP address
#' @param port proxy port
#'
#' @return silent
#' @export
#'
#' @examples
#'   set_proxy()
#'   # run command
#'   # tinytex::install()
set_proxy = function(url = "http://127.0.0.1", port = 36119){
  proxy = paste(url,port,sep=":")
  Sys.setenv(http_proxy = proxy)
  Sys.setenv(https_proxy = proxy)
  invisible()
}
