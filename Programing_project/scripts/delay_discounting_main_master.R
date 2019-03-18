# =============================================================================
#### Info #### 
# =============================================================================
# Hierachical models for delay discounting models
#

# =============================================================================
#### Construct Data #### 
# =============================================================================
# clear workspace
rm(list=ls(all=TRUE))
library(rstan)
library(loo)
library(ggplot2)

#### read raw -----------------------------------------------------------------
rawdata   <- read.table( 'data/raw_Data.txt', header = T )

#### Preprocess the data ------------------------------------------------------
subjList  <- unique(rawdata[,"subjID"])
nSubjects <- length(subjList) 

Tsubj <- as.vector( rep( 0, nSubjects ) ) # number of valid trials per subj

for ( s in 1:nSubjects )  {
    curSubj  <- subjList[ s ]
    Tsubj[s] <- sum( rawdata$subjID == curSubj )
}

maxTrials <- max(Tsubj)
delay_later   <- array(0, c(nSubjects, maxTrials) )
amount_later  <- array(0, c(nSubjects, maxTrials) )
delay_sooner  <- array(0, c(nSubjects, maxTrials) )
amount_sooner <- array(0, c(nSubjects, maxTrials) )
choice <- array(0, c(nSubjects, maxTrials) )

for (s in 1:nSubjects) {
    curSubj      <- subjList[s]
    useTrials    <- Tsubj[s]
    tmp          <- subset(rawdata, rawdata$subjID == curSubj)
    delay_later[s, 1:useTrials]  <- tmp$delay_later
    amount_later[s, 1:useTrials] <- tmp$amount_later
    delay_sooner[s, 1:useTrials]  <- tmp$delay_sooner
    amount_sooner[s, 1:useTrials] <- tmp$amount_sooner
    choice[s, 1:useTrials] <- tmp$choice
}

dataList <- list(
    nSubjects = nSubjects,
    nTrials   = maxTrials,
    Tsubj     = Tsubj,
    choice    = choice,
    amount_later   = amount_later,
    delay_later    = delay_later,
    amount_sooner  = amount_sooner,
    delay_sooner   = delay_sooner
)

# =============================================================================
#### Running Stan #### 
# =============================================================================
rstan_options(auto_write = TRUE)
options(mc.cores = 2)

nIter     <- 2000
nChains   <- 4 
nWarmup   <- floor(nIter/2)
nThin     <- 1

#### run the hyperbolic model ----------------------------------------
modelFile1 <- 'scripts/hyperbolic.stan'

cat("Estimating", modelFile1, "model... \n")
startTime = Sys.time(); print(startTime)
cat("Calling", nChains, "simulations in Stan... \n")

fit_dd1 <- stan(modelFile1, 
               data    = dataList, 
               chains  = nChains,
               iter    = nIter,
               warmup  = nWarmup,
               thin    = nThin,
               init    = "random"
)

cat("Finishing", modelFile1, "model simulation ... \n")
endTime = Sys.time(); print(endTime)  
cat("It took",as.character.Date(endTime - startTime), "\n")

#### run the simple heuristic model ---------------------------------------
modelFile2 <- 'scripts/heuristic.stan'

cat("Estimating", modelFile1, "model... \n")
startTime = Sys.time(); print(startTime)
cat("Calling", nChains, "simulations in Stan... \n")

fit_dd2 <- stan(modelFile2, 
               data    = dataList, 
               chains  = nChains,
               iter    = nIter,
               warmup  = nWarmup,
               thin    = nThin,
               init    = "random"
)

cat("Finishing", modelFile2, "model simulation ... \n")
endTime = Sys.time(); print(endTime)  
cat("It took",as.character.Date(endTime - startTime), "\n")

# =============================================================================
#### Model selection #### 
# =============================================================================
LL1 = extract_log_lik(fit_dd1)
LL2 = extract_log_lik(fit_dd2)

( loo1 <- waic(LL1) )
( loo2 <- waic(LL2) )


#### End of file

