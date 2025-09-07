#' Generic report generation function
#'
#' @param rmd_file_path String, path to the R Markdown report template file
#' @param output_file_path String, path to save the generated report file
#' @param output_format String, report output format ("html_document", "pdf_document", etc.)
#' @param clean Logical, whether to clean up intermediate files after rendering, default is TRUE
#' @return No return value, but generates a report file
#' @export
#'
#' @examples
#' generate_report("analysis.Rmd", "output/analysis.pdf", "pdf_document")
generate_report <- function(rmd_file_path, output_file_path, output_format = "html_document", clean = TRUE) {
  # Check if necessary packages are loaded
  if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    stop("Please install 'rmarkdown' package: install.packages('rmarkdown')")
  }
  
  # Ensure output directory exists
  output_dir <- dirname(output_file_path)
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Render report
  message("Generating report...")
  rmarkdown::render(
    input = rmd_file_path,
    output_format = output_format,
    output_file = output_file_path,
    clean = clean
  )
  
  message("Report generation completed! Please check: ", output_file_path)
}