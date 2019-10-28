# Requires synapseClient to be loaded, from server.R

# df <- synGet("syn7122655")
# 
# d <- fread(getFileLocation(df), data.table=FALSE)

releaseManifestId <- 'syn9838977'
q <- sprintf("select id,CellLine,Level from %s WHERE Level='4' AND StainingSet='SSC'",
             releaseManifestId)
dataFiles <- as.data.frame(synTableQuery(q))

annotTable <- synTableQuery("SELECT Category,MetadataTerm FROM syn5662377")
annotTable <- as.data.frame(annotTable)
ligandTable <- annotTable %>% filter(Category == "Ligand")
ligands <- ligandTable$MetadataTerm

ecmpTable <- annotTable %>% filter(Category == "ECMp")
ecmps <- ecmpTable$MetadataTerm

curatedFeatures <- fread(synGet('syn7187256')$path)

curatedFeaturesBoxX <- curatedFeatures %>% 
  filter(FeatureName %in% c("Ligand", "ECMp"))

curatedFeaturesListBoxX <- curatedFeaturesBoxX$FeatureName
names(curatedFeaturesListBoxX) <- curatedFeaturesBoxX$DisplayName

curatedFeaturesSelect <- curatedFeatures %>% 
  filter(!(FeatureName %in% c("MEP", "Ligand", "ECMp")))
         
curatedFeaturesList <- curatedFeaturesSelect$FeatureName
names(curatedFeaturesList) <- curatedFeaturesSelect$DisplayName
