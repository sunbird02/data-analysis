#' Generic exploratory data analysis (EDA) function
#'
#' @param data Data frame, cleaned data
#' @param output_dir String, directory path to save charts
#' @return No return value, but generates and saves charts to specified directory
#' @export
#'
#' @examples
#' perform_eda(cleaned_data, "output/")
perform_eda <- function(data, output_dir) {
  # Check if necessary packages are loaded
  if (!requireNamespace("tidyverse", quietly = TRUE)) {
    stop("Please install 'tidyverse' package: install.packages('tidyverse')")
  }
  if (!requireNamespace("here", quietly = TRUE)) {
    stop("Please install 'here' package: install.packages('here')")
  }
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Please install 'ggplot2' package: install.packages('ggplot2')")
  }
  if (!requireNamespace("corrplot", quietly = TRUE)) {
    stop("Please install 'corrplot' package: install.packages('corrplot')")
  }
  
  # Ensure output directory exists
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Get numeric variables
  numeric_vars <- data %>% select_if(is.numeric)
  
  # 1. Generate histograms for all numeric variables
  message("Generating distribution plots for numeric variables...")
  for (var in names(numeric_vars)) {
    p <- ggplot(data, aes_string(x = var)) +
      geom_histogram(fill = "steelblue", bins = 30, alpha = 0.8) +
      labs(title = paste("Distribution of", var), x = var, y = "Frequency") +
      theme_minimal()
    
    filename <- file.path(output_dir, paste0(var, "_distribution.png"))
    ggsave(filename, p, width = 8, height = 6)
  }
  
  # 2. Generate scatterplot matrix for all numeric variables
  message("Generating scatterplot matrix...")
  # To avoid too many charts, we only select the first 5 numeric variables for pairwise combinations
  selected_vars <- head(names(numeric_vars), 5)
  for (i in seq_along(selected_vars)) {
    for (j in seq_along(selected_vars)) {
      if (i < j) {
        var1 <- selected_vars[i]
        var2 <- selected_vars[j]
        p <- ggplot(data, aes_string(x = var1, y = var2)) +
          geom_point(alpha = 0.6, color = "steelblue") +
          geom_smooth(method = "lm", color = "red") +
          labs(title = paste(var1, "vs", var2), x = var1, y = var2) +
          theme_minimal()
        
        filename <- file.path(output_dir, paste0(var1, "_vs_", var2, ".png"))
        ggsave(filename, p, width = 8, height = 6)
      }
    }
  }
  
  # 3. Correlation analysis and heatmap
  message("Generating correlation matrix heatmap...")
  cor_matrix <- cor(numeric_vars)
  
  # Save correlation matrix as CSV file
  write.csv(cor_matrix, file.path(output_dir, "correlation_matrix.csv"))
  
  # Generate and save correlation heatmap
  corrplot_filename <- file.path(output_dir, "correlation_plot.png")
  png(corrplot_filename, width = 800, height = 800)
  corrplot::corrplot(cor_matrix, method = "color", type = "upper", 
                     tl.col = "black", tl.srt = 45, addCoef.col = "black")
  dev.off()
  
  message("Exploratory data analysis completed! Charts saved to: ", output_dir)
}