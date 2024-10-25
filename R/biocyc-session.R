
#' 建立BioCyc会话
#'
#' 此函数用于建立与BioCyc网站的会话连接。
#'
#' @param email 字符串，BioCyc账户的电子邮箱
#' @param password 字符串，BioCyc账户的密码
#' @param base_url 字符串，BioCyc API的基础URL，默认为"https://websvc.biocyc.org/"
#'
#' @return httr::handle对象，表示已建立的会话
#' @export
#'
#' @importFrom httr handle_pool POST status_code content
#' @examples
#' \dontrun{
#' session <- establish_biocyc_session("your_email@example.com", "your_password")
#' }
biocyc_session <- function(email = readline("请输入您的BioCyc注册邮箱: "),  # nolint
                           password = readline("请输入您的BioCyc密码: "), 
                           base_url = "https://websvc.biocyc.org/") {
  login_url <- paste0(base_url, "credentials/login/")
  
  session <- httr::handle(base_url)
  
  response <- httr::POST(
    url = login_url,
    handle = session,
    body = list(email = email, password = password),
    encode = "form"
  )
  
  if (httr::status_code(response) == 200) {
    message("登录成功")
    return(session)
  } else {
    stop("登录失败: ", httr::content(response, "text", encoding = "UTF-8"))
  }
}

