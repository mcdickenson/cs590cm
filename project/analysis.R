# set up workspace
setwd('~/github/cs590cm/project/data')
library(doBy)

# load data
# data = read.csv('simdata-233948.csv', as.is=T)
# data = read.csv('simdata-487370.csv', as.is=T)
data = read.csv('simdata-687301.csv', as.is=T)
dim(data)
head(data)
tail(data)

data$manip = ifelse(data$manipulation=="True", 1, 0)
summary(data$manip)

# data$manip_util_ratio_total = data$total_utils_in_outcome / data$total_utils_in_true
data$manip_util_ratio = data$total_utils_manipulator / data$total_utils_in_true_manipulator
summary(data$manip_util_ratio)
data$total_manip_util_ratio = data$total_utils_in_outcome/ data$total_utils_in_true
summary(data$total_manip_util_ratio)
# todo: get this to work
data = data[-which(is.na(data$total_manip_util_ratio)), ]

summary(data$total_utils_in_true)
summary(data$total_utils_in_outcome)
length(which(data$total_utils_in_outcome != data$total_utils_in_true))

# set params
rules = c("borda")
ws = c(0.1, 0.3, 0.5, 0.7, 0.9)
as = c(9, 7, 5, 3, 1)
ns = seq(1, 10)
perfect_info = c("True", "False")

mean(data$manip[data$perfect_info=="True"])
mean(data$manip[data$perfect_info=="False"])

mean(data$manip[data$w==0.1])
mean(data$manip[data$w==0.3])
mean(data$manip[data$w==0.5])
mean(data$manip[data$w==0.7])
mean(data$manip[data$w==0.9])

mean(data$manip[data$a==9])
mean(data$manip[data$a==7])
mean(data$manip[data$a==5])
mean(data$manip[data$a==3])
mean(data$manip[data$a==1])

# subset
rule = "borda"
a = 1 
w = 0.5 
perf = "False"

subset = data[which(data$a==a & data$w==w & data$perfect_info==perf),]
dim(subset)

summary = summaryBy(manip ~ n_nonmanip + rule,
  data=data,
  FUN=mean)

head(summary)
tail(summary)
summary

summary = summary[1:30,]
summary
summary$n_nonmanip = as.numeric(summary$n_nonmanip)
summary = summary[order(summary$rule, summary$n_nonmanip),]
head(summary)
class(summary$n_nonmanip)

setwd('~/github/cs590cm/presentation')
png("plot.png")
plot(summary$n_nonmanip[summary$rule=="borda"], 
  summary$manip.mean[summary$rule=="borda"],
  xlab = "Number of Nonmanipulating Voters",
  ylab = "Proportion of Simulations with Manipulation",
  ylim=c(0,1),
  pch=16,
  type='o',
  col='blue')
# lines(summary$n_nonmanip[summary$rule=="veto"], 
#   summary$manip.mean[summary$rule=="veto"],
#   pch=16,
#   type='o')
# legend("topright",
#   legend=c("Borda", "Veto"),
#   pch=16,
#   col=c('blue', 'black'))
dev.off()

# todo: plot proportion of manipulations

# todo: plot how much utility changes in manipulations