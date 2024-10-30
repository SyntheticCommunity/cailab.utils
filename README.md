# cailab.utils

<!-- badges: start -->
[![R-CMD-check](https://github.com/syntheticcommunity/cailab.utils/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/syntheticcommunity/cailab.utils/actions/workflows/R-CMD-check.yaml)
[![pkgdown](https://github.com/syntheticcommunity/cailab.utils/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/syntheticcommunity/cailab.utils/actions/workflows/pkgdown.yaml)
<!-- badges: end -->

## 概述

cailab.utils 是一个 R 包，包含了在蔡实验室日常数据分析中常用的工具函数。主要功能包括：

1. 数据处理与可视化
   - 统计绘图函数
   - 网络分析与可视化
   - 数据表格处理

2. R Markdown 文档生成
   - Rnw 转 Rmd 工具
   - 图表标题链接
   - 文档格式化工具

3. 序列分析
   - 序列比对
   - 特异性引物设计
   - 系统发育树构建

4. 合成群落分析
   - 群落组合生成
   - 群落设计工具

5. BioCyc 数据库交互
   - 富集分析
   - 通路分析
   - 基因注释

6. AI 集成
   - 智谱 AI 接口
   - GPT-4 接口
   - 百度分词

## 安装

```r
# 从 GitHub 安装
# install.packages("devtools")
devtools::install_github("syntheticcommunity/cailab.utils")
```

## 使用示例

### BioCyc 数据库查询

```r
library(cailab.utils)

# 创建 BioCyc 会话
session <- biocyc_session(username, password)

# 获取基因列表
genes <- biocyc_get_all(session, "ECOLI", "Genes")

# 创建智能表
table_id <- biocyc_create_smart_table(session, "ECOLI", values = genes[1:10])
```

### 序列分析

```r
# 运行序列比对
alignment <- run_alignment_with_muscle(sequences)

# 构建系统发育树
tree <- tree_from_aln(alignment)
```

### 统计绘图

```r
# 箱线图
gg_boxplot(data, x = "group", y = "value")

# 饼图
ggpie(data, "category", "value")
```

## 文档

完整的文档请访问 [在线文档](https://syntheticcommunity.github.io/cailab.utils/)。

## 贡献

欢迎提交问题和建议到 [Issues](https://github.com/syntheticcommunity/cailab.utils/issues)。

## 许可证

本项目采用 GPL-3 许可证。详见 [LICENSE](LICENSE) 文件。

## 作者

Chun-Hui Gao ([@gaospecial](https://github.com/gaospecial))

## 引用

如果您在研究中使用了本软件包，请引用：

```bibtex
@software{cailab.utils,
  author = {Gao, Chun-Hui},
  title = {cailab.utils: Collection of data analysis utilities in Cai Lab @ HZAU},
  year = {2024},
  publisher = {GitHub},
  url = {https://github.com/syntheticcommunity/cailab.utils}
}
``` 