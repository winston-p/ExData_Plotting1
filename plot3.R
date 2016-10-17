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


# Plot 3: Sub-metering Lines
png( "plot3.png", width = 480, height = 480 )
main <- ""
ylab <- "Energy sub metering"
xlab <- ""

legentxt <- paste0( "Sub_metering_", 1:3 )
legencol <- c( "black", "red", "blue" )

with( dts, 
      {
        plot( DTime2, Sub_metering_1, type = "l", xlab = xlab, ylab = ylab, col = "black" )
        lines( DTime2, Sub_metering_2, type = "l", col = "red" )
        lines( DTime2, Sub_metering_3, type = "l", col = "blue" )
        legend( "topright", legend = legentxt, col = legencol, lwd = 1 )
        
        } )
dev.off()



## End of Code
