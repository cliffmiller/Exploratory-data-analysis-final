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

cityData <- subset(NEI, (fips == "24510" | fips == "06037") & type == "ON-ROAD")

aggregatedEmissions <- aggregate(Emissions ~ year + fips, cityData, sum)

print("Update fips to actual names...")
aggregatedEmissions$fips[aggregatedEmissions$fips == "24510"] <- "Baltimore, MD"
aggregatedEmissions$fips[aggregatedEmissions$fips == "06037"] <- "Los Angeles, CA"

# change colname 
colnames(aggregatedEmissions)[2] <- "city"
print("Building plot...")

png("plot6.png")
g <- ggplot(aggregatedEmissions, aes(factor(year), Emissions))
g <- g + geom_bar(stat = "identity") + xlab("year")
g <- g + ylab("Total PM2.5 Emissions") + facet_grid(.~city) 
g <- g + ggtitle("Total ON-ROAD Emissions in Baltimore (1999 to 2008)")
print(g)

dev.off()

