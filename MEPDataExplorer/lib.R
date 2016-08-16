firstPlot <- function(dt) {
  p <- ggplot(dt, aes(x=reorder(Ligand, 
                                #Nuclei_CP_AreaShape_AreaLog2RUV3, 
                                Nuclei_PA_Gated_EdUPositiveProportionLogitRUV3LoessBacktransformed,
                                FUN=median), 
                      #y=Nuclei_CP_AreaShape_AreaLog2RUV3,
                      y=Nuclei_PA_Gated_EdUPositiveProportionLogitRUV3LoessBacktransformed,
                      fill=Ligand))
  p <- p + geom_boxplot(outlier.colour = NA, alpha=.5)
  p <- p + geom_jitter(aes(colour=ECMp),size=rel(.1),alpha=.5)
  
  p <- p + guides(fill=FALSE, colour=FALSE) + xlab("Ligand") + ylab("Normalized EdU+")
  p <- p + ggtitle("MEP EdU+ Response by Ligand")
  p <- p + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1, 
                                            size=rel(.7)), #, colour=textColourVec), 
                 axis.text.y = element_text(angle = 0, vjust = 0.5, hjust=1, 
                                            size=rel(1)), 
                 plot.title = element_text(size = rel(1)),
                 legend.text=element_text(size = rel(1)),
                 legend.title=element_text(size = rel(1)))
  
  p
}

secondPlot <- function(dt) {
  p <- ggplot(dt, aes(x=Nuclei_PA_Gated_EdUPositiveProportionLogitRUV3LoessBacktransformed, 
                      y=Cytoplasm_CP_Intensity_MedianIntensity_KRT5Log2RUV3Loess,
                      colour=Ligand, text=paste("ECMp:",ECMp)))
  p <- p + geom_point(alpha=.4)
  p <- p + guides(colour=FALSE, size=FALSE) + xlab("Normalized EdU+\n(Logit)") + ylab("Normalized KRT5\n(Log2)")
  p <- p + ggtitle("MEP KRT5 vs Proliferation")
  p <- p + theme(axis.text.x = element_text(angle = 0, vjust = 0.5, hjust=1, size=rel(1)), 
                 axis.text.y = element_text(angle = 0, vjust = 0.5, hjust=1, size=rel(1)), 
                 plot.title = element_text(size = rel(1)),
                 legend.text=element_text(size = rel(1)),
                 legend.title=element_text(size = rel(1)))
  ggplotly(p)
  
}