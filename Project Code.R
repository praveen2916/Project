# Geocoding a csv column of "addresses" in R

#load ggmap
library(ggmap)

# Select the file from the file chooser
fileToLoad <- file.choose(new = TRUE)

# Read in the CSV data and store it in a variable 
origAddress <- read.csv(fileToLoad, stringsAsFactors = FALSE)

#Concatenating the address into single string
origAddress$full.address <-if (origAddress$Street.Address.2.of.the.Provider==""){
  do.call(paste,c(origAddress[c("Street.Address.1.of.the.Provider",
                                "City.of.the.Provider",
                                "Zip.Code.of.the.Provider",
                                "State.Code.of.the.Provider")], sep=","))
} else {
  do.call(paste,c(origAddress[c("Street.Address.1.of.the.Provider",
                                "Street.Address.2.of.the.Provider",
                                "City.of.the.Provider",
                                "Zip.Code.of.the.Provider",
                                "State.Code.of.the.Provider")], sep=","))
}


# Initialize the data frame
geocoded <- data.frame(stringsAsFactors = FALSE)

# Loop through the addresses to get the latitude and longitude of each address and add it to the
# origAddress data frame in new columns lat and lon

origAddress$full.address<-gsub("#","",origAddress$full.address)

for(i in 1:nrow(d))
{
  # Print("Working...")
  result <- tryCatch(geocode(as.character(origAddress$full.address[i]), 
                             output = "latlona", source = "dsk"),
            warning = function(w) print("warning"))
  if(inherits(result,"warning"))next
            origAddress$lat[i] <- as.numeric(result[2])
            origAddress$lon[i] <- as.numeric(result[1])
            origAddress$geoAddress[i] <-as.character(result[3])
}
# Write a CSV file containing origAddress to the working directory
write.csv(origAddress, "geocoded.csv", row.names=FALSE)
