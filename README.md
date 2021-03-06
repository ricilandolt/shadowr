# shadowr <img src='inst/figures/shadowlogo.png' align="right" height="139" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/ricilandolt/shadowr/workflows/R-CMD-check/badge.svg)](https://github.com/ricilandolt/shadowr/actions)
[![codecov](https://codecov.io/gh/ricilandolt/shadowr/branch/master/graph/badge.svg)](https://codecov.io/github/ricilandolt/shadowr?branch=master)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/shadowr)](https://cran.r-project.org/package=shadowr)
<!-- badges: end -->



## Overview:
The `shadowr` package enables to use the [shadow selenium plugin](https://github.com/sukgu/shadow-automation-selenium) to manage multi level shadow DOM elements on web page.

Shadow DOM is a web standard that offers component style and markup encapsulation. It is a critically important piece of the Web Components story as it ensures that a component will work in any environment even if other CSS or JavaScript is at play on the page.

## Custom HTML Tags:
Custom HTML tags can't be directly identified with selenium tools. Using this plugin you can handle any custom HTML tags.

## Problem Statement:
- You have already developed your web-based automation framework in java selenium. Your frontend application uses Polymer that uses shadow dom. Selenium doesn't provide any way to deal with shadow-dom elements.
- Your application page contains custom HTML tags that can't be identified directly using selenium.

## Solution:
You can use this plugin by adding jar file or by including maven dependency in your java selenium project.

## How it works:



## Methods:

Depending on the method, either a RSelenium::WebElement or a boolean is returned.
You can access the RSelenium::WebElement like you used to.

`find_element(shadowObject, css_selector)`:
Use this method if want single element from DOM

`find_element(shadowObject, element, css_selector)`:
Use this if you want to find a single elements from parent object

`find_elements(shadowObject, css_selector)`:
Use this if you want to find all elements from DOM

`find_elements(shadowObject, element, css_selector)`:
Use this if you want to find all elements from parent object

`get_shadow_element(shadowObject, element,css_selector)`:
Use this if you want to find a single element from parent DOM

`get_all_shadow_element(shadowObject, element, css_selector)`:
Use this if you want to find all elements from parent DOM

`get_parent_element(shadowObject, element)`:
Use this to get the parent element if web element

`get_sibling_element(shadowObject, element, css_selector)`:
Use this to get adjacent(sibling) element using css selector

`get_previous_sibling_element(shadowObject, element)`:
Use this to get previous adjacent(sibling) element

`get_next_sibling_element(shadowObject, element)`:
Use this to get next adjacent(sibling) element

`scroll_to(shadowObject, element)`:
Use this to scroll to web element

`is_checked(shadowObject, element)`:
Use this if you want to check if checkbox is selected

`is_disabled(shadowObject, element)`:
Use this if you want to check if element is disabled

`is_visible(shadowObject, element)`:
Use this if you want to find visibility of element
  
 
## Installation
  ```
  install.packages("shadowr")
```

## Selector:
  ###### Examples: 
  for html tag ``` <paper-tab title="Settings"> ```
  You can use this code in your framework to grab the paper-tab element Object.
  ```r
library(shadowr)
library(RSelenium)
remDr <- RSelenium::remoteDriver(
  remoteServerAddr = "host.docker.internal",
  port = 4445 , browser = "chrome")
remDr$open(silent = TRUE)
remDr$navigate(url)
shadow_rd <- shadow(remDr)
element <- find_element(shadow_rd, 'paper-tab[title="Settings"]')
elements <- find_elements(shadow_rd, 'paper-tab[title="Settings"]')
element$getElementText()

  ```
  for html tag that resides under a shadow-root dom element ``` <input title="The name of the employee"> ```
  You can use this code in your framework to grab the paper-tab element Object.
  ```r
library(shadowr)
library(RSelenium)
remDr <- RSelenium::remoteDriver(
  remoteServerAddr = "host.docker.internal",
  port = 4445 , browser = "chrome")
remDr$open(silent = TRUE)
remDr$navigate(url)
shadow_rd <- shadow(remDr)
element <- find_element(shadow_rd, 'input[title="The name of the employee"]')
elements <- find_elements(shadow_rd, 'input[title="The name of the employee"]')
element$getElementText()

  ```
  for html tag that resides under a shadow-root dom element 
  ```html 
<properties-page id="settingsPage"> 
    <textarea id="textarea">
</properties-page>
  ```
  You can use this code in your framework to grab the textarea element Object.
  ```r
library(shadowr)
library(RSelenium)
remDr <- RSelenium::remoteDriver(
  remoteServerAddr = "host.docker.internal",
  port = 4445 , browser = "chrome")
remDr$open(silent = TRUE)
remDr$navigate(url)
shadow_rd <- shadow(remDr)
element <- find_element(shadow_rd, "properties-page#settingsPage>textarea#textarea")
element$getElementText()
  ```
  
  ###### Note: > is used to combine multi level dom structure. So you can combine 5 levels of dom. If you want some more level modify the script and ready to rock.
   
   **Documentation** [Link](https://github.com/sukgu/pyshadow/wiki)

