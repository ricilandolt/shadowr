
#' @title CLASS shadow
#' @description Selenium plugin to manage multi level shadow DOM elements on web page.
#' @import methods
#' @import RSelenium
#' @keywords shadow
#' @slot driver The shadow class takes a RSelenium RemoteDriver
#' @slot javascript_library the selenium plugin
#' @param theObject the shadow class
#' @param element a RSelenium webelement
#' @param css_selector a css string to find a webelement
#' @exportClass shadow
#' @rdname shadow-class
#' @name shadow-class
#' @seealso \url{https://github.com/Ricardo281/shadowr} for examples


setClass("shadow",
         slots = c(
           driver = "remoteDriver",
           javascript_library = "character"
         )
)

setGeneric(name="inject_shadow_executor",
           def=function(theObject,script, element)
           {
             standardGeneric("inject_shadow_executor")
           }
)


setMethod(f="inject_shadow_executor",
          signature=c("shadow","character", "missing"),
          definition=function(theObject,script, element)
          {
            result <- theObject@driver$executeScript(script)
            if(length(result)>0){
              if(is.list(result[[1]])){
                result <- lapply(result, function(x) RSelenium::webElement$new(as.character(x))$import(theObject@driver))
              } else {
                if(grepl("TRUE|FALSE", result)){
                  result <- as.logical(result)
                } else{
                  result <- RSelenium::webElement$new(as.character(result))$import(theObject@driver)
                }
              }
            }
            return(result)
          }
)


setMethod(f="inject_shadow_executor",
          signature=c("shadow","character","webElement" ),
          definition=function(theObject,script, element)
          {
            result <- theObject@driver$executeScript(script, args=list(element))
            if(length(result)>0){
              if(is.list(result[[1]])){
                result <- lapply(result, function(x) RSelenium::webElement$new(as.character(x))$import(theObject@driver))
              } else {
                if(grepl("TRUE|FALSE", result)){
                  result <- as.logical(result)
                } else{
                  result <- RSelenium::webElement$new(as.character(result))$import(theObject@driver)
                }
              }
            }
            return(result)
          }
)



setGeneric(name="executor_get_object",
           def=function(theObject,script, element)
           {
             standardGeneric("executor_get_object")
           }
)


setMethod(f="executor_get_object",
          signature=c("shadow","character", "missing"),
          definition=function(theObject,script, element)
          {
            javascript <- paste0(theObject@javascript_library,script)
            return(inject_shadow_executor(theObject,javascript))
          }
)


setMethod(f="executor_get_object",
          signature=c("shadow","character","webElement" ),
          definition=function(theObject,script, element)
          {
            javascript <- paste0(theObject@javascript_library,script)
            return(inject_shadow_executor(theObject,javascript,element))
          }
)

#' @rdname shadow-class
#' @usage \dontshow{}
#' The following methods can be used with the shadow Class
#' @export
setGeneric(name="find_element",
           def=function(theObject,css_selector,element)
           {
             standardGeneric("find_element")
           }
)

#' @rdname shadow-class
#' @usage \dontshow{}
#' \strong{find_element}(css_selector) :
#' Use this method if want single element from DOM
#' \cr
#' @export
setMethod(f="find_element",
          signature=c("shadow","character","missing"),
          definition=function(theObject,css_selector,element)
          {
            command <- paste0("return getObject('", css_selector, "');")
            element <- executor_get_object(theObject,command)

            if(length(element$elementId)==0){
              stop(paste("Element with CSS",css_selector, "is not in dom"))
            }


            if(!is_present(theObject,element)){
              warning(paste("Element with CSS", css_selector, "is not visible on screen"))
            }
            return(element)
          }


)


#' @rdname shadow-class
#' @usage \dontshow{}
#' \strong{find_element}(object parent, str css_selector):
#' Use this if you want to find a single elements from parent object DOM
#' @export
setMethod(f="find_element",
          signature=c("shadow","character","webElement"),
          definition=function(theObject,css_selector,element)
          {
            command <- paste0("return getObject('", css_selector, "', arguments[0]);")
            element <- executor_get_object(theObject,command,element)


            if(length(element$elementId)==0){
              stop(paste("Element with CSS",css_selector, "is not in dom"))
            }
            if(!is_present(theObject,element)){
              warning(paste("Element with CSS", css_selector, "is not visible on screen"))
            }
            return(element)
          }


)

#' @rdname shadow-class
#' @usage \dontshow{}
#' @export
setGeneric(name="find_elements",
           def=function(theObject,css_selector,element)
           {
             standardGeneric("find_elements")
           }
)

#' @rdname shadow-class
#' @usage \dontshow{}
#' \strong{find_elements}(str css_selector):
#' Use this if you want to find all elements from DOM
#' \cr
#' @export
setMethod(f="find_elements",
          signature=c("shadow","character","missing"),
          definition=function(theObject,css_selector,element)
          {
            command <- paste0("return getAllObject('", css_selector, "');")
            element <- executor_get_object(theObject,command)
            if(length(element)==0){
              stop(paste("Element with CSS",css_selector, "is not in dom"))
            }
            return(element)
          }
)

#' @rdname shadow-class
#' @usage \dontshow{}
#' \strong{find_elements}(object parent, str css_selector):
#' Use this if you want to find all elements from parent object DOM
#' @export
setMethod(f="find_elements",
          signature=c("shadow","character","webElement"),
          definition=function(theObject,css_selector,element)
          {
            command <- paste0("return getAllObject('", css_selector, "', arguments[0]);")
            element <- executor_get_object(theObject,command,element)
            if(length(element)==0){
              stop(paste("Element with CSS",css_selector, "is not in dom"))
            }
            return(element)
          }
)


#' @rdname shadow-class
#' @usage \dontshow{}
#' @export
setGeneric(name="get_shadow_element",
           def=function(theObject,element,css_selector)
           {
             standardGeneric("get_shadow_element")
           }
)

#' @rdname shadow-class
#' @usage \dontshow{}
#' \strong{get_shadow_element}(object parent,str css_selector):
#' Use this if you want to find a single element from parent DOM
#' @export
setMethod(f="get_shadow_element",
          signature=c("shadow","webElement","character"),
          definition=function(theObject,element,css_selector)
          {
            command <- paste0("return getShadowElement(arguments[0], '", css_selector, "');")
            return(executor_get_object(theObject,command, element))
          }
)

#' @rdname shadow-class
#' @usage \dontshow{}
#' @export
setGeneric(name="get_all_shadow_element",
           def=function(theObject,element,css_selector)
           {
             standardGeneric("get_all_shadow_element")
           }
)

#' @rdname shadow-class
#' @usage \dontshow{}
#' \strong{get_all_shadow_element}(object parent, str css_selector):
#' Use this if you want to find all elements from parent DOM
#' @export
setMethod(f="get_all_shadow_element",
          signature=c("shadow","webElement","character"),
          definition=function(theObject,element,css_selector)
          {
            command <- paste0("return getShadowElement(arguments[0], '", css_selector, "');")
            return(executor_get_object(theObject,command, element))
          }
)


#' @rdname shadow-class
#' @usage \dontshow{}
#' @export
setGeneric(name="get_parent_element",
           def=function(theObject,element)
           {
             standardGeneric("get_parent_element")
           }
)

#' @rdname shadow-class
#' @usage \dontshow{}
#' \strong{get_parent_element}(object element):
#' Use this to get the parent element if web element
#' @export
setMethod(f="get_parent_element",
          signature=c("shadow","webElement"),
          definition=function(theObject,element)
          {
            command <- "return getParentElement(arguments[0]);"
            return(executor_get_object(theObject,command, element))
          }
)

#' @rdname shadow-class
#' @usage \dontshow{}
#' @export
setGeneric(name="get_child_elements",
           def=function(theObject,element)
           {
             standardGeneric("get_child_elements")
           }
)

#' @rdname shadow-class
#' @usage \dontshow{}
#' \strong{get_child_elements}(object parent) :
#' Use this to get all the child elements of parent element
#' @export
setMethod(f="get_child_elements",
          signature=c("shadow","webElement"),
          definition=function(theObject,element)
          {
            command <-  "return getChildElements(arguments[0]);"
            return(executor_get_object(theObject,command, element))
          }
)

#' @rdname shadow-class
#' @usage \dontshow{}
#' @export
setGeneric(name="get_sibling_element",
           def=function(theObject,element,css_selector)
           {
             standardGeneric("get_sibling_element")
           }
)

#' @rdname shadow-class
#' @usage \dontshow{}
#' \strong{get_sibling_element}(object element, str css_selector):
#' Use this to get adjacent(sibling) element using css selector
#' @export
setMethod(f="get_sibling_element",
          signature=c("shadow","webElement","character"),
          definition=function(theObject,element,css_selector)
          {
            command <- paste("return getSiblingElement(arguments[0],'",css_selector,"');")
            return(executor_get_object(theObject,command, element))
          }
)

#' @rdname shadow-class
#' @usage \dontshow{}
#' @export
setGeneric(name="get_previous_sibling_element",
           def=function(theObject,element)
           {
             standardGeneric("get_previous_sibling_element")
           }
)

#' @rdname shadow-class
#' @usage \dontshow{}
#' \strong{get_previous_sibling_element}(object element):
#' Use this to get previous adjacent(sibling) element
#' @export
setMethod(f="get_previous_sibling_element",
          signature=c("shadow","webElement"),
          definition=function(theObject,element)
          {
            command <- "return getPreviousSiblingElement(arguments[0]);"
            return(executor_get_object(theObject,command, element))
          }
)



#' @rdname shadow-class
#' @usage \dontshow{}
#' @export
setGeneric(name="get_next_sibling_element",
           def=function(theObject,element)
           {
             standardGeneric("get_next_sibling_element")
           }
)

#' @rdname shadow-class
#' @usage \dontshow{}
#' \strong{get_next_sibling_element}(object element):
#' Use this to get next adjacent(sibling) element
#' @export
setMethod(f="get_next_sibling_element",
          signature=c("shadow","webElement"),
          definition=function(theObject,element)
          {
            command <- "return getNextSiblingElement(arguments[0]);"
            return(executor_get_object(theObject,command, element))
          }
)


#' @rdname shadow-class
#' @usage \dontshow{}
#' @export
setGeneric(name="scroll_to",
           def=function(theObject,element)
           {
             standardGeneric("scroll_to")
           }
)

#' @rdname shadow-class
#' @usage \dontshow{}
#' \strong{scroll_to}(object element):
#' Use this to scroll to web element
#' @export
setMethod(f="scroll_to",
          signature=c("shadow","webElement"),
          definition=function(theObject,element)
          {
            command <- "return scrollTo(arguments[0]);"
            return(executor_get_object(theObject,command, element))
          }
)

#' @rdname shadow-class
#' @usage \dontshow{}
#' @export
setGeneric(name="is_checked",
           def=function(theObject,element)
           {
             standardGeneric("is_checked")
           }
)

#' @rdname shadow-class
#' @usage \dontshow{}
#' \strong{is_checked}(object element):
#' Use this if you want to check if checkbox is selected
#' @export
setMethod(f="is_checked",
          signature=c("shadow","webElement"),
          definition=function(theObject,element)
          {
            command <- "return isChecked(arguments[0]);"
            return(executor_get_object(theObject,command, element))
          }
)

#' @rdname shadow-class
#' @usage \dontshow{}
#' @export
setGeneric(name="is_disabled",
           def=function(theObject,element)
           {
             standardGeneric("is_disabled")
           }
)

#' @rdname shadow-class
#' @usage \dontshow{}
#' \strong{is_disabled}(object element):
#' Use this if you want to check if element is disabled
#' @export
setMethod(f="is_disabled",
          signature=c("shadow","webElement"),
          definition=function(theObject,element)
          {
            command <- "return isDisabled(arguments[0]);"
            return(executor_get_object(theObject,command, element))
          }
)

#' @rdname shadow-class
#' @usage \dontshow{}
#' @export
setGeneric(name="is_visible",
           def=function(theObject,element)
           {
             standardGeneric("is_visible")
           }
)

#' @rdname shadow-class
#' @usage \dontshow{}
#' \strong{is_visible}(object element):
#' Use this if you want to find visibility of element
#' @export
setMethod(f="is_visible",
          signature=c("shadow","webElement"),
          definition=function(theObject,element)
          {
            command <- "return isVisible(arguments[0]);"
            return(executor_get_object(theObject,command, element))
          }
)


setGeneric(name="is_present",
           def=function(theObject,element)
           {
             standardGeneric("is_present")
           }
)


setMethod(f="is_present",
          signature=c("shadow","webElement"),
          definition=function(theObject,element)
          {
            present <-  executor_get_object(theObject, "return isVisible(arguments[0]);", element)
            print(paste("QA--QAQA",present))
            return(present)
          }
)

