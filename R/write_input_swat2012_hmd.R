#' Write out humidity SWAT 2012 meteorology input file
#'
#' This is a wrapper function for write_input_swat2012_other()
#'
#' @param file string: directory + file name of output file
#' @param data data.frame: contains a column with time stamp and >=1 columns with data; time column needs to be of type POSIXct
#' @param station_names character-array: contains names of the stations to write out; have to be equal to column names of data
#' @param col_time_name character, optional: name of the time stamp column, default = 'time_posix'
#'
#' @export
#'
#' @examples
#' 
#' # see example in README
#' 
write_input_swat2012_hmd <- function(file, data, station_names, col_time_name = 'time_posix') {
  write_input_swat2012_other(file, data, station_names, 'hmd', col_time_name)
}