# library(agricolae)
# data(sweetpotato)
# model<-aov(yield~virus,data=sweetpotato)
# out <- duncan.test(model,"virus",
#                    main="Yield of sweetpotato. Dealt with different virus")
# plot(out,variation="IQR")

#' Plot a boxplot and add group to it
#'
#' See also: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6193594/
#'
#' @param data data
#' @param method aov
#' @param group group variable, should be a column in data
#' @param value values, should be a column in data
#' @param with_jitter add jitter points
#' @param label_repel use ggrepel to plot label
#'
#' @return a ggplot object
#' @export
#'
#' @importFrom ggplot2 ggplot aes geom_boxplot geom_jitter geom_text
#' @importFrom ggrepel geom_text_repel
#' @importFrom dplyr mutate left_join select
#' @importFrom tibble rownames_to_column
#' @importFrom rlang .data
#'
#' @examples
#'  data("PlantGrowth")
#'  gg_boxplot_with_group(PlantGrowth, group = "group", value = "weight")
gg_boxplot_with_group = function(data,
                                 group,
                                 value,
                                 method = "aov",
                                 with_jitter = TRUE,
                                 label_repel = TRUE){
  # run statistical analysis
  model = do.call(what = method,
                  list(formula = stats::formula(paste0(value, " ~ ", group)),
                       data = data))
  # get groups
  out = agricolae::duncan.test(model,
                               trt = group)

  # prepare group data
  groups = out$groups %>%
    rownames_to_column(var = {{ group }})
  label_pos = out$means %>%
    rownames_to_column(var = {{ group }}) %>%
    mutate(group_pos = .data$Max + .data$se) %>%  # use Max + se for place group label
    left_join(groups, by = {{ group }}) %>%
    select(c(group, "groups", "group_pos"))

  # plot
  p = ggplot(data = data,
             aes(x = .data[[group]],  # I don't know why {{}} isn't work
                 y = .data[[value]])) +
    geom_boxplot(outlier.shape = NA)

  if (with_jitter){
    p = p + geom_jitter(alpha = 0.5)
  }

  if (label_repel){
    label_geom = ggrepel::geom_text_repel
  } else {
    label_geom = geom_text
  }

  p = p + label_geom(
    mapping = aes(x = .data[[group]],
                  y = .data$group_pos,
                  label = groups),
    data = label_pos)

  return(p)
}

#' boxplot
#'
#' @param data data frame
#' @param x x
#' @param y y
#' @param method stat method, default is 'wilcox.test'
#' @param label default is 'p.signif'
#' @param ... pass to `ggpubr::stat_compare_means()`
#'
#' @return
#' @export
#'
#' @examples
#'   data("PlantGrowth")
#'   gg_boxplot(PlantGrowth, group, weight, ref.group = "ctrl")
#'   gg_boxplot(PlantGrowth,group, weight, ref.group = "ctrl",
#'              method = "t.test", label = "p.format")
gg_boxplot = function(data, x, y,
                      method = "wilcox.test",
                      label = "p.signif",
                      ref.group = NULL,
                      comparisons = NULL,
                      ...){
  p = ggplot2::ggplot(data, ggplot2::aes({{ x }}, {{ y }})) +
    ggplot2::geom_boxplot(outlier.shape = NA) +
    ggplot2::geom_jitter() +
    ggpubr::stat_compare_means(method = method,
                               ref.group = ref.group,
                               comparisons = comparisons,
                               label = label,
                               ...)
  return(p)
}
