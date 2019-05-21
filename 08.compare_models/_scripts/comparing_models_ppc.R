####################################################################
# load data
load('_data/rlnc_data.RData')
sz <- dim(rlnc)
nSubjects <- sz[1]
nTrials   <- sz[2]

dataList <- list(nSubjects=nSubjects,
                 nTrials=nTrials, 
                 choice=rlnc[,,1], 
                 reward=rlnc[,,2])

# load model object
f_rl = readRDS('_outputs/fit_RL_ppc.RData')
f_rlfic = readRDS('_outputs/fit_RLfict_ppc.RData')

####################################################################
source('_scripts/HDIofMCMC.R')

# overall mean
mean(dataList$choice[1:2,] == 1 )

# trial-by-trial sequence
#plot(1:100, colMeans(dataList$choice == 1),type='b')
y_mean = colMeans(dataList$choice == 1)

y_pred_rl = extract(f_rl, pars='y_pred')$y_pred
y_pred_rlfic = extract(f_rlfic, pars='y_pred')$y_pred

y_pred_rl_mean_mcmc = apply(y_pred_rl==1, c(1,3), mean)
y_pred_rl_mean = colMeans(y_pred_rl_mean_mcmc)
y_pred_rl_mean_HDI = apply(y_pred_rl_mean_mcmc, 2, HDIofMCMC)

y_pred_rlfic_mean_mcmc = apply(y_pred_rlfic==1, c(1,3), mean)
y_pred_rlfic_mean = colMeans(y_pred_rlfic_mean_mcmc)
y_pred_rlfic_mean_HDI = apply(y_pred_rlfic_mean_mcmc, 2, HDIofMCMC)

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
                RL = y_pred_rl_mean,
                RL_HDI_l = y_pred_rl_mean_HDI[1,],
                RL_HDI_h = y_pred_rl_mean_HDI[2,],
                RLfic = y_pred_rlfic_mean,
                RLfic_HDI_l = y_pred_rlfic_mean_HDI[1,],
                RLfic_HDI_h = y_pred_rlfic_mean_HDI[2,])

## time course of the choice
g1 = ggplot(df, aes(Trial,Data))
g1 = g1 + geom_line(size = 1.5, aes(color= 'Data')) + geom_point(size = 2, shape = 21, fill='skyblue3',color= 'skyblue3')
g1 = g1 + geom_ribbon(aes(ymin=RL_HDI_l, ymax=RL_HDI_h, fill='RL'), linetype=2, alpha=0.3)
g1 = g1 + geom_ribbon(aes(ymin=RLfic_HDI_l, ymax=RLfic_HDI_h, fill='RLfic'), linetype=2, alpha=0.3)
g1 = g1 + myconfig + scale_fill_manual(name = '',  values=c("RL" = "skyblue3", "RLfic" = "indianred3")) +
                     scale_color_manual(name = '',  values=c("Data" = "skyblue"))  +
                     labs(y = 'Choosing correct (%)')
g1 = g1 + theme(axis.text   = element_text(size=22),
                axis.title  = element_text(size=25),
                legend.text = element_text(size=25))
g1
ggsave(plot = g1, "_plots/compare_choice_seq_ppc.png", width = 8, height = 4, type = "cairo-png", units = "in")


## overall choice: true data (vertical line) + model prediction (hist)
tt_y = mean(df$Data)
df2 = data.frame(xx = c(rowMeans(y_pred_rl_mean_mcmc),rowMeans(y_pred_rlfic_mean_mcmc)) ,
                 model = rep(c('RL','RLfic'),each=4000) ) # overall mean, 4000 mcmc samples

g2 = ggplot(data=df2, aes(xx)) + 
        geom_histogram(data=subset(df2, model == 'RL'),fill = "skyblue3", alpha = 0.5, binwidth =.005) +
        geom_histogram(data=subset(df2, model == 'RLfic'),fill = "indianred3", alpha = 0.5, binwidth =.005)
g2 = g2 + geom_vline(xintercept=tt_y, color = 'skyblue2',size=1.5)
g2 = g2 + labs(x = 'Choosing correct (%)', y = 'Frequency')
g2 = g2 + myconfig# + scale_x_continuous(breaks=c(tt_y), labels=c("Event1")) 
g2 = g2 + theme(axis.text   = element_text(size=22),
                axis.title  = element_text(size=25),
                legend.text = element_text(size=25))
g2
ggsave(plot = g2, "_plots/compare_choice_mean_ppc.png", width = 6, height = 4, type = "cairo-png", units = "in")


