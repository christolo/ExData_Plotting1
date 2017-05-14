packages_list <- c("dplyr")
new_packages <- packages_list[!(packages_list %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

library(dplyr)

# Read data in. Date and Time as character vectors. Will convert them in a later step
data <- read.csv(file = "household_power_consumption.txt", 
                 header = TRUE, 
                 sep = ";", 
                 na.strings = "?", 
                 colClasses = c(rep("character", 2), rep("numeric",5)))

# Date in format dd/mm/yyyy
# Only interested in 2007-02-01 and 2007-02-02
feb1and2 <- subset(data, Date == "1/2/2007" | Date == "2/2/2007")

feb1and2$DateTime <- 
  do.call(paste, c(feb1and2[c("Date", "Time")], sep = " ")) %>%
  strptime(format = "%d/%m/%Y %H:%M:%S")

feb1and2$DayOfWeek <- weekdays(feb1and2$DateTime)

png(filename = "plot1.png", width = 480, height = 480)

with(feb1and2, hist(Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power"))

dev.off()