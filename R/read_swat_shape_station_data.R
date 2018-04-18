library('foreign')
#' Read station data from a dbf file (part of the set of ArcGIS shape files)
#'
#' Reads from a *.dbf file
#' 
#' @param file character: directory and file name
#'
#' @return data.frame: consisting of four columns 'station_name', 'lon', 'lat', and 'elev'
#' @export
#'
#' @examples
#' 
#' file <- './my_stations.dbf'
#' 
#' read_swat_shape_station_data(file)
#' #   station_name   lon   lat elev
#' # 1          zyx 12.10 53.61   58
#' # 2          wvu 11.39 53.64   59
#' # 3          tsr 12.56 53.76   38
#' # 4          qpo 12.33 54.07   34
#' 
read_swat_shape_station_data <- function(file) {
  
  stations_raw <- read.dbf(file, as.is = TRUE)
  names(stations_raw) <- tolower(names(stations_raw))
  
  header_stations <- names(stations_raw)
  
  # if( 'statname'%in%header_stations ) {
  #   out_stations <- stations_raw$statname
  # } else if( 'stationsna'%in%header_stations ) {
  #   out_stations <- stations_raw$stationsna
  # } else if( 'stationsname'%in%header_stations ) {
  #   out_stations <- stations_raw$stationsname
  # } else if( 'name'%in%header_stations ) {
  #   out_stations <- stations_raw$name
  # } else {
  #   stop('read_swat_shape_station_data: no column containing station names was found')
  # }
  
  if( 'statid'%in%header_stations ) {
    out_stations <- formatC(stations_raw$statid, format='d', width=4, digits=0, flag='0')
  } else if( 'id'%in%header_stations ) {
    out_stations <- formatC(stations_raw$id, format='d', width=4, digits=0, flag='0')
  } else {
    stop('read_swat_shape_station_data: no column containing station names was found')
  }
  
  if( 'lon'%in%header_stations ) {
    out_stations <- data.frame(out_stations, stations_raw$lon, stringsAsFactors = FALSE)
  } else if( 'long'%in%header_stations ) {
    out_stations <- data.frame(out_stations, stations_raw$long, stringsAsFactors = FALSE)
  } else if( 'longitude'%in%header_stations ) {
    out_stations <- data.frame(out_stations, stations_raw$longitude, stringsAsFactors = FALSE)
  } else {
    stop('read_swat_shape_station_data: no column containing lon coordinates was found')
  }
  
  if( 'lat'%in%header_stations ) {
    out_stations <- data.frame(out_stations, stations_raw$lat, stringsAsFactors = FALSE)
  } else if( 'lati'%in%header_stations ) {
    out_stations <- data.frame(out_stations, stations_raw$lati, stringsAsFactors = FALSE)
  } else if( 'latitude'%in%header_stations ) {
    out_stations <- data.frame(out_stations, stations_raw$latitude, stringsAsFactors = FALSE)
  } else {
    stop('read_swat_shape_station_data: no column containing lat coordinates was found')
  }
  
  if( 'hoehe'%in%header_stations ) {
    out_stations <- data.frame(out_stations, stations_raw$hoehe, stringsAsFactors = FALSE)
  } else if( 'elev'%in%header_stations ) {
    out_stations <- data.frame(out_stations, stations_raw$elev, stringsAsFactors = FALSE)
  } else if( 'elevation'%in%header_stations ) {
    out_stations <- data.frame(out_stations, stations_raw$elevation, stringsAsFactors = FALSE)
  } else {
    warning('read_swat_shape_station_data: no column containing elevation of the station was found')
    out_stations <- data.frame(out_stations, rep(0.0, dim(out_stations)[1]), stringsAsFactors = FALSE)
    out_stations[out_stations[,1] == '1694', 4] = 58 # Goldberg
    out_stations[out_stations[,1] == '4625', 4] = 59 # Schwerin
    out_stations[out_stations[,1] == '5009', 4] = 38 # Teterow
    out_stations[out_stations[,1] == '1803', 4] = 34 # Gross_Luesewitz
  }
  
  names(out_stations) <- c('station_name', 'lon', 'lat', 'elev')
  
  return(out_stations)
  
}