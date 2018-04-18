library('udunits2')
#' Convert units of columns of a data.frame with the udunits2 package
#' 
#' All columns of 'data', which are listed in 'station_names', are converted from 'unit_in' to 'unit_out' with the help of the udunits2 package.
#'
#' @param data data.frame: contains a column with data; columns indicated by 'station_names' are converted from 'unit_in' to 'unit_out'
#' @param station_names character-array: contains names of the stations (columns of data), which units should be converted
#' @param unit_in character: unit of the input data (FROM which should be converted)
#' @param unit_out character: unit of the output data (TO which should be converted)
#'
#' @return data.from: same format as the 
#' @export
#'
#' @examples
#' 
#' # see example in README
#' 
#' 
convert_eurocordex_units <- function(data, station_names, unit_in, unit_out) {
  
  if (length(station_names) == 0) stop('convert_eurocordex_units: station list (station_names) is empty')
  if (sum(!(station_names%in%names(data))) > 0) stop('convert_eurocordex_units: not all station_names are as columns in data')
  
  out_data <- data
  
  for (iS in station_names) {
    out_data[[iS]] <- ud.convert(data[[iS]], unit_in, unit_out)
  }
  
  return(out_data)
  
}