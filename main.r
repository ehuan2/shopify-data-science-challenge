# the following is reading the data from the shoe stores
mydata <- read.csv(file = "shopify-data.csv")
order_amount <- mydata$order_amount

# let's get the five numbers first, lowest, first quartile, median, third quartile, final
fivenum(order_amount)

# and we get: [1]     90    163    284    390 704000

# then, let's get the kurtosis and skewness to see how far it deviates from normal distributions, and its tail behaviours
skewness <- function(x) {(sum((x - mean(x))^3)/length(x))/(sum((x - mean(x))^2)/length(x))^(3/2)}
kurtosis <- function(x) {(sum((x - mean(x))^4)/length(x))/(sum((x - mean(x))^2)/length(x))^2}

skewness(order_amount) # [1] 16.67003 - really heavily skewed to the right!
kurtosis(order_amount) # [1] 282.6205 - really big tails, usually it should be around 3

# let's find the standard deviation then, and see if we can do the 2 sd's away trick
order_amount.sd <- sd(order_amount) # [1] 41282.54 - even the sd is so huge

# now we're going to try and split the data up now:
topQuartile <- order_amount[which(order_amount > 390)]

# now let's analyze the five number summary from top quartile + kurtosis + skewness:
# let's get the five numbers first, lowest, first quartile, median, third quartile, final
fivenum(topQuartile)

# 392    459    507    591 704000 - still skewed lol

skewness(topQuartile) # [1] 8.19412 - still really heavily skewed to the right!
kurtosis(topQuartile) # [1] 69 - a lot smaller, but still not good

# let's find the standard deviation then, and see if we can do the 2 sd's away trick
topQuartile.sd <- sd(topQuartile) # [1] 82066.36 - even the sd is so huge

# then, in this case, we continue partitioning
topQuartile2 <- order_amount[which(order_amount > 591)]
# and analyze once more:
fivenum(topQuartile2)

# 592    652    712    935 704000 - still skewed lol

skewness(topQuartile2) # [1] 3.82986 - smaller!
kurtosis(topQuartile2) # [1] 15.90744 - a lot smaller, but still not good

# we'll split one more time:
topQuartile3 <- order_amount[which(order_amount > 935)]
# and analyze once more:
fivenum(topQuartile3)

# 948.0  25725.0  51450.0  90037.5 704000.0 - seems reasonable now!

skewness(topQuartile3) # [1] 1.293732 - very good! barely to the right now
kurtosis(topQuartile3) # [1] 2.721902 - very close to 3!!

# now let's analyze the lower 75% + 12.5% + 6.25% = 93.75%, all lower than 948
bottom <- order_amount[which(order_amount <= 948)]
fivenum(bottom)

# 90 163 284 387 948 - seems reasonable

skewness(bottom) # [1] 0.9399418 - very good! barely to the right now
kurtosis(bottom) # [1] 3.596285 - very close to 3!!

library(MASS)

truehist(bottom, xlab = "Different order amounts for lower cost shoes", ylab = "Relative Frequency", main = "Relative frequency histogram of different order amounts of low cost shoes", ylim = c(0, 0.004), xlim = c(0, 1000), nbins = 25, las = 1, col = "dodgerblue3", density = 25, angle = 45)
bottom.mean <- mean(bottom)
bottom.sd <- sd(bottom)

curve(dnorm(x, bottom.mean, bottom.sd), col = "red", add = TRUE, lwd = 1.5)

bottom.mean # 300.5241
mean(topQuartile3) # 187454
