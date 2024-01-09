# a valid input for SpectralKeras looks like this
# 0  1000  1001  1002  1003 ...
# lab1  123 140  180  150  ...
# lab2 ... ... ... ... ...

generate_spectralkeras_data = function(n = 1000, label_n = 10, from = 1000, to = 1500, step = 1, seed = 0, label_prefix = ""){
  set.seed(seed)
  label = paste0(label_prefix, 1:label_n)
  colname = c("0", as.character(seq(from, to, by = step)))
  rowlab = sample(label, size = n, replace = TRUE)
  m = (to - from)/1 + 1
  mat = matrix(data = rnorm(n = n * m), nrow = n)
  data = cbind(rowlab, as.data.frame(mat))
  colnames(data) = colname
  as_tibble(data)
}