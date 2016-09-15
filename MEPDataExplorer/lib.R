boxPlot <- function(dt, x, y, color) {
  
  xFeat <- curatedFeatures %>% filter(FeatureName == x)
  yFeat <- curatedFeatures %>% filter(FeatureName == y)
  colorFeat <- curatedFeatures %>% filter(FeatureName == color)
  
  dt[x] <- reorder(dt[[x]],
                   dt[[y]],
                   FUN=median)
  
  p <- ggplot(dt, aes_string(x=x, y=y))
  p <- p + geom_boxplot(outlier.colour = NA, alpha=.5)
  
  if (length(unique(dt[, color])) < 8) {
    p <- p + geom_jitter(aes_string(color=color), size=rel(0.2),alpha=.5)
    p <- p + scale_color_brewer(palette="Set1")
  }
  else {
    p <- p + geom_jitter(size=rel(0.2),alpha=.5)
  }
  
  p <- p + xlab(xFeat$DisplayName) + ylab(yFeat$DisplayName)
  
  p <- p + theme_bw()
  p <- p + theme(axis.text.x = element_text(angle = 270, vjust = 0.5, hjust=0, 
                                            size=rel(1)), #, colour=textColourVec), 
                 axis.text.y = element_text(angle = 0, vjust = 0.5, hjust=1, 
                                            size=rel(2.25)), 
                 plot.title = element_text(size = rel(1.5)),
                 legend.position="top",
                 legend.text=element_text(size = rel(1.5)),
                 legend.title=element_text(size = rel(1.5)))
  
  p
}

scatterPlot <- function(dt, x, y, color) {
  
  xFeat <- curatedFeatures %>% filter(FeatureName == x)
  yFeat <- curatedFeatures %>% filter(FeatureName == y)
  colorFeat <- curatedFeatures %>% filter(FeatureName == color)
  
  #textAes <- paste("ECMp:",dt$ECMp)
  
  if (length(unique(dt[, color])) < 8) {
    p <- ggplot(dt, aes_string(x=x, y=y, colour=color)) #, text=textAes))
    p <- p + scale_color_brewer(palette="Set1")
  }
  else {
    p <- ggplot(dt, aes_string(x=x, y=y)) #, text=textAes))
  }
  p <- p + geom_point(alpha=.4)
  p <- p + guides(colour=FALSE, size=FALSE)
  p <- p + xlab(xFeat$DisplayName) + ylab(yFeat$DisplayName)
  p <- p + theme(axis.text.x = element_text(angle = 0, vjust = 0.5, hjust=1, size=rel(1)), 
                 axis.text.y = element_text(angle = 0, vjust = 0.5, hjust=1, size=rel(1)), 
                 plot.title = element_text(size = rel(1)),
                 legend.text=element_text(size = rel(1)),
                 legend.position="top",
                 legend.title=element_text(size = rel(1)))
  ggplotly(p)
  
}