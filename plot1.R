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


# Plot 1: Histogram
png( "plot1.png", width = 480, height = 480 )
xlab <- "Global Active Power (kilowatts)"
main <- "Global Active Power"
with( dts, hist( Global_active_power, xlab = xlab, main = main, col = "red" ) )
dev.off()



## End of Code
