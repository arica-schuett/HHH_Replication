# HHH Data
setwd("/Users/aricaschuett/Dropbox/Arica_PrecinctData/HillHopkinsHuber_2021/ReplicatingCode/ReplicatingDataWithIDs")
load("GA-precincts-merged-census-wgt-08022019.Rdata")
head(dta.joint.35)
HHH_GA <- dta.joint.35
names(HHH_GA)

good <- names(HHH_GA)[!grepl("^CT", names(HHH_GA))]                
HHH_GA <- subset(HHH_GA, select = good)
good2 <- names(HHH_GA)[!grepl("^SE_", names(HHH_GA))]
HHH_GA <- subset(HHH_GA, select = good2)


HHH_GA$id <- paste(HHH_GA$GEOCODE.COUNTY, HHH_GA$PRECINCT.CODE, sep="--")
length(unique(HHH_GA$id))/nrow(HHH_GA) # precinct-level data, one row per precinct, that's good

summary(HHH_GA$PCT.SAME.PRCT.13t17)
summary(HHH_GA$PCT.SAME.PRCT.17t13)

HHH_GA <- subset(HHH_GA, PCT.SAME.PRCT.13t17 > 0.85 & !is.na(PCT.SAME.PRCT.13t17),
                 PCT.SAME.PRCT.17t13 > 0.85 & !is.na(PCT.SAME.PRCT.17t13))

HHH_GA <- subset(HHH_GA, FILTER.2013t17 == 0 & FILTER.2017t13 == 0)



library(haven)
other <- read_dta("../../HHHElecChangeRepArchive/PooledPrecinctAnalysisData.dta")
other <- subset(other, state == "GA")

# Create key
other$ID_Voters <- paste(other$P12_V12_DEM, other$P16_V16_DEM, other$PBOTH_VBOTH_DEM, other$GOP_Voters_2016_Prct, sep = "-" )
length(other$ID_Voters)


HHH_GA$ID_Voters <- paste(HHH_GA$P12.V12.DEM, HHH_GA$P16.V16.DEM, HHH_GA$PBOTH.VBOTH.DEM, HHH_GA$GOP.Voters.2016.Prct, sep = "-" )
length(HHH_GA$ID_Voters)


MetaDF <- merge( HHH_GA, other, by = "ID_Voters") #this just keeps the 


# MetaDFRed <- MetaDF[, c( "COUNTY.CODE" , "PRECINCT.CODE", "state", "Total_Voters_2012_Prct", "GOP_Voters_2016_Prct", "GOP_Voters_2012_Prct", 
#                          "Dem_Voters_2016_Prct", "Dem_Voters_2012_Prct", "P12_V12_DEM",  "P16_V16_DEM", "PBOTH_V16_GOP",
#                          "PBOTH_VBOTH_GOP", "P12_V12_OTH",  "P16_V16_OTH", "PBOTH_V12_OTH", "PBOTH_V16_OTH", "PBOTH_VBOTH_OTH",   "DEMTURNOUTPCT12",
#                          "DEMTURNOUTPCT16", "GOPTURNOUTPCT12", "GOPTURNOUTPCT16", "PBOTH_VNEI_DEM", "PBOTH_VNEI_GOP", "PBOTH_VNEI_OTH", 
#                          "PBOTH_VNEI", "PBOTH_V12",  "PBOTH_V16", "PBOTH_VBOTH" ,  "gop_vote_change", "PresBothNetDem16TO", "PresBothNetGOP16TO",
#                          "PresBothNetOTH16TO",  "TRACT.1.PCT" ,  "TRACT.1.ID",
#                          "TRACT.2.PCT", "TRACT.2.ID" , "TRACT.3.PCT", "TRACT.3.ID", "TRACT.4.PCT", "TRACT.4.ID", "TRACT.5.PCT",  "TRACT.5.ID","TRACT.6.PCT",
#                          "TRACT.6.ID",  "TRACT.7.PCT" , "TRACT.7.ID" , "TRACT.8.PCT",  "TRACT.8.ID", "TRACT.9.PCT", "TRACT.9.ID",  "TRACT.10.PCT",  "TRACT.10.ID"  )]

CountyCodes <- read.csv("/Users/aricaschuett/Dropbox/Arica_PrecinctData/HillHopkinsHuber_2021/ReplicatingCode/ReplicatingDataWithIDs/StateCountyCodes.csv")
names(CountyCodes) <- c("COUNTY.CODE", "COUNTY_NAME")

MetaDFwNames <- merge(MetaDF, CountyCodes, by ="COUNTY.CODE" )

HHH_wIDs <- write.csv(MetaDFwNames, "/Users/aricaschuett/Dropbox/Arica_PrecinctData/3YP Data & Code/DataForPaper/HHH_wIDs.csv")
