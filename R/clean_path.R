#' Clean paths of leading and trailing slashes
#'
#' Clean paths of leading and trailing slashes to work cleanly with file.path().
#' A wrapper gsub
#'
#' @param x character string, a path to clean
clean_path <- function(x){
  gsub('^/|/$', '', x)
}
