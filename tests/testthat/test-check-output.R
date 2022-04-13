context("check-output")  # Our file is called "test-check_output.R"
library(testthat)        # load testthat package
library(shadowr)


remDr <- RSelenium::remoteDriver(
  remoteServerAddr = "host.docker.internal",
  port = 4445 , browser = "chrome")
remDr$open(silent = TRUE)
url <- "https://configure.bmw.ch/de_CH/configure/F40/7K31/FEGAT,P0300,S01CB,S01DF,S01DZ,S01TK,S0230,S0240,S0249,S02PA,S02VB,S0302,S0413,S0423,S0428,S0465,S0493,S04GN,S04NE,S0508,S0544,S05AQ,S05DA,S0654,S06AE,S06AF,S06AK,S06C4,S06U3,S06UX,S07CG,S07LC,S0851,S0879,S08KA,S08R9,S08TF,S08WC,S0962,S09QX,S0Z42,S0ZBC,S0ZBS,S0ZX4?expanded=true"
remDr$navigate(url)
Sys.sleep(3)


# Test whether inject_shadow_executor returns same element
test_that("inject_shadow_executor(shadow_rd,script) execute script and return webelement or boolean", {
  shadow_rd <- shadow(remDr)
  script <- 'return document.querySelector("body > con-app").shadowRoot.querySelector("#conConfigure").shadowRoot.querySelector("#enginesContainer > con-engine-list").shadowRoot.querySelector("div > con-tile-engine").shadowRoot.querySelector("#tileTitle")'
  element <- inject_shadow_executor(shadow_rd,script)

  reference_element_id <- remDr$executeScript(script)
  reference_element <- RSelenium::webElement$new(as.character(reference_element_id))$import(remDr)
  expect_equal(element$getElementText()[[1]],reference_element$getElementText()[[1]] )
})

# Test whether inject_shadow_executor returns same element
test_that("inject_shadow_executor(shadow_rd,script) execute script and return webelement or boolean", {
  shadow_rd <- shadow(remDr)
  script <- 'return document.querySelector("body > con-app").shadowRoot.querySelector("#conConfigure").shadowRoot.querySelector("#enginesContainer > con-engine-list").shadowRoot.querySelector("div > con-tile-engine").shadowRoot.querySelector("#tileTitle")'
  element <- inject_shadow_executor(shadow_rd,script)
  reference_element_id <- remDr$executeScript(script)
  reference_element <- RSelenium::webElement$new(as.character(reference_element_id))$import(remDr)
  expect_equal(element$getElementText()[[1]],reference_element$getElementText()[[1]] )
})

# Test whether executor_get_object execute script for specific element
test_that("executor_get_object(shadow_rd,script,element ) execute script for element and return boolean", {
  shadow_rd <- shadow(remDr)
  element <- find_element(shadow_rd, "con-stream-section")
  script <- "return isVisible(arguments[0]);"
  expect_equal(executor_get_object(shadow_rd,script,element ),TRUE)
})

# Test whether executor_get_object execute script
test_that("executor_get_object(shadow_rd,script,element ) execute script and return boolean", {
  shadow_rd <- shadow(remDr)
  script <- 'return document.querySelector("body > con-app").shadowRoot.querySelector("#conConfigure").shadowRoot.querySelector("#enginesContainer > con-engine-list").shadowRoot.querySelector("div > con-tile-engine").shadowRoot.querySelector("#tileTitle")'
  element <- executor_get_object(shadow_rd,script)
  reference_element_id <- remDr$executeScript(script)
  reference_element <- RSelenium::webElement$new(as.character(reference_element_id))$import(remDr)
  expect_equal(element$getElementText()[[1]],reference_element$getElementText()[[1]] )
})




# Test whether the output is a object of class shadow
test_that("shadow() returns a object of class shadow", {

  shadow_rd <- shadow(remDr)
  expect_s4_class(shadow_rd, "shadow")
})

# Test if shadow element is found in the dom
test_that("find_element(shadow_rd, 'div.sg-category.extended') returns a object of class webElement", {
  shadow_rd <- shadow(remDr)
  element <- find_element(shadow_rd, 'div.sg-category.extended')
  expect_s4_class(element, "webElement")
})

# Test if shadow element is found in the dom for specific webelement
test_that("find_element(shadow_rd, 'div.sg-category.extended', element) returns a object of class webElement", {
  shadow_rd <- shadow(remDr)
  reference_element <-  find_element(shadow_rd, 'con-stream-section')
  element <- find_element(shadow_rd, 'div.sg-category.extended')
  child <- find_element(shadow_rd, 'con-stream-section', element)

  expect_equal(reference_element$elementId, child$elementId)
})



# Test if multiple shadow elements are found in the dom
test_that("find_elements(shadow_rd, 'div') returns a list with objects of class webElement", {
  shadow_rd <- shadow(remDr)
  element <- find_elements(shadow_rd, 'div')
  expect_type(element, "list")
})


# Test if multiple shadow elements are found in the dom for specific webelement
test_that("find_elements(shadow_rd, 'div') returns a list with objects of class webElement for specific webelement", {
  shadow_rd <- shadow(remDr)
  reference_elements <-  find_elements(shadow_rd, 'div.radio-button-container')
  element <- find_element(shadow_rd, 'div#tooltipContainer')
  childs <- find_elements(shadow_rd, 'div.radio-button-container', element)

  expect_equal(length(reference_elements), length(childs))
})


# # Test if parent shadow element is found in the dom
test_that("find_elements(shadow_rd, 'div') returns the parent webelement", {
  shadow_rd <- shadow(remDr)
  reference_element <- find_element(shadow_rd, 'div.sg-category.extended')
  child <- find_element(shadow_rd, 'con-stream-section')
  dad <- get_parent_element(shadow_rd,child)
  expect_equal(reference_element$elementId, dad$elementId)
})


# Test if child shadow element is found in the dom
test_that("get_child_elements(shadow_rd,element ) returns a list with child webelements", {
  shadow_rd <- shadow(remDr)
  reference_element <- find_element(shadow_rd,"con-stream-section")
  element <- find_element(shadow_rd, 'div.sg-category.extended')
  child <- get_child_elements(shadow_rd,element )
  expect_equal(reference_element$elementId, child[[1]]$elementId)
})


# Test if previous sibling shadow element is found in the dom
test_that("get_previous_sibling_element(shadow_rd,element ) returns the previous sibling webelement", {
  shadow_rd <- shadow(remDr)
  reference_element <-  find_element(shadow_rd,"div.tile-details-container")
  element <- find_element(shadow_rd,"div#tooltipContainer")
  sib <- get_previous_sibling_element(shadow_rd,element )
  expect_equal(reference_element$elementId, sib$elementId)
})


# Test if next sibling shadow element is found in the dom
test_that("get_next_sibling_element(shadow_rd,element ) returns the next sibling webelement", {
  shadow_rd <- shadow(remDr)
  reference_element <-  find_element(shadow_rd,"con-accordion.accordion-group")
  element <- find_element(shadow_rd,"div#tooltipContainer")
  sib <- get_next_sibling_element(shadow_rd,element )
  expect_equal(reference_element$elementId, sib$elementId)
})


# Test if is_present gives true back for specific element
test_that("is_present(shadow_rd,element ) returns a boolean if the element is present", {
  shadow_rd <- shadow(remDr)
  element <-  find_element(shadow_rd,"div.tile-details-container")
  expect_equal(TRUE,  is_present(shadow_rd,element ))
})


# Test if is_disabled gives true back for specific element
test_that("is_disabled(shadow_rd,element ) returns a boolean if the element is disabled", {
  remDr$navigate("https://yari-demos.prod.mdn.mozit.cloud/en-US/docs/Web/HTML/Attributes/disabled/_sample_.examples.html")
  shadow_rd <- shadow(remDr)
  element <- find_elements(shadow_rd, 'input[type="checkbox"]')
  expect_equal(TRUE, is_disabled(shadow_rd,element[[2]] ))
})


# Test if is_visible gives true back for specific element
test_that("is_visible(shadow_rd,element ) returns a boolean if the element is visible", {
  remDr$navigate("https://interactive-examples.mdn.mozilla.net/pages/tabbed/attribute-hidden.html")
  shadow_rd <- shadow(remDr)
  elements <- find_elements(shadow_rd, "p")
  expect_equal(FALSE,   is_visible(shadow_rd, elements[[2]]))
})


# Test if is_checked gives true back for specific element
test_that("is_checked(shadow_rd,element ) returns a boolean if the element is checked", {
  remDr$navigate("https://interactive-examples.mdn.mozilla.net/pages/tabbed/input-checkbox.html")
  shadow_rd <- shadow(remDr)
  element <- find_elements(shadow_rd,'input[type="checkbox"]')
  expect_equal(TRUE,   is_checked(shadow_rd,element[[1]]))
})




