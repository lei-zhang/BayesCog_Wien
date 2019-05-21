# =============================================================================
#### Info #### 
# =============================================================================
# true generating model: fictitious model
#
# true parameters: lr  = rnorm(10, mean=0.6, sd=0.12); tau = rnorm(10, mean=1.5, sd=0.2)
#
# Lei Zhang, UKE, Hamburg, DE
# lei.zhang@uke.de


# =============================================================================
#### Construct Data #### 
# =============================================================================
# clear workspace
rm(list = ls())
library(rstan)
library(ggplot2)
library(R.matlab)
library(loo)

load('_data/rlnc_data.RData')
sz <- dim(rlnc)
nSubjects <- sz[1]
nTrials   <- sz[2]

dataList <- list(nSubjects=nSubjects,
                 nTrials=nTrials, 
                 choice=rlnc[,,1], 
                 reward=rlnc[,,2])

# =============================================================================
#### Running Stan #### 
# =============================================================================
rstan_options(auto_write = TRUE)
options(mc.cores = 2)

modelFile1 <- '_scripts/comparing_models_model1.stan'  # simple RL model
modelFile2 <- '_scripts/comparing_models_model2.stan'  # fictitious RL model

nIter     <- 2000
nChains   <- 4 
nWarmup   <- floor(nIter/2)
nThin     <- 1

### model1
cat("Estimating", modelFile1, "model... \n")
startTime = Sys.time(); print(startTime)
cat("Calling", nChains, "simulations in Stan... \n")

fit_rl1 <- stan(modelFile1, 
               data    = dataList, 
               chains  = nChains,
               iter    = nIter,
               warmup  = nWarmup,
               thin    = nThin,
               init    = "random",
               seed    = 145015634
)

cat("Finishing", modelFile1, "model simulation ... \n")
endTime = Sys.time(); print(endTime)  
cat("It took",as.character.Date(endTime - startTime), "\n")


### model2
cat("Estimating", modelFile2, "model... \n")
startTime = Sys.time(); print(startTime)
cat("Calling", nChains, "simulations in Stan... \n")

fit_rl2 <- stan(modelFile2, 
                data    = dataList, 
                chains  = nChains,
                iter    = nIter,
                warmup  = nWarmup,
                thin    = nThin,
                init    = "random",
                seed    = 1450154637
)

cat("Finishing", modelFile2, "model simulation ... \n")
endTime = Sys.time(); print(endTime)  
cat("It took",as.character.Date(endTime - startTime), "\n")

# =============================================================================
#### extract log_likelihood and compare models #### 
# =============================================================================
LL1 <- extract_log_lik(fit_rl1)
LL2 <- extract_log_lik(fit_rl2)

loo1 <- loo(LL1)
loo2 <- loo(LL2)
compare(loo1, loo2) # positive difference indicates the 2nd model's predictive accuracy is higher





