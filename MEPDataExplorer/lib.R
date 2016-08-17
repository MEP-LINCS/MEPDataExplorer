boxPlot <- function(dt, y='Spot_PA_SpotCellCountLog2') {
  
  dt$Ligand <- reorder(dt$Ligand,
                       dt[[y]],
                       FUN=median)
  
  p <- ggplot(dt, aes_string(x='Ligand', y=y))
  p <- p + geom_boxplot(outlier.colour = NA, alpha=.5)
  p <- p + geom_jitter(aes(color=StainingSet), size=rel(0.2),alpha=.5)
  
  p <- p + xlab("Ligand")#  + ylab("Normalized EdU+")
  
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

scatterPlot <- function(dt, x, y) {
  textAes <- paste("ECMp:",dt$ECMp)
  p <- ggplot(dt, aes_string(x=x, y=y, colour='Ligand')) #, text=textAes))
  p <- p + geom_point(alpha=.4)
  p <- p + guides(colour=FALSE, size=FALSE)
  p <- p + theme(axis.text.x = element_text(angle = 0, vjust = 0.5, hjust=1, size=rel(1)), 
                 axis.text.y = element_text(angle = 0, vjust = 0.5, hjust=1, size=rel(1)), 
                 plot.title = element_text(size = rel(1)),
                 legend.text=element_text(size = rel(1)),
                 legend.title=element_text(size = rel(1)))
  ggplotly(p)
  
}