#' Get url basename
#'
#' @param url character string, URL from which to get the basename (http[s]?://xyz.com)
get_base <- function(url){
  has_http <- grepl('^http', url)
  if(has_http){
    gsub('(http[s]?://)(.+\\.sharepoint\\.com)(.*)',
       '\\1\\2',
       url)
  } else {
    message('http scheme is missing, https will be assumed')
    gsub('(.+\\.sharepoint\\.com)(.*)',
         'https://\\1',
         url)
  }
}
