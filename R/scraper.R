#' Gets one month of daily data
#'
#' @param remDr a Selenium remotedriver object
#' @param station a weather station code e.g. 'EGNM'
#' @param year numeric year
#' @param month numeric month
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' wg_get_data('EGNM', 2022, 01, remDr)
#' }
wg_get_data <- function(station = NULL, year = NULL, month = NULL, remDr){

  url = glue::glue("https://www.wunderground.com/history/monthly/{station}/date/{year}-{month}")

  remDr$navigate(url)

  Sys.sleep(5)

  page_source <- rvest::read_html(remDr$getPageSource()[[1]])

  date <- page_source %>%
    rvest::html_element(xpath = '//*[@id="inner-content"]/div[2]/div[1]/div[5]/div[1]/div/lib-city-history-observation/div/div[2]/table/tbody/tr/td[1]') %>%
    rvest::html_table() %>%
    dplyr::filter(dplyr::row_number() > 1) %>%
    dplyr::rename(date = X1)

  temp <- page_source %>%
    rvest::html_element(xpath = '//*[@id="inner-content"]/div[2]/div[1]/div[5]/div[1]/div/lib-city-history-observation/div/div[2]/table/tbody/tr/td[2]/table') %>%
    rvest::html_table() %>%
    dplyr::filter(dplyr::row_number() > 1) %>%
    dplyr::rename(temp_max = X1,
                  temp_avg = X2,
                  temp_min = X3)

  dew_point <- page_source %>%
    rvest::html_element(xpath = '//*[@id="inner-content"]/div[2]/div[1]/div[5]/div[1]/div/lib-city-history-observation/div/div[2]/table/tbody/tr/td[3]/table') %>%
    rvest::html_table() %>%
    dplyr::filter(dplyr::row_number() > 1) %>%
    dplyr::rename(dew_point_max = X1,
                  dew_point_avg = X2,
                  dew_point_min = X3)

  humidity <- page_source %>%
    rvest::html_element(xpath = '//*[@id="inner-content"]/div[2]/div[1]/div[5]/div[1]/div/lib-city-history-observation/div/div[2]/table/tbody/tr/td[4]/table') %>%
    rvest::html_table() %>%
    dplyr::filter(dplyr::row_number() > 1) %>%
    dplyr::rename(humidity_max = X1,
                  humidity_avg = X2,
                  humidity_min = X3)

  wind <- page_source %>%
    rvest::html_element(xpath = '//*[@id="inner-content"]/div[2]/div[1]/div[5]/div[1]/div/lib-city-history-observation/div/div[2]/table/tbody/tr/td[5]/table') %>%
    rvest::html_table() %>%
    dplyr::filter(dplyr::row_number() > 1) %>%
    dplyr::rename(wind_max = X1,
                  wind_avg = X2,
                  wind_min = X3)

  pressure <- page_source %>%
    rvest::html_element(xpath = '//*[@id="inner-content"]/div[2]/div[1]/div[5]/div[1]/div/lib-city-history-observation/div/div[2]/table/tbody/tr/td[6]/table') %>%
    rvest::html_table() %>%
    dplyr::filter(dplyr::row_number() > 1) %>%
    dplyr::rename(pressure_max = X1,
                  pressure_avg = X2,
                  pressure_min = X3)

  precipitation <- page_source %>%
    rvest::html_element(xpath = '//*[@id="inner-content"]/div[2]/div[1]/div[5]/div[1]/div/lib-city-history-observation/div/div[2]/table/tbody/tr/td[7]/table') %>%
    rvest::html_table() %>%
    dplyr::filter(dplyr::row_number() > 1) %>%
    dplyr::rename(precipitation = X1)

  weather <- date %>%
    dplyr::bind_cols(temp, dew_point, humidity, wind, pressure, precipitation) %>%
    dplyr::mutate(date = as.Date(glue::glue("{year}-{month}-{date}")))

  weather
}
