# =============================================================================
#### Info #### 
# =============================================================================
# Optimizing Stan code, Neal's Funnel example
#
# Lei Zhang, UKE, Hamburg, DE
# lei.zhang@uke.de
#
# Adapted from Stan Reference 2.12, 2016

# =============================================================================
library(rstan); library(ggplot2)


startTime = proc.time()

# =============================================================================
# direct model
# =============================================================================
rstan_options(auto_write = TRUE)
options(mc.cores = 2)

system.time(
    funnel_fit1 <- stan("_scripts/funnel.stan",
                        seed = 1212337896)
)


# =============================================================================
# adjust delta
# =============================================================================
system.time(
    funnel_fit2 <- stan("_scripts/funnel.stan",
                        seed = 1212337896, 
                        control = list(adapt_delta = 0.999, max_treedepth=20))
)


# =============================================================================
# reparameterized model
# =============================================================================
system.time(
    funnel_fit3 <- stan("_scripts/funnel_reparam.stan",
                        seed = 1212337896)
)

stopTime = proc.time()
elapsedTime = stopTime - startTime


myx <- extract(funnel_fit1,'x')$x
myy <- extract(funnel_fit1,'y')$y
qplot(myx[,1],myy)


myx <- extract(funnel_fit2,'x')$x
myy <- extract(funnel_fit2,'y')$y
qplot(myx[,1],myy)

# =============================================================================
# Trace plot
# =============================================================================
plot_trace1 <- stan_trace(funnel_fit1, pars = 'y', inc_warmup = F)

plot_trace2 <- stan_trace(funnel_fit2, pars = 'y', inc_warmup = F)

plot_trace3 <- stan_trace(funnel_fit3, pars = 'y', inc_warmup = F)
