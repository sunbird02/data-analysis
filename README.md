# 汽车价格预测数据分析项目

本项目旨在分析汽车价格与各种因素（如车龄、行驶里程、马力等）之间的关系，并构建一个预测模型。项目代码完全使用 R 语言编写，并遵循标准的数据科学项目结构。

## 项目功能

- **数据导入与清洗**：自动从 CSV 文件导入数据，并进行清洗和预处理。
- **探索性数据分析 (EDA)**：生成各种图表来可视化数据分布和变量之间的关系。
- **建模预测**：使用线性回归等机器学习算法构建价格预测模型。
- **报告生成**：自动生成 HTML 和 PDF 格式的详细分析报告。

## 文件夹结构

- `data/`: 数据文件
  - `raw/`: 原始数据文件 (data.csv)
  - `processed/`: 处理后的数据文件 (cleaned_data.rds, final_model.rds)
- `docs/`: 项目文档 (未来可添加)
- `img/`: 图像文件和图形输出 (各种分析图表)
- `reports/`: 报告输出 (analysis.html, analysis.pdf)
- `analysis.Rmd`: R Markdown 报告模板

## 使用方法

### 先决条件

- 安装 [R](https://cran.r-project.org/) 和 [RStudio](https://posit.co/download/rstudio-desktop)
- 安装必要的 R 包：
  ```r
  install.packages(c("tidyverse", "here", "janitor", "corrplot", "rsample", "parsnip", "yardstick", "recipes", "rmarkdown"))
  ```

### 运行项目

1. 克隆或下载此仓库到本地。
2. 在 RStudio 中打开 `DA.Rproj` 项目文件。
3. 运行主分析脚本：
   ```r
   source("03_analysis.R")
   main()
   ```
   或者在命令行中运行：
   ```bash
   Rscript 03_analysis.R
   ```
4. 分析完成后，您可以在 `reports/` 文件夹中查看生成的 HTML 和 PDF 报告。

### 自定义数据

如果您想用自己的数据进行分析，请将您的 CSV 文件重命名为 `data.csv` 并替换 `data/raw/data.csv` 文件。确保您的数据包含与示例数据相似的列（如 Age, KM, Weight, HP, MetColor, CC, Doors, Price）。

## R 脚本说明

分析流程由根目录下的编号 R 脚本组织：

1. `00_config.R`: 项目配置设置和路径定义
2. `01_import_data.R`: 数据导入和清洗函数
3. `02_clean_data.R`: 探索性数据分析 (EDA) 和图表生成函数
4. `03_analysis.R`: 主分析脚本，协调整个分析流程
5. `04_modeling.R`: 建模函数
6. `05_generate_report.R`: 报告生成函数

## 贡献

欢迎提交 Issue 和 Pull Request 来改进此项目。

## 许可证

本项目采用 [MIT 许可证](LICENSE)。