#' Get full file information from an SharePoint site
#'
#' @param connection a SharePoint connection
#' @param rurl character, sub-directory of the SharePoint site
#'
#' @return a data.frame of the file information from the sub-directory
sp_list_files <- function(connection, rurl){

  if (missing(rurl)) rurl <- ''

  url <- file.path(do.call(file.path, connection$site), '_api/web',
                   sprintf("GetFolderByServerRelativeUrl('%s')", URLencode(rurl)), 'files')

  response <-
    httr::GET(url,
              httr::set_cookies(rtFa = connection$cookies$rtFa, FedAuth = connection$cookies$FedAuth),
              httr::accept("application/json;odata=verbose"),
              config = connection$config)

  if (response$status_code != 200) stop("Receiving files list failed.")

  content <- httr::content(response, as = 'text')

  out <- jsonlite::fromJSON(content)$d$results

  out

  # ## Class stuff
  #
  # out_list <- lapply(seq(nrow(out)), function(i) {
  #   out_row <- out[i,]
  #   #class(out_row) <- c('sp_column', class(out_row))
  #   out_row
  # })
  # #
  # names(out_list) <- out$Name
  # #
  # # class(out_list) <- c('sp_list', class(out_list))
  # #
  # out_list

}
