# =============================================================================
#### Info #### 
# =============================================================================
# simple reinforcement learning model
# variant true parameters, true lr = 0.6, tau = 1.5, pRew = 0.7
# 
# modelType = 'indv' for individual fitting, or 'hrch' for hierarchical fitting
#
# Lei Zhang
# lei.zhang@univie.ac.at

run_rl_mp <- function(modelType = 'indv') {
    # =============================================================================
    #### Construct Data #### 
    # =============================================================================
    # clear workspace
    library(rstan)
    library(ggplot2)
    library(R.matlab)
    
    ###
    
    load('_data/rl_mp.RData')
    sz <- dim(rl_mp)
    nSubjects <- sz[1]
    nTrials   <- sz[2]
    
    dataList <- list(nSubjects=nSubjects,
                     nTrials=nTrials, 
                     choice=rl_mp[,,1], 
                     reward=rl_mp[,,2])
    

    # =============================================================================
    #### Running Stan #### 
    # =============================================================================
    rstan_options(auto_write = TRUE)
    options(mc.cores = 2)
    
    if (modelType=='indv') {
        modelFile <- '_scripts/reinforcement_learning_mp_indv_model.stan'
    } else if (modelType == 'hrch') {
        modelFile <- '_scripts/reinforcement_learning_mp_hrch_model.stan'
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
                   seed    = 1450154637
                   )
    
    cat("Finishing", modelFile, "model simulation ... \n")
    endTime = Sys.time(); print(endTime)  
    cat("It took",as.character.Date(endTime - startTime), "\n")
    
    # =============================================================================
    #### Model Summary and Diagnostics #### 
    # =============================================================================
    print(fit_rl)
    
    if (modelType=='indv') {
        plot_dens_lr  <- stan_plot(fit_rl, pars=c('lr'), show_density=T, fill_color = 'skyblue')
        plot_dens_tau <- stan_plot(fit_rl, pars=c('tau'), show_density=T, fill_color = 'skyblue')
        
        print(plot_dens_lr)
        print(plot_dens_tau)

    } else {
        plot_dens_lr  <- stan_plot(fit_rl, pars=c('lr_mu','lr_sd','lr'), show_density=T, fill_color = 'skyblue')
        plot_dens_tau <- stan_plot(fit_rl, pars=c('tau_mu','tau_sd','tau'), show_density=T, fill_color = 'skyblue')
        plot_dens_grp <- stan_plot(fit_rl, pars=c('lr_mu','lr_sd', 'tau_mu','tau_sd'), show_density=T, fill_color = 'skyblue')
        
        print(plot_dens_lr)
        print(plot_dens_tau)
        print(plot_dens_grp)
    } 
    
    # =============================================================================
    #### Violin plot of posterior means #### 
    # =============================================================================
    pars_value <- get_posterior_mean(fit_rl, pars=c('lr','tau'))[,5]
    pars_name  <- as.factor(c(rep('lr',10),rep('tau',10)))
    df <- data.frame(pars_value=pars_value, pars_name=pars_name)
    
    myconfig <- theme_bw(base_size = 20) +
        theme(panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.background = element_blank() )
    
    data_summary <- function(x) {
        m <- mean(x)
        ymin <- m-sd(x)
        ymax <- m+sd(x)
        return(c(y=m,ymin=ymin,ymax=ymax))
    }

    g1 <- ggplot(df, aes(x=pars_name, y=pars_value, color = pars_name, fill=pars_name)) 
    g1 <- g1 + geom_violin(trim=TRUE, size=2)
    g1 <- g1 + stat_summary(fun.data=data_summary, geom="pointrange", color="black", size=1.5)
    g1 <- g1 + scale_fill_manual(values=c("#2179b5", "#c60256"))
    g1 <- g1 + scale_color_manual(values=c("#2179b5", "#c60256"))
    g1 <- g1 + myconfig + theme(legend.position="none")
    g1 <- g1 + labs(x = '', y = 'parameter value') + ylim(0.3,2.2)
    print(g1)

    ### violin plot of true parameters
    load('_data/rl_mp_parms_optm.RData')
    pars_true_value <- rl_mp_parms
    pars_name  <- as.factor(c(rep('lr',10),rep('tau',10)))
    df2 <- data.frame(pars_true_value=pars_true_value, pars_name=pars_name)
    
    g2 <- ggplot(df2, aes(x=pars_name, y=pars_true_value, color = pars_name, fill=pars_name)) 
    g2 <- g2 + geom_violin(trim=TRUE, size=2)
    g2 <- g2 + stat_summary(fun.data=data_summary, geom="pointrange", color="black", size=1.5)
    g2 <- g2 + scale_fill_manual(values=c("#2179b5", "#c60256"))
    g2 <- g2 + scale_color_manual(values=c("#2179b5", "#c60256"))
    g2 <- g2 + myconfig + theme(legend.position="none")
    g2 <- g2 + labs(x = '', y = 'parameter value') + ylim(0.3,2.2)
    print(g2)

    return(fit_rl)
}
