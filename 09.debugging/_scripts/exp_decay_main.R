# =============================================================================
#### Info #### 
# =============================================================================
# debugging excercise: simple exponential decay model for memory retention task
#
# Lei Zhang
# lei.zhang@univie.ac.at
#
# Adapted from Lee & Wagenmakers, 2013

# =============================================================================
#### Construct Data #### 
# =============================================================================
# clear workspace
rm(list=ls(all=TRUE))

intervals <- c(1, 2, 4, 7, 12, 21, 35, 59, 99)
nt        <- length(intervals)
ns        <- 3
nItem     <- 18

k <- matrix(c(18, 18, 16, 13, 9, 6, 4, 4, 4,
              17, 13,  9,  6, 4, 4, 4, 4, 4,
              14, 10,  6,  4, 4, 4, 4, 4, 4), nrow=ns, ncol=nt, byrow=T)


dataList  <- list(k         = k,          # items remmebered
                  nItem     = nItem,      # total number of items
                  intervals = intervals,  # time intervals
                  ns        = ns,         # number of subjects
                  nt        = nt)         # number of trials


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

modelFile <- '_scripts/exp_decay_model2.stan'

cat("Estimating", modelFile, "model... \n")
startTime = Sys.time(); print(startTime)
cat("Calling", nChains, "simulations in Stan... \n")

fit_mem <- stan(modelFile, 
                  data    = dataList, 
                  chains  = nChains,
                  iter    = nIter,
                  warmup  = nWarmup,
                  thin    = nThin,
                  init    = "random")#,
                  #seed    = 1450154626)

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

plot_dens <- stan_plot(fit_coin2, pars = 'theta', show_density = T)
ggsave(plot = plot_dens, "_plots/dens.png", width = 6, height = 4, type = "cairo-png", units = "in")
