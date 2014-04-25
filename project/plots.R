# set up workspace
setwd('~/github/cs590cm/project/data')
library(doBy)

# load data
movies = as.data.frame(matrix(NA, nrow=5, ncol=3))
colnames(movies) = c("name", "critics", "audience")

movies[1,] = c("Captain America", 0.89, 0.95)
movies[2,] = c("Noah",            0.77, 0.47)
movies[3,] = c("Divergent",       0.40, 0.78)
movies[4,] = c("Muppets",         0.79, 0.67)
movies[5,] = c("Grand Budapest",  0.92, 0.90)
movies$critics = as.numeric(movies$critics)
movies$audience = as.numeric(movies$audience)

w = seq(from=0, to=1, by=0.01)
utils = as.data.frame(matrix(NA, nrow=101, ncol=6))
colnames(utils) = c("w", movies[,1])
utils$w = w
head(utils)
tail(utils)
for(i in 1:nrow(movies)){
  m = movies$name[i]
  critics = movies$critics[i]
  audience = movies$audience[i]
  util = w*critics + (1-w)*audience
  utils[ , m] = util
}
head(utils)
tail(utils)

# plot helpers
myColors = c('red', 'blue', 'black', 'forestgreen', 'brown')
first = utils$w[which(utils[,4]-utils[,5]<=0.0001 & utils[,4]-utils[,5]>=-0.0001)]
second = utils$w[which(utils[,3]-utils[,4]<=0.01 & utils[,3]-utils[,4]>=-0.001)][1]
third = utils$w[which(utils[,2]-utils[,6]<=0.001 & utils[,2]-utils[,6]>=-0.001)][2]

plot(utils$w, utils[,2], # capt-america
    type='l',
    col=myColors[1],
    lwd=2,
    ylim=c(0,1),
    xlab = "w",
    ylab = "Utility"
  )
for(j in 3:6){
  lines(utils$w, utils[,j], lwd=2, col=myColors[j-1])
}
# add vertical lines where utils cross
abline(v=first)
abline(v=second)
abline(v=third)
legend('bottomright',
    col=myColors,
    legend=movies$name,
    pch=16
  )


# pathological case
myColors = c("#e41a1c", "#377eb8", "#4daf4a", "#984ea3")
x = .575/.75
fakeMovies = as.data.frame(matrix(NA, nrow=4, ncol=3))
colnames(fakeMovies) = c("name", "critics", "audience")
fakeMovies[1,] = c("A", 0.00, 0.60)
fakeMovies[2,] = c("B", 0.45, 0.45)
fakeMovies[3,] = c("C", 0.70, 0.20)
fakeMovies[4,] = c("D", x,    0.00)
fakeMovies$critics = as.numeric(fakeMovies$critics)
fakeMovies$audience = as.numeric(fakeMovies$audience)

fakeUtils = as.data.frame(matrix(NA, nrow=101, ncol=5))
colnames(fakeUtils) = c("w", fakeMovies[,1])
fakeUtils$w = w
for(i in 1:nrow(fakeMovies)){
  m = fakeMovies$name[i]
  critics = fakeMovies$critics[i]
  audience = fakeMovies$audience[i]
  util = w*critics + (1-w)*audience
  fakeUtils[ , m] = util
}
head(fakeUtils)
tail(fakeUtils)

plot(fakeUtils$w, fakeUtils[,2], # capt-america
    type='l',
    col=myColors[1],
    lwd=2,
    ylim=c(0,1),
    xlab = "w",
    ylab = "Utility"
  )
for(j in 3:5){
  lines(fakeUtils$w, fakeUtils[,j], lwd=2, col=myColors[j-1])
}
# add vertical lines where utils cross
abline(v=0.25, lty=2)
abline(v=0.50, lty=2)
abline(v=0.75, lty=2)
legend('topleft',
    col=myColors,
    legend=fakeMovies$name,
    pch=16
  )




