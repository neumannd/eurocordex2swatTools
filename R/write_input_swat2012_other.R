#' Write out default SWAT 2012 meteorology input file
#'
#' @param file string: directory + file name of output file
#' @param data data.frame: contains a column with time stamp and >=1 columns with data; time column needs to be of type POSIXct
#' @param station_names character-array: contains names of the stations to write out; have to be equal to column names of data
#' @param type character: file type ('wnd', 'slr', 'hmd'); only used in the header row
#' @param col_time_name character, optional: name of the time stamp column, default = 'time_posix'
#'
#' @export
#'
#' @examples
#' 
#' # see example in README
#' 
write_input_swat2012_other <- function(file, data, station_names, type, col_time_name = 'time_posix') {
  # first line depends on type; the othe lines are independent of the type
  
  if (length(station_names) == 0) stop('convert_eurocordex_units: station list (station_names) is empty')
  if (sum(!(station_names%in%names(data))) > 0) stop('convert_eurocordex_units: not all station_names are as columns in data')
  
  # write header ----
  header_str = paste0("Input File ", type, ".", type, "          ", 
                      format(Sys.time(), "%d/%m/%Y"), " R Tools for PhosWaM")
  write(header_str, file = file, append = FALSE)
  
  # write data ----
  #' explanation of the following command:
  #'   - make time column:
  #'       format(data[[time_name]],"%Y%m%d")
  #'   - format the individual values of the data column:
  #'       formatC(as.matrix(data[station_names]), format='f', width=8, digits=3, flag='0')
  #'      We need 'as.matrix' because my_data is a data frame. formatC cannot be applied to a 2d data frame.
  #'   - append all formatted data values in one row:
  #'       apply(formatC(...), 1, paste0, collapse = '')
  data_str = paste0(format(data[[col_time_name]],"%Y%j"), 
                    apply(formatC(as.matrix(data[station_names]), format='f', width=8, digits=3, flag='0'), 
                          1, paste0, collapse = ''))
  
  write(data_str, file = file, append = TRUE, ncolumns = 1)
}

