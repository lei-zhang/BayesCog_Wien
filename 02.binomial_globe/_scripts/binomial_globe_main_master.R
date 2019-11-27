# =============================================================================
#### Info #### 
# =============================================================================
# binomial globe example
#
# Lei Zhang 
# lei.zhang@univie.ac.at
#
# Adapted from McElreath, 2016

# =============================================================================
#### Construct Data #### 
# =============================================================================
# clear workspace
rm(list=ls(all=TRUE))

w <- 6
N <- 9
dataList <- list(w=w, N=N)

# =============================================================================
#### Running Stan #### 
# =============================================================================
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = 2)

modelFile <- '_scripts/binomial_globe_model.stan'
nIter     <- 2000
nChains   <- 4 
nWarmup   <- floor(nIter/2)
nThin     <- 1

cat("Estimating", modelFile, "model... \n")
startTime = Sys.time(); print(startTime)
cat("Calling", nChains, "simulations in Stan... \n")

fit_globe <- stan(modelFile, 
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
print(fit_globe)

plot_trace_excl_warm_up <- stan_trace(fit_globe, pars = 'theta', inc_warmup = F)
plot_trace_incl_warm_up <- stan_trace(fit_globe, pars = 'theta', inc_warmup = T)
ggsave(plot = plot_trace_excl_warm_up, "_plots/trace_excl_warmup.png", width = 6, height = 4, type = "cairo-png", units = "in")
ggsave(plot = plot_trace_incl_warm_up, "_plots/trace_incl_warmup.png", width = 6, height = 4, type = "cairo-png", units = "in")

plot_dens_cmb <- stan_dens(fit_globe, separate_chains = F, fill = 'skyblue')
plot_dens_sep <- stan_dens(fit_globe, separate_chains = T)
ggsave(plot = plot_dens_cmb, "_plots/dens_cmb.png", width = 6, height = 4, type = "cairo-png", units = "in")
ggsave(plot = plot_dens_sep, "_plots/dens_sep.png", width = 6, height = 4, type = "cairo-png", units = "in")

## stan_plot(fit_globe, pars = 'p', show_density = T)
