head(data)
data <- read.csv('data.csv')
row_index <- 149
column_name <- 'total_minutes_as_duration'
new_value <- '1:30:24'
data[149,15] <- new_value
write.csv(data, 'data1.csv', row.names = FALSE)

data <- read.csv('data.csv')
row_index <- 149
column_name <- 'points'
new_value <- '0'
data[149,16] <- new_value
write.csv(data, 'data1.csv', row.names = FALSE)

head(data)
ggplot(data, aes ( x = 'penalties_in_minutes_pim', y ='weight')) +
  geom_point()+
  geom_smooth(method = "lm", se = TRUE) +
  labs( x = "sog", y = "minutes")
