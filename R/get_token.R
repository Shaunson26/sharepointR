#' Get security token for logging in
#'
#' @param base_site character string, the sharepoint base site address e.g. mysite.sharepoint.com '('https://' will be removed)
#' @param username character, your health email address
#' @param password character, your password
#' @param get_config boolean, whether to use proxy script (from Internet Explorer settings).
#' Will fail if you are outside the network and not on the VPN
#' @param config httr::config request, a httr::config list
#'
#' @export
get_token <- function(base_site, username, password, get_config = F, config){

  if (!missing(config) & get_config) {
    stop('get_config and config cannot be used together')
  }

  if (get_config) {
    config <- get_config()
  } else if (missing(config)){
    config <- NULL
  }

  request = readLines(system.file("saml.xml", package = "sharepointR"), warn = F)
  request = gsub("\\{Username\\}", username, request)
  request = gsub("\\{Password\\}", password, request)
  request = gsub("\\{Address\\}", base_site, request)

  response = httr::POST(url = "https://login.microsoftonline.com/extSTS.srf",
                        body = request,
                        config = config)

  if (response$status_code != 200) stop("Receiving security token failed.")

  content = xml2::as_list(xml2::read_xml(rawToChar(response$content)))

  if (!is.null(content$Envelope$Body$Fault))
    stop(content$Envelope$Body$Fault$Reason$Text[[1]])

  token = as.character(content$Envelope$Body$RequestSecurityTokenResponse$RequestedSecurityToken$BinarySecurityToken)

  token

}
