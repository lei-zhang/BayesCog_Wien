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
source('_scripts/HDIofMCMC.R')

load('_data/height.RData')
d <- Howell1
d <- d[ d$age >= 18 , ]

# =============================================================================
#### Running Stan #### 
# =============================================================================
rstan_options(auto_write = TRUE)
options(mc.cores = 2)

N <- length(d$height)
dataList <- list(N=N, height=d$height, weight=d$weight)

modelFile <- '_scripts/regression_height_ppc_model.stan'
nIter     <- 2000
nChains   <- 4 
nWarmup   <- floor(nIter/2)
nThin     <- 1

cat("Estimating", modelFile, "model... \n")
startTime = Sys.time(); print(startTime)
cat("Calling", nChains, "simulations in Stan... \n")

fit_reg_ppc <- stan(modelFile, 
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
#### posterior predictive check #### 
# =============================================================================

# extract samples
height_bar <- extract(fit_reg_ppc, pars = 'height_bar', permuted = TRUE)$height_bar
dim(height_bar) # 4000-by-352
length(d$weight)
height_HDI <- apply(height_bar, 2, HDIofMCMC) # 2nd dimension

# construct intervals into df
d$lower <- height_HDI[1,]
d$upper <- height_HDI[2,]

# =============================================================================
#### make plots #### 
# =============================================================================
myconfig <- theme_bw(base_size = 20) +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank() )

# density of a generated value
plot_dens_height_bar1 <- stan_plot(fit_reg_ppc, pars = 'height_bar[1]', show_density = T, fill_color='skyblue')
plot_dens_height_bar1 <- plot_dens_height_bar1 + ylab("dens(height_bar | x = 47.8)")
ggsave(plot = plot_dens_height_bar1, "_plots/dens_height_bar1.png", width = 6, height = 4, type = "cairo-png", units = "in")

# scatter plot
g1 <- ggplot(d, aes(weight,height))
g1 <- g1 + geom_jitter(width=0.25, height=0.25, size=3, colour='skyblue', alpha=0.9)
g1 <- g1 + myconfig + labs(x = 'weight', y = 'height')
print(g1)

# add the regression line
parm <- get_posterior_mean(fit_reg_ppc, c('alpha','beta'))[,5]
g2 <- g1 + geom_abline(intercept = parm[1], slope = parm[2], 
                       color = "red", size = 2, alpha=0.8)
print(g2)

# plot shaded error bar
g3 <- g2 + geom_ribbon(aes(ymin=lower, ymax=upper), linetype=2, alpha=0.2)
print(g3)

ggsave(plot = g3, "_plots/regressionline_lm_ppc.png", width = 6, height = 4, type = "cairo-png", units = "in")





