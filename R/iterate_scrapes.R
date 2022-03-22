#' Scrapes daily data for a weather station
#'
#' @param station A wunderground station e.g. 'EGNM'
#' @param min_date e.g. '2022-01-01'
#' @param max_date e.g. '2022-03-01'
#' @param remDr a Seleium remotedriver object
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' wg_get_daily('EGNM', '2022-01-01', '2022-03-01', remDr)
#' }
wg_get_daily <- function(station, min_date, max_date, remDr){

  dates <- seq(lubridate::ymd(min_date), lubridate::ymd(max_date), by = 'months')

  base_table <- tibble::tibble(year = lubridate::year(dates),
         month = lubridate::month(dates))

  base_table$station <- station

  weather <- base_table %>%
    dplyr::mutate(weather = purrr::pmap(.l = ., .f = wg_get_data, remDr = remDr)) %>%
    dplyr::select(-year, month, station) %>%
    tidyr::unnest(weather)

  weather

}
