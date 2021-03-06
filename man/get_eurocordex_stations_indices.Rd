% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_eurocordex_stations_indices.R
\name{get_eurocordex_stations_indices}
\alias{get_eurocordex_stations_indices}
\title{Get locations of stations on the model grid defined in the netCDF file 'file'}
\usage{
get_eurocordex_stations_indices(file, stations, var_lon = "lon",
  var_lat = "lat", col_lon = "lon", col_lat = "lat")
}
\arguments{
\item{file}{path (directory and name) of a netCDF file, in which den model grid is defined}

\item{stations}{data.frame containing the stations information as columns station_name, lon, and lat}

\item{var_lon}{character, optional: name of the longitude variable in file}

\item{var_lat}{character, optional: name of the latitude variable in file}

\item{col_lon}{character, optional: name of the longitude column in stations}

\item{col_lat}{character, optional: name of the latitude column in stations}
}
\value{
data.frame containing the stations information as columns station_name, idx_lon, and idx_lat; if the stations are not on the model grid, idx_lon and idx_lat of the nearest grid cell are provided
}
\description{
We have a data.frame with station information and want to know, in which model grid cell boxes these stations are located.
}
\examples{

## EXAMPLE 1:
# construct data:
stations <- data.frame(c('abc', 'def', 'ghi', 'jkl'), 
                       c(10.31, 11.12, 9.2, 9.31), 
                       c(55.19, 54.77, 55.02, 53.2), 
                       c(44, 1, 5, 107), 
                       stringsAsFactors = FALSE)
names(stations) <- c('station_name', 'lon', 'lat', 'elev')

# we need to have some file with EURO-CORDEX data somewhere.
file = './tasmin_EUR-11_ICHEC-EC-EARTH_rcp26_r12i1p1_CLMcom-CCLM4-8-17_v1_day_20060101-20101231.nc'

# call the function
idx_stations <- get_eurocordex_stations_indices(file, stations)

print(idx_stations)
#  station_name idx_lon idx_lat
# 1          abc     219     256
# 2          def     223     252
# 3          ghi     213     255
# 4          jkl     212     239


## EXAMPLE 2:
## If we have different column names in the stations data.frame
# construct data:
stations <- data.frame(c('abc', 'def', 'ghi', 'jkl'), 
                       c(10.31, 11.12, 9.2, 9.31), 
                       c(55.19, 54.77, 55.02, 53.2), 
                       c(44, 1, 5, 107), 
                       stringsAsFactors = FALSE)
names(stations) <- c('station_name', 'long', 'lati', 'elev')

# we need to have some file with EURO-CORDEX data somewhere.
file = './tasmin_EUR-11_ICHEC-EC-EARTH_rcp26_r12i1p1_CLMcom-CCLM4-8-17_v1_day_20060101-20101231.nc'

# call the function
idx_stations <- get_eurocordex_stations_indices(file, stations, col_lon = 'long', col_lat = 'lati')

print(idx_stations)
#  station_name idx_lon idx_lat
# 1          abc     219     256
# 2          def     223     252
# 3          ghi     213     255
# 4          jkl     212     239


# Used by `read_eurocordex_data`. Please look into that function's code for further usage examples.


}
