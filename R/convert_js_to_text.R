
#' @title Convert Plugin File
#' @description reads the Plugin file
#' @keywords internal


convert_js_to_text <- function(){
  file_name <- file.path(find.package("shadowr"),"resources","querySelector.js")
  print(file_name)
  return(readChar(file_name, file.info(file_name)$size))
}
