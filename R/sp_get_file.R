#' Download a file from SharePoint using a HTTP GET request
#'
#' @param connection a sp_connection object, that from a successful \code{sp_connection()} call
#' @param rurl a character string, the relative url (rurl) of the file you want to download
#' @param destfile a character string, the file name (and possibly file path) you want to save to. If missing
#' the file name from the connection will be used and file saved to the working directory.
#'
#' @return A message on whether the download was successful or not.
#'
#' @export
sp_get_file <- function(connection, rurl, destfile){

  if (grepl(sp_con$site$site, rurl)) {
    rurl <- sub(paste0('[\\/|]', sp_con$site$site, '[\\/|]'), '',  rurl)
  }

  url <- file.path(do.call(file.path, connection$site), URLencode(rurl))

  if (missing(destfile)){
    destfile = basename(url)
  }

  response = httr::GET(url,
                       httr::set_cookies(rtFa = connection$cookies$rtFa, FedAuth = connection$cookies$FedAuth),
                       config = connection$config,
                       httr::write_disk(destfile, overwrite = T))

  if (response$all_headers[[1]]$status == 200) {
    message('File successfully downloaded to ', destfile)
  } else {
    stop('File failed downloaded.')
  }

  invisible(NULL)

}
