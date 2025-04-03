# Run da function

if (!require("pacman")) install.packages("pacman")
pacman::p_load(lubridate,tidyverse, googledrive, readxl, gsheet)


source("https://raw.githubusercontent.com/abreefpilz/try_gdrive_github/main/scripts/download_google.R")

download_google(
   directory = "data/",
   gdrive = T, # Are the files on Google Drive. True or False
   gshared_drive = as_id("184hpPY8L2ixtMj2Bw2q9N1BZf4FRBQ7t"),
   #gshared_drive = as_id("1e1EOr_dd3ZfAS5g4Wl_KutGQ-zjfkkNE"),
  output_file = "test_gdrive.csv"
)
