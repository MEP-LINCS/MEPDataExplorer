library('plotly')

boxPlot_yVars <- c("Spot_PA_SpotCellCountLog2",
                   "Spot_PA_SpotCellCountLog2RUV3Loess",
                   "Nuclei_PA_Cycle_DNA2NProportionLogitRUV3Loess"
                   # "Cytoplasm_CP_Intensity_MedianIntensity_MitoTrackerLog2RUV3Loess",
                   #"Nuclei_CP_Intensity_MedianIntensity_EdULog2RUV3Loess",
                   # "Cytoplasm_CP_Intensity_MedianIntensity_KRT19Log2RUV3Loess",
                   # "Cytoplasm_CP_Intensity_MedianIntensity_KRT5Log2RUV3Loess",
                   # "Nuclei_PA_Gated_EdUPositiveProportionLogitRUV3LoessBacktransformed",
                   # "Nuclei_PA_Cycle_DNA2NProportionLogitRUV3LoessBacktransformed"
                   )

scatterPlot_xyVars <- c("Nuclei_PA_Cycle_DNA2NProportionLogitRUV3Loess",
                        "Spot_PA_SpotCellCountLog2RUV3Loess"
                        #"Spot_PA_SpotCellCountLog2",
                        # "Cytoplasm_CP_Intensity_MedianIntensity_MitoTrackerLog2RUV3Loess",
                        # "Nuclei_CP_Intensity_MedianIntensity_EdULog2RUV3Loess",
                        # "Cytoplasm_CP_Intensity_MedianIntensity_KRT19Log2RUV3Loess",
                        # "Cytoplasm_CP_Intensity_MedianIntensity_KRT5Log2RUV3Loess",
                        # "Nuclei_PA_Gated_EdUPositiveProportionLogitRUV3LoessBacktransformed",
                        # "Nuclei_PA_Cycle_DNA2NProportionLogitRUV3LoessBacktransformed"
                        )
