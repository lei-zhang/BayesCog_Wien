# =============================================================================
#### Info #### 
# =============================================================================
# R basics and probability functions
#
# Lei Zhang, UKE, Hamburg, DE
# lei.zhang@uke.de

# =============================================================================
#### Exercise I #### 
# =============================================================================

#------------------------------------------------------------------------------
## Get to know your R
R.version
sessionInfo()

#------------------------------------------------------------------------------
## Basic Commands
getwd()
setwd() # this requires the PATH as input argument
dir()
ls()
print('hello world')
cat("Hello", "World")
paste0('C:/', 'Group1')
? mean
rm(list = ls())
#q()

#------------------------------------------------------------------------------
## Data Classes 

# numeric & integer
a1 <- 5
a2 <- as.integer(a1)

class(a1)
class(a2)

# character
b1 <- 'Hello World!'
b2 <- "Hello World!"
class(b1)
class(b2)


## logical
c1 <- T; c2 <- TRUE; c3 <- F; c4 <- FALSE
class(c1)

# factor
f <- factor(letters[c(1, 1, 2, 2, 3:10)])
class(f)

#------------------------------------------------------------------------------
## Data Types

# vector
v1 <- 1:12
v2 <- c(2,4,1,5,1,6, 13:18)
v3 <- c(rep('aa',4), rep('bb',4), rep('cc',4))
class(v1)
class(v2)
class(v3)

# matrix and array
m1 <- matrix(v1, nrow=3, ncol=4)
m2 <- matrix(v1, nrow=3, ncol=4, byrow = T)
arr <- array(v1, dim=c(2,2,3))
class(m1)
class(arr)

# dataframe
df <- data.frame(v1=v1, v2=v2, v3=v3, f=f)
class(df)
str(df)
class(df$v1)
class(df$v2)
class(df$v3)
class(df$f)

# =============================================================================
#### Exercise II #### 
# =============================================================================

#------------------------------------------------------------------------------
## Control Flow

# if-else
t <- runif(1) # random number between 0 and 1
if (t <= 1/3) {
    cat("t =", , ", t <= 1/3. \n")
} else if () {
    cat("t =", t, ", t > 2/3. \n")
} else {
    cat("t =", t, ", 1/3 < t <= 2/3. \n")
}

# for-loop
month_name <- format(ISOdate(2018,1:12,1),"%B")
for (j in 1:length(month_name) ) {
    cat()
}

#------------------------------------------------------------------------------
## User-defined Function

# example: standard error of the mean
sem <- function(x) {
    sqrt( var(x,na.rm=TRUE) / (length(na.omit(x))-1) )
}

# calculate the meam 
my_mean <- function(x) {
    x_bar <- 
    return(x_bar)
}

tmp <- rnorm(10)
my_mean(tmp)

# sanity check
all.equal(mean(tmp), my_mean(tmp))

#------------------------------------------------------------------------------
## basic ploting

x = rnorm(20)
y = x + rnorm(20,0,.8)
plot(x,y)
ggplot2::qplot(x,y)
lattice::xyplot(y ~ x)


# =============================================================================
#### Exercise III #### 
# =============================================================================

#------------------------------------------------------------------------------
## basic data management
data_dir = ('_data/RL_raw_data/sub01/raw_data_sub01.txt')
data = read.table(data_dir, header = T, sep = ",")
head(data)

# rm NAs
sum(complete.cases(data))
data = data[complete.cases(data),]
dim(data[complete.cases(data),])

# indexing
data[1,1]
data[1,]
data[,1]
data[1:10,]
data[,1:2]
data[1:10, 1:2]
data[c(1,3,5,6), c(2,4)]
data$choice

# read in all the data!
ns = 10
data_dir = '_data/RL_raw_data'

rawdata = c();
for (s in 1:ns) {
    sub_file = file.path(, sprintf('sub%02i/raw_data_sub%i.txt',s,s))
    sub_data = read.table(sub_file, header = T, sep = ",")
    rawdata = rbind(rawdata, sub_data)
}
rawdata = rawdata[complete.cases(rawdata),]
rawdata$accuracy = (rawdata$choice == rawdata$correct) * 1.0

acc_mean = aggregate(rawdata$accuracy, by = list(rawdata$subjID), mean)[,2]


# =============================================================================
#### Exercise IV #### 
# =============================================================================

#------------------------------------------------------------------------------
# read descriptive data
load('_data/RL_descriptive.RData')
descriptive$acc = acc_mean
df = descriptive

#------------------------------------------------------------------------------
# one sample t-test , to test if 'acc' is above chance level
t.test(df$acc, mu = 0.5) 
# simple correlation, to test if IQ is correlated with acc
cor.test(df$IQ, df$acc)

# =============================================================================
#### Exercise V #### 
# =============================================================================

#------------------------------------------------------------------------------
## plot the scatter and the regression line
library(ggplot2)

myconfig <- theme_bw(base_size = 20) +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank() )

# scatter plot
g1 <- ggplot(df, aes(IQ,acc))
g1 <- g1 + geom_jitter(width=0.0, height=0.0, size=5, colour='skyblue', alpha=0.95)
g1 <- g1 + myconfig + labs(x = 'IQ', y = 'Choice accuracy (%)')

# add the regression line
g1 <- g1 + geom_smooth(method = "lm", se = T, colour='skyblue3')
g1
#ggsave(plot = g1, "_plots/scatter.png", width = 4, height = 3, type = "cairo-png", units = "in")


# =============================================================================
#### Exercise VI #### 
# =============================================================================

## simple regression
fit1 = lm(acc ~ IQ, data = df)
summary(fit1)



# =============================================================================
#### Exercise VII #### 
# =============================================================================
library(MASS)
str(UScrime)
# U1 unemployment rate of urban males 14 to 24.
# U2 unemployment rate of urban males 35 to 39.
t.test(UScrime$U1, UScrime$U2, paired=TRUE)


#------------------------------------------------------------------------------
# perform a Bayesian t-test using http://sumsar.net/best_online/




