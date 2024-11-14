#' 生成 DNA 序列的互补序列
#'
#' @param sequence 字符串，DNA 序列
#' @return 字符串，互补序列
#' @keywords internal
get_complement <- function(sequence) {
  sequence <- toupper(sequence)
  # 检查是否只包含合法的碱基
  if (any(grepl("[^ATCG]", sequence))) {
    stop("sequence 只能包含 A, T, C, G")
  }
  
  comp_map <- c("A"="T", "T"="A", "G"="C", "C"="G")
  bases <- strsplit(sequence, "")[[1]]
  complement <- paste(sapply(bases, function(x) comp_map[x]), collapse="")
  return(complement)
}

#' 计算 DNA 序列的热力学参数
#'
#' 使用 SantaLucia 的最近邻参数计算 DNA 序列的热力学参数
#'
#' @param sequence 字符串，DNA 序列
#' @return list 包含以下元素：
#'   \item{dH}{焓变(kcal/mol)}
#'   \item{dS}{熵变(cal/mol·K)}
#' @export
#' @examples
#' # 计算简单序列的热力学参数
#' calculate_thermodynamics("ATGC")
#'
#' # 计算较长序列的热力学参数
#' calculate_thermodynamics("ATGCTAGCTAGCTAG")
calculate_thermodynamics <- function(sequence) {
  if (!is.character(sequence) || length(sequence) != 1) {
    stop("sequence 必须是单个字符串")
  }
  
  sequence <- toupper(sequence)
  if (nchar(sequence) < 2) {
    stop("sequence 长度必须大于1")
  }
  
  if (grepl("[^ATCG]", sequence)) {
    stop("sequence 只能包含 A, T, C, G")
  }
  
  # 初始化总热力学参数
  total_dH <- thermo_params$init_params$init[1]
  total_dS <- thermo_params$init_params$init[2]
  
  # 处理末端参数
  if(substr(sequence, 1, 1) %in% c("A", "T")) {
    total_dH <- total_dH + thermo_params$init_params$term_AT[1]
    total_dS <- total_dS + thermo_params$init_params$term_AT[2]
  } else {
    total_dH <- total_dH + thermo_params$init_params$term_GC[1]
    total_dS <- total_dS + thermo_params$init_params$term_GC[2]
  }
  
  if(substr(sequence, nchar(sequence), nchar(sequence)) %in% c("A", "T")) {
    total_dH <- total_dH + thermo_params$init_params$term_AT[1]
    total_dS <- total_dS + thermo_params$init_params$term_AT[2]
  } else {
    total_dH <- total_dH + thermo_params$init_params$term_GC[1]
    total_dS <- total_dS + thermo_params$init_params$term_GC[2]
  }
  
  # 计算序列内部的最近邻参数
  for(i in 1:(nchar(sequence)-1)) {
    dinuc <- substr(sequence, i, i+1)
    comp_dinuc <- get_complement(dinuc)
    pair_key <- paste(dinuc, comp_dinuc, sep="/")
    
    # 如果找不到确切的键，尝试反向键
    if(!(pair_key %in% names(thermo_params$nn_parameters))) {
      pair_key <- paste(comp_dinuc, dinuc, sep="/")
    }
    
    if(pair_key %in% names(thermo_params$nn_parameters)) {
      params <- thermo_params$nn_parameters[[pair_key]]
      total_dH <- total_dH + params[1]
      total_dS <- total_dS + params[2]
    }
  }
  
  return(list(dH=total_dH, dS=total_dS))
}

#' 计算 DNA 序列的熔解温度
#'
#' 使用 Bolton and McCarthy (PNAS 84:1390, 1962) 的公式计算 DNA 序列的熔解温度，
#' 该公式在 Sambrook et al., Molecular Cloning (1989) 中也有描述。
#'
#' 公式：Tm = 81.5 + 16.6(log10([Na+])) + 0.41*(%GC) - 675/length
#'
#' 注意：
#' 1. 对于 K+，50mM K+ 相当于 200mM Na+ (Wetmur, Critical Reviews in BioChem. 26:227, 1991)
#' 2. Mg2+ 的影响通过等效 Na+ 浓度计算：[Na+]eq = [Na+] + 120*sqrt([Mg2+])
#'
#' @param sequence 字符串，DNA 序列
#' @param primer_conc 数值，引物浓度(pM)，默认 250pM
#' @param K 数值，K+ 浓度(mM)，默认 50mM
#' @param Mg 数值，Mg2+ 浓度(mM)，默认 1.5mM
#' @return 数值，熔解温度(°C)
#' @references 
#' Bolton & McCarthy (1962) PNAS 84:1390
#' Sambrook et al. (1989) Molecular Cloning, CSHL Press
#' Wetmur (1991) Critical Reviews in BioChem. 26:227
#' @export
#' @examples
#' calculate_tm("ATGCTAGCTAGCTAG")
calculate_tm <- function(sequence, primer_conc=250, K=50, Mg=1.5) {
  # 参数验证
  if (!is.numeric(primer_conc) || primer_conc <= 0) {
    stop("primer_conc 必须是正数")
  }
  if (!is.numeric(K) || K < 0) {
    stop("K 必须是非负数")
  }
  if (!is.numeric(Mg) || Mg < 0) {
    stop("Mg 必须是非负数")
  }
  
  sequence <- toupper(sequence)
  len <- nchar(sequence)
  
  # 计算 GC 含量百分比
  gc_count <- sum(strsplit(sequence, "")[[1]] %in% c("G", "C"))
  gc_percent <- 100 * gc_count / len
  
  # 计算等效 Na+ 浓度 (mM)
  # 1. K+ 转换为等效 Na+: 50mM K+ = 200mM Na+
  # 2. 加入 Mg2+ 的影响
  Na_eq <- (K * 4) + 120 * sqrt(Mg)
  
  # Bolton & McCarthy 公式
  tm <- 81.5 + 
        16.6 * log10(Na_eq/1000) +  # 转换为 M
        0.41 * gc_percent - 
        675/len
  
  return(tm)
}

#' 计算 DNA 序列的自由能变化
#'
#' 在指定温度下计算 DNA 序列的 Gibbs 自由能变化
#'
#' @param sequence 字符串，DNA 序列
#' @param temperature 数值，温度(°C)，默认 37°C
#' @return 数值，Gibbs 自由能变化(kcal/mol)
#' @export
#' @examples
#' # 在默认温度(37°C)下计算
#' calculate_dG("ATGCTAGCTAGCTAG")
#'
#' # 在不同温度下计算
#' calculate_dG("ATGCTAGCTAGCTAG", temperature = 25)
calculate_dG <- function(sequence, temperature=37) {
  if (!is.numeric(temperature)) {
    stop("temperature 必须是数值")
  }
  
  thermo <- calculate_thermodynamics(sequence)
  dG <- thermo$dH - (temperature + 273.15) * thermo$dS/1000
  return(dG)
}

#' 检查 DNA 序列的二级结构
#'
#' 通过滑动窗口方法检查可能的自补配对结构返回最稳定的结构
#'
#' @param sequence 字符串，DNA 序列
#' @param temperature 数值，温度(°C)，默认 37°C
#' @param min_length 数值，最小互补长度，默认 4bp
#' @return list 包含以下元素：
#'   \item{pos}{结构起始位置}
#'   \item{length}{结构长度}
#'   \item{dG}{结构稳定性(kcal/mol)}
#'   \item{seq1}{第一条链序列}
#'   \item{seq2}{第二条链序列}
#' @export
#' @examples
#' # 检查序列的二级结构
#' check_secondary_structure("ATGCTAGCTAGCTAG")
#'
#' # 指定不同的最小互补长度
#' check_secondary_structure("ATGCTAGCTAGCTAG", min_length = 5)
#'
#' # 在不同温度下检查
#' check_secondary_structure("ATGCTAGCTAGCTAG", temperature = 25)
check_secondary_structure <- function(sequence, temperature=37, min_length=4) {
  if (!is.numeric(min_length) || min_length < 3) {
    stop("min_length 必须是大于等于3的整数")
  }
  
  sequence <- toupper(sequence)
  rev_comp <- get_complement(sequence)
  
  best_structure <- NULL
  min_dG <- 0
  
  for(i in 1:(nchar(sequence)-min_length+1)) {
    for(len in min_length:min(nchar(sequence)-i+1, nchar(sequence))) {
      subseq1 <- substr(sequence, i, i+len-1)
      subseq2 <- substr(rev_comp, nchar(sequence)-i-len+2, nchar(sequence)-i+1)
      
      matches <- sum(strsplit(subseq1, "")[[1]] == rev(strsplit(subseq2, "")[[1]]))
      if(matches >= 0.75 * len) {
        dG <- calculate_dG(subseq1, temperature)
        if(dG < min_dG) {
          min_dG <- dG
          best_structure <- list(
            pos = i,
            length = len,
            dG = dG,
            seq1 = subseq1,
            seq2 = subseq2
          )
        }
      }
    }
  }
  
  return(best_structure)
}

#' 计算 DNA 序列的 GC 含量
#'
#' @param sequence 字符串，DNA 序列
#' @return 数值，GC 含量百分比
#' @export
#' @examples
#' calculate_gc_content("ATGCTAGCTAGCTAG")  # 应该返回 46.7
calculate_gc_content <- function(sequence) {
  sequence <- toupper(sequence)
  gc_count <- sum(strsplit(sequence, "")[[1]] %in% c("G", "C"))
  gc_percent <- gc_count * 100 / nchar(sequence)
  return(gc_percent)
}

#' 获取引物基本信息
#'
#' @param sequence 字符串，DNA 序列
#' @return list 包含引物的基本信息
#' @export
#' @examples
#' get_primer_info("ATGCTAGCTAGCTAG")
get_primer_info <- function(sequence) {
  tm <- calculate_tm(sequence)
  gc <- calculate_gc_content(sequence)
  
  return(list(
    length = nchar(sequence),
    gc_content = round(gc, 1),
    tm = round(tm, 1),
    annealing_temp = round(tm, 1)  # 推荐的退火温度
  ))
}


#' @references 
#' Untergasser A, Cutcutache I, Koressaar T, et al. 
#' Primer3--new capabilities and interfaces. 
#' Nucleic Acids Res. 2012;40(15):e115. 
#' doi:10.1093/nar/gks596 