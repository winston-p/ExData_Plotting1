## Wk 1

library( lubridate )  # Offers fast conversion of char to date/time class
library( data.table )


# Define var
dformat <- "%d/%m/%Y"
datetformat <- "%d/%m/%Y %H:%M:%S"


# Check characteristics of input file
con <- file( "household_power_consumption.txt" )
open( con )
a <- readLines( con, n = 2 )
print( a )  # Header present, separator is semi-colon
close( con )


# Load file
Fn <- "household_power_consumption.txt"
df <- read.table( Fn, header = T, sep = ";", na.strings = "?" )


# Convert to data table
dt <- as.data.table( df )


# Add date/time columns & sort
dt[ , tmp := paste( Date, Time) ]  # Combine Date & Time columns into single col
dt[ , Date2 := as.IDate( fast_strptime( as.character( Date ), dformat, lt = F ) ) ]
dt[ , DTime2 := fast_strptime( tmp, datetformat, lt = F ) ]
dt[ , tmp := NULL ]

setkey( dt, DTime2 )  # Sort by chronological order


# Subset to 2007-02-01 and 2007-02-02
dts <- dt[ Date2 >= "2007-02-01" & Date2 <= "2007-02-02" ]


# Plot 4: Multi-charts

png( "plot4.png", width = 480, height = 480 )
par( mfrow = c( 2, 2 ) )
with( dts, 
      {
        # Chart 1
        ylab <- "Global Active Power (kilowatts)"
        xlab <- ""
        plot( DTime2, Global_active_power, type = "l", xlab = xlab, ylab = ylab )
        
        
        # Chart 2
        ylab <- "Voltage"
        plot( DTime2, Voltage, type = "l", xlab = xlab, ylab = ylab )
        
        
        # Chart 3
        ylab <- "Energy sub metering"
        legentxt <- paste0( "Sub_metering_", 1:3 )
        legencol <- c( "black", "red", "blue" )
        
        plot( DTime2, Sub_metering_1, type = "l", xlab = xlab, ylab = ylab, col = "black" )
        legend( "topright", legend = legentxt, col = legencol, lwd = 1 )
        lines( DTime2, Sub_metering_2, type = "l", col = "red" )
        lines( DTime2, Sub_metering_3, type = "l", col = "blue" )
        
        
        # Chart 4
        ylab <- "Global Reactive Power"
        plot( DTime2, Global_reactive_power, type = "l", xlab = xlab, ylab = ylab )
                
        
      } )

dev.off()
par( mfrow = c( 1, 1 ) )  # Reset


## End of Code
