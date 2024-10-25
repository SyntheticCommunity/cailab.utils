## code to prepare `transformations` dataset goes here
session <- biocyc_session()
transformations <- biocyc_get_transformations(session)
usethis::use_data(transformations, overwrite = TRUE)
