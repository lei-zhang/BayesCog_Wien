####################################################################
# load data
load('_data/rl_mp.RData')
sz <- dim(rl_mp)
nSubjects <- sz[1]
nTrials   <- sz[2]

dataList <- list(nSubjects=nSubjects,
                 nTrials=nTrials, 
                 choice=rl_mp[,,1], 
                 reward=rl_mp[,,2])

# load model object
f = readRDS('_outputs/fit_hrch_optm_ppc.RData')

####################################################################
# overall mean
mean(dataList$choice[1:2,] == 1 )

# trial-by-trial sequence
#plot(1:100, colMeans(dataList$choice == 1),type='b')
y_mean = colMeans(dataList$choice == 1)

y_pred = extract(f, pars='y_pred')$y_pred
dim(y_pred)  # [4000,10,100]

y_pred_mean_mcmc = apply(y_pred==1, c(1,3), mean)
dim(y_pred_mean_mcmc)  # [4000, 100]
y_pred_mean = colMeans(y_pred_mean_mcmc)
y_pred_mean_HDI = apply(y_pred_mean_mcmc, 2, HDIofMCMC)

#plot(1:100, colMeans(y_pred_mean),type='b')

# =============================================================================
#### make plots #### 
# =============================================================================
myconfig <- theme_bw(base_size = 20) +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank() )

df = data.frame(Trial = 1:100,
                Data  = y_mean,
                Model = y_pred_mean,
                HDI_l = y_pred_mean_HDI[1,],
                HDI_h = y_pred_mean_HDI[2,])

## time course of the choice
g1 = ggplot(df, aes(Trial,Data))
g1 = g1 + geom_line(size = 1.5, aes(color= 'Data')) + geom_point(size = 2, shape = 21, fill='skyblue3',color= 'skyblue3')
#g1 = g1 + geom_ribbon(aes(ymin=HDI_l, ymax=HDI_h), linetype=2, alpha=0.3, fill = 'skyblue3')
g1 = g1 + geom_ribbon(aes(ymin=HDI_l, ymax=HDI_h, fill='Model'), linetype=2, alpha=0.3)
g1 = g1 + myconfig + scale_fill_manual(name = '',  values=c("Model" = "skyblue3")) +
                     scale_color_manual(name = '',  values=c("Data" = "skyblue"))  +
                     labs(y = 'Choosing correct (%)')
g1 = g1 + theme(axis.text   = element_text(size=22),
                axis.title  = element_text(size=25),
                legend.text = element_text(size=25))
g1
ggsave(plot = g1, "_plots/choice_seq_ppc.png", width = 8, height = 4, type = "cairo-png", units = "in")


## overall choice: true data (vertical line) + model prediction (hist)
tt_y = mean(df$Data)
df2 = data.frame(Model = rowMeans(y_pred_mean_mcmc)) # overall mean, 4000 mcmc samples
g2 = ggplot(data=df2, aes(Model)) + geom_histogram(binwidth =.005, alpha=.5, fill = 'skyblue3')
g2 = g2 + geom_vline(xintercept=tt_y, color = 'skyblue3',size=1.5)
g2 = g2 + labs(x = 'Choosing correct (%)', y = 'Frequency')
g2 = g2 + myconfig# + scale_x_continuous(breaks=c(tt_y), labels=c("Event1")) 
g2 = g2 + theme(axis.text   = element_text(size=22),
                axis.title  = element_text(size=25),
                legend.text = element_text(size=25))
g2
ggsave(plot = g2, "_plots/choice_mean_ppc.png", width = 6, height = 4, type = "cairo-png", units = "in")


