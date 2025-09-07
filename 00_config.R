# Project configuration file
# Define global variables and paths used in the project

# Data directories
RAW_DATA_DIR <- here::here("data", "raw")
PROCESSED_DATA_DIR <- here::here("data", "processed")

# Output directory
OUTPUT_DIR <- here::here("img")

# Figures directory
FIGURES_DIR <- here::here("img")

# Default input file name
DEFAULT_INPUT_FILE <- "data.csv"

# Default output file names
DEFAULT_CLEANED_DATA_FILE <- "cleaned_data.rds"
DEFAULT_MODEL_FILE <- "final_model.rds"

# Report files
REPORT_RMD_FILE <- here::here("analysis.Rmd")
REPORT_OUTPUT_FILE <- here::here("reports", "analysis.pdf")