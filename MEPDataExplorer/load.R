# Requires synapseClient to be loaded, from server.R


releaseManifestId <- 'syn9612057'
curatedFeatureId <- 'syn7826686'
curatedFeatureVersion <- '8'

annotTableId <- 'syn5662377'
q <- sprintf("select id,Study,CellLine,Level from %s WHERE Level='4'",
             releaseManifestId)
dataFiles <- synTableQuery(q)@values

annotTable <- synTableQuery(sprintf("SELECT Category,MetadataTerm FROM %s", annotTableId))
ligandTable <- annotTable@values %>% filter(Category == "Ligand")
ligands <- ligandTable$MetadataTerm

ecmpTable <- annotTable@values %>% filter(Category == "ECMp")
ecmps <- ecmpTable$MetadataTerm

curatedFeatures <- synGet(curatedFeatureId, version = curatedFeatureVersion) %>% 
  getFileLocation() %>% 
  fread(data.table=FALSE)%>% 
  rename(FeatureName=Binding_CP, DisplayName=Name)


curatedFeaturesBoxX <- curatedFeatures %>% 
  filter(FeatureName %in% c("Ligand", "ECMp"))

curatedFeaturesListBoxX <- curatedFeaturesBoxX$FeatureName
names(curatedFeaturesListBoxX) <- curatedFeaturesBoxX$DisplayName

curatedFeaturesSelect <- curatedFeatures %>% 
  filter(!(FeatureName %in% c("MEP", "Ligand", "ECMp")))
         
curatedFeaturesList <- curatedFeaturesSelect$FeatureName
names(curatedFeaturesList) <- curatedFeaturesSelect$DisplayName
