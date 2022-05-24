library(testthat)        # load testthat package
library(shadowr)

tryCatch({
  remDr <- RSelenium::remoteDriver(
    remoteServerAddr = "host.docker.internal",
    port = 4445 , browser = "chrome")
  remDr$open(silent = TRUE)
  shadow_rd <- shadow(remDr)
  url <- "https://interactive-examples.mdn.mozilla.net/pages/tabbed/input-checkbox.html"
  remDr$navigate(url)
  Sys.sleep(1)

}, error = function(cond){
  shadow_rd <<- NULL
  message("There is a problem. Check if your selenium server is running on the right port")
})


# Test whether the output is a object of class shadow
test_that("shadow() returns a object of class shadow", {
  skip_on_cran()
  skip_if(class(shadow_rd) != "shadow" | class(remDr)!="remoteDriver", "There is a problem. Check if your selenium server is running on the right port" )
  expect_s4_class(shadow_rd, "shadow")
})


# Test if shadow element is found in the dom
test_that("find_element(shadow_rd, 'input[type=checkbox]') returns a object of class webElement", {
  skip_on_cran()
  skip_if(class(shadow_rd) != "shadow" | class(remDr)!="remoteDriver", "There is a problem. Check if your selenium server is running on the right port" )
  element <- find_element(shadow_rd,'input[type="checkbox"]')
  expect_s4_class(element[[1]], "webElement")
})


# Test if shadow element is found in the dom for specific webelement
test_that("find_element(shadow_rd, 'div.sg-category.extended', element) returns a object of class webElement", {
  skip_on_cran()
  skip_if(class(shadow_rd) != "shadow" | class(remDr)!="remoteDriver", "There is a problem. Check if your selenium server is running on the right port" )
  element <- find_element(shadow_rd,'fieldset')
  child <- find_element(shadow_rd,'input[type="checkbox"]', element[[1]])
  expect_equal(child[[1]]$getElementAttribute("name")[[1]], "scales")
})



# # Test if multiple shadow elements are found in the dom
test_that("find_elements(shadow_rd, 'div') returns a list with objects of class webElement", {
  skip_on_cran()
  skip_if(class(shadow_rd) != "shadow" | class(remDr)!="remoteDriver", "There is a problem. Check if your selenium server is running on the right port" )
  elements <- find_elements(shadow_rd, 'fieldset')
  expect_type(elements, "list")
})


# Test if parent shadow element is found in the dom
test_that("find_elements(shadow_rd, 'div') returns the parent webelement", {
  skip_on_cran()
  skip_if(class(shadow_rd) != "shadow" | class(remDr)!="remoteDriver", "There is a problem. Check if your selenium server is running on the right port" )
  child <- find_element(shadow_rd, 'input[type="checkbox"]')
  dad <- get_parent_element(shadow_rd,child[[1]])
  expect_equal(dad[[1]]$getElementText()[[1]], "Scales")
})



# Test if is_disabled gives true back for specific element
test_that("is_disabled(shadow_rd,element ) returns a boolean if the element is disabled", {
  skip_on_cran()
  skip_if(class(shadow_rd) != "shadow" | class(remDr)!="remoteDriver", "There is a problem. Check if your selenium server is running on the right port" )
  remDr$navigate("https://yari-demos.prod.mdn.mozit.cloud/en-US/docs/Web/HTML/Attributes/disabled/_sample_.examples.html")
  Sys.sleep(1)
  element <- find_element(shadow_rd, 'input[value="disabled"]')
  expect_equal(TRUE, is_disabled(shadow_rd,element[[1]] )[[1]])
})



# Test if is_visible gives true back for specific element
test_that("is_visible(shadow_rd,element ) returns a boolean if the element is visible", {
  skip_on_cran()
  skip_if(class(shadow_rd) != "shadow" | class(remDr)!="remoteDriver", "There is a problem. Check if your selenium server is running on the right port" )
  Sys.sleep(1)
  remDr$navigate("https://interactive-examples.mdn.mozilla.net/pages/tabbed/attribute-hidden.html")
  Sys.sleep(1)

  element <- find_element(shadow_rd, "p:nth-child(2)")
  expect_equal(FALSE, is_visible(shadow_rd, element[[1]]))
})



# Test if is_checked gives true back for specific element
test_that("is_checked(shadow_rd,element ) returns a boolean if the element is checked", {
  skip_on_cran()
  skip_if(class(shadow_rd) != "shadow" | class(remDr)!="remoteDriver", "There is a problem. Check if your selenium server is running on the right port" )

  remDr$navigate("https://interactive-examples.mdn.mozilla.net/pages/tabbed/input-checkbox.html")
  Sys.sleep(1)

  element <- find_element(shadow_rd,'input[type="checkbox"]')
  expect_equal(TRUE, is_checked(shadow_rd,element[[1]]))
})


