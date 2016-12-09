library(ggplot2)

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

baltimoreData <- subset(NEI, fips == "24510")

aggregatedEmissions <- aggregate(Emissions ~ year + type, baltimoreData, sum)

print("Building plot...")

png("plot3.png", height = 480, width = 480)
g <- ggplot(aggregatedEmissions, aes(year, Emissions, color = type))
g <- g + geom_line() + ylab("Total PM2.5 Emissions") + ggtitle("Total Emissions in Baltimore (1999 to 2008)")
print(g)

dev.off()