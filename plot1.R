## Set the locale to United States English
Sys.setlocale(category = "LC_ALL", locale = "English")

## If necessary, download the ZIP file from the web
## and extract it in a directory named data.
filePath <- "data/household_power_consumption.txt"
if (!file.exists(filePath)) {
    tempFile <- tempfile()
    zipFile <- download.file(
        url = "https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip",
        destfile = tempFile
    )
    unzip(zipfile = tempFile, exdir = "data")
}

## Create a dataframe from the downloaded file.
## In this file, the field separator character is ";"
## and missing values are coded as "?".
data <- read.table(
    file = filePath,
    header = TRUE,
    sep = ";",
    na.strings = "?"
)

## Convert the Date and Time variables to DateTime,
## replace the Time variables with the resulting DateTime variables
## and change the name of the Time column to DateTime.
data$Time <- as.POSIXlt(
    x = paste(data$Date, data$Time), tz = "CET", format = "%d/%m/%Y %H:%M:%S"
)
names(data)[names(data) == "Time"] = "DateTime"

## Subset the dataframe
## removing the rows corresponding to datetimes we will not consider
## and removing the now useless Date column.
data <- subset(
    x = data,
    subset = DateTime >= "2007-02-01 00:00:00 CET"
             & DateTime <= "2007-02-02 23:59:00 CET",
    select = -Date
)

## Open the PNG graphic device
## and create a file plot1.png in the figure directory.
## The width and height of this device are the default ones: 480*480 pixels.
## The background color is set to be transparent
## and the rendering to be antialiased.
png(
    filename = "plot1.png",
    bg = "transparent",
    type = "cairo",
    antialias = "default"
)

## Construct the plot
hist(
    x = data$Global_active_power,
    col = "red",
    main = "Global Active Power",
    xlab = "Global Active Power (kilowatts)"
)

## Close the graphic device
dev.off()