
# scrapeWunderground

<!-- badges: start -->
<!-- badges: end -->

R based scraper for wunderground historical data, based on Selenium

## Installation

Installation

``` r
remotes::install_github("neilcharles/scrapeWunderground")
```

scrapeWunderground uses RSelenium and it is recommended to [run Selenium in docker](https://cran.r-project.org/web/packages/RSelenium/vignettes/docker.html).


## Example
``` r
library(scrapeWunderground)

remDr <- RSelenium::remoteDriver(remoteServerAddr = "localhost"
                                 , port = 4445L
                                 , browserName = "firefox")

remDr$open(silent = TRUE)

wg_get_daily('EGNM', '2022-01-01', '2022-03-01', remDr)
```
