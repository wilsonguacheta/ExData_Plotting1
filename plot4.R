library(data.table)
library(dplyr)


if (!dir.exists('./data')){dir.create('./data')}


#data dowload
if (!file.exists('./data/household_power_consumption.txt')){
    
    fileUrl <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
    download.file(fileUrl, destfile = './data/house_electric_power.zip', method = 'curl')
    unzip('./data/house_electric_power.zip', exdir = './data')    
}


#load data
path<- './data/household_power_consumption.txt'
df <- tbl_df(fread(path, sep = ';', header = TRUE))

#select rows
df$Date <- as.Date(df$Date, '%d/%m/%Y')
df_fill<-  filter(df, Date == '2007-02-02'| Date == '2007-02-01')


#convert variables
df_fill$date_time <- paste(df_fill$Date, df_fill$Time)
df_fill$date_time <- strptime(df_fill$date_time, format = '%Y-%m-%d %H:%M:%S' )
for (i in 3:9) {
    
    df_fill[i] <- as.numeric(df_fill[[i]])
    
}


#plot
par(mfrow = c(2, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 0, 0))
with(df_fill,{ 
    plot(date_time, Global_active_power, type = 'l',
         xlab = '', ylab = 'Global Active Power')
    
    
    plot(date_time, Voltage, xlab = 'datatime', ylab = 'Voltage',
         type ='l' )
    
    
    plot(date_time, Sub_metering_1,type = 'n',
         xlab = '', ylab = 'Energy sub metering')
    points(date_time, Sub_metering_1, type = 'l', col='black')
    points(date_time, Sub_metering_2, type = 'l', col='red')
    points(date_time, Sub_metering_3, type = 'l', col='blue')
    legend('topright',pch = '' ,col = c('black', 'red', 'blue'),
           legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'),
           lwd = 2, cex = 0.5)
    
    
    plot(date_time, Global_reactive_power, xlab = 'datatime',
         type = 'l')
    
})
dev.copy(png, file = 'plot4.png', width = 480, height=480, units='px' )
dev.off()
