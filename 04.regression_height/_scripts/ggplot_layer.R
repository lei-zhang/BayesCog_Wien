load('_data/height.RData')
d <- Howell1
d <- d[ d$age >= 18 , ]

L <- lm( height ~ weight, d) # estimate model by minimizing least squares errors
summary(L)

myconfig <- theme_bw(base_size = 20) +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank() )

# background
g0 <- ggplot(d, aes(weight,height)) + myconfig + ylim(130, 180)
ggsave(plot = g0, "_plots/layer0.png", width = 4, height = 3, type = "cairo-png", units = "in")

# scatter plot
g1 <- g0 + geom_jitter(width=0.25, height=0.25, size=3, colour='skyblue', alpha=0.9)
ggsave(plot = g1, "_plots/layer1.png", width = 4, height = 3, type = "cairo-png", units = "in")

# regression line
parm <- get_posterior_mean(fit_reg_ppc, c('alpha','beta'))[,5]
g2 <- g1 + geom_abline(intercept = parm[1], slope = parm[2], 
                       color = "red", size = 2, alpha=0.8)
ggsave(plot = g2, "_plots/layer2.png", width = 4, height = 3, type = "cairo-png", units = "in")

# plot shaded error bar
g3 <- g2 + geom_ribbon(aes(ymin=lower, ymax=upper), linetype=2, alpha=0.2)
ggsave(plot = g3, "_plots/layer3.png", width = 4, height = 3, type = "cairo-png", units = "in")
