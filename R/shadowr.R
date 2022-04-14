
#' @title Shadow Class Constructor
#' @description This is a Class Constructor function to create a shadow class and are able to use the
#' Selenium plugin to manage multiple levels of shadow elements on a web page.
#' @param driver The shadow class takes a R Selenium Remote Driver
#' @import methods
#' @import RSelenium
#' @keywords shadow
#' @seealso
#' \code{\link{shadow-class}} or
#' \cr
#' \url{https://github.com/Ricardo281/shadowr} for examples
#' @export
#'
shadow <- function(driver){

  new("shadow", driver = driver, javascript_library = convert_js_to_text())

}
