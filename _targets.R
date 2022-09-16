library(targets)
source("1_fetch/src/get_nwis_data.R")
source("2_process/src/process_and_style.R")
source("3_visualize/src/plot_timeseries.R")

options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("tidyverse", "dataRetrieval")) # Loading tidyverse because we need dplyr, ggplot2, readr, stringr, and purrr

p1_targets_list <- list(
  tar_target(site_01427207, download_nwis_site_data(site_num = "01427207", dir_out = "1_fetch/out/sites/"), format = "file"),
  tar_target(site_01432160, download_nwis_site_data(site_num = "01432160", dir_out = "1_fetch/out/sites/"), format = "file"),
  tar_target(site_01436690, download_nwis_site_data(site_num = "01436690", dir_out = "1_fetch/out/sites/"), format = "file"),
  tar_target(site_01466500, download_nwis_site_data(site_num = "01466500", dir_out = "1_fetch/out/sites/"), format = "file"),
  tar_target(in_dir, "1_fetch/out/sites", format = "file"),
  tar_target(site_data, combine_into_df(in_dir)),
  tar_target(site_info_csv,nwis_site_info(fileout = "1_fetch/out/site_info.csv", site_data),format = "file")
)

p2_targets_list <- list(
  tar_target(
    site_data_clean, 
    process_data(site_data)
  ),
  tar_target(
    site_data_styled,
    style_data(site_data_clean, site_filename = site_info_csv)
  )
)

p3_targets_list <- list(
  tar_target(
    figure_1_png,
    plot_nwis_timeseries(fileout = "3_visualize/out/figure_1.png", site_data_styled),
    format = "file"
  )
)

# Return the complete list of targets
c(p1_targets_list, p2_targets_list, p3_targets_list)
