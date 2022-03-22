
# scrapeWunderground

<!-- badges: start -->
<!-- badges: end -->

R based scraper for wunderground historical data, based on Selenium

## Installation

Installation

``` r
remotes::install_github("neilcharles/scrapeWunderground")
```

## Example
``` r
library(scrapeWunderground)

remDr <- RSelenium::remoteDriver(remoteServerAddr = "localhost"
                                 , port = 4445L
                                 , browserName = "firefox")

remDr$open(silent = TRUE)

wg_get_daily('EGNM', '2022-01-01', '2022-03-01', remDr)
```
