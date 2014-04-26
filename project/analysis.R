# set up workspace
setwd('~/github/cs590cm/project/data')
library(doBy)
require(plotrix)

# load data
# data = read.csv('simdata-233948.csv', as.is=T)
# data = read.csv('simdata-487370.csv', as.is=T)
data = read.csv('simdata-636462.csv', as.is=T)
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
data$total_nonmanip_util_ratio = (data$total_utils_in_outcome - data$total_utils_manipulator)/(data$total_utils_in_true - data$total_utils_in_true_manipulator)
summary(data$total_nonmanip_util_ratio)

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
mean(data$manip[data$w==0.7]) # lower than normal
mean(data$manip[data$w==0.9]) # higher than normal

mean(data$manip[data$a==9])
mean(data$manip[data$a==7])
mean(data$manip[data$a==5])
mean(data$manip[data$a==3])
mean(data$manip[data$a==1])

# subset
# rule = "borda"
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

##################################################
# plot manipulation by voting rule 
setwd('~/github/cs590cm/graphics')
pdf("manipulation-frequency.pdf")
plot(summary$n_nonmanip[summary$rule=="borda"], 
  summary$manip.mean[summary$rule=="borda"],
  xlab = "Number of Nonmanipulating Voters",
  ylab = "Proportion of Simulations with Manipulation",
  ylim=c(0,1),
  pch=16,
  type='o',
  col='blue')
lines(summary$n_nonmanip[summary$rule=="veto"], 
  summary$manip.mean[summary$rule=="veto"],
  pch=16,
  type='o', 
  col='red'
  )
lines(summary$n_nonmanip[summary$rule=="plurality"], 
  summary$manip.mean[summary$rule=="plurality"],
  pch=16,
  type='o')
legend("topright",
  legend=c("Borda", "Plurality", "Veto"),
  pch=16,
  col=c('blue', 'black', 'red')
  )
dev.off()
# todo: check values for veto

##################################################
# plot how much utility changes in manipulations
data$nonmanip_utils_in_outcome =  data$total_utils_in_outcome - data$total_utils_manipulator
data$nonmanip_utils_in_true    =  data$total_utils_in_true    - data$total_utils_in_true_manipulator

names(data)
class(data$n_nonmanip)
data$n_nonmanip = as.numeric(data$n_nonmanip)
summary(data$n_nonmanip)
data$avg_nonmanip_utils_in_outcome =  data$nonmanip_utils_in_outcome / data$n_nonmanip
data$avg_nonmanip_utils_in_true    =  data$nonmanip_utils_in_true    / data$n_nonmanip
summary(data$avg_nonmanip_utils_in_outcome)

names(data)
unique(data$perfect_info)
borda = data[which(data$rule=="borda"), ]
plurality = data[which(data$rule=="plurality"), ]
veto = data[which(data$rule=="veto"), ]
mean(borda$manip)
mean(plurality$manip)
mean(veto$manip)
mean(borda$manip[borda$perfect_info=="True"]) # .202
mean(borda$manip[borda$perfect_info=="False"]) # .172
mean(plurality$manip[plurality$perfect_info=="True"]) # .03
mean(plurality$manip[plurality$perfect_info=="False"]) # .01
mean(veto$manip[veto$perfect_info=="True"]) # .8
mean(veto$manip[veto$perfect_info=="False"]) # .8

names(borda)
unique(borda$manipulation)
lst = list(borda$avg_nonmanip_utils_in_outcome[borda$manipulation=="True"], borda$avg_nonmanip_utils_in_outcome[borda$manipulation=="False"])

pdf("nonmanipulators-utilities.pdf")
multhist(lst, #probability=TRUE,
  breaks=10
  )
legend('topleft', 
  legend=c("Without Manipulation", "With Manipulation"),
  col=c('grey80', 'grey40'),
  pch=16
)
dev.off()

# how do nonmanipulators do on average in both scenarios?
mean(borda$avg_nonmanip_utils_in_outcome[borda$manipulation=="True"]) # 0.40
# sd(borda$avg_nonmanip_utils_in_outcome[borda$manipulation=="True"]) # 0.14
mean(borda$avg_nonmanip_utils_in_outcome[borda$manipulation=="False"]) # 0.52
# sd(borda$avg_nonmanip_utils_in_outcome[borda$manipulation=="False"]) # 0.10

# how does this compare to other rules?
summary(plurality$avg_nonmanip_utils_in_outcome[plurality$manipulation=="True"]) # mean 0.43
summary(plurality$avg_nonmanip_utils_in_outcome[plurality$manipulation=="False"]) # mean 0.52
summary(veto$avg_nonmanip_utils_in_outcome[veto$manipulation=="True"]) # mean 0.43
summary(veto$avg_nonmanip_utils_in_outcome[veto$manipulation=="False"]) # mean 0.45

pdf("manipulator-utilities.pdf")
lst = list(borda$total_utils_manipulator[borda$manipulation=="True"], borda$total_utils_manipulator[borda$manipulation=="False"])
multhist(lst, #probability=TRUE,
  breaks=5
)
legend('topleft', 
  legend=c("Without Manipulation", "With Manipulation"),
  col=c('grey80', 'grey40'),
  pch=16
)
dev.off()

# summary(borda$nonmanip_utils_in_outcome[borda$manipulation=="True"]) # mean 1.70
# summary(borda$nonmanip_utils_in_outcome[borda$manipulation=="False"]) # mean 3.04

# how does manipulator do on average in both scenarios?
summary(borda$total_utils_manipulator[borda$manipulation=="True"]) # mean .584
summary(borda$total_utils_manipulator[borda$manipulation=="False"]) # mean .436
# how does this compare to other rules?
summary(plurality$total_utils_manipulator[plurality$manipulation=="True"]) # mean 0.552
summary(plurality$total_utils_manipulator[plurality$manipulation=="False"]) # mean 0.443
summary(veto$total_utils_manipulator[veto$manipulation=="True"]) # mean 0.510
summary(veto$total_utils_manipulator[veto$manipulation=="False"]) # mean 0.550






