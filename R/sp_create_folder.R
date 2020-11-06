#' Create a folder on SharePoint
#'
#' @param connection a SharePoint connection
#' @param rurl character, sub-directory of the SharePoint site
#'
#' @export
sp_create_folder <- function(connection, rurl){


  if (grepl(sp_con$site$site, rurl)) {
    rurl <- sub(paste0('[\\/|]', sp_con$site$site, '[\\/|]'), '',  rurl)
  }

  url <- file.path(do.call(file.path, connection$site), '_api/web/folders',  sprintf("add('%s')", URLencode(rurl)))

  xrequestdigest <- httr::POST(url = url,
                               httr::set_cookies(rtFa = connection$cookies$rtFa, FedAuth = connection$cookies$FedAuth),
                               config = connection$config)

  xrequestdigest <- httr::headers(xrequestdigest)['x-requestdigest'][[1]]

  response <-
    httr::POST(url = url,
               httr::set_cookies(rtFa = connection$cookies$rtFa, FedAuth = connection$cookies$FedAuth),
               httr::accept("application/json;odata=verbose"),
               httr::add_headers(`x-requestdigest` = xrequestdigest),
               config = connection$config)

  if (response$status_code != 200) {
    stop('Creating folder failed with status: ', response$status_code)
  } else {
    message(file.path(do.call(file.path, connection$site), rurl), ' successfully created')
  }
}
