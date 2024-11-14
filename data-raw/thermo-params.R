#' 准备 DNA 序列热力学参数数据
#'
#' 基于 SantaLucia (1998) 的最近邻参数和其他热力学参数
#' 
#' @references
#' SantaLucia JR (1998) "A unified view of polymer, dumbbell and 
#' oligonucleotide DNA nearest-neighbor thermodynamics"
#' Proc Natl Acad Sci 95:1460-65
#' http://dx.doi.org/10.1073/pnas.95.4.1460

# 创建热力学参数数据
thermo_params <- list(
  # 最近邻参数 (ΔH kcal/mol, ΔS cal/mol·K)
  nn_parameters = list(
    "AA/TT" = c(-7.9, -22.2),  # AA/TT 碱基对
    "AT/TA" = c(-7.2, -20.4),  # AT/TA 碱基对
    "TA/AT" = c(-7.2, -21.3),  # TA/AT 碱基对
    "CA/GT" = c(-8.5, -22.7),  # CA/GT 碱基对
    "GT/CA" = c(-8.4, -22.4),  # GT/CA 碱基对
    "CT/GA" = c(-7.8, -21.0),  # CT/GA 碱基对
    "GA/CT" = c(-8.2, -22.2),  # GA/CT 碱基对
    "CG/GC" = c(-10.6, -27.2), # CG/GC 碱基对
    "GC/CG" = c(-9.8, -24.4),  # GC/CG 碱基对
    "GG/CC" = c(-8.0, -19.9)   # GG/CC 碱基对
  ),
  
  # 初始化参数
  init_params = list(
    "init" = c(0.2, -5.7),      # 序列起始参数
    "term_AT" = c(2.2, 6.9),    # AT 末端修正
    "term_GC" = c(3.0, 7.9)     # GC 末端修正
  )
)

# 保存数据
usethis::use_data(thermo_params, overwrite = TRUE)
