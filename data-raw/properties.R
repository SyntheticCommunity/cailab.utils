## code to prepare `properties` dataset goes here
session <- biocyc_session()
properties <- biocyc_get_properties(session)
usethis::use_data(properties, overwrite = TRUE)

