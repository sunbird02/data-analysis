# Data Analysis Project

This project follows a standard data analysis project structure.

## Folder Structure

- `data/`: Contains data files
  - `raw/`: Raw data files
  - `processed/`: Processed data files
- `docs/`: Project documentation
- `img/`: Image files and graphical outputs
- `reports/`: Report outputs (HTML, PDF, etc.)
- `scripts/`: Utility scripts (if any)

## R Script Files

The main analysis workflow is organized in numbered R scripts in the root directory:

1. `00_config.R`: Configuration settings
2. `01_import_data.R`: Data import functions
3. `02_clean_data.R`: Data cleaning functions
4. `03_analysis.R`: Main analysis
5. `04_modeling.R`: Modeling functions
6. `05_generate_report.R`: Report generation functions

## Other Files

- `analysis.Rmd`: R Markdown file for the analysis report
- `DA.Rproj`: RStudio project file
- `.Rhistory`: R history file