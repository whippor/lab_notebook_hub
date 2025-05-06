get_git_commit <- function(filepath) {
  # Step 1: Normalize path (make absolute), no matter where script is run from
  
  dataset_abs_path <- normalizePath(filepath, mustWork = TRUE)
  
  
  
  # Step 2: Start from the folder containing the file
  
  current_dir <- dirname(dataset_abs_path)
  
  
  
  # Step 3: Walk up until we find a .git folder
  
  while (!file.exists(file.path(current_dir, ".git")) && dirname(current_dir) != current_dir) {
    
    current_dir <- dirname(current_dir)
    
  }
  
  
  
  git_dir <- file.path(current_dir, ".git")
  
  fetch_head_file <- file.path(git_dir, "FETCH_HEAD")
  
  
  
  # Step 4: Validate the Git repository and FETCH_HEAD file
  
  if (!file.exists(fetch_head_file)) {
    
    stop("No FETCH_HEAD file found — are you sure this file is in a Git repository and you've run 'git fetch'?")
    
  }
  
  
  
  # Step 5: Extract the commit hash (first word of first line)
  
  first_line <- readLines(fetch_head_file, warn = FALSE)[1]
  
  commit_hash <- strsplit(first_line, "\\s+")[[1]][1]
  
  
  
  return(commit_hash)
  
}
