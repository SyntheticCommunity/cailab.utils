
# show file download links for figure
caption_download <- function(..., PPT = TRUE, PDF = TRUE){
  x <- paste0(...)
  if (PPT) x <- paste0(x," [ppt](", knitr::fig_path(".pptx"),"),")
  if (PDF) x <- paste0(x, " [pdf](", knitr::fig_path(".pdf"),")")
  return(x)
}

capd <- caption_download

# export current plot to .pptx
graph2pptx <- function(..., file = knitr::fig_path(".pptx")){
  export::graph2ppt(..., file = file)
}
