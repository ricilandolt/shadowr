
#' @title CLASS shadow
#' @description Selenium plugin to manage multiple levels of shadow elements on web page. Returning a \code{RSelenium::WebElement} which you can access like you used to.
#' @import methods
#' @import RSelenium
#' @keywords shadow
#' @slot driver The shadow class takes a Remote Driver
#' @slot javascript_library the selenium plugin
#' @param shadowObject the shadow class
#' @param element a web element
#' @param css_selector selector string to find a web element
#' @exportClass shadow
#' @rdname shadow-class
#' @name shadow-class
#' @seealso \url{https://github.com/ricilandolt/shadowr} for examples
#' @return  Depends on the method, either a \code{RSelenium::WebElement} or a \code{boolean}.
#' @examples \dontrun{

#' library(shadowr)
#' library(RSelenium)
#' remDr <- RSelenium::remoteDriver(
#' remoteServerAddr = "host.docker.internal",
#' port = 4445 , browser = "chrome")
#' remDr$open(silent = TRUE)
#' remDr$navigate(url)
#' shadow_rd <- shadow(remDr)
#' element <- find_element(shadow_rd, 'paper-tab[title="Settings"]')
#' elements <- find_elements(shadow_rd, 'paper-tab[title="Settings"]')
#' element$getElementText()



#' library(shadowr)
#' library(RSelenium)
#' remDr <- RSelenium::remoteDriver(
#' remoteServerAddr = "host.docker.internal",
#' port = 4445 , browser = "chrome")
#' remDr$open(silent = TRUE)
#' remDr$navigate(url)
#' shadow_rd <- shadow(remDr)
#' element <- find_element(shadow_rd, 'input[title="The name of the employee"]')
#' elements <- find_elements(shadow_rd, 'input[title="The name of the employee"]')
#' element$getElementText()



#' library(shadowr)
#' library(RSelenium)
#' remDr <- RSelenium::remoteDriver(
#'  remoteServerAddr = "host.docker.internal",
#' port = 4445 , browser = "chrome")
#' remDr$open(silent = TRUE)
#' remDr$navigate(url)
#' shadow_rd <- shadow(remDr)
#' element <- find_element(shadow_rd, "properties-page#settingsPage>textarea#textarea")
#' element$getElementText()}


setClass("shadow",
         slots = c(
           driver = "remoteDriver",
           javascript_library = "character"
         )
)

setGeneric(name="inject_shadow_executor",
           def=function(shadowObject,script, element)
           {
             standardGeneric("inject_shadow_executor")
           }
)


setMethod(f="inject_shadow_executor",
          signature=c("shadow","character", "missing"),
          definition=function(shadowObject,script, element)
          {
            result <- shadowObject@driver$executeScript(script)
            if(length(result) ==1){
              if(is(result[[1]], "webElement")){
                result <- result[[1]]
              } else {
                if(grepl("TRUE|FALSE", result)){
                  result <- as.logical(result)
                } else {
                  result <- list(RSelenium::webElement$new(as.character(result[[1]]))$import(shadowObject@driver))
                }
              }
            } else if(length(result)>1){
              result <- lapply(result, function(x) RSelenium::webElement$new(as.character(x[[1]]))$import(shadowObject@driver))
            }

            return(result)
          }
)


setMethod(f="inject_shadow_executor",
          signature=c("shadow","character","webElement" ),
          definition=function(shadowObject,script, element)
          {
            result <- shadowObject@driver$executeScript(script, args=list(element))
            if(length(result) ==1){
              if(is(result[[1]], "webElement")){
                result <- result[[1]]
              } else {
                if(grepl("TRUE|FALSE", result)){
                  result <- as.logical(result)
                } else {
                  result <- list(RSelenium::webElement$new(as.character(result[[1]]))$import(shadowObject@driver))
                }
              }
            } else if(length(result)>1){
              result <- lapply(result, function(x) RSelenium::webElement$new(as.character(x[[1]]))$import(shadowObject@driver))
            }

            return(result)
          }
)



setGeneric(name="executor_get_object",
           def=function(shadowObject,script, element)
           {
             standardGeneric("executor_get_object")
           }
)


setMethod(f="executor_get_object",
          signature=c("shadow","character", "missing"),
          definition=function(shadowObject,script, element)
          {
            javascript <- paste0(shadowObject@javascript_library,script)
            return(inject_shadow_executor(shadowObject,javascript))
          }
)


setMethod(f="executor_get_object",
          signature=c("shadow","character","webElement" ),
          definition=function(shadowObject,script, element)
          {
            javascript <- paste0(shadowObject@javascript_library,script)
            return(inject_shadow_executor(shadowObject,javascript,element))
          }
)

#' @rdname shadow-class
#' @export
setGeneric(name="find_element",
           def=function(shadowObject,css_selector,element)
           {
             standardGeneric("find_element")
           }
)

#' @describeIn shadow-class Use this method if want single element
#' @export
setMethod(f="find_element",
          signature=c("shadow","character","missing"),
          definition=function(shadowObject,css_selector,element)
          {
            command <- paste0("return getObject('", css_selector, "');")
            element <- executor_get_object(shadowObject,command)

            if(length(element)==0){
              stop(paste("Element with selector",css_selector, "is not in dom"))
            }

            return(element)
          }


)


#' @describeIn  shadow-class Use this if you want to find a single elements from parent object
#' @export
setMethod(f="find_element",
          signature=c("shadow","character","webElement"),
          definition=function(shadowObject,css_selector,element)
          {
            command <- paste0("return getObject('", css_selector, "', arguments[0]);")
            element <- executor_get_object(shadowObject,command,element)


            if(length(element)==0){
              stop(paste("Element with selector",css_selector, "is not in dom"))
            }

            return(element)
          }


)

#' @rdname shadow-class
#' @export
setGeneric(name="find_elements",
           def=function(shadowObject,css_selector,element)
           {
             standardGeneric("find_elements")
           }
)

#' @describeIn  shadow-class Use this if you want to find all elements
#' @export
setMethod(f="find_elements",
          signature=c("shadow","character","missing"),
          definition=function(shadowObject,css_selector,element)
          {
            command <- paste0("return getAllObject('", css_selector, "');")
            element <- executor_get_object(shadowObject,command)

            return(element)
          }
)

#' @describeIn  shadow-class Use this if you want to find all elements from parent object
#' @export
setMethod(f="find_elements",
          signature=c("shadow","character","webElement"),
          definition=function(shadowObject,css_selector,element)
          {
            command <- paste0("return getAllObject('", css_selector, "', arguments[0]);")
            element <- executor_get_object(shadowObject,command,element)

            return(element)
          }
)


#' @rdname shadow-class
#' @export
setGeneric(name="get_shadow_element",
           def=function(shadowObject,css_selector, element)
           {
             standardGeneric("get_shadow_element")
           }
)

#' @describeIn  shadow-class Use this if you want to find a single element from parent
#' @export
setMethod(f="get_shadow_element",
          signature=c("shadow","character","webElement"),
          definition=function(shadowObject,css_selector,element)
          {
            command <- paste0("return getShadowElement(arguments[0], '", css_selector, "');")
            return(executor_get_object(shadowObject,command, element))
          }
)

#' @rdname shadow-class
#' @export
setGeneric(name="get_all_shadow_element",
           def=function(shadowObject,css_selector,element)
           {
             standardGeneric("get_all_shadow_element")
           }
)

#' @describeIn  shadow-class Use this if you want to find all elements from parent
#' @export
setMethod(f="get_all_shadow_element",
          signature=c("shadow","character","webElement"),
          definition=function(shadowObject,css_selector,element)
          {
            command <- paste0("return getShadowElement(arguments[0], '", css_selector, "');")
            return(executor_get_object(shadowObject,command, element))
          }
)


#' @rdname shadow-class
#' @export
setGeneric(name="get_parent_element",
           def=function(shadowObject,element)
           {
             standardGeneric("get_parent_element")
           }
)

#' @describeIn  shadow-class Use this to get the parent element if web element
#' @export
setMethod(f="get_parent_element",
          signature=c("shadow","webElement"),
          definition=function(shadowObject,element)
          {
            command <- "return getParentElement(arguments[0]);"
            return(executor_get_object(shadowObject,command, element))
          }
)


#' @rdname shadow-class
#' @export
setGeneric(name="get_sibling_element",
           def=function(shadowObject,element,css_selector)
           {
             standardGeneric("get_sibling_element")
           }
)

#' @describeIn  shadow-class Use this to get adjacent(sibling) element
#' @export
setMethod(f="get_sibling_element",
          signature=c("shadow","webElement","character"),
          definition=function(shadowObject,element,css_selector)
          {
            command <- paste("return getSiblingElement(arguments[0],'",css_selector,"');")
            return(executor_get_object(shadowObject,command, element))
          }
)

#' @rdname shadow-class
#' @export
setGeneric(name="get_previous_sibling_element",
           def=function(shadowObject,element)
           {
             standardGeneric("get_previous_sibling_element")
           }
)

#' @describeIn  shadow-class Use this to get previous adjacent(sibling) element
#' @export
setMethod(f="get_previous_sibling_element",
          signature=c("shadow","webElement"),
          definition=function(shadowObject,element)
          {
            command <- "return getPreviousSiblingElement(arguments[0]);"
            return(executor_get_object(shadowObject,command, element))
          }
)



#' @rdname shadow-class
#' @export
setGeneric(name="get_next_sibling_element",
           def=function(shadowObject,element)
           {
             standardGeneric("get_next_sibling_element")
           }
)

#' @describeIn  shadow-class Use this to get next adjacent(sibling) element
#' @export
setMethod(f="get_next_sibling_element",
          signature=c("shadow","webElement"),
          definition=function(shadowObject,element)
          {
            command <- "return getNextSiblingElement(arguments[0]);"
            return(executor_get_object(shadowObject,command, element))
          }
)


#' @rdname shadow-class
#' @export
setGeneric(name="scroll_to",
           def=function(shadowObject,element)
           {
             standardGeneric("scroll_to")
           }
)

#' @describeIn  shadow-class Use this to scroll to web element
#' @export
setMethod(f="scroll_to",
          signature=c("shadow","webElement"),
          definition=function(shadowObject,element)
          {
            command <- "return scrollTo(arguments[0]);"
            return(executor_get_object(shadowObject,command, element))
          }
)

#' @rdname shadow-class
#' @export
setGeneric(name="is_checked",
           def=function(shadowObject,element)
           {
             standardGeneric("is_checked")
           }
)

#' @describeIn  shadow-class Use this if you want to check if checkbox is selected
#' @export
setMethod(f="is_checked",
          signature=c("shadow","webElement"),
          definition=function(shadowObject,element)
          {
            command <- "return isChecked(arguments[0]);"
            return(executor_get_object(shadowObject,command, element))
          }
)

#' @rdname shadow-class
#' @export
setGeneric(name="is_disabled",
           def=function(shadowObject,element)
           {
             standardGeneric("is_disabled")
           }
)

#' @describeIn  shadow-class Use this if you want to check if element is disabled
#' @export
setMethod(f="is_disabled",
          signature=c("shadow","webElement"),
          definition=function(shadowObject,element)
          {
            command <- "return isDisabled(arguments[0]);"
            return(executor_get_object(shadowObject,command, element))
          }
)

#' @rdname shadow-class
#' @export
setGeneric(name="is_visible",
           def=function(shadowObject,element)
           {
             standardGeneric("is_visible")
           }
)

#' @describeIn  shadow-class Use this if you want to find visibility of element
#' @export
setMethod(f="is_visible",
          signature=c("shadow","webElement"),
          definition=function(shadowObject,element)
          {
            command <- "return isVisible(arguments[0]);"
            return(executor_get_object(shadowObject,command, element))
          }
)




