# Load necessary packages
library(tidyverse)
library(here)
library(janitor)
library(corrplot)
library(rsample)
library(parsnip)
library(yardstick)

# Load custom utility functions
source(here("00_config.R"))
source(here("01_import_data.R"))
source(here("02_clean_data.R"))
source(here("04_modeling.R"))
source(here("05_generate_report.R"))

# Main function for data analysis
main <- function() {
  # 1. Data import and cleaning
  input_file <- file.path(RAW_DATA_DIR, DEFAULT_INPUT_FILE)
  output_file <- file.path(PROCESSED_DATA_DIR, DEFAULT_CLEANED_DATA_FILE)
  
  # Check if input file exists
  if (!file.exists(input_file)) {
    stop("Raw data file does not exist: ", input_file, "\nPlease ensure the data file is in the specified location.")
  }
  
  # Perform data import and cleaning
  import_and_clean_data(input_file, output_file)
  
  # 2. Exploratory Data Analysis (EDA)
  cleaned_data <- readRDS(output_file)
  perform_eda(cleaned_data, OUTPUT_DIR)
  
  # 3. Modeling
  # Automatically determine the target variable (assumed to be the last numeric column)
  numeric_vars <- cleaned_data %>% select_if(is.numeric)
  target_var <- names(numeric_vars)[ncol(numeric_vars)]
  
  model_results <- build_model(
    data = cleaned_data,
    target_var = target_var,
    model_type = "lm",
    test_split_ratio = 0.2,
    output_model_path = file.path(PROCESSED_DATA_DIR, DEFAULT_MODEL_FILE)
  )
  
  # 4. Generate reports
  # Update the target variable name in the Rmd template
  update_rmd_template(target_var)
  
  # Generate HTML report
  generate_report(
    rmd_file_path = REPORT_RMD_FILE,
    output_file_path = file.path(OUTPUT_DIR, "analysis.html"),
    output_format = "html_document"
  )
  
  # Generate PDF report
  generate_report(
    rmd_file_path = REPORT_RMD_FILE,
    output_file_path = file.path(OUTPUT_DIR, "analysis.pdf"),
    output_format = "pdf_document"
  )
  
  message("Data analysis completed! Both HTML and PDF reports have been generated.")
}

# Helper function: Update target variable name in Rmd template
update_rmd_template <- function(target_var) {
  # Read Rmd file content with proper encoding
  rmd_content <- readLines(REPORT_RMD_FILE, encoding = "UTF-8")
  
  # Replace target variable name
  # Here we assume the Rmd file uses "price" as the target variable name
  rmd_content <- gsub("price", target_var, rmd_content, fixed = TRUE)
  
  # Write back to file with proper encoding
  writeLines(rmd_content, REPORT_RMD_FILE, useBytes = TRUE)
}