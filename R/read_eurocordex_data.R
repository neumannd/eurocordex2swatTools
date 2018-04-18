#' search for EURO-CORDEX netCDF files, get the data from the netCDF files and put them into a data.frame
#'
#' @param dir string: file direcotory 
#' @param variable string: model variable, see EURO-CORDEX Doc
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
#' @return data.frame with first column "time" and last column "time_posix". further columns in between are denoted according to idxStations$station_name; each row contains data of one time step
#' @export
#'
#' @examples
#' 
#' # define directory that contains the model data
#' dir <- '/my/data/directory/for/EUROCORDEX/data'
#' 
#' # define EURO-CORDEX model run details
#' variable <- 'sfcWind'
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
#' my_data <- read_eurocordex_data(dir, variable, domain, driver, experiment, ensemble, institute, model, downscaling_realisation, time_frequency, time, stations)
#' 
#' 
read_eurocordex_data <- function(dir, variable, domain, driver, experiment, ensemble, institute, model, downscaling_realisation, time_frequency, time, stations) {
  
  # test time ----
  num_time <- get_eurocordex_correct_time(time)
  
  # get file list ----
  fInSearch <- paste(variable, domain, driver, experiment, ensemble, paste(institute, model, sep = '-'), downscaling_realisation, time_frequency, sep = '_')
  fList <- get_eurocordex_filelist(dir, fInSearch)
  
  # filter file list ----
  fImport <- filter_eurocordex_filelist(fList, num_time)
  
  # get grid cell ids for the stations ----
  idxStations <- get_eurocordex_stations_indices(paste(dir, fImport$filename[1], sep = '/'), stations)
  
  # read the data ----
  data_raw <- read_eurocordex_files(dir, fImport, idxStations, variable)
  
  return(data_raw)
}