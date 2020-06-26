# =============================================================================
#### Info #### 
# =============================================================================
# Hierachical models for two-armed bandit learning task
# (C) Lei Zhang <lei.zhang@univie.ac.at>

# =============================================================================
#### Construct Data #### 
# =============================================================================
# clear workspace
rm(list=ls(all=TRUE))
library(rstan)
library(loo)
library(ggplot2)

#### read raw -----------------------------------------------------------------
rawdata   = # complete this line for reading raw data
    
# write a line here to remove missing trials

#### Preprocess the data ------------------------------------------------------
subjList  = unique(rawdata[,"subjID"])
nSubjects = length(subjList) 

Tsubj = as.vector( rep( 0, nSubjects ) ) # number of valid trials per subj

for ( s in 1:nSubjects )  {
    curSubj  = subjList[ s ]
    Tsubj[s] = sum( rawdata$subjID == curSubj )
}

maxTrials = max(Tsubj)
choice = array(0, c(nSubjects, maxTrials) )
reward = array(0, c(nSubjects, maxTrials) )

for (s in 1:nSubjects) {
    curSubj      = subjList[s]
    useTrials    = Tsubj[s]
    tmp          = subset(rawdata, rawdata$subjID == curSubj)
    choice[s, 1:useTrials] = tmp$choice
    reward[s, 1:useTrials] = tmp$reward
}

dataList = list(
    nSubjects = nSubjects,
    nTrials   = maxTrials,
    Tsubj     = Tsubj,
    choice    = choice,
    reward    = reward
)

# =============================================================================
#### Running Stan #### 
# =============================================================================
rstan_options(auto_write = TRUE)
options(mc.cores = 2) # <-- adjust if you want to run 4 cores in parallel

nIter     = 2000
nChains   = 4 
nWarmup   = floor(nIter/2)
nThin     = 1

#### run the Rescorla-Wagner model ----------------------------------------
modelFile1 = 'scripts/rw.stan'

cat("Estimating", modelFile1, "model... \n")
startTime = Sys.time(); print(startTime)
cat("Calling", nChains, "simulations in Stan... \n")

fit_rw = stan() # complete this line for calling Stan

cat("Finishing", modelFile1, "model simulation ... \n")
endTime = Sys.time(); print(endTime)  
cat("It took",as.character.Date(endTime - startTime), "\n")

#### run the reward-punishment model ---------------------------------------
modelFile2 = 'scripts/rp.stan'

cat("Estimating", modelFile1, "model... \n")
startTime = Sys.time(); print(startTime)
cat("Calling", nChains, "simulations in Stan... \n")

fit_rp = stan() # complete this line for calling Stan

cat("Finishing", modelFile2, "model simulation ... \n")
endTime = Sys.time(); print(endTime)  
cat("It took",as.character.Date(endTime - startTime), "\n")

# =============================================================================
#### Model selection #### 
# =============================================================================
LL_rw = # complete this line for extreact log-likelihood
LL_rp  = # complete this line for extreact log-likelihood

waic_rw = waic(LL_rw)
waic_rp = waic(LL_rp)

#### End of file
