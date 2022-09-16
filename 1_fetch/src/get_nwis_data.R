
combine_into_df <- function(in_dir = "1_fetch/out/sites"){

  data_out <- list.files(in_dir, full.names = TRUE) %>% lapply(read_csv, col_types = 'ccTdcc') %>% bind_rows()
  return(data_out)
}

nwis_site_info <- function(fileout, site_data){
  site_no <- unique(site_data$site_no)
  site_info <- dataRetrieval::readNWISsite(site_no)
  write_csv(site_info, fileout)
  return(fileout)
}


download_nwis_site_data <- function(site_num = "01427207", parameterCd = '00010', 
                                    startDate="2014-05-01", endDate="2015-05-01",
                                    dir_out = "1_fetch/out/sites/"){
  
  if (!dir.exists(dir_out)){
    dir.create(dir_out)
  }

  filepath = paste0(dir_out,"nwis_", site_num, ".csv")
  
  # readNWISdata is from the dataRetrieval package
  data_out <- readNWISdata(sites=site_num, service="iv", 
                           parameterCd = parameterCd, startDate = startDate, endDate = endDate)

  # -- simulating a failure-prone web-sevice here, do not edit --
  set.seed(Sys.time())
  if (sample(c(T,F,F,F), 1)){
    stop(site_num, ' has failed due to connection timeout. Try tar_make() again')
  }
  # -- end of do-not-edit block
  
  write_csv(data_out, file = filepath)
  return(filepath)
}

