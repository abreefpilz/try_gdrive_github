# Function to download data from Google Drive and bind them together

  download_google<-function(directory,
                     maintenance_file,
                     gdrive = F,
                     gshared_drive,
                     output_file){
    
     #  directory = "data/"
     #  gdrive = T # Are the files on Google Drive. True or False
     #  gshared_drive = as_id("1e1EOr_dd3ZfAS5g4Wl_KutGQ-zjfkkNE")
     # output_file <- "test_gdrive.csv"
     # 
    #### 1. Read in the Maintenance Log and then Raw files ####
     
     # list of GHG files on Github
     rfiles <- list.files(path= directory, pattern="", full.names=TRUE)
     
    
   
    ### 1.2 Get Files off of Google Drive ####
    
    # Are the files on Google Drive? If so then download missing GHG files
    # This should be False until we figure out how to use GitHub actions and 
    # authentication
    
    if(gdrive==T){
      
      # authenticate Google Drive to download the files from the ACL folder.
      # Still figuring this out
      googledrive::drive_auth(path = Sys.getenv('GDRIVE_PAT')) # for the service account 
     # googledrive::drive_auth(cache = '.secrets/', email = 'abreefpilz@gmail.com') # for the cache secret
     # googledrive::drive_auth(cache = Sys.getenv('GDRIVE_PAT'), email = 'abreefpilz@gmail.com')
      
      
      
      
      # Get the file info of the GHG spreadsheets from GoogleDrive
      ghgfiles<-googledrive::drive_ls(path = gshared_drive, 
                                          pattern = "file", 
                                          type = "xlsx",
                                          recursive = T)
      
      # we only want GHG files after 
      
      #times <- unlist(lapply(gdrive_files$drive_resource, "[", "createdTime"), use.names = F)
      
      # make a data frame of the times the files were created
      #gh <- as.data.frame(times)
      
      # we just want the Date when the sheet was created
      #gh$Date <- as.Date(gh$times)
      
      # bind the names of the files and the dates the files were created. Select only files after 2022 because the rest are in the historical EDI files
      
      # ghgfiles <- bind_cols(gdrive_files, gh)|>
      #   select(name, id, Date)|>
      #   filter(Date>as.Date("2023-01-01"))
      
      
      # download output files and put them on GitHub
      
      for(i in 1:nrow(ghgfiles)){
        
        #extract the beginning of the file name to see if a qaqc plot has been made
        dfile<-sub("\\_full.*", "",sub(pattern = "(.*)\\..*$", replacement = "\\1", basename(ghgfiles$name[i])))
        
        
        if(any(grepl(dfile,rfiles))==F){
          # download and put on GitHub
          
          name<-ghgfiles$name[i]
          
          googledrive::drive_download(ghgfiles$id[i], path = paste0(directory,name), overwrite = F)
          
        }else{
          
        }
      }
      
    }
    
    ### 2. Process the files if necessary ####
    
    ## 2.1 Collate files ### 
    
    # First make sure to include the newly downloaded files if necessary
    # list of GHG files on Github
    rfiles <- list.files(path=directory, pattern="", full.names=TRUE)
    
    # use purr to read in all the files using the function above
    all<-list.files(path= directory,pattern="", full.names=TRUE)%>%
      map_df(~ read_excel(.x))
    
    print("Files combined")
    
    ### 3. Add a new column ####
    
    all$a <- all$x + all$y
    
    all$b <- all$y + all$z
    
    print("Add columns")
    
    ### 4. Save file ####
    
    write_csv(all, output_file)
    
    print("saved file")
    
  } 
    
