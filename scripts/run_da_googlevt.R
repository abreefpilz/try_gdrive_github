# Run da function

if (!require("pacman")) install.packages("pacman")
pacman::p_load(lubridate,tidyverse, googledrive, readxl, gsheet)


source("https://raw.githubusercontent.com/abreefpilz/try_gdrive_github/refs/heads/main/scripts/download_googlevt.R")

download_googlevt(
  directory = "datavt/",
  gdrive = T, # Are the files on Google Drive. True or False
  gshared_drive = as_id("1JsoCQMDUQH5xgkcGzmBG6O1uWJpmbKSm"),
  output_file = "testvt_gdrive.csv"
)
