#' List the contents of a SharePoint directory
#'
#' @param connection a sp_connection object, that from a successful \code{sp_connection()} call
#' @param rurl a character string, the relative url (rurl) of the folder you want to list contents
#' @param use_config boolean, whether to use proxy script (from Internet Explorer settings).
#' Will fail if you are outside the network and not on the VPN
#' @param recursive boolean, recursively search the directories. Not implemented yet.
#'
#' @return A data.frame with type, name and relative url information.
#'
#' @export
sp_list_contents <- function(connection, rurl, recursive = F){

  folders = sp_list_folders(connection, rurl)
  files = sp_list_files(connection, rurl)


  folders_out <- folders[, c('odata.type', 'Name', 'ServerRelativeUrl')]
  files_out <- data.frame(odata.type = files$`__metadata`$type,
                          Name = files$Name,
                          ServerRelativeUrl = files$ServerRelativeUrl)

  out <- rbind.data.frame(folders_out, files_out)

  names(out)[1] <- 'Type'
  out$Type <- sub('SP.', '', out$Type)

  class(out) <- c('sp_contents', class(out))

  out

}
