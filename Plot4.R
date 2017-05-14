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

png(filename = "plot4.png", width = 480, height = 480)

par(mfrow = c(2, 2))

# Plot 1
plot(feb1and2$DateTime, feb1and2$Global_active_power, type = "n", main = "", xlab = "", ylab = "Global Active Power")
lines(feb1and2$DateTime, feb1and2$Global_active_power)

# Plot 2
plot(feb1and2$DateTime, feb1and2$Voltage, type = "n", main = "", xlab = "datetime", ylab = "Voltage")
lines(feb1and2$DateTime, feb1and2$Voltage)

# Plot 3

plot(feb1and2$DateTime, feb1and2$Sub_metering_1, type = "n", main = "", xlab = "", ylab = "Energy Sub Metering")

lines(feb1and2$DateTime, feb1and2$Sub_metering_1, col = "black")
lines(feb1and2$DateTime, feb1and2$Sub_metering_2, col = "red")
lines(feb1and2$DateTime, feb1and2$Sub_metering_3, col = "blue")

legend("topright", 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), 
       lty = c(1, 1, 1))

# Plot 4
plot(feb1and2$DateTime, feb1and2$Global_reactive_power, type = "n", main = "", xlab = "datetime", ylab = "Global Reactive Power")
lines(feb1and2$DateTime, feb1and2$Global_reactive_power)

dev.off()
