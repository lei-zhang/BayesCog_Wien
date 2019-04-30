# =============================================================================
#### Info #### 
# =============================================================================
# polynomial linear regression model
#
# Lei Zhang
# lei.zhang@univie.ac.at
#
# Adapted from McElreath, 2016

# =============================================================================

reg_poly <- function(poly_order = 1){

    # =============================================================================
    #### Construct Data #### 
    # =============================================================================
    library(rstan)
    library(ggplot2)
    source('_scripts/HDIofMCMC.R')
    
    load('_data/height.RData')
    d <- Howell1
    d$weight_sq <- d$weight^2
   
    # =============================================================================
    #### Running Stan #### 
    # =============================================================================
    rstan_options(auto_write = TRUE)
    options(mc.cores = 2)
    
    N <- length(d$height)
    dataList <- list(N=N, height=d$height, weight=d$weight, weight_sq=d$weight_sq)

    if (poly_order == 1) {
        modelFile <- '_scripts/regression_height_poly1_model.stan'
    } else if (poly_order == 2) {
        modelFile <- '_scripts/regression_height_poly2_model.stan'
    }    
        
    nIter     <- 2000
    nChains   <- 4 
    nWarmup   <- floor(nIter/2)
    nThin     <- 1
    
    cat("Estimating", modelFile, "model... \n")
    startTime = Sys.time(); print(startTime)
    cat("Calling", nChains, "simulations in Stan... \n")
    
    fit_reg_poly <- stan(modelFile, 
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
    height_bar <- extract(fit_reg_poly, pars = 'height_bar', permuted = TRUE)$height_bar
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
    
    # scatter plot
    g1 <- ggplot(d, aes(weight,height))
    g1 <- g1 + geom_jitter(width=0.25, height=0.25, size=3, colour='skyblue', alpha=0.9)
    g1 <- g1 + myconfig + labs(x = 'weight', y = 'height') + ylim(47, 210)
    print(g1)

    # add the regression line
    if (poly_order == 1) {
        parm <- get_posterior_mean(fit_reg_poly, c('alpha','beta'))[,5]
        myfun <-  function(x, alpha=parm[1], beta=parm[2]){alpha + beta * x}
    } else if (poly_order == 2) {
        parm  <- get_posterior_mean(fit_reg_poly, c('alpha','beta1', 'beta2'))[,5]
        myfun <-  function(x, alpha=parm[1], beta1=parm[2], beta2=parm[3]){alpha + beta1 * x + beta2 * x^2}
    }
    g2 <- g1 + stat_function(fun = myfun, color = "red", size = 2, alpha = 0.8)
    print(g2)
    
    # plot shaded error bar
    g3 <- g2 + geom_ribbon(aes(ymin=lower, ymax=upper), linetype=2, alpha=0.2)
    print(g3)
    
    L <- list(fit_reg_poly = fit_reg_poly,
              g1 = g1, 
              g2 = g2, 
              g3 = g3)
    
    return(L)
}
