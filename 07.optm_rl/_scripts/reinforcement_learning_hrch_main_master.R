# =============================================================================
#### Info #### 
# =============================================================================
# simple reinforcement learning model
#
# true parameters: lr  = rnorm(10, mean=0.6, sd=0.12); tau = rnorm(10, mean=1.5, sd=0.2)
#
# Lei Zhang
# lei.zhang@univie.ac.at

run_rl_mp2 <- function(optimized = FALSE, ppc = FALSE) {
    # =============================================================================
    #### Construct Data #### 
    # =============================================================================
    # clear workspace
    library(rstan)
    library(ggplot2)
    library(R.matlab)
    
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
    
    if (optimized == FALSE) {
        modelFile <- '_scripts/reinforcement_learning_mp_hrch_model.stan'
    } else {
        if (ppc == FALSE) {
            modelFile <- '_scripts/reinforcement_learning_mp_hrch_optm_model.stan'
        } else {
            modelFile <- '_scripts/reinforcement_learning_mp_hrch_optm_model_ppc.stan'
        }
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
                   seed    = 1450154626
                   )
    
    cat("Finishing", modelFile, "model simulation ... \n")
    endTime = Sys.time(); print(endTime)  
    cat("It took",as.character.Date(endTime - startTime), "\n")
    
    # =============================================================================
    #### Model Summary and Diagnostics #### 
    # =============================================================================
    print(fit_rl)
    
    if (optimized == FALSE) {
        plot_dens_lr  <- stan_plot(fit_rl, pars=c('lr_mu','lr'), show_density=T, fill_color = 'skyblue')
        plot_dens_tau <- stan_plot(fit_rl, pars=c('tau_mu','tau'), show_density=T, fill_color = 'skyblue')
        
        print(plot_dens_lr)
        print(plot_dens_tau)
        
        ggsave(plot = plot_dens_lr, "_plots/lr_mp_hrch_lr_dens.png", width = 3, height = 4, type = "cairo-png", units = "in")
        ggsave(plot = plot_dens_tau, "_plots/lr_mp_hrch_tau_dens.png", width = 3, height = 4, type = "cairo-png", units = "in")
      
    } else {
        plot_dens_lr  <- stan_plot(fit_rl, pars=c('lr_mu','lr'), show_density=T, fill_color = 'skyblue')
        plot_dens_tau <- stan_plot(fit_rl, pars=c('tau_mu','tau'), show_density=T, fill_color = 'skyblue')
        
        print(plot_dens_lr)
        print(plot_dens_tau)
        
        ggsave(plot = plot_dens_lr, "_plots/lr_mp_hrch_optm_lr_dens.png", width = 3, height = 4, type = "cairo-png", units = "in")
        ggsave(plot = plot_dens_tau, "_plots/lr_mp_hrch_optm_tau_dens.png", width = 3, height = 4, type = "cairo-png", units = "in")
    } 
    
    ## stan_plot(fit_reg, pars = 'p', show_density = T)
    
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
    
    if (optimized == FALSE) {
        ggsave(plot = g1, "_plots/lr_mp_hrch_violin.png", width = 4, height = 4, type = "cairo-png", units = "in")
    } else {
        ggsave(plot = g1, "_plots/lr_mp_hrch_optm_violin.png", width = 4, height = 4, type = "cairo-png", units = "in")
    } 
    
    return(fit_rl)
}
