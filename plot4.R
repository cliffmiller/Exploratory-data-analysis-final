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

combustedCoalData <- subset(SCC, grepl("Comb.*coal", EI.Sector, ignore.case = TRUE))[,1]

sub1 <- NEI[NEI$SCC %in% combustedCoalData, ]

#get the mean of the data for each year this helps to deal with the fact that 
# there are a different number of observations per year.
aggregatedEmissions <-aggregate(Emissions ~ year + type, sub1, sum)

print("Building plot...")

png("plot4.png", height = 480, width = 480)
g <- ggplot(aggregatedEmissions, aes(x = factor(year), y = Emissions)) 
g <- g + geom_bar(stat = "identity", aes(fill = type))
g <- g + xlab("year") + ylab("Total Emissions")
g <- g + ggtitle("Total Emissions from Coal combustion (1999 to 2008)")
print(g)

dev.off()
