#' Design specific primer
#'
#' @param fasta_file fasta format
#' @param minLength primer min length
#' @param maxLength primer max length
#' @param minProductSize product min length
#' @param maxProductSize product max length
#' @param verbose if TRUE, will print progress during the run
#'
#' @return primers
#' @export
design_specific_primer = function(fasta_file,
                                  minLength = 20,
                                  maxLength = 25,
                                  minProductSize = 150,
                                  maxProductSize = 500,
                                  verbose = FALSE){
  dbConn <- DBI::dbConnect(SQLite(), ":memory:")
  on.exit(DBI::dbDisconnect(dbConn))
  seqs = Biostrings::readDNAStringSet(fasta_file)
  acc = names(seqs)
  if (length(unique(acc)) != length(acc)) {
    stop("Sequences have duplicated ids. Please fix it and rerun this function.")
  }

  # seqs = msa::msa(seqs,
  #                 method = "ClustalOmega",
  #                 verbose = verbose)
  # seqs = Biostrings::DNAStringSet(seqs)


  DECIPHER::Seqs2DB(seqs,
          type = "XStringSet",
          dbFile = dbConn,
          identifier = acc,
          processors = NULL,
          verbose = verbose)

  tiles = DECIPHER::TileSeqs(dbConn,
                   add2tbl = "Tiles",
                   minLength = maxLength,
                   maxLength = maxLength + 1,
                   minCoverage = 1,
                   processors = NULL,
                   verbose = verbose)

  primers = lapply(acc, function(x){
    .design_primers(tiles = tiles,
                    identifier = x,
                    minLength = minLength,
                    maxLength = maxLength,
                    minProductSize = minProductSize,
                    maxProductSize = maxProductSize,
                    verbose = verbose)
    })
  primers = dplyr::bind_rows(primers)
  return(primers)
}

# design primer using DECIPHER, with optimized settings
.design_primers = function(tiles,
                           identifier,
                           verbose = FALSE,
                           minLength = 20,
                           maxLength = 25,
                           minProductSize = 150,
                           maxProductSize = 500,
                           numPrimerSets = 1,
                           minCoverage = 1,
                           minGroupCoverage = 1){
  primers = DECIPHER::DesignPrimers(tiles = tiles,
                            identifier = identifier,
                            verbose = verbose,
                            processors = NULL,
                            minLength = minLength,
                            maxLength = maxLength,
                            minProductSize = minProductSize,
                            maxProductSize = maxProductSize,
                            numPrimerSets = numPrimerSets,
                            maxPermutations = 1,
                            minCoverage = minCoverage,
                            minGroupCoverage = minGroupCoverage)
  primers = .format_decipher_primer(primers)
  return(primers)
}


# format DECIPHER output to a small tibble
.format_decipher_primer = function(primers){
  columns = c("forward_primer","reverse_primer")
  for (col in columns) {
    primers[[col]] = primers[[col]][,1]
  }
  primers |>
    dplyr::as_tibble() |>
    dplyr::select(dplyr::all_of(c("identifier", "forward_primer","reverse_primer","product_size")))
}
