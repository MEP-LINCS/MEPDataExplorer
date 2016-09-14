# Requires synapseClient to be loaded, from server.R

# df <- synGet("syn7122655")
# 
# dt <- fread(getFileLocation(df), data.table=FALSE)

q <- sprintf('select id,versionLabel,CellLine,Level from file where parentId=="syn5713302" AND Level==4 AND StainingSet=="SSC"')
dataFiles <- synQuery(q)


curatedFeatures <- fread(getFileLocation(synGet('syn7187256')))

curatedFeaturesBoxX <- curatedFeatures %>% 
  filter(FeatureName %in% c("Ligand", "ECMp"))

curatedFeaturesListBoxX <- curatedFeaturesBoxX$FeatureName
names(curatedFeaturesListBoxX) <- curatedFeaturesBoxX$DisplayName

curatedFeaturesSelect <- curatedFeatures %>% 
  filter(!(FeatureName %in% c("MEP", "Ligand", "ECMp")))
         
curatedFeaturesList <- curatedFeaturesSelect$FeatureName
names(curatedFeaturesList) <- curatedFeaturesSelect$DisplayName
