#' Wrapper to download a sharepoint file
#'
#' @param url character, full URL of sharepoint file wanted
#' @param destfile character, the file name to save the file to
#' @param username character, your health email address. Using a keyring will help hide your password in workflows.
#' @param password character, your password
#' @param get_config boolean, whether to use proxy script (from Internet Explorer settings).
#' Will fail if you are outside the network and not on the VPN
#' @param config httr::config request, a httr::config list
#'
#' @examples
#'
#' \dontrun{
#'
#' url = "https://n...h.sharepoint.com/sites/group_i_am_part_of/folder_1/file.xlsx"
#'
#' get_sharepoint_file(url = url,
#'                     destfile = 'file.xlsx',
#'                     username = 'me@this.place.com',
#'                     password = keyring::key_get('mail'))
#'
#' }
#' @export
sp_qget <- function(url, destfile, username, password, get_config = F, config){

  if (!missing(config) & get_config) {
    stop('get_config and config cannot be used together')
  }

  if (get_config) {
    config <- get_config()
  } else if (missing(config)){
    config <- NULL
  }

  base <- get_base(url)

  if (missing(destfile)){
    destfile = basename(url)
  }

  token <- get_token(base_site = base, username = username, password = password, config = config)
  cookies <- get_cookie(base_site = base, token = token, config = config)

  response = httr::GET(URLencode(url),
                       httr::set_cookies(rtFa = cookies$rtFa, FedAuth = cookies$FedAuth),
                       config = config,
                       httr::write_disk(destfile, overwrite = T))

  if (response$all_headers[[1]]$status == 200) {
    message('File successfully downloaded to "', destfile, '"')
  } else {
    stop('File failed downloaded.')
  }

  invisible(NULL)

}
