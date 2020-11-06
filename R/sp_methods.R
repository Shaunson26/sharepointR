#' @export
print.sp_connection <- function(x){
  cat('SharePoint connection list\n',
      '  site: ', file.path(x$site$base, x$site$site), '\n',
      if(!is.null(x$config)) { paste0('  proxy: ', x$config$options$proxy, '\n')} ,
      '  cookies: ', length(x$cookies),
      ' (', paste(names(x$cookies), collapse = ', '), ')\n', sep = '')
}

print.sp_contents <- function(x){
  base::print.data.frame(
    within(x, {
      ServerRelativeUrl = paste(substr(ServerRelativeUrl, 1, 20), "...", sep = "")
    })
  )
}
#
# print.sp_list <- function(x){
#   Names <- sapply(x, function(list_item) list_item$Name)
#   cat('sp_list with', length(Names), 'objects\n\n')
#   print(unname(Names))
# }
#
# print.sp_column <- function(x){
#   out <- cbind(rownames(x), t(x))
#   dimnames(out) <- list(1:nrow(out), c('Column', 'Value'))
#   print(out, quote = F)
# }
#
# print.sp_file_list <- function(x){
#   print(names(x))
# }


registerS3method('print', 'sp_connection', method = print.sp_connection)
registerS3method('print', 'sp_contents', method = print.sp_contents)
#registerS3method('print', 'sp_list', method = print.sp_list)
#registerS3method('print', 'sp_column', method = print.sp_column)

# print.sp_connection <- function(x) {
#   UseMethod("print.sp_connection")
# }
