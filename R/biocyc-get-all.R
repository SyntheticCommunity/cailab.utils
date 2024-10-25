
#' 获取所有数据
#'
#' 此函数用于获取指定生物体数据库中的所有数据
#'
#' @param session httr::handle对象，表示已建立的BioCyc会话
#' @param orgid 字符串，生物体数据库标识符（如 "ECOLI"），获取 organism 数据时可以不填
#' @param type 字符串，数据类型（如 "pathways", "genes"，详见 details
#'
#' @details `type` 参数一共支持 23 种类型，分别是（不区分大小写）：
#'  1. "ATTENUATORS": 衰减子
#'  2. "COMPOUNDS": 化合物
#'  3. "GENES": 基因
#'  4. "ORGANISMS": 物种
#'  5. "PATHWAYS": 通路
#'  6. "PROMOTERS": 启动子
#'  7. "PROTEINS": 全部蛋白质，包括多肽和蛋白质复合体
#'  8. "POLYPEPTIDES": 多肽
#'  9. "PROTEIN-COMPLEXES": 蛋白质复合物
#'  10. "ENZYMES": 酶
#'  11. "RIBOSOMAL-PROTEINS": 核糖体蛋白质
#'  12. "TRANSCRIPTION-FACTORS": 转录因子
#'  13. "TRANSPORTERS": 转运蛋白
#'  14. "CYTOSOLIC-PROTEINS": 细胞质蛋白质
#'  15. "MEMBRANE-PROTEINS": 膜蛋白质
#'  16. "PERIPLASMIC-PROTEINS": 周质蛋白质
#'  17. "PUBLICATIONS": 出版物
#'  18. "REACTIONS": 反应
#'  19. "RIBOSWITCHES": 核糖开关
#'  20. "RNAS": RNA
#'  21. "TERMINATORS": 终止子
#'  22. "TRANSCRIPTION-FACTOR-BINDING-SITES": 转录因子结合位点
#'  23. "TRANSCRIPTION-UNITS": 转录单位
#' @return 数据框，包含所有数据
#' @export
#' @importFrom httr GET content status_code
#' @importFrom readr read_delim
biocyc_get_all = function(session, type = "pathways", orgid = "ECOLI") {
  type = toupper(type)
  type_available = c("ATTENUATORS","COMPOUNDS","GENES","ORGANISMS","PATHWAYS",
                     "PROMOTERS", paste0("PROTEINS-", 0:9), 
                     "PUBLICATIONS", "REACTIONS", "RIBOSWITCHES", "RNAS",
                     "TERMINATORS","TRANSCRIPTION-FACTOR-BINDING-SITES", 
                     "TRANSCRIPTION-UNITS")
  protein_types = c("PROTEINS", "POLYPEPTIDES", "PROTEIN-COMPLEXES", "ENZYMES",
                    "RIBOSOMAL-PROTEINS", "TRANSCRIPTION-FACTORS", "TRANSPORTERS",
                    "CYTOSOLIC-PROTEINS", "MEMBRANE-PROTEINS", "PERIPLASMIC-PROTEINS")
  if (type %in% protein_types) {
    type = paste0("PROTEINS-", which(type == protein_types)-1) # 从 0 开始
  }
  if (!type %in% type_available) {
    stop("Invalid type: ", type, " Please choose from: ", paste(type_available, collapse = ", "))
  }
  type = match.arg(type, type_available)
  cli::cli_alert_info("Fetching all {type} for {orgid}")
  url = paste0("https://websvc.biocyc.org/st-get?format=tsv&id=:ALL-", type, "&orgid=", orgid)
  response = httr::GET(url, handle = session)
  if (httr::status_code(response) %in% c(200, 201)) {
    content = httr::content(response, "text", encoding = "UTF-8")
    data = readr::read_delim(content, delim = "\t", col_names = TRUE, show_col_types = FALSE)
    return(data)
  } else {
    stop("Fetch all ", type, " failed: ", httr::content(response, "text"))
  }
}
