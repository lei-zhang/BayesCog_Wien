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
#### Grid Approximation #### 
# =============================================================================
# inits
theta_start <- 0
theta_end   <- 1
n_grid  <- 20
w <- 6
N <- 9

# define grid
theta_grid <- seq( from = theta_start , to = theta_end , length.out = n_grid )

# define prior
prior <- rep(1 , n_grid)

# compute likelihood at each value in grid
likelihood <- dbinom(w , size = N , prob = theta_grid )

# compute product of likelihood and prior
unstd.posterior <- likelihood * prior

# standardize the posterior, so it sums to 1
posterior <- unstd.posterior / sum(unstd.posterior)

# =============================================================================
#### Plot #### 
# =============================================================================
library(ggplot2)

myconfig <- theme_bw(base_size = 20) +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank() )

df <- data.frame(theta_grid=theta_grid, posterior=posterior)

g <- ggplot(df, aes(theta_grid, posterior))
g <- g + geom_line(size = 2) + geom_point(size = 5, shape = 21, fill='white')
g <- g + myconfig + labs(x = 'probability of water', 
                         y = 'posterior probability', title = paste0(as.character(n_grid),' points'))
print(g)
