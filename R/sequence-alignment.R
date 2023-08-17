
#' Run multiple sequence alignment with MUSCLE
#'
#'
#'
#' @param fasta_file sequence file(s) in fasta format, if a vector is provided, all files will be read.
#' @param quiet silent MUSCLE progress
#'
#' @return a alignment object
#' @export
#'
#' @examples
#' file.path = system.file("extdata", "someORF.fa", package = "Biostrings")
#' run_alignment_with_muscle(file.path)
run_alignment_with_muscle = function(fasta_file, quiet = TRUE){
  message("Runing multiple sequence alignment may take a while.")
  message("If you want to see the progress, set `quiet = FALSE`.")
  seq = Biostrings::readDNAStringSet(fasta_file)
  aln = seq %>%
    muscle::muscle(quiet = quiet)
  return(aln)
}


#' Construct a phylogenetic tree from sequence alignment
#'
#' @param aln a 'DNAMultipleAlignment' object
#' @param dist.method method to caculate distance
#'
#' @return a tree
#' @export
tree_from_aln = function(aln, dist.method = "hamming"){
  dist = Biostrings::stringDist(
    x = Biostrings::DNAStringSet(aln),
    method = dist.method)
  phy = ape::fastme.bal(dist) # can use more method
  tree = treeio::as.treedata(phy)
  return(tree)
}


#' Plot tree with ggtree
#'
#' By default, this function plot a tree with tip labels and colors.
#'
#' @param tree tree
#' @param tip.label tip.label mapping
#' @param tip.color tip.color mapping
#'
#' @return a ggplot object
#' @export
plot_tree = function(tree, tip.label = "label", tip.color = "parent"){
  ggtree::ggtree(tree) +
    ggtree::geom_tiplab(ggplot2::aes(
      # see: https://rlang.r-lib.org/reference/topic-inject.html#injecting-names-with-
      label = {{ tip.label }},
      color = {{ tip.color }})) +
    ggtree::theme_tree2()
}
