clean_url <- function(url, return){

  base <- sub('^.+://', '', url)
  base <- sub('/.*', '', base)
  site <- sub(base, '', url)
  site <- sub('^.+:///', '', site)

  if (return == 'base'){
    return(base)
  }

  if (return == 'site'){
    return(site)
  }

}
