#' Read all values in QuantStudio export
#'
#' @param file all in one text file (*.txt)
#'
#' @return
#' @export
#'
#' @examples
read_quantstudio = function(file){
  require(readr)
  lines = readLines(file)
  lines = lines[-grep("^$", lines)]
  
  # find the start line of different set
  set_linenum = grep("^\\[.+\\]$", lines)
  nset = length(set_linenum)
  nrow = length(lines)
  set_name = lines[set_linenum]
  set_from = set_linenum + 1
  set_to = c(set_linenum[-1] - 1, nrow)
  
  # read set data one by one
  raw = vector("list", nset)
  for (i in 1:nset){
    content = lines[set_from[i]:set_to[i]]
    type = NULL
    if (grepl("Well", content[1])){
      type = list(well = 'c')
    }
    raw[[i]] = read_delim(I(content),
                          trim_ws = TRUE,
                          show_col_types = FALSE,
                          name_repair = lower_join,
                          col_types = type)
  }
  names(raw) = set_name
  return(raw)
}

lower_join = function(x){
  require(stringr)
  tolower(x) %>% 
    stringr::str_replace("\\s", "_")
}

get_quantstudio_melting_curve = function(x){
  get_by_name(x, pattern = "Melt Curve Raw Data")
}

get_quantstudio_amplication = function(x){
  get_by_name(x, "Amplification Data")
}

get_quantstudio_raw = function(x){
  get_by_name(x, "Raw Data")
}

get_quantstudio_result = function(x){
  get_by_name(x, "Results")
}

get_by_name = function(x, pattern){
  name = names(x)
  idx = grep(pattern, name)
  x[[idx]]
}