# =============================================================================
#### Info #### 
# =============================================================================
# bernoulli coin example
#
# Lei Zhang
# lei.zhang@univie.ac.at
#
# Adapted from Kruschke, 2015

# =============================================================================
#### Construct Data #### 
# =============================================================================
# clear workspace
rm(list=ls(all=TRUE))

# true theta should be around 0.75

load('_data/flip.RData')
N <- length(flip)
dataList <- list(flip=flip, N=N)

# =============================================================================
#### Running Stan #### 
# =============================================================================
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = 2)

nIter     <- 2000
nChains   <- 4 
nWarmup   <- floor(nIter/2)
nThin     <- 1

#### model1 #### --------------------------------------------

modelFile <- '_scripts/bernoulli_coin_model1.stan'

cat("Estimating", modelFile, "model... \n")
startTime = Sys.time(); print(startTime)
cat("Calling", nChains, "simulations in Stan... \n")

fit_coin1 <- stan(modelFile, 
                  data    = dataList, 
                  chains  = nChains,
                  iter    = nIter,
                  warmup  = nWarmup,
                  thin    = nThin,
                  init    = "random",
                  seed    = 1450154626)

cat("Finishing", modelFile, "model simulation ... \n")
endTime = Sys.time(); print(endTime)  
cat("It took",as.character.Date(endTime - startTime), "\n")

#### model2 #### --------------------------------------------

modelFile <- '_scripts/bernoulli_coin_model2.stan'

cat("Estimating", modelFile, "model... \n")
startTime = Sys.time(); print(startTime)
cat("Calling", nChains, "simulations in Stan... \n")

fit_coin2 <- stan(modelFile, 
                 data    = dataList, 
                 chains  = nChains,
                 iter    = nIter,
                 warmup  = nWarmup,
                 thin    = nThin,
                 init    = "random",
                 seed    = 1450154626)

cat("Finishing", modelFile, "model simulation ... \n")
endTime = Sys.time(); print(endTime)  
cat("It took",as.character.Date(endTime - startTime), "\n")

# =============================================================================
#### Model Summary and Diagnostics #### 
# =============================================================================
print(fit_coin1)

plot_trace_excl_warm_up <- stan_trace(fit_coin1, pars = 'theta', inc_warmup = F)
plot_trace_incl_warm_up <- stan_trace(fit_coin1, pars = 'theta', inc_warmup = T)

plot_dens_cmb <- stan_dens(fit_coin1, separate_chains = F)
plot_dens_sep <- stan_dens(fit_coin1, separate_chains = T)

plot_dens <- stan_plot(fit_coin2, pars = 'theta', show_density = T, fill_color="skyblue")
ggsave(plot = plot_dens, "_plots/dens.png", width = 6, height = 4, type = "cairo-png", units = "in")
