library('udunits2')
library('ncdf4')

#' read actual data from netCDF files
#'
#' @param dir string: file direcotory 
#' @param fImport data.frame: containing columns filename, read_idx_start, and read_idx_count
#' @param idxStations data.frame: containing columns station_name, idx_lon, and idx_lat
#' @param varname variable name to import
#'
#' @return data.frame with first column "time" and last column "time_posix". further columns in between are denoted according to idxStations$station_name; each row contains data of one time step
#' @export
#'
#' @examples
#' 
#' # Used by `read_eurocordex_data`. Please look into that function's code for a usage example.
#' 
#' 
read_eurocordex_files <- function(dir, fImport, idxStations, varname) {
  
  first <- TRUE
  
  nfile <- dim(fImport)[1]
  nstat <- dim(idxStations)[1]
  
  if (nfile == 0) stop('read_eurocordex_files: file list is empty')
  if (nstat == 0) stop('read_eurocordex_files: station list is empty')
  
  for (i1 in 1:nfile) {
    # open netCDF file
    ncid <- nc_open(paste(dir, fImport$filename[i1], sep = '/'))
    
    # get time values
    tmp_time <- ncvar_get(ncid, 'time', start = fImport$read_idx_start[i1],
                          count = fImport$read_idx_count[i1])
    ntime <- length(tmp_time)
    tmp_df <- data.frame(tmp_time, array(0.0, dim = c(ntime, nstat)), stringsAsFactors = FALSE)
    names(tmp_df) <- c('time', idxStations$station_name)
    
    # get time unit
    if (first) {
      time_unit <- ncatt_get(ncid, 'time', attname='units')
      if (!time_unit$hasatt) {
        warning('read_eurocordex_files: variable "time" has no attribute "units"; assuming "days since 1949-12-01 00:00:00"')
        time_unit$value <- 'days since 1949-12-01 00:00:00'
      }
      first <- FALSE
    }
    
    # read data variables
    for (i2 in 1:nstat) {
      tmp_name <- idxStations$station_name[i2]
      tmp_idx_lon <- idxStations$idx_lon[i2]
      tmp_idx_lat <- idxStations$idx_lat[i2]
      
      tmp_data <- ncvar_get(ncid, varname,
                                      start = c(tmp_idx_lon, tmp_idx_lat, fImport$read_idx_start[i1]),
                                      count = c(1, 1, fImport$read_idx_count[i1]))  
      tmp_df[[tmp_name]] <- tmp_data
    }
    
    # close file
    nc_close(ncid)
    
    # start new data frame if first iteration; else append the data
    if (i1 == 1) {
      out_data <- tmp_df
    } else {
      out_data <- rbind(out_data, tmp_df)
    }
  }
  
  # correct the time column and add a time_posix column ----
  out_data$time <- ud.convert(out_data$time, time_unit$value, 'days since 1949-12-01 00:00:00')
  out_data$time_posix <- as.POSIXct(out_data$time*86400, tz = 'UTC', origin = '1949-12-01 00:00:00')
  
  # return data.frame
  return(out_data)
}