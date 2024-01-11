#' Read all values in QuantStudio export
#'
#' @param file all in one text file (*.txt)
#'
#' @return a list of table, QuantStudioRaw class object
#' @export
#'
read_quantstudio = function(file){
  lines = readLines(file)

  # remove empty line
  empty_linenum = grep("^$", lines)
  if (length(empty_linenum > 0)) lines = lines[-empty_linenum]

  # find the start line of different set
  set_linenum = grep("^\\[.+\\]$", lines)
  if (length(set_linenum) < 1) stop("No valid data in this file. Please check.")
  nset = length(set_linenum)
  nrow = length(lines)
  set_name = lines[set_linenum]
  set_from = set_linenum + 1
  set_to = c(set_linenum[-1] - 1, nrow)

  # read set data one by one
  raw = vector("list", nset)
  for (i in 1:nset) {
    content = lines[set_from[i]:set_to[i]]
    type = NULL
    if (grepl("Well", content[1])) {
      type = list(well = 'c')
    }
    raw[[i]] = readr::read_delim(I(content),
                          trim_ws = TRUE,
                          show_col_types = FALSE,
                          name_repair = lower_join,
                          col_types = type)
  }
  names(raw) = set_name
  class(raw) = "QuantStudioRaw"
  return(raw)
}

lower_join = function(x){
  require(stringr)
  tolower(x) %>%
    stringr::str_replace("\\s", "_")
}

#' Get melting curve from QuantStudio dataset
#'
#' @param x QuantStudio dataset
#'
#' @return a tibble
#' @export
#'
get_quantstudio_melting_curve = function(x){
  get_by_name(x, pattern = "Melt Curve Raw Data")
}

#' Get amplication data from QuantStudio dataset
#'
#' @param x  QuantStudio dataset
#'
#' @return a tibble
#' @export
#'
get_quantstudio_amplication = function(x){
  get_by_name(x, "Amplification Data")
}

#' Get raw data from QuantStudio dataset
#'
#' @param x  QuantStudio dataset
#'
#' @return a tibble
#' @export
#'
get_quantstudio_raw = function(x){
  get_by_name(x, "Raw Data")
}

#' Get analysis results from QuantStudio dataset
#'
#' @param x  QuantStudio dataset
#'
#' @return a tibble
#' @export
#'
get_quantstudio_result = function(x){
  get_by_name(x, "Results")
}

get_by_name = function(x, pattern){
  name = names(x)
  idx = grep(pattern, name)
  x[[idx]]
}



#' Print user-friendly information of a object
#'
#' @param object a object
#' @method print QuantStudioRaw
#' @rdname quantstudio
#' @name quantastudio
#' @docType methods
#' @export
print.QuantStudioRaw = function(object){
            cat("An object of class 'QuantStudioDaw':\n")
            cat("   Slots: ", paste0(names(object), collapse = ", "), ";\n", sep = "")
          }
