#' DNA 序列热力学参数
#'
#' SantaLucia 的最近邻热力学参数数据集，用于计算 DNA 序列的热力学性质。
#'
#' @format 一个列表，包含两个子列表：
#' \describe{
#'   \item{nn_parameters}{最近邻参数，每个参数包含 ΔH (kcal/mol) 和 ΔS (cal/mol·K)}
#'   \item{init_params}{初始化参数，包含序列起始和末端效应的修正值}
#' }
#' @source SantaLucia JR (1998) "A unified view of polymer, dumbbell and 
#' oligonucleotide DNA nearest-neighbor thermodynamics"
#' Proc Natl Acad Sci 95:1460-65
#' http://dx.doi.org/10.1073/pnas.95.4.1460
"thermo_params"