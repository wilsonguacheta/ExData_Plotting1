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
with(df_fill, plot(date_time, Global_active_power, type = 'l',
                   xlab = '', ylab = 'Global Active Power'))
dev.copy(png, file = 'plot2.png', width = 480, height=480, units='px')
dev.off()
