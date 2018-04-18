#' Write out min-max temperature SWAT 2012 meteorology input file
#'
#' @param file string: directory + file name of output file
#' @param data_min data.frame: minimum temperature [deg C]; contains a column with time stamp and >=1 columns with data; time column needs to be of type POSIXct
#' @param data_max data.frame: maximum temperature [deg C]; contains a column with time stamp and >=1 columns with data; time column needs to be of type POSIXct
#' @param stations data.frame : contains station information in four columns: station name, lon coordinate, lat coordinate, and elevation
#' @param station_names character-array: contains names of the stations to write out; have to be equal to column names of data
#' @param col_time_name character, optional: name of the time stamp column in 'data', default = 'time_posix'
#' @param col_station_name character, optional: name of the station names column in 'stations', default = 'station_name'
#' @param col_lon character, optional: name of the longitude column in 'stations', default = 'lon'
#' @param col_lat character, optional: name of the latitude column in 'stations', default = 'lat'
#' @param col_elev character, optional: name of the elevation column in 'stations', default = 'elev'
#'
#' @export
#'
#' @examples
#' 
#' # see example in README
#' 
write_input_swat2012_tmp <- function(file, data_min, data_max, stations, station_names, col_time_name = 'time_posix', 
                                     col_station_name = 'station_name', col_lon = 'lon', col_lat = 'lat', col_elev = 'elev') {
  
  if (length(station_names) == 0) stop('convert_eurocordex_units: station list (station_names) is empty')
  if (sum(!(station_names%in%names(data_min))) > 0) stop('convert_eurocordex_units: not all station_names are as columns in data')
  if (sum(!(station_names%in%names(data_max))) > 0) stop('convert_eurocordex_units: not all station_names are as columns in data')
  
  # test if data_min and data_max have same time axis
  if (sum(!(data_min[[col_time_name]] == data_max[[col_time_name]])) != 0) {
    stop('write_input_swat2012_tmp: time stamp columns of data_min and data_max have to be equal')
  }
  
  # create array for header information ----
  header_str = rep("", 4)
  
  # create first header row ---- 
  # Please not the ',' as last character in the header row. I am not sure if it 
  # was a mistake in the original file or if it has to be this way.
  header_str[1] <- paste0('Station  ', paste0('TMP_', station_names, collapse = ','), ',')
  
  # write station data header rows 2 to 4 ----
  header_str[2] <- paste0('Lati   ', paste0(formatC(stations[[col_lat]], format = 'f', width = 10, digits = 1), collapse=''))
  header_str[3] <- paste0('Long   ', paste0(formatC(stations[[col_lon]], format = 'f', width = 10, digits = 1), collapse=''))
  header_str[4] <- paste0('Elev   ', paste0(formatC(stations[[col_elev]], format = 'd', width = 10), collapse=''))
  
  # write header row ----
  write(header_str, file = file, append = FALSE, ncolumns = 1)
  
  # format and write data ----
  #' explanation of the following command:
  #'   - make time column:
  #'       format(data[[time_name]],"%Y%m%d")
  #'   - format the individual values of the data column:
  #'       formatC(as.matrix(my_data[station_names]), format='f', width=8, digits=3, flag='0')
  #'      We need 'as.matrix' because my_data is a data frame. formatC cannot be applied to a 2d data frame.
  #'   - append all formatted data values in one row:
  #'       apply(formatC(...), 1, paste0, collapse = '')
  data_str = paste0(format(data_min[[col_time_name]],"%Y%j"), 
                    apply(matrix(paste0(formatC(as.matrix(data_min[station_names]), format='f', width=5, digits=1, flag='0'), 
                                           formatC(as.matrix(data_max[station_names]), format='f', width=5, digits=1, flag='0')),
                                 ncol = length(station_names)), 
                          1, paste0, collapse = ''))
  
  write(data_str, file = file, append = TRUE, ncolumns = 1)
  
}