# Requires synapseClient to be loaded, from server.R
library(data.table)

df <- synGet("syn6187842")

dt <- fread(getFileLocation(df), data.table=FALSE)
