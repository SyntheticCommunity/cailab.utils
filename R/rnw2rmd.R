#' Convert vignettes from Rnw to Rmd
#'
#' This function is derived from **spMisc**.
#' See also: <https://rdrr.io/github/GegznaV/spMisc/src/R/rnw2rmd.R>.
#' It can convert old Sweave vignettes into R Markdown.
#' Please do not expect it to do wonders, but to give you a good starting point
#' for conversions.
#'
#' @param file Path to an *.Rnw file to convert.
#' @param output_file Path to write *.Rmd file.
#' @param output_format Character string defining the R markdown output format.
#' @param extra_replacement a list of file to specify additional replacement.
#' @param overwrite Logical, whether existing files should be overwritten.
#'
#' @export
#'
#' @return Open the output to enable further edition.
rnw2rmd <- function(file,
                    output_file = gsub("[Rr]nw$", "Rmd", file),
                    output_format  = "rmarkdown::html_vignette",
                    extra_replacement  = NULL,
                    overwrite      = FALSE) {

  # list of replacement
  pat <- list(
    c(from = "\\\\maketitle",                to = ""),
    c(from = "(?<!\\\\)%.+",                 to = ""), # if "50% "
    # comment
    c(from = "\\\\%",                        to = "%"),
    # %

    # text format
    # @TODO: deal with user-defined \newcommand
    c(from = "\\\\Rpackage{(.+?)}",          to = "**\\1**"),
    # user-defined function
    c(from = "\\\\Robject{(.+?)}",           to = "`\\1`"),
    # user-defined function
    c(from = "\\\\Rcode{(.+?)}",             to = "`\\1`"),
    # user-defined function
    c(from = "\\\\Rclass{(.+?)}",            to = "*\\1*"),
    # user-defined function
    c(from = "\\\\Rfunction{(.+?)}",         to = "`\\1`"),
    # user-defined function
    c(from = "\\\\Rfunarg{(.+?)}",           to = "`\\1`"),
    c(from = "\\\\code{(.+?)}",              to = "`\\1`"),
    c(from = "\\\\texttt{(.+?)}",            to = "`\\1`"),
    c(from = "\\\\textit{(.+?)}",            to = "*\\1*"),
    c(from = "\\\\textbf{(.+?)}",            to = "**\\1**"),
    c(from = "\\\\emph{(.+?)}",              to = "*\\1*"),
    c(from = "\\\\underline{(.+?)}",         to = "\\1"),
    c(from = "\\\\term{(.+?)}",              to = "\\1"),
    c(from = "``(.+?)''",                     to = "\"\\1\""),

    # code chunk
    c(from = "^\\s*<<",                       to = "```{r "),
    c(from = ">>=\\s*",                      to = "}"),
    c(from = "^\\s*@",                            to = "```"),

    # code output
    c(from = "\\s*\\\\begin{Sinput}",        to = "```"),
    c(from = "\\s*\\\\end{Sinput}",          to = "```"),
    c(from = "\\s*\\\\begin{Schunk}",        to = ""),
    c(from = "\\s*\\\\end{Schunk}",          to = ""),
    c(from = "\\s*\\\\begin{Soutput}",       to = "<!-- \\\\begin{Soutput}"),
    c(from = "\\s*\\\\end{Soutput}",         to = "\\\\end{Soutput} -->"),
    c(from = "\\s*\\\\begin{Verbatim}",      to = "```"),
    c(from = "\\s*\\\\end{Verbatim}",        to = "```"),

    # headers
    c(from = "\\s*\\\\section{(.+?)}",       to = "# \\1\\\n"),
    c(from = "\\s*\\\\subsection{(.+?)}",    to = "## \\1\\\n"),
    c(from = "\\s*\\\\subsubsection{(.+?)}", to = "### \\1\\\n"),
    c(from = "\\s*\\\\paragraph{(.+?)}",     to = "#### \\1\\\n"),
    c(from = "\\s*\\\\tableofcontents",      to = ""),

    c(from = "\\\\Biocexptpkg{(.+?)}",       to = "`r Biocexptpkg(\"\\1\")`"),
    c(from = "\\\\Biocannopkg{(.+?)}",       to = "`r Biocannopkg(\"\\1\")`"),
    c(from = "\\\\Biocpkg{(.+?)}",           to = "`r Biocpkg(\"\\1\")`"),
    c(from = "\\\\cite{(.+?)}",              to = "[\\@\\1]"),
    c(from = "\\\\cite<(.+?)>{(.+?)}",       to = "[\\1 \\@\\2]"),
    c(from = "\\\\citeA{(.+?)}",             to = "\\@\\1"),
    c(from = "\\\\citeNP{(.+?)}",            to = "\\@\\1"),
    c(from = "\\\\citeNP<(.+?)>{(.+?)}",     to = "\\1 \\@\\2"),
    c(from = "\\\\ref{(.+?)}",               to = "\\\\@ref(\\1)"),

    # link
    c(from = "\\\\url{(.+?)}",               to = "<\\1>"),
    c(from = "\\\\href{(.+?)}{(.+?)}",       to = "[\\2](\\1)"),


    c(from = "\\\\ldots",                    to = "\\.\\.\\."),
    c(from = "\\\\label{",                   to = " {#"),
    # only for sections
    c(from = "\\\\deseqtwo{}",               to = "DESeq2"),
    c(from = "\\\\footnote{(.+?)}",          to = "[^\\1]"),
    c(from = "\\\\bibliography{(.+?)}",      to = "# References"),
    c(from = "\\\\bibliographystyle{(.+?)}", to = ""),
    c(from = "\\\\addcontentsline{(.+)}",    to = ""),
    c(from = "\\\\\\$",                      to = "\\$"),
    c(from = "^(\\s*)%(.*)[^->]\\s*$",       to = "\\1<!-- \\2 -->"),
    c(from = "\\\\,",                        to = "")
  )

  if (is.list(extra_replacement)) {
    pat <- append(pat, extra_replacement)
  }

  # start transformation
  txt <- txt_body <- xfun::read_utf8(file)

  # essentials
  title           <- which(grepl("\\\\title{", txt, perl = TRUE))
  author          <- which(grepl("\\\\author{", txt, perl = TRUE))
  bibliography    <-
    which(grepl("^\\s*\\\\bibliography{", txt, perl = TRUE))

  # vignette setting (can be ignored)
  vignette_meta   <-
    which(grepl("%\\\\Vignette.+", txt, perl = TRUE))
  vignette_engine <-
    which(grepl("%\\\\VignetteEngine{.+", txt, perl = TRUE))
  vignette_meta   <-
    vignette_meta[!vignette_meta %in% vignette_engine]  # remove engine if set

  # document body
  begin_document  <-
    which(grepl("\\\\begin{document}", txt, perl = TRUE))
  end_document    <-
    which(grepl("\\\\end{document}", txt, perl = TRUE))
  if (isTRUE(begin_document > 0)) {
    txt_body <-
      txt[c((begin_document + 1):ifelse(isTRUE(end_document > 0), (end_document - 1), length(txt)))]
  }

  # document abstract
  begin_abstract <-
    which(grepl("\\\\begin{abstract}", txt_body, perl = TRUE))
  end_abstract <-
    which(grepl("\\\\end{abstract}", txt_body, perl = TRUE))

  # for yaml header
  preamble <- list()
  if (isTRUE(title > 0)) {
    preamble[["title"]] <-
      gsub("\\\\title{(.+?)}", "\"\\1\"", txt[[title]], perl = TRUE)
  }
  if (isTRUE(author > 0)) {
    preamble[["author"]] <-
      gsub("\\\\author{(.+?)}", "\"\\1\"", txt[[author]], perl = TRUE)
  }
  preamble[["date"]] <- "\"`r Sys.Date()`\""
  preamble[["output"]] <- output_format

  if (isTRUE(bibliography > 0)) {
    preamble[["bibliography"]] <-
      gsub("\\\\bibliography{(.+?)}", "\\1.bib", txt[[bibliography]], perl = TRUE)
  }

  if (isTRUE(begin_abstract > 0)) {
    abstract_text <-
      txt_body[c((begin_abstract + 1):(end_abstract - 1))]
    for (thisPat in pat) {
      abstract_text <-
        gsub(thisPat[["from"]], thisPat[["to"]], abstract_text, perl = TRUE)
    }
    preamble[["abstract"]] <-
      paste0(">\n  ", paste(abstract_text, collapse = "\n  "))
    txt_body <- txt_body[-c((begin_abstract):(end_abstract))]
  }

  # pattern replacement
  for (thisPat in pat) {
    txt_body <-
      gsub(thisPat[["from"]], thisPat[["to"]], txt_body, perl = TRUE)
  }

  txt_body <- nested_env(txt = txt_body)

  # clean up multiple newlines
  txt_body <- gsub("[\\\n]{3,}?", "\\\n\\\n", txt_body, perl = TRUE)

  txt_body <- vignette_stub(preamble = preamble,
                            txt_body = txt_body,
                            output_format = output_format)

  if (!overwrite && file.exists(output_file)) {
    cat("    File already exists: ", output_file, ". Overwrite it? [y]/n.", sep = "")
    response = readLines(n = 1)
    if (response == "n") {
      return(invisible(TRUE))
    }
  }
  xfun::write_utf8(txt_body, output_file)
  usethis::edit_file(output_file)
  invisible(TRUE)
}


## internal function nested_env()
# iterates through a character vector and tries to replace
# itemize or enumerate blocks with R markdown equivalents
nested_env <- function(txt) {
  begin_itemize <- paste0("\\s*\\\\begin{itemize}\\s*")
  begin_enumerate <- paste0("\\s*\\\\begin{enumerate}\\s*")
  level <- 0
  enum <- 0
  envir_in <- ""
  for (thisTxtNum in 1:length(txt)) {
    if (isTRUE(grepl(begin_itemize, txt[thisTxtNum], perl = TRUE))) {
      envir_in <- "itemize"
      level <- level + 1
      txt[thisTxtNum] <-
        gsub(begin_itemize, "", txt[thisTxtNum], perl = TRUE)
    } else if (isTRUE(grepl(begin_enumerate, txt[thisTxtNum], perl = TRUE))) {
      envir_in <- "enumerate"
      enum <- 0
      level <- level + 1
      txt[thisTxtNum] <-
        gsub(begin_enumerate, "", txt[thisTxtNum], perl = TRUE)
    } else {
    }
    if (isTRUE(grepl("\\\\item", txt[thisTxtNum], perl = TRUE))) {
      if (level > 2) {
        warning(
          "list depths of more than two levels are not supported in Rmarkdown, reducing to two levels -- please check!"
        )
      } else {
      }
      if (envir_in %in% "itemize") {
        indent <- switch(
          as.character(level),
          "0" = "",
          "1" = "* ",
          "2" = "    + ",
          "    + "
        )
        txt[thisTxtNum] <-
          gsub("\\s*\\\\item[(.+?)]\\s*", indent, txt[thisTxtNum], perl = TRUE)
        txt[thisTxtNum] <-
          gsub("\\s*\\\\item\\s*", indent, txt[thisTxtNum], perl = TRUE)
      } else if (envir_in %in% "enumerate") {
        # message(level)
        enum <- enum + 1
        if (level > 1) {
          indent <- paste0("    ", letters[enum], ". ")
        } else if (level > 0) {
          indent <- paste0(enum, ". ")
        } else {
          indent <- ""
        }
        txt[thisTxtNum] <-
          gsub("\\s*\\\\item\\s*", indent, txt[thisTxtNum], perl = TRUE)
      } else {
      }
    } else {
    }
    if (envir_in %in% c("itemize", "enumerate")) {
      envir_end <- paste0("\\s*\\\\end{", envir_in, "}\\s*")
      if (isTRUE(grepl(envir_end, txt[thisTxtNum], perl = TRUE))) {
        level <- level - 1
        txt[thisTxtNum] <-
          gsub(envir_end, "", txt[thisTxtNum], perl = TRUE)
      } else {
      }
    } else {
    }
  }
  if (level != 0) {
    warning(
      "looks like we were not able to correctly detect all levels of ",
      envir_in,
      " environments. is the input document valid?"
    )
  } else {
  }
  return(txt)

}



## internal function vignette_stub()
vignette_stub <- function(preamble = NULL,
                          txt_body = NULL,
                          output_format = "html_document") {
  preamble_rmd <- "---"
  for (thisPreamble in names(preamble)) {
    preamble_rmd <-
      paste0(preamble_rmd, "\n", thisPreamble, ": ", preamble[[thisPreamble]])
  }
  preamble_rmd <- paste0(preamble_rmd, "\n---\n")

  txt_body <- paste0(preamble_rmd, paste0(txt_body, collapse = "\n"))
  return(txt_body)
}
