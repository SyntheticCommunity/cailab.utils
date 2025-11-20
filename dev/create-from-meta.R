# dev/create_from_meta.R
# —— 极简包创建脚本，仅注入 Title / Description / Author —

library(yaml)
library(usethis)

create_cailab_package <- function(pkg_name, meta_path = "config/cailab-meta.yml") {
  # 读取配置
  meta <- read_yaml(meta_path)

  # 提取作者和包配置
  author_cfg <- meta$author
  pkg_cfg <- meta$packages[[pkg_name]]
  if (is.null(pkg_cfg)) {
    stop("Package '", pkg_name, "' not found in ", meta_path)
  }


  # 构造 Authors@R 字符串
  authors_r <- sprintf(
    'c(person(given = "%s", family = "%s", email = "%s",role = c("aut", "cre"), comment = c(ORCID = "%s")))',
    author_cfg$given,
    author_cfg$family,
    author_cfg$email,
    author_cfg$orcid
  )

  fields = list(
    "Title" = pkg_cfg$Title,
    "Description" = pkg_cfg$Description,
    "Authors@R" = authors_r
  )

  # 设置路径
  pkg_path <- file.path("packages", pkg_name)

  create_package(pkg_path, fields = fields, open = FALSE)

  message("✅ Configured: ", pkg_name)
}

create_all_package = function(meta_path = "config/cailab-meta.yml"){
  meta <- yaml::read_yaml(meta_path)
  pkg_names <- names(meta$packages)

  for (pkg in pkg_names) {
    create_cailab_package(pkg)
  }
}
