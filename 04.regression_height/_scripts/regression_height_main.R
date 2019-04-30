# =============================================================================
#### Info #### 
# =============================================================================
# linear regression model
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
library(rstan)
library(ggplot2)

load('_data/height.RData')
d <- Howell1
d <- d[ d$age >= 18 , ]
str(d)
head(d)

# =============================================================================
#### basic GLM #### 
# =============================================================================
L <- lm( height ~ weight, d) # estimate model by minimizing least squares errors
summary(L)

myconfig <- theme_bw(base_size = 20) +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank() )

# scatter plot
g1 <- ggplot(d, aes(weight,height))
g1 <- g1 + geom_jitter(width=0.25, height=0.25, size=3, colour='skyblue', alpha=0.9)
g1 <- g1 + myconfig + labs(x = 'weight', y = 'height')
print(g1)

# add the regression line
g2 <- g1 + geom_abline(intercept = L$coefficients[[1]], slope = L$coefficients[[2]], 
                       color = "red", size = 2, alpha=0.8)
print(g2)

# =============================================================================
#### Running Stan #### 
# =============================================================================
rstan_options(auto_write = TRUE)
options(mc.cores = 2)

N <- length(d$height)
dataList <- list(N=N, height=d$height, weight=d$weight)

modelFile <- '_scripts/regression_height_model.stan'
nIter     <- 2000
nChains   <- 4 
nWarmup   <- floor(nIter/2)
nThin     <- 1

cat("Estimating", modelFile, "model... \n")
startTime = Sys.time(); print(startTime)
cat("Calling", nChains, "simulations in Stan... \n")

fit_reg <- stan(modelFile, 
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
print(fit_reg)

plot_trace_excl_warm_up <- stan_trace(fit_reg, pars = 'alpha', inc_warmup = F)
plot_trace_incl_warm_up <- stan_trace(fit_reg, pars = 'alpha', inc_warmup = T)

plot_dens_cmb <- stan_dens(fit_reg, separate_chains = F, fill = 'skyblue')
plot_dens_sep <- stan_dens(fit_reg, separate_chains = T)
