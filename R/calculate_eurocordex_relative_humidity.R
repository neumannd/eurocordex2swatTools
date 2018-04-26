#' calculate relative humidity from specific humidity, temperature and pressure
#'
#' The relative humidity was missing in some archived simulations. In these cases, 
#' it can be approximately calculated from the specific humidity, temperature, and 
#' pressure. This is done by this funciton. It uses `read_eurocordex_data` to
#' obtain the data of the three needed variables.
#'
#' The relative humidity was missing in some archived simulations. In these cases, 
#' it can be approximately calculated from the specific humidity, temperature, and 
#' pressure. This is done by this funciton. It uses `read_eurocordex_data` to
#' obtain the data of the three needed variables.
#' 
#' The relative humidity is calculated given in the equation below. The '=' is
#' actually an 'approximately'.
#' 
#' \deqn{hurs = 0.263 Pa^{-1} huss * ps * exp(-17.67 * (tas - 273.16 K)/(tas - 29.65 K))}
#'
#' with specific humidity (huss, dimensionless), pressure (ps in Pa), and 
#' temperature (tas in K).
#'
#'
#' @param dir string: file direcotory 
#' @param domain string: model domain, see EURO-CORDEX Doc
#' @param driver string: driving global model, see EURO-CORDEX Doc
#' @param experiment string: experiment type (historical, rcp2.6, rcp4.5, rcp8.5), see EURO-CORDEX Doc
#' @param ensemble string: ensemble (e.g. r12i1p1), see EURO-CORDEX Doc
#' @param institute string: institution who did the model run, see EURO-CORDEX Doc
#' @param model string: used RCM (regional climate model), see EURO-CORDEX Doc
#' @param downscaling_realisation string: version of the downscaling realisation (most often 'v1'), see EURO-CORDEX Doc
#' @param time_frequency string: time frequency of model output (e.g. 'day'), see EURO-CORDEX Doc
#' @param time_lim string, numeric or integer: array of length 2 containing start and end time to read in format 'YYYYMMDD' (as character, numeric or integer)
#' @param stations data.frame of three columns station_name, lon, and lat
#'
#' @return data.frame imported data
#' @export
#'
#' @examples
#' 
#' # define directory that contains the model data
#' dir <- '/my/data/directory/for/EUROCORDEX/data'
#' 
#' # define EURO-CORDEX model run details
#' domain <- 'EUR-11'
#' driver <- 'ICHEC-EC-EARTH'
#' experiment <- 'rcp85'
#' ensemble <- 'r12i1p1'
#' institute <- 'CLMcom'
#' model <- 'CCLM4-8-17'
#' downscaling_realisation <- 'v1'
#' time_frequency <- 'day'
#' time <- c('20110201', '20170301')
#' 
#' # define stations
#' stations <- data.frame(c('abc', 'def', 'ghi', 'jkl'), c(10.31, 11.12, 9.2, 9.31), c(55.19, 54.77, 55.02, 53.2), c(44, 1, 5, 107), stringsAsFactors = FALSE)
#' names(stations) <- c('station_name', 'lon', 'lat', 'elev')
#' 
#' # read in the data
#' my_data <- calculate_eurocordex_relative_humidity(dir, domain, driver, experiment, ensemble, institute, model, downscaling_realisation, time_frequency, time, stations)
#' 
#' 
#' # have a look into the README for further details
#' 
calculate_eurocordex_relative_humidity <- function(dir, domain, driver, experiment, ensemble, institute, model, downscaling_realisation, time_frequency, time, stations) {
  
  # test time ----
  num_time <- get_eurocordex_correct_time(time)
  
  # get files ----
  hurs_VARs <- c('huss', 'tas', 'ps')
  data_tmp <- list()
  
  for (iVar in hurs_VARs) {
    print(paste0('== reading ', iVar))
    data_tmp[[iVar]] <- read_eurocordex_data(dir, iVar, domain, driver, experiment, ensemble, institute, model, downscaling_realisation, time_frequency, time, stations)
  }
  print('== finished reading')
  
  # get time intersection between different data sets
  hurs_time <- data_tmp[[hurs_VARs[1]]]$time
  for (iVar in hurs_VARs) {
    hurs_time <- intersect(hurs_time, data_tmp[[iVar]]$time)
  }
  
  # filter the times, which are present in all data sets
  for (iVar in hurs_VARs) {
    data_tmp[[iVar]] <- data_tmp[[iVar]][data_tmp[[iVar]]$time%in%hurs_time,]
  }
  
  # RH = 0.263 * p * q / exp( 17.67 * (T - T0) / ( T - 29.65 ) )
  # T0 = 273.16
  # T: temperature
  # p: pressure
  # q: specific humidity
  idx_not_time <- !(names(data_tmp$huss)%in%c('time','time_posix'))
  data_raw <- data_tmp$huss
  data_raw[,idx_not_time] <- 0.263 * data_tmp$huss[,idx_not_time] * data_tmp$ps[,idx_not_time] / exp(17.67 * (data_tmp$tas[,idx_not_time] - 273.16)/(data_tmp$tas[,idx_not_time] - 29.65))
  
  return(data_raw)
  
}