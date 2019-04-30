# =============================================================================
#### Info #### 
# =============================================================================
# simple reinforcement learning model
# single true parameters, true lr = 0.6, tau = 1.5, pRew = 0.7
#
# Lei Zhang
# lei.zhang@univie.ac.at

run_rl_sp <- function(multiSubj = FALSE) {
    # =============================================================================
    #### Construct Data #### 
    # =============================================================================
    # clear workspace
    library(rstan)
    library(ggplot2)
    library(R.matlab)
    
    if (multiSubj==FALSE) {
        load('_data/rl_sp_ss.RData')
        sz <- dim(rl_ss)
        nTrials <- sz[1]
        
        dataList <- list(nTrials=nTrials, 
                         choice=rl_ss[,1], 
                         reward=rl_ss[,2])
    } else {
        load('_data/rl_sp_ms.RData')
        sz <- dim(rl_ms)
        nSubjects <- sz[1]
        nTrials   <- sz[2]
        
        dataList <- list(nSubjects=nSubjects,
                         nTrials=nTrials, 
                         choice=rl_ms[,,1], 
                         reward=rl_ms[,,2])
    }   
    

    # =============================================================================
    #### Running Stan #### 
    # =============================================================================
    rstan_options(auto_write = TRUE)
    options(mc.cores = 2)
    
    if (multiSubj==FALSE) {
        modelFile <- '_scripts/reinforcement_learning_sp_ss_model.stan'
    } else {
        modelFile <- '_scripts/reinforcement_learning_sp_ms_model.stan'
    } 
    
    nIter     <- 2000
    nChains   <- 4 
    nWarmup   <- floor(nIter/2)
    nThin     <- 1
    
    cat("Estimating", modelFile, "model... \n")
    startTime = Sys.time(); print(startTime)
    cat("Calling", nChains, "simulations in Stan... \n")
    
    fit_rl <- stan(modelFile, 
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
    print(fit_rl)
    
    plot_trace_excl_warm_up <- stan_trace(fit_rl, pars = c('lr','tau'), inc_warmup = F)
    plot_dens <- stan_plot(fit_rl, pars=c('lr','tau'), show_density=T, fill_color = 'skyblue')
    
    return(fit_rl)
    
}
