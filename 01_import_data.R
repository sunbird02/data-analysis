#' Generic data import and cleaning function
#'
#' @param input_file_path String, path to the raw data file
#' @param output_file_path String, path to save the cleaned data
#' @param remove_na Logical, whether to remove missing values, default is TRUE
#' @return No return value, but saves the cleaned data to the specified path
#' @export
#'
#' @examples
#' import_and_clean_data("data/raw/my_data.csv", "data/processed/cleaned_data.rds")
import_and_clean_data <- function(input_file_path, output_file_path, remove_na = TRUE) {
  # Check if necessary packages are loaded
  if (!requireNamespace("tidyverse", quietly = TRUE)) {
    stop("Please install 'tidyverse' package: install.packages('tidyverse')")
  }
  if (!requireNamespace("here", quietly = TRUE)) {
    stop("Please install 'here' package: install.packages('here')")
  }
  if (!requireNamespace("janitor", quietly = TRUE)) {
    stop("Please install 'janitor' package: install.packages('janitor')")
  }
  
  # Read data
  message("Reading data: ", input_file_path)
  raw_data <- readr::read_csv(input_file_path)
  
  # Data cleaning and transformation
  message("Cleaning data...")
  cleaned_data <- raw_data %>%
    janitor::clean_names() # Clean column names to snake case
  
  # Remove missing values based on parameter
  if (remove_na) {
    cleaned_data <- cleaned_data %>% tidyr::drop_na()
  }
  
  # Save cleaned data
  message("Saving cleaned data to: ", output_file_path)
  saveRDS(cleaned_data, output_file_path)
  
  message("Data import and cleaning completed!")
}