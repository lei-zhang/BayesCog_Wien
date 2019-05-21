count_divergences <- function(fit, nchain=1) { 
    sampler_params <- get_sampler_params(fit, inc_warmup=FALSE) 
    if (nchain == 1) {
        sum(sapply(sampler_params, function(x) c(x[,'n_divergent__']))[,1]) 
    } else {
        sum(sapply(sampler_params, function(x) c(x[,'n_divergent__']))[,1:nchain]) 
    }
} 

hist_treedepth <- function(fit, nchain=1) { 
    sampler_params <- get_sampler_params(fit, inc_warmup=FALSE) 
    if (nchain == 1) {
        hist(sapply(sampler_params, function(x) c(x[,'treedepth__']))[,1], breaks=0:20, main="", xlab="Treedepth")  
    } else {
        hist(sapply(sampler_params, function(x) c(x[,'treedepth__']))[,1:nchain], breaks=0:20, main="", xlab="Treedepth")  
    }
    abline(v=10, col=2, lty=1) 
} 
