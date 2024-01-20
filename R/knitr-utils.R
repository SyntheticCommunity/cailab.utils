
# show file download links for figure
caption_download <- function(..., PPT = TRUE, PDF = TRUE){
  x <- paste0(...)
  if (PPT) x <- paste0(x," [ppt](", fig_path(".pptx"),"),")
  if (PDF) x <- paste0(x, " [pdf](", fig_path(".pdf"),")")
  return(x)
}

capd <- caption_download

# export current plot to .pptx
graph2pptx <- function(..., file = fig_path(".pptx")){
  require(export)
  export::graph2ppt(..., file = file)
}
