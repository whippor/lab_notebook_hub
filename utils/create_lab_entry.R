create_lab_entry <- function(project_path, title = "Lab Entry") {
  entry_dir <- file.path(project_path, "lab_notebook", "entries")
  log_file <- file.path(project_path, "lab_notebook", "log", "data_reference_log.csv")
  
  date <- Sys.Date()
  filename <- sprintf("%s_entry.qmd", date)
  filepath <- file.path(entry_dir, filename)
  
  content <- glue::glue(
    "---
title: \"{title}\"
date: {date}
format: html
---

## Objective

## Method

## Results

## Notes
"
  )
  
  if (!file.exists(filepath)) {
    writeLines(content, filepath)
    message(glue::glue("✅ Entry created: {filename}"))
    
    # Log it
    log_entry <- tibble::tibble(
      date = date,
      entry = filename,
      description = title,
    )
    
    if (file.exists(log_file)) {
      log <- readr::read_csv(log_file, show_col_types = FALSE)
      log <- dplyr::bind_rows(log, log_entry)
    } else {
      log <- log_entry
    }
    
    readr::write_csv(log, log_file)
  } else {
    message("⚠️ Entry already exists.")
  }
  
  return(filepath)
}
