#' Upload a file to SharePoint using a HTTP POST request
#'
#' @param connection a sp_connection object, that from a successful \code{sp_connection()} call
#' @param rurl a character string, the relative url (rurl) of the folder you want to upload to
#' @param file a character string, the file you want to upload from your system
#' Will fail if you are outside the network and not on the VPN
#'
#' @return A message on whether the upload was successful or not.
#'
#' @export
sp_post_file <- function(connection, rurl, file){

  if (!file.exists(file)) {
    stop ('Cannot find specified file to upload')
  }

  # Remove site URI if present
  if (grepl(connection$site$site, rurl)) {
    # [/]site[/]
    rurl <- sub(paste0('[\\/]?', connection$site$site, '[\\/]?'), '',  rurl)
  }

  # Leading/trailing /
  rurl = gsub('^\\/?|\\/?$', '', rurl)

  # Build URL
  re_rurl = sprintf("GetFolderByServerRelativeUrl('%s')/files", URLencode(rurl))
  re_file = sprintf("add(url='%s',overwrite=true)", URLencode(basename(file)))
  url <- file.path(do.call(file.path, connection$site), '_api/web', re_rurl, re_file)
  print(url)

  # Begin POST
  xrequestdigest <- httr::POST(url = url,
                               httr::set_cookies(rtFa = connection$cookies$rtFa, FedAuth = connection$cookies$FedAuth),
                               config = connection$config)

  xrequestdigest <- httr::headers(xrequestdigest)['x-requestdigest'][[1]]

  # POST
  response <-
    httr::POST(url = url,
               httr::set_cookies(rtFa = connection$cookies$rtFa, FedAuth = connection$cookies$FedAuth),
               httr::add_headers(`x-requestdigest` = xrequestdigest),
               config = connection$config,
               body = httr::upload_file(file))

  # Outcome
  if (response$status_code != 200) {
    stop('Uploading file failed with status: ', response$status_code)
  } else {
    message('File successfully uploaded to: ', file.path(do.call(file.path, connection$site), rurl, basename(file)))
  }

}
