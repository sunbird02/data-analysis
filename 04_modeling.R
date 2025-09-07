#' Generic modeling function
#'
#' @param data Data frame for modeling
#' @param target_var String, name of the target variable
#' @param model_type String, model type ("lm" for linear regression, "rf" for random forest, etc.)
#' @param test_split_ratio Numeric, proportion of test set in total data, default is 0.2
#' @param output_model_path String, path to save the trained model
#' @return List containing the trained model, test set predictions, and model evaluation metrics
#' @export
#'
#' @examples
#' build_model(cleaned_data, "price", "lm", 0.2, "data/processed/final_model.rds")
build_model <- function(data, target_var, model_type = "lm", test_split_ratio = 0.2, output_model_path = NULL) {
  # Check if necessary packages are loaded
  if (!requireNamespace("tidyverse", quietly = TRUE)) {
    stop("Please install 'tidyverse' package: install.packages('tidyverse')")
  }
  if (!requireNamespace("rsample", quietly = TRUE)) {
    stop("Please install 'rsample' package: install.packages('rsample')")
  }
  if (!requireNamespace("parsnip", quietly = TRUE)) {
    stop("Please install 'parsnip' package: install.packages('parsnip')")
  }
  if (!requireNamespace("yardstick", quietly = TRUE)) {
    stop("Please install 'yardstick' package: install.packages('yardstick')")
  }
  if (!requireNamespace("recipes", quietly = TRUE)) {
    stop("Please install 'recipes' package: install.packages('recipes')")
  }
  
  # Split data into training and test sets
  message("Splitting data into training and test sets...")
  set.seed(123) # Set random seed for reproducible results
  split <- rsample::initial_split(data, prop = 1 - test_split_ratio)
  train_data <- rsample::training(split)
  test_data <- rsample::testing(split)
  
  # Create a recipe to handle factor variables
  message("Creating recipe for data preprocessing...")
  # Assume all predictors are used
  recipe_formula <- as.formula(paste("~ ."))
  
  data_recipe <- recipes::recipe(recipe_formula, data = train_data) %>%
    # Convert character variables to factors if any
    recipes::step_string2factor(recipes::all_nominal(), -tidyselect::all_of(target_var)) %>%
    # Create dummy variables for all factor variables
    recipes::step_dummy(recipes::all_nominal(), -tidyselect::all_of(target_var), one_hot = TRUE) %>%
    # Prepare the recipe
    recipes::prep()
  
  # Apply the recipe to training and test sets
  message("Applying recipe to training and test sets...")
  train_data_processed <- recipes::bake(data_recipe, new_data = train_data)
  test_data_processed <- recipes::bake(data_recipe, new_data = test_data)
  
  # Define model
  message("Defining model...")
  if (model_type == "lm") {
    model_spec <- parsnip::linear_reg() %>% parsnip::set_engine("lm")
  } else if (model_type == "rf") {
    model_spec <- parsnip::rand_forest() %>% parsnip::set_engine("randomForest")
  } else {
    stop("Unsupported model type. Currently only 'lm' and 'rf' are supported.")
  }
  
  # Train model
  message("Training model...")
  formula <- as.formula(paste(target_var, "~ ."))
  model_fit <- model_spec %>% parsnip::fit(formula, data = train_data_processed)
  
  # Make predictions on test set
  message("Making predictions on test set...")
  predictions <- model_fit %>% predict(test_data_processed)
  
  # Calculate evaluation metrics
  message("Calculating model evaluation metrics...")
  test_results <- test_data_processed %>%
    dplyr::select(!!target_var) %>%
    dplyr::mutate(predictions = predictions$.pred)
  
  # Calculate RMSE and R-squared
  rmse_val <- yardstick::rmse(test_results, !!sym(target_var), predictions)$.estimate
  rsq_val <- yardstick::rsq(test_results, !!sym(target_var), predictions)$.estimate
  
  # Show model summary
  if (model_type == "lm") {
    print(summary(model_fit$fit))
  }
  
  # Save model (if path is specified)
  if (!is.null(output_model_path)) {
    message("Saving model to: ", output_model_path)
    saveRDS(model_fit, output_model_path)
  }
  
  # Return results
  results <- list(
    model = model_fit,
    test_predictions = test_results,
    rmse = rmse_val,
    r_squared = rsq_val
  )
  
  message("Model building completed!")
  message("Test set RMSE: ", round(rmse_val, 3))
  message("Test set R-squared: ", round(rsq_val, 3))
  
  return(results)
}