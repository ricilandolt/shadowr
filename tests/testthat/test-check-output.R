
library(testthat)        # load testthat package
library(shadowr)
library(RSelenium)


user <- "ricardo.landolt"
key <- "GEXBdw9uQyBE8SkFFxZ8XsZ721cht54x5tS8dgUDDPFFNycM64"
port <- 80
server <- paste0(user, ':', key, "@hub.lambdatest.com")
browser <- "chrome"
version <- "90"
platform <- "Windows 10"
extraCapabilities <- list(
  build = "RSelenium-Sample",
  name = "RSelenium-Sample-LambdaTest",
  username = user,
  accessKey = key,
  geoLocation = 'US'
)

remDr <- remoteDriver$new(
  remoteServerAddr = server,
  port = port,
  browserName = browser,
  version = version,
  platform = platform,
  extraCapabilities = extraCapabilities
)
remDr$open(silent = TRUE)



# prepare_selenium <- function(user,pass){
#   port <- 80
#   ip <- paste0(user, ':', pass, "@hub.lambdatest.com/wd/hub")
#   extraCapabilities <- list("browserName" = "chrome",
#                             "version" = "92.0",
#                             "platform" = "Windows 10",
#                             "resolution" = "1024x768")
#
#   remDr <- remoteDriver$new(remoteServerAddr = ip, port = port
#                             , extraCapabilities = extraCapabilities)
#   remDr$open(silent = TRUE)
#   remDr$setWindowSize(1300,900)
#   remDr$maxWindowSize()
#   return(remDr)
#
# }
shadow_rd <- shadow(remDr)
url <- "https://configure.bmw.ch/de_CH/configure/F40/7K31/FEGAT,P0300,S01CB,S01DF,S01DZ,S01TK,S0230,S0240,S0249,S02PA,S02VB,S0302,S0413,S0423,S0428,S0465,S0493,S04GN,S04NE,S0508,S0544,S05AQ,S05DA,S0654,S06AE,S06AF,S06AK,S06C4,S06U3,S06UX,S07CG,S07LC,S0851,S0879,S08KA,S08R9,S08TF,S08WC,S0962,S09QX,S0Z42,S0ZBC,S0ZBS,S0ZX4?expanded=true"
remDr$navigate(url)

Sys.sleep(3)

cookie <- find_elements(shadow_rd, "button.accept-button.button-primary")
if(length(cookie)>0){
  cookie[[1]]$clickElement()
}

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

# # Test if multiple shadow elements are found in the dom
test_that("find_elements(shadow_rd, 'div') returns a list with objects of class webElement", {
  shadow_rd <- shadow(remDr)
  cookie <- find_elements(shadow_rd, "button.accept-button.button-primary")
  expect_type(cookie, "list")
})



# Test if parent shadow element is found in the dom
test_that("find_elements(shadow_rd, 'div') returns the parent webelement", {
  shadow_rd <- shadow(remDr)
  reference_element <- find_element(shadow_rd, 'div.sg-category.extended')
  child <- find_element(shadow_rd, 'con-stream-section')
  dad <- get_parent_element(shadow_rd,child)
  expect_equal(reference_element$elementId, dad$elementId)
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



# Test if is_disabled gives true back for specific element
test_that("is_disabled(shadow_rd,element ) returns a boolean if the element is disabled", {

  Sys.sleep(1)
  remDr$navigate("https://yari-demos.prod.mdn.mozit.cloud/en-US/docs/Web/HTML/Attributes/disabled/_sample_.examples.html")
  shadow_rd <- shadow(remDr)
  element <- find_element(shadow_rd, 'input[value="disabled"]')
  expect_equal(TRUE, is_disabled(shadow_rd,element )[[1]])
})



# Test if is_visible gives true back for specific element
test_that("is_visible(shadow_rd,element ) returns a boolean if the element is visible", {
  remDr$navigate("https://interactive-examples.mdn.mozilla.net/pages/tabbed/attribute-hidden.html")
  Sys.sleep(1)
  shadow_rd <- shadow(remDr)
  element <- find_element(shadow_rd, "p:nth-child(2)")
  expect_equal(FALSE, is_visible(shadow_rd, element))
})



# Test if is_checked gives true back for specific element
test_that("is_checked(shadow_rd,element ) returns a boolean if the element is checked", {
  remDr$navigate("https://interactive-examples.mdn.mozilla.net/pages/tabbed/input-checkbox.html")
  Sys.sleep(1)
  shadow_rd <- shadow(remDr)
  element <- find_element(shadow_rd,'input[type="checkbox"]')
  expect_equal(TRUE, is_checked(shadow_rd,element))
})

remDr$close()
