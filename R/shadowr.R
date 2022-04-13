
#' @title Shadow Class Constructer
#' @description This is a Class Constructer funtion to create a shadow class and are able to use the
#' Selenium plugin to manage multi level shadow DOM elements on a web page.
#' @param driver The shadow class takes a RSelenium RemoteDriver
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
