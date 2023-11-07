#' Design specific primer
#'
#' @param fasta_file fasta format
#'
#' @return primers
#' @export
#'
#' @examples
design_specific_primer = function(fasta_file, ...){
  require("DECIPHER")
  dbConn <- dbConnect(SQLite(), ":memory:")
  seqs = Biostrings::readDNAStringSet(fasta_file)
  acc = names(seqs)
  if (length(unique(acc)) != length(acc)){
    stop("Sequences have duplicated ids. Please fix it and rerun this function.")
  }
  Seqs2DB(seqs,
          type = "XStringSet",
          dbFile = dbConn,
          identifier = acc,
          processors = NULL,
          verbose = FALSE)
  tiles = TileSeqs(dbConn, add2tbl="Tiles", minCoverage=1, verbose = FALSE)
  primers = lapply(acc, function(x) .design_primers(tiles = tiles, identifier = x, ...))
  primers = dplyr::bind_rows(primers)
  DBI::dbDisconnect(dbConn)
  return(primers)
}

# design primer using DECIPHER, with optimized settings
.design_primers = function(tiles,
                           identifier,
                           minCoverage = 1,
                           minLength = 20,
                           minGroupCoverage = 1,
                           numPrimerSets = 1,
                           minProductSize = 150,
                           maxProductSize = 500){
  primers = DECIPHER::DesignPrimers(tiles = tiles,
                            identifier = identifier,
                            verbose = FALSE,
                            processors = NULL,
                            minCoverage = minCoverage,
                            minLength = minLength,
                            minGroupCoverage = minGroupCoverage,
                            numPrimerSets = numPrimerSets,
                            minProductSize = minProductSize,
                            maxProductSize = maxProductSize)
  primers = .format_decipher_primer(primers)
  return(primers)
}


# format DECIPHER output to a small tibble
.format_decipher_primer = function(primers){
  columns = c("forward_primer","reverse_primer")
  for (col in columns){
    primers[[col]] = primers[[col]][,1]
  }
  primers |>
    dplyr::as_tibble() |>
    dplyr::select(identifier,
                  forward_primer,
                  reverse_primer,
                  product_size)
}
