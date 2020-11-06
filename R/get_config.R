#' Get IE proxy settings
#'
#' This may alleviate some issues with work proxy settings. On the other hand
#' if you are not connected to the VPN and outside the network, then this
#' function will fail. The proxy script cannot be downloaded in these latter
#' cases (set \code{use_config = FALSE in function calls})
#'
#' @return a httr::config request object. A list of settings.
#'
#' @export
get_config <- function(){

  httr::config(
    proxy = curl::ie_get_proxy_for_url(),
    proxyauth = 8,
    proxyuserpwd = ":",
    ssl_verifypeer = 0
  )

}
