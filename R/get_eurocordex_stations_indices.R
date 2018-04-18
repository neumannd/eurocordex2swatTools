library('ncdf4')
#' Get locations of stations on the model grid defined in the netCDF file 'file'
#' 
#' We have a data.frame with station information and want to know, in which model grid cell boxes these stations are located.
#'
#' @param file path (directory and name) of a netCDF file, in which den model grid is defined
#' @param stations data.frame containing the stations information as columns station_name, lon, and lat
#' @param var_lon character, optional: name of the longitude variable in file
#' @param var_lat character, optional: name of the latitude variable in file 
#' @param col_lon character, optional: name of the longitude column in stations
#' @param col_lat character, optional: name of the latitude column in stations
#'
#' @return data.frame containing the stations information as columns station_name, idx_lon, and idx_lat; if the stations are not on the model grid, idx_lon and idx_lat of the nearest grid cell are provided
#' @export
#'
#' @examples
#' 
#' ## EXAMPLE 1:
#' # construct data:
#' stations <- data.frame(c('abc', 'def', 'ghi', 'jkl'), 
#'                        c(10.31, 11.12, 9.2, 9.31), 
#'                        c(55.19, 54.77, 55.02, 53.2), 
#'                        c(44, 1, 5, 107), 
#'                        stringsAsFactors = FALSE)
#' names(stations) <- c('station_name', 'lon', 'lat', 'elev')
#' 
#' # we need to have some file with EURO-CORDEX data somewhere.
#' file = './tasmin_EUR-11_ICHEC-EC-EARTH_rcp26_r12i1p1_CLMcom-CCLM4-8-17_v1_day_20060101-20101231.nc'
#' 
#' # call the function
#' idx_stations <- get_eurocordex_stations_indices(file, stations)
#' 
#' print(idx_stations)
#' #  station_name idx_lon idx_lat
#' # 1          abc     219     256
#' # 2          def     223     252
#' # 3          ghi     213     255
#' # 4          jkl     212     239
#' 
#' 
#' ## EXAMPLE 2:
#' ## If we have different column names in the stations data.frame
#' # construct data:
#' stations <- data.frame(c('abc', 'def', 'ghi', 'jkl'), 
#'                        c(10.31, 11.12, 9.2, 9.31), 
#'                        c(55.19, 54.77, 55.02, 53.2), 
#'                        c(44, 1, 5, 107), 
#'                        stringsAsFactors = FALSE)
#' names(stations) <- c('station_name', 'long', 'lati', 'elev')
#' 
#' # we need to have some file with EURO-CORDEX data somewhere.
#' file = './tasmin_EUR-11_ICHEC-EC-EARTH_rcp26_r12i1p1_CLMcom-CCLM4-8-17_v1_day_20060101-20101231.nc'
#' 
#' # call the function
#' idx_stations <- get_eurocordex_stations_indices(file, stations, col_lon = 'long', col_lat = 'lati')
#' 
#' print(idx_stations)
#' #  station_name idx_lon idx_lat
#' # 1          abc     219     256
#' # 2          def     223     252
#' # 3          ghi     213     255
#' # 4          jkl     212     239
#' 
#' 
#' # Used by `read_eurocordex_data`. Please look into that function's code for further usage examples.
#' 
#' 
get_eurocordex_stations_indices <- function(file, stations, var_lon = 'lon', var_lat = 'lat', col_lon = 'lon', col_lat = 'lat') {
  
  nstat <- dim(stations)[1]
  if (nstat == 0) stop('get_eurocordex_stations_indices: station list is empty')
  
  out_stations <- data.frame(stations$station_name, rep(as.numeric(NA), nstat), rep(as.numeric(NA), nstat),
                             stringsAsFactors = FALSE)
  names(out_stations) <- c('station_name', 'idx_lon', 'idx_lat')
  
  # get one set of lon-lat-data
  ncid <- nc_open(file)
  tmp_lon <- ncvar_get(ncid, var_lon)
  tmp_lat <- ncvar_get(ncid, var_lat)
  nc_close(ncid)
  
  # We ignore the situation in which the station is not on the grid
  for (i1 in 1:nstat) {
    this_lon <- stations[[col_lon]][i1]
    this_lat <- stations[[col_lat]][i1]
    
    if (length(dim(tmp_lon)) == 1) {
      out_stations$idx_lon[i1] <- which.min((tmp_lon - this_lon)^2)
      out_stations$idx_lat[i1] <- which.min((tmp_lat - this_lat)^2)
    } else {
      idx_min <- which.min((tmp_lon - this_lon)^2 + (tmp_lat - this_lat)^2)
      n_x <- dim(tmp_lon)[1]
      n_y <- dim(tmp_lon)[2]
      out_stations$idx_lon[i1] <- (idx_min-1)%%n_x+1
      out_stations$idx_lat[i1] <- ceiling(idx_min/n_x)
    }
  }
  
  return(out_stations)
  
}