#' Clean the site from a relative URL
#'
#' @param rurl character string, the relative URL with the site
#' @param site character string, the site string to remove
clean_site <- function(rurl, site){
  sub(sprintf('[/]?%s[/]?', site), '', rurl)
}
