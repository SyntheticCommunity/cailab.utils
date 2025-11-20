
#' 检查引物的二级结构
#'
#' @inheritParams calculate_tm
#' @return list 包含二级结构信息
#' @export
check_primer_structure <- function(sequence, temperature=37, K=50, Mg=1.5) {
  sequence <- toupper(sequence)
  
  # 检查序列合法性
  if (!is.character(sequence) || length(sequence) != 1) {
    stop("sequence 必须是单个字符串")
  }
  if (any(grepl("[^ATCG]", sequence))) {
    stop("sequence 只能包含 A, T, C, G")
  }
  
  # 1. 检查自身互补配对(Self-Any)
  self_any <- tryCatch({
    check_self_complementarity(sequence, 
                             end_only = FALSE, 
                             temperature = temperature,
                             K = K, 
                             Mg = Mg)
  }, error = function(e) NULL)
  
  # 2. 检查3'端互补配对(Self-End)
  self_end <- tryCatch({
    check_self_complementarity(sequence, 
                             end_only = TRUE,
                             temperature = temperature,
                             K = K, 
                             Mg = Mg)
  }, error = function(e) NULL)
  
  # 3. 检查发夹结构(Hairpin)
  hairpin <- tryCatch({
    check_hairpin_structure(sequence,
                          temperature = temperature,
                          K = K,
                          Mg = Mg)
  }, error = function(e) NULL)
  
  return(list(
    self_any = self_any,
    self_end = self_end,
    hairpin = hairpin
  ))
}

#' 检查序列的自身互补配对
#'
#' @param sequence 字符串，DNA 序列
#' @param end_only 逻辑值，是否只检查3'端
#' @param temperature 数值，温度(°C)
#' @param K 数值，K+ 浓度(mM)
#' @param Mg 数值，Mg2+ 浓度(mM)
#' @return list 包含互补配对信息
#' @keywords internal
check_self_complementarity <- function(sequence, end_only=FALSE, temperature=37, K=50, Mg=1.5) {
  # 获取互补序列
  rev_comp <- get_complement(sequence)
  rev_comp <- rev(strsplit(rev_comp, "")[[1]])
  sequence_chars <- strsplit(sequence, "")[[1]]
  
  # 如果只检查3'端，则只考虑最后5个碱基
  if (end_only) {
    check_len <- min(5, length(sequence_chars))
    sequence_chars <- tail(sequence_chars, check_len)
    rev_comp <- head(rev_comp, check_len)
  }
  
  # 寻找最稳定的互补配对
  best_match <- NULL
  min_dG <- 0
  
  seq_len <- length(sequence_chars)
  for (i in seq_len(max(1, seq_len-2))) {
    max_j <- min(seq_len-i, seq_len-1)
    for (j in seq_len(max_j)) {
      # 确保索引不超出范围
      end_idx <- min(i+j, seq_len)
      if (end_idx <= i) next
      
      subseq1 <- paste(sequence_chars[i:end_idx], collapse="")
      subseq2 <- paste(rev_comp[i:end_idx], collapse="")
      
      # 计算匹配度
      matches <- sum(strsplit(subseq1, "")[[1]] == strsplit(subseq2, "")[[1]])
      if (matches >= 0.75 * length(subseq1)) {  # 至少75%的碱基互补
        dG <- calculate_dG(subseq1, temperature)
        if (dG < min_dG) {
          min_dG <- dG
          best_match <- list(
            pos = i,
            length = length(subseq1),
            dG = dG,
            seq1 = subseq1,
            seq2 = subseq2,
            structure = format_alignment(subseq1, subseq2)
          )
        }
      }
    }
  }
  
  return(best_match)
}

#' 检查序列的发夹结构
#'
#' @param sequence 字符串，DNA 序列
#' @param temperature 数值，温度(°C)
#' @param K 数值，K+ 浓度(mM)
#' @param Mg 数值，Mg2+ 浓度(mM)
#' @return list 包含发夹结构信息
#' @keywords internal
check_hairpin_structure <- function(sequence, temperature=37, K=50, Mg=1.5) {
  # 最小茎长度和环长度
  min_stem_length <- 3
  min_loop_length <- 3
  max_loop_length <- 10
  
  best_hairpin <- NULL
  min_dG <- 0
  
  seq_chars <- strsplit(sequence, "")[[1]]
  seq_len <- length(seq_chars)
  
  # 遍历可能的茎-环结构
  for (loop_size in seq_len(min(max_loop_length, seq_len-2*min_stem_length))) {
    loop_size <- loop_size + min_loop_length - 1  # 调整为实际环长度
    
    max_possible_stem <- floor((seq_len - loop_size) / 2)
    if (max_possible_stem < min_stem_length) next
    
    for (stem_length in seq_len(min(max_possible_stem, 6))) {
      stem_length <- stem_length + min_stem_length - 1  # 调整为实际茎长度
      
      for (i in seq_len(seq_len - 2*stem_length - loop_size + 1)) {
        # 获取茎序列
        stem1 <- paste(seq_chars[i:(i+stem_length-1)], collapse="")
        stem2_start <- i + stem_length + loop_size
        stem2_end <- stem2_start + stem_length - 1
        
        if (stem2_end > seq_len) next
        
        stem2 <- paste(rev(seq_chars[stem2_start:stem2_end]), collapse="")
        stem2_comp <- get_complement(stem2)
        
        # 检查茎的互补性
        matches <- sum(strsplit(stem1, "")[[1]] == strsplit(stem2_comp, "")[[1]])
        
        if (matches >= 0.75 * stem_length) {  # 至少75%的碱基互补
          dG <- calculate_dG(stem1, temperature)
          if (dG < min_dG) {
            min_dG <- dG
            best_hairpin <- list(
              stem_start = i,
              stem_length = stem_length,
              loop_size = loop_size,
              dG = dG,
              stem1 = stem1,
              stem2 = stem2,
              structure = format_hairpin(stem1, loop_size, stem2)
            )
          }
        }
      }
    }
  }
  
  return(best_hairpin)
}

#' 格式化对齐显示
#'
#' @param seq1 字符串，第一条序列
#' @param seq2 字符串，第二条序列
#' @return 字符串，格式化的对齐结果
#' @keywords internal
format_alignment <- function(seq1, seq2) {
  # 生成匹配标记
  matches <- strsplit(seq1, "")[[1]] == strsplit(seq2, "")[[1]]
  match_symbols <- ifelse(matches, "|", " ")
  
  # 返回三行对齐
  paste(
    "5' ", seq1, " 3'\n",
    "   ", paste(match_symbols, collapse=""), "\n",
    "3' ", seq2, " 5'", 
    sep=""
  )
}

#' 格式化发夹结构显示
#'
#' @param stem1 字符串，茎的第一部分
#' @param loop_size 数值，环的大小
#' @param stem2 字符串，茎的第二部分
#' @return 字符串，格式化的发夹结构
#' @keywords internal
format_hairpin <- function(stem1, loop_size, stem2) {
  # 生成环的表示
  loop <- paste(rep("-", loop_size), collapse="")
  
  # 返回发夹结构表示
  paste(
    "5' ", stem1, loop, stem2, " 3'\n",
    "   ", paste(rep(" ", nchar(stem1)), collapse=""),
    "╭", paste(rep("-", loop_size-2), collapse=""), "╮\n",
    "   ", paste(rep(" ", nchar(stem1)), collapse=""),
    "│", paste(rep(" ", loop_size-2), collapse=""), "│\n",
    "3' ", get_complement(stem2), paste(rep(" ", loop_size), collapse=""), 
    get_complement(stem1), " 5'",
    sep=""
  )
}