context("check-output")  # Our file is called "test-check_output.R"
library(testthat)        # load testthat package
library(shadowr)
library(RSelenium)

user <- "ricaardolandolt_5QjBl3"
pass <- "qSVxzaxysfKC2cyu1Sp2"

prepare_selenium <- function(user,pass){
  port <- 80
  ip <- paste0(user, ':', pass, "@hub.browserstack.com")
  extraCapabilities <- list("browser" = "chrome",
                            "browser_version" = "latest",
                            "os" = "Windows",
                            "os_version" = "11",
                            "browserstack.debug" = "true")

  remDr <- remoteDriver$new(remoteServerAddr = ip, port = port
                            , extraCapabilities = extraCapabilities)
  remDr$open(silent = TRUE)
  remDr$setWindowSize(1300,900)
  remDr$maxWindowSize()
  return(remDr)

}


# Test whether the output is a object of class shadow
test_that("shadow() returns a object of class shadow", {
  remDr <- prepare_selenium(user,pass)
  shadow_rd <- shadow(remDr)
  expect_s4_class(shadow_rd, "shadow")
})


# Test if shadow element is found in the dom
test_that("find_element(shadow_rd, 'div.sg-category.extended') returns a object of class webElement", {
  remDr <- prepare_selenium(user,pass)
  url <- "https://configure.bmw.ch/de_CH/configure/F40/7K31/FEGAT,P0300,S01CB,S01DF,S01DZ,S01TK,S0230,S0240,S0249,S02PA,S02VB,S0302,S0413,S0423,S0428,S0465,S0493,S04GN,S04NE,S0508,S0544,S05AQ,S05DA,S0654,S06AE,S06AF,S06AK,S06C4,S06U3,S06UX,S07CG,S07LC,S0851,S0879,S08KA,S08R9,S08TF,S08WC,S0962,S09QX,S0Z42,S0ZBC,S0ZBS,S0ZX4?expanded=true"
  remDr$navigate(url)
  Sys.sleep(3)
  shadow_rd <- shadow(remDr)
  element <- find_element(shadow_rd, 'div.sg-category.extended')
  expect_s4_class(element, "webElement")
})

#
# # Test if shadow element is found in the dom for specific webelement
# test_that("find_element(shadow_rd, 'div.sg-category.extended', element) returns a object of class webElement", {
#   remDr <- prepare_selenium(user,pass)
#   url <- "https://configure.bmw.ch/de_CH/configure/F40/7K31/FEGAT,P0300,S01CB,S01DF,S01DZ,S01TK,S0230,S0240,S0249,S02PA,S02VB,S0302,S0413,S0423,S0428,S0465,S0493,S04GN,S04NE,S0508,S0544,S05AQ,S05DA,S0654,S06AE,S06AF,S06AK,S06C4,S06U3,S06UX,S07CG,S07LC,S0851,S0879,S08KA,S08R9,S08TF,S08WC,S0962,S09QX,S0Z42,S0ZBC,S0ZBS,S0ZX4?expanded=true"
#   remDr$navigate(url)
#   Sys.sleep(3)
#   shadow_rd <- shadow(remDr)
#   reference_element <-  find_element(shadow_rd, 'con-stream-section')
#   element <- find_element(shadow_rd, 'div.sg-category.extended')
#   child <- find_element(shadow_rd, 'con-stream-section', element)
#
#   expect_equal(reference_element$elementId, child$elementId)
# })






# # Test if multiple shadow elements are found in the dom
test_that("find_elements(shadow_rd, 'div') returns a list with objects of class webElement", {
  remDr <- prepare_selenium(user,pass)
  url <- "https://configure.bmw.ch/de_CH/configure/F40/7K31/FEGAT,P0300,S01CB,S01DF,S01DZ,S01TK,S0230,S0240,S0249,S02PA,S02VB,S0302,S0413,S0423,S0428,S0465,S0493,S04GN,S04NE,S0508,S0544,S05AQ,S05DA,S0654,S06AE,S06AF,S06AK,S06C4,S06U3,S06UX,S07CG,S07LC,S0851,S0879,S08KA,S08R9,S08TF,S08WC,S0962,S09QX,S0Z42,S0ZBC,S0ZBS,S0ZX4?expanded=true"
  remDr$navigate(url)
  Sys.sleep(3)
  shadow_rd <- shadow(remDr)
  element <- find_elements(shadow_rd, 'div')
  expect_type(element, "list")
})


# # Test if multiple shadow elements are found in the dom for specific webelement
# test_that("find_elements(shadow_rd, 'div') returns a list with objects of class webElement for specific webelement", {
# remDr <- prepare_selenium(user,pass)
#   url <- "https://configure.bmw.ch/de_CH/configure/F40/7K31/FEGAT,P0300,S01CB,S01DF,S01DZ,S01TK,S0230,S0240,S0249,S02PA,S02VB,S0302,S0413,S0423,S0428,S0465,S0493,S04GN,S04NE,S0508,S0544,S05AQ,S05DA,S0654,S06AE,S06AF,S06AK,S06C4,S06U3,S06UX,S07CG,S07LC,S0851,S0879,S08KA,S08R9,S08TF,S08WC,S0962,S09QX,S0Z42,S0ZBC,S0ZBS,S0ZX4?expanded=true"
#   remDr$navigate(url)
#   Sys.sleep(3)
#   shadow_rd <- shadow(remDr)
#   reference_elements <-  find_elements(shadow_rd, 'div.radio-button-container')
#   element <- find_element(shadow_rd, 'div#tooltipContainer')
#   childs <- find_elements(shadow_rd, 'div.radio-button-container', element)
#
#   expect_equal(length(reference_elements), length(childs))
# })


# # Test if parent shadow element is found in the dom
# test_that("find_elements(shadow_rd, 'div') returns the parent webelement", {
#
#   url <- "https://configure.bmw.ch/de_CH/configure/F40/7K31/FEGAT,P0300,S01CB,S01DF,S01DZ,S01TK,S0230,S0240,S0249,S02PA,S02VB,S0302,S0413,S0423,S0428,S0465,S0493,S04GN,S04NE,S0508,S0544,S05AQ,S05DA,S0654,S06AE,S06AF,S06AK,S06C4,S06U3,S06UX,S07CG,S07LC,S0851,S0879,S08KA,S08R9,S08TF,S08WC,S0962,S09QX,S0Z42,S0ZBC,S0ZBS,S0ZX4?expanded=true"
#   remDr$navigate(url)
#   Sys.sleep(3)
#   shadow_rd <- shadow(remDr)
#   reference_element <- find_element(shadow_rd, 'div.sg-category.extended')
#   child <- find_element(shadow_rd, 'con-stream-section')
#   dad <- get_parent_element(shadow_rd,child)
#   expect_equal(reference_element$elementId, dad$elementId)
# })


# # Test if child shadow element is found in the dom
# test_that("get_child_elements(shadow_rd,element ) returns a list with child webelements", {
#   remDr <- prepare_selenium(user,pass)
#   url <- "https://configure.bmw.ch/de_CH/configure/F40/7K31/FEGAT,P0300,S01CB,S01DF,S01DZ,S01TK,S0230,S0240,S0249,S02PA,S02VB,S0302,S0413,S0423,S0428,S0465,S0493,S04GN,S04NE,S0508,S0544,S05AQ,S05DA,S0654,S06AE,S06AF,S06AK,S06C4,S06U3,S06UX,S07CG,S07LC,S0851,S0879,S08KA,S08R9,S08TF,S08WC,S0962,S09QX,S0Z42,S0ZBC,S0ZBS,S0ZX4?expanded=true"
#   remDr$navigate(url)
#   Sys.sleep(3)
#   shadow_rd <- shadow(remDr)
#   reference_element <- find_element(shadow_rd,"con-stream-section")
#   element <- find_element(shadow_rd, 'div.sg-category.extended')
#   child <- get_child_elements(shadow_rd,element )
#   expect_equal(reference_element$elementId, child[[1]]$elementId)
# })




# # Test if previous sibling shadow element is found in the dom
# test_that("get_previous_sibling_element(shadow_rd,element ) returns the previous sibling webelement", {
#   remDr <- prepare_selenium(user,pass)
#   url <- "https://configure.bmw.ch/de_CH/configure/F40/7K31/FEGAT,P0300,S01CB,S01DF,S01DZ,S01TK,S0230,S0240,S0249,S02PA,S02VB,S0302,S0413,S0423,S0428,S0465,S0493,S04GN,S04NE,S0508,S0544,S05AQ,S05DA,S0654,S06AE,S06AF,S06AK,S06C4,S06U3,S06UX,S07CG,S07LC,S0851,S0879,S08KA,S08R9,S08TF,S08WC,S0962,S09QX,S0Z42,S0ZBC,S0ZBS,S0ZX4?expanded=true"
#   remDr$navigate(url)
#   Sys.sleep(3)
#   shadow_rd <- shadow(remDr)
#   reference_element <-  find_element(shadow_rd,"div.tile-details-container")
#   element <- find_element(shadow_rd,"div#tooltipContainer")
#   sib <- get_previous_sibling_element(shadow_rd,element )
#   expect_equal(reference_element$elementId, sib$elementId)
# })


# # Test if next sibling shadow element is found in the dom
# test_that("get_next_sibling_element(shadow_rd,element ) returns the next sibling webelement", {
#   remDr <- prepare_selenium(user,pass)
#   url <- "https://configure.bmw.ch/de_CH/configure/F40/7K31/FEGAT,P0300,S01CB,S01DF,S01DZ,S01TK,S0230,S0240,S0249,S02PA,S02VB,S0302,S0413,S0423,S0428,S0465,S0493,S04GN,S04NE,S0508,S0544,S05AQ,S05DA,S0654,S06AE,S06AF,S06AK,S06C4,S06U3,S06UX,S07CG,S07LC,S0851,S0879,S08KA,S08R9,S08TF,S08WC,S0962,S09QX,S0Z42,S0ZBC,S0ZBS,S0ZX4?expanded=true"
#   remDr$navigate(url)
#   Sys.sleep(3)
#   shadow_rd <- shadow(remDr)
#   reference_element <-  find_element(shadow_rd,"con-accordion.accordion-group")
#   element <- find_element(shadow_rd,"div#tooltipContainer")
#   sib <- get_next_sibling_element(shadow_rd,element )
#   expect_equal(reference_element$elementId, sib$elementId)
# })



# # Test if is_disabled gives true back for specific element
# test_that("is_disabled(shadow_rd,element ) returns a boolean if the element is disabled", {
#   remDr <- prepare_selenium(user,pass)
#   remDr$navigate("https://yari-demos.prod.mdn.mozit.cloud/en-US/docs/Web/HTML/Attributes/disabled/_sample_.examples.html")
#   shadow_rd <- shadow(remDr)
#   element <- find_elements(shadow_rd, 'input[type="checkbox"]')
#   expect_equal(TRUE, is_disabled(shadow_rd,element[[2]] )[[1]])
# })


# Test if is_visible gives true back for specific element
test_that("is_visible(shadow_rd,element ) returns a boolean if the element is visible", {
  remDr <- prepare_selenium(user,pass)
  remDr$navigate("https://interactive-examples.mdn.mozilla.net/pages/tabbed/attribute-hidden.html")
  shadow_rd <- shadow(remDr)
  elements <- find_elements(shadow_rd, "p")
  expect_equal(FALSE,   is_visible(shadow_rd, elements[[2]]))
})



# # Test if is_checked gives true back for specific element
# test_that("is_checked(shadow_rd,element ) returns a boolean if the element is checked", {
#   remDr <- prepare_selenium(user,pass)
#   remDr$navigate("https://interactive-examples.mdn.mozilla.net/pages/tabbed/input-checkbox.html")
#   shadow_rd <- shadow(remDr)
#   element <- find_elements(shadow_rd,'input[type="checkbox"]')
#   expect_equal(TRUE,   is_checked(shadow_rd,element[[1]]))
# })




