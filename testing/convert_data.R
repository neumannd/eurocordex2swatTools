library('eurocordex2swatTools')


# directories
dInBase <- '/silod4/dneumann/phoswam/euro-cordex'
dOt <- './testout'
dStations <- '/media/neumannd/work_dell/89_PhosWAM/61_SWAT_Data/01_SWAT_input/example_input_data_andreas'

# variables
VARs <- c('wnd', 'hmd', 'slr', 'pcp', 'tmp')
order_stations <- list('wnd' = c("1803", "1694", "5009", "4625"),
                        'hmd' = c("1803", "1694", "5009", "4625"), 
                        'slr' = c("1803", "1694", "5009", "4625"), 
                        'pcp' = c('1803','4575','0581','3469','3770','0312','0590','1888','5009','0741','3482','2725','1694','1806'), 
                        'tmp' = c("1803", "1694", "5009", "4625"))

fStationsList <- list('wnd' = 'klima.dbf',
                      'hmd' = 'klima.dbf',
                      'slr' = 'klima.dbf',
                      'pcp' = 'niederschlag.dbf',
                      'tmp' = 'klima.dbf')

INSTITUTEs <- c('SMHI', 'CLMcom') # 'CLMcom
MODELs <- list('SMHI' = 'RCA4', 'CLMcom' = 'CCLM4-8-17')
EXPERIMENTs <- c('historical', 'rcp26', 'rcp85')
TIMEss <- list('historical' = 'past', 'rcp26' = c('nearfuture', 'farfuture'), 'rcp85' = c('nearfuture', 'farfuture'))
TIMEs  <- list('past' = c('19710101', '20001231'), 'nearfuture' = c('20210101', '20501231'), 'farfuture' = c('20710101', '21001231'))


# parameters
domain <- 'EUR-11'
driver <- 'ICHEC-EC-EARTH'
ensemble <- 'r12i1p1'
downscaling_realisation <- 'v1'
time_frequency <- 'day'
fakeTime <- as.POSIXct((0:10956)*86400, origin = '1985/01/01 00:00:00', tz = 'UTC')

# # stations
# stations <- data.frame(c('abc', 'def', 'ghi', 'jkl'), c(10.31, 11.12, 9.2, 9.31), c(55.19, 54.77, 55.02, 53.2), c(44, 1, 5, 107), stringsAsFactors = FALSE)
# names(stations) <- c('station_name', 'lon', 'lat', 'elev')


for (institute in INSTITUTEs) {
  model <- MODELs[[institute]]
  for (experiment in EXPERIMENTs) {
    for (times in TIMEss[[experiment]]) {
      time <- TIMEs[[times]]

      dIn <- paste(dInBase, paste(domain, driver, 'MIXED', ensemble, paste(institute, model, sep = '-'), downscaling_realisation, time_frequency, sep = '_'), 
                   sep = '/')

      for(var_swat in VARs) {
        
        # user output
        print(paste0('~~~ processing ', var_swat))
        
        # get var names
        var_eurocordex <- convert_varname_swat2eurocordex(var_swat)
        
        # get stations
        stations <- read_swat_shape_station_data(paste(dStations, fStationsList[[var_swat]], sep = '/'))
        
        # reorder stations
        row.names(stations) <- stations$station_name
        stations <- stations[order_stations[[var_swat]],]
        row.names(stations) <- NULL
        
        # create empty array for data
        my_data <- list()
        
        print('  reading data')
        
        # get data and convert
        for (iV in var_eurocordex) {
          if ( (iV == 'hurs') && (experiment%in%c('rcp85','historical')) && (institute=='CLMcom') ) {
            
            my_data[[iV]] <- calculate_eurocordex_relative_humidity(dIn, domain, driver, experiment, ensemble, institute, model, downscaling_realisation, time_frequency, time, stations)
            my_data[[iV]] <- convert_eurocordex_units(my_data[[iV]], stations$station_name, get_eurocordex_unit(iV), get_swat_unit(var_swat))
            
          } else {
            
            my_data[[iV]] <- read_eurocordex_data(dIn, iV, domain, driver, experiment, ensemble, institute, model, downscaling_realisation, time_frequency, time, stations)
            my_data[[iV]] <- convert_eurocordex_units(my_data[[iV]], stations$station_name, get_eurocordex_unit(iV), get_swat_unit(var_swat))
            
          }
        }
        
        print('  write original data')
        
        # write out data with original data
        fOt <- paste(paste(var_swat, domain, driver, experiment, ensemble, paste(institute, model, sep = '-'), downscaling_realisation, time_frequency, times, 'origDate', sep = '_'), 
                     var_swat, sep = '.')
        if (var_swat == 'tmp') {
          write_input_swat2012_tmp(paste(dOt, fOt, sep = '/'), my_data[['tasmin']], my_data[['tasmax']], stations, stations$station_name)
        } else if (var_swat == 'pcp') {
          write_input_swat2012_pcp(paste(dOt, fOt, sep = '/'), my_data[[var_eurocordex]], stations, stations$station_name)
        } else {
          write_input_swat2012_other(paste(dOt, fOt, sep = '/'), my_data[[var_eurocordex]], stations$station_name, var_swat)
        }
        
        print('  fake data')
        
        # change time axis
        for (iV in var_eurocordex) {
          my_data[[iV]] <- set_eurocordex_faketime(my_data[[iV]], fakeTime, fakeLength=TRUE)
        }
        
        print('  write fake data')
        
        # write out data with original data
        fOt <- paste(paste(var_swat, domain, driver, experiment, ensemble, paste(institute, model, sep = '-'), downscaling_realisation, time_frequency, times, 'fakeDate', sep = '_'), 
                     var_swat, sep = '.')
        if (var_swat == 'tmp') {
          write_input_swat2012_tmp(paste(dOt, fOt, sep = '/'), my_data[['tasmin']], my_data[['tasmax']], stations, stations$station_name)
        } else if (var_swat == 'pcp') {
          write_input_swat2012_pcp(paste(dOt, fOt, sep = '/'), my_data[[var_eurocordex]], stations, stations$station_name)
        } else {
          write_input_swat2012_other(paste(dOt, fOt, sep = '/'), my_data[[var_eurocordex]], stations$station_name, var_swat)
        }
        
      }
    }
  }
}
