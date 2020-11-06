#' Get full folder information from an SharePoint site
#'
#' @param connection a SharePoint connection
#' @param sub_dir character, sub-directory of the SharePoint site
#'
#' @return a data.frame of the folder information from the sub-directory
sp_list_folders <- function(connection, sub_dir){

  ## Input
  if (!missing(sub_dir)) {
    sub_dir = sprintf("GetFolderByServerRelativeUrl('%s')", URLencode(sub_dir))
    url <- file.path(do.call(file.path, connection$site), '_api/web', sub_dir, 'folders')
  } else {
    url <- file.path(do.call(file.path, connection$site), '_api/web', 'folders')
  }

  ## Consistent part
  response <-
    httr::GET(url,
              httr::set_cookies(rtFa = connection$cookies$rtFa, FedAuth = connection$cookies$FedAuth),
              config = connection$config)

  if (response$status_code != 200) stop("Receiving folders list failed.")

  content <- httr::content(response, as = 'text')

  out <- jsonlite::fromJSON(content)$value

  out

  # ## Class stuff
  #
  # out_list <- lapply(seq(nrow(out)), function(i) {
  #   out_row <- out[i,]
  #   class(out_row) <- c('sp_column', class(out_row))
  #   out_row
  # })
  #
  # names(out_list) <- out$Name
  #
  # class(out_list) <- c('sp_list', class(out_list))
  #
  # out_list

}
