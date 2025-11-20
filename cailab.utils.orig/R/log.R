#' Print git log in datatable
#'
#' @export
print_git_log = function(){
  log = system('git log --pretty=format:"%ad%x09%s" --date=relative', intern = TRUE)
  data.frame(log = log) %>%
    tidyr::separate(log, into = c("date","message"), sep = "\t") %>%
    DT_table()
}

