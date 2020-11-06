#' Get cookies
#'
#' @param base_site character string, the sharepoint base site address e.g. mysite.sharepoint.com '('https://' will be removed)
#' @param token the output from a successful \code{get_token()} call
#' @param get_config boolean, whether to use proxy script (from Internet Explorer settings).
#' Will fail if you are outside the network and not on the VPN
#' @param config httr::config request, a httr::config list

#'
#' @export
get_cookie <- function(base_site, token, get_config = F, config){

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

  base_site = sub('^.+://', '', base_site)

  post_url = sprintf("https://%s/_forms/default.aspx?wa=wsignin1.0", base_site)

  response = httr::POST(post_url,
                        body = token,
                        httr::add_headers(Host = base_site),
                        config = config)

  if (response$status_code != 200) stop("Receiving access cookies failed.")

  cookie = list(rtFa = response$cookies$value[response$cookies$name %in% "rtFa"],
                FedAuth = response$cookies$value[response$cookies$name %in% "FedAuth"])

  cookie

}
