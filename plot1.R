
dataDir <- "data"
zipFileName <- paste(dataDir, "exdata-data-NEI_data.zip", sep = "/")
zipFileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
if(!dir.exists(dataDir)) {
  dir.create(dataDir)
}
if(!file.exists(zipFileName)) {
  print("Downloading data....")
  download.file(zipFileUrl, destfile = zipFileName, method = "curl")
}

extractedFileName1 <- paste(dataDir, "summarySCC_PM25.rds", sep = "/")
extractedFileName2 <- paste(dataDir, "Source_Classification_Code.rds", sep = "/")

if(!file.exists(extractedFileName1)) {
  print("Decompressing data...")
  unzip(zipFileName, exdir = dataDir)
}

print("Loading data...")
NEI <- readRDS(extractedFileName1)
SCC <- readRDS(extractedFileName2)

print("Aggregating data...")
aggregatedEmissions <- aggregate(Emissions ~ year, NEI, sum)

print("Building plot...")

#store current scientific notation setting
currentSCIPEN <- options("scipen")
#Configure R not to use scientific notation in the graph
options(scipen = 999)

png("plot1.png")
plot(aggregatedEmissions, type = "b", pch = 19, col = "blue", main = "Total Emissions")
dev.off()

#Set Scientific notation back to previous value
options(scipen = currentSCIPEN)
