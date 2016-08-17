# Requires synapseClient to be loaded, from server.R

# df <- synGet("syn6187842")
# 
# dt <- fread(getFileLocation(df), data.table=FALSE)

q <- sprintf('select id,CellLine,Level,StainingSet from file where parentId=="syn5713302" AND Level==4')
dataFiles <- synQuery(q)
