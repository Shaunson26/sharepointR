#' Get url site from a SharePoint URL
#'
#' to-do - input xyz.com/sites/team/to/many/paths
#'
#' @param url character string, URL from which to get the site name (http[s]?://xyz.com/sites/team)
get_site <- function(url){
  has_http <- grepl('^http', url)
  if(has_http){
  site_out <-  gsub('(http[s]?://)(.+\\.sharepoint\\.com)(.*)',
                    '\\3',
                    url)
  } else {
    site_out <-  gsub('(.+\\.sharepoint\\.com)(.*)',
                      '\\2',
                      url)
  }
  clean_path(site_out)
}
