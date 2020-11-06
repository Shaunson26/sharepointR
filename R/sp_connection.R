#' Create a connection object to a SharePoint site
#'
#' @param site character, URL of the SharePoint site e.g. https://org.sharepoint.com/sites/our_team
#' @param username character, an email address, ID or other
#' @param password character, a password for the associated user name
#' @param get_config boolean, whether to use a proxy script (from Internet Explorer settings).
#' Will fail if you are outside the network and not on the VPN
#' @param config httr::config request, a httr::config list
#'
#' @return a list with objects:
#' * site - the input URL, a list with base and site parts
#' * config - a list of proxy settings
#' * cookie - a list of cookies
#'
#' @examples
#'\dontrun{
#'  sp_con <- sp_connection(site = 'https://org.sharepoint.com/sites/our_team',
#'                          username = 'me@org.place.come',
#'                          password = 'mypass')
#'}
#' @export
sp_connection <- function(site, username, password, get_config = F, config){

  if (!missing(config) & get_config) {
    stop('get_config and config cannot be used together')
  }

  if (get_config) {
    #cat('getting config\n')
    config <- get_config()
  } else if (missing(config)){
    #cat('config NULL\n')
    config <- NULL
  }

  base <- clean_url(site, return = 'base')
  site <- clean_url(site, return = 'site')

  # tokens and cookies
  token <- get_token(base_site = base,
                     username = username,
                     password = password,
                     config = config)

  cookies <- get_cookie(base_site = base,
                        token = token,
                        config = config)


  # return value
  structure(.Data =
              list(site = list(base = paste0('https://', base),
                               site = site),
                   config = config,
                   cookies = cookies),
            class = c('sp_connection', 'list'))

}
