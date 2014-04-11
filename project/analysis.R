setwd('~/github/cs590cm/project/data')
data = read.csv('simdata-823226.csv', as.is=T)
dim(data)
head(data)

length(which(data$manipulation=="True"))


rules = c("borda")
ws = c(0.1, 0.3, 0.5, 0.7, 0.9)
as = c(9, 7, 5, 3, 1)
ns = seq(1, 10)
ns = range(1,11)
perfect_info = c("True", "False")

# todo: plot proportion of manipulations
# todo: plot how much utility changes in manipulations