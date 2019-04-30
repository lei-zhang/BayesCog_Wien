library(ggplot2)
library(reshape2)

myconfig <- theme_bw(base_size = 20) +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank() )

x <- seq(0,20,by = 0.1 )
y1 = dnorm(x, 0, 5)
y2 = dcauchy(x, 0, 5)

df  <- data.frame(x=x, y1=y1, y2=y2)
dfl <- melt(df, id = 'x') # datafreame long
df1 <- data.frame(x=x, y1=y1)
df2 <- data.frame(x=x, y2=y2)

g <- ggplot(data=dfl, aes(x=x, y=value, colour=variable))
g <- g + geom_line(size = 3) + myconfig + labs(x="",y="")
g <- g + scale_color_manual(values=c("#004a93", "#c49e3b"),
                            breaks=c("y1","y2"),
                            labels=c(expression(paste(italic("Normal"),"(0,5)")),expression(paste(italic("Cauchy"),"(0,5)"))))
g <- g + theme(legend.position=c(.8,.85), # bottom-left is 0,0; top-right is 1,1
               legend.title=element_blank(),
               legend.key=element_blank()) # remove box
g <- g + geom_vline(xintercept = 5, size = 1.5, colour="red", linetype = 2)
g

ggsave(plot = g, "_plots/halfCauchy.png", width = 6, height = 4, type = "cairo-png", units = "in")
