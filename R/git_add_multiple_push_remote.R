#' Setup git remote push urls
#'
#' Add/delete/check git remote push urls
#'
#' @name setup_git_remote_url
#'
#' @param path default is current working space
#' @param gitee_user default is "soilmicro"
#' @param github_user default is "gaospecial"
#' @param repository default is the directory name
#' @param branch default is "origin"
#'
#' @return a warning or message
#' @export
#'
#' @examples
git_add_multiple_push_remote = function(path = ".",
                                        gitee_user = NULL,
                                        github_user = NULL,
                                        repository = basename(R.utils::getAbsolutePath(path)),
                                        branch = "origin"){
  remote_url = list()
  if (!is.null(gitee_user)) remote_url$gitee = paste0(branch, " git@gitee.com:", gitee_user, '/', repository,".git")
  if (!is.null(github_user)) remote_url$github = paste0(branch, " git@github.com:", github_user, '/', repository,".git")
  cmd = lapply(remote_url, function(x) paste("git remote set-url --add --push", x))
  ret = lapply(cmd, system)
  if (all(ret == 0)){
    message("Add multiple git push remote successfully.")
    invisible(NULL)
  } else {
    warning("Failed to setup multiple push remotes.")
  }
}


#' @rdname setup_git_remote_url
git_delete_push_remote = function(path = ".",
                                        gitee_user = NULL,
                                        github_user = NULL,
                                        repository = basename(R.utils::getAbsolutePath(path)),
                                        branch = "origin"){
  remote_url = list()
  if (!is.null(gitee_user)) remote_url$gitee = paste0(branch, " git@gitee.com:", gitee_user, '/', repository, ".git")
  if (!is.null(github_user)) remote_url$github = paste0(branch, " git@github.com:", github_user, '/', repository, ".git")
  cmd = lapply(remote_url, function(x) paste("git remote set-url --delete --push", x))
  ret = lapply(cmd, system)
  if (all(ret == 0)){
    message("Delete git push remote successfully.")
    invisible(NULL)
  } else {
    warning("Failed to setup push remote(s) of this repository.")
  }

}

#' @rdname setup_git_remote_url
git_show_remote_origin = function(path = ".",
                                  branch = "origin"){
  cmd = paste("git remote show", branch)
  out = system(cmd, intern = TRUE)
  paste(out, collapse = "\n") |> message()
  invisible(NULL)
}
