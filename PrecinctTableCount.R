## Table that shows where I have good county coverage

CountyCodes <- read.csv("/Users/aricaschuett/Dropbox/Arica_PrecinctData/HillHopkinsHuber_2021/ReplicatingCode/ReplicatingDataWithIDs/StateCountyCodes.csv")


#Cty.Reg20 <- read.csv("/Users/aricaschuett/Dropbox/Arica_PrecinctData/3YP Data & Code/DataForPaper/CountyDataForRegs16.20.csv")
Reg20DF <- read.csv("/Users/aricaschuett/Dropbox/Arica_PrecinctData/3YP Data & Code/DataForPaper/PrecinctDataForRegs16.20.csv")
PrecinctCount20 <- table(Reg20DF$CTYNAME_2016)
PrecinctCount20 <- as.data.frame(PrecinctCount20)
colnames(PrecinctCount20) <- c("COUNTY_NAME", "Precincts16")

PrecintCountTable <- merge(CountyCodes, PrecinctCount20,  by = "COUNTY_NAME", all.x = T)

#Cty.Reg22 <- read.csv("/Users/aricaschuett/Dropbox/Arica_PrecinctData/3YP Data & Code/DataForPaper/CountyDataForRegs18.22.csv")
Reg22DF <- read.csv("/Users/aricaschuett/Dropbox/Arica_PrecinctData/3YP Data & Code/DataForPaper/PrecinctDataForRegs18.22.csv")
PrecintCount22 <- table(Reg22DF$CTYNAME_2018)
PrecintCount22 <- as.data.frame(PrecintCount22)
colnames(PrecintCount22)  <- c("COUNTY_NAME", "Precincts18")

PrecintCountTable <- merge(PrecintCountTable, PrecintCount22,  by = "COUNTY_NAME", all.x = T)


HHH_wIDs <- read.csv( "/Users/aricaschuett/Dropbox/Arica_PrecinctData/3YP Data & Code/DataForPaper/HHH_wIDs.csv")
PrecintCountHHH <- table(HHH_wIDs$COUNTY_NAME)
PrecintCountHHH <- as.data.frame(PrecintCountHHH)
colnames(PrecintCountHHH) <- c("COUNTY_NAME", "Precincts12_HHH")


HHH_wIDs <- merge(CountyCodes, HHH_wIDs, by.x = "COUNTY_CODE", by.y = "COUNTY.CODE" )
HHH_wIDs$UniqueID_20 <- paste(HHH_wIDs$COUNTY_NAME.y, HHH_wIDs$PRECINCT.CODE, sep = "-")
PrecinctCheck <- merge(HHH_wIDs, Reg20DF, by = "UniqueID_20", all.x = T, all.y = T)


PrecintCountTable <- merge(PrecintCountTable, PrecintCountHHH,  by = "COUNTY_NAME", all.x = T)

#PrecintCountTable <- PrecintCountTable[, c("COUNTY_NAME", "Precincts16", "Precincts18", "Precincts12_HHH")]

PrecintCountTable$IHaveMore <- ifelse(PrecintCountTable$Precincts16 & PrecintCountTable$Precincts18 >= PrecintCountTable$Precincts12_HHH, 1, 0)

PrecintCountTable$Metro <- ifelse(PrecintCountTable$COUNTY_NAME == "CHEROKEE" | PrecintCountTable$COUNTY_NAME == "FORSYTH" | 
                                    PrecintCountTable$COUNTY_NAME == "COBB" | PrecintCountTable$COUNTY_NAME == "GWINNETT" | 
                                    PrecintCountTable$COUNTY_NAME == "DOUGLAS" | PrecintCountTable$COUNTY_NAME == "FULTON" | 
                                    PrecintCountTable$COUNTY_NAME == "DEKALB" | PrecintCountTable$COUNTY_NAME == "CLAYTON" | 
                                    PrecintCountTable$COUNTY_NAME == "FAYETTE" | PrecintCountTable$COUNTY_NAME == "HENRY" | 
                                    PrecintCountTable$COUNTY_NAME == "ROCKDALE", 1, 0 )

#write.csv(PrecintCountTable, "/Users/aricaschuett/Dropbox/Arica_PrecinctData/HillHopkinsHuber_2021/ReplicatingCode/ReplicatingDataWithIDs/PrecintCountTable.csv")

data2 <- read.csv("/Users/aricaschuett/Dropbox/Arica_PrecinctData/Analysis Data/Registrant_Level_Precs16-22.csv") 
data2$P_ID <- paste(data2$COUNTY_CODE_16, data2$COUNTY_PRECINCT_ID_16, sep="-")
length(unique(data2$P_ID)) #2834 , their origional precincts before cleaning has 2814. I think my 2834 includes the error codes--the 999 or 000 ones. 

FullPrecincts <- merge(data2, CountyCodes, by.x = "COUNTY_CODE_16", by.y = "COUNTY_CODE", all.x = T, all.y = T)
FP_Table <- table(FullPrecincts$COUNTY_NAME)
FP_Table <- as.data.frame(FP_Table)
colnames(FP_Table) <- c("COUNTY_NAME", "REG_VOTERS")
FP_Precinct_Voters <- FullPrecincts %>%
  group_by(COUNTY_NAME) %>%
  count(P_ID)
CountiesPrecinctIndex16 <- FP_Precinct_Voters[, c("COUNTY_NAME", "P_ID")]
CP_Tally16 <- table(CountiesPrecinctIndex16$COUNTY_NAME)
CP_Tally16 <- as.data.frame(CP_Tally16)
names(CP_Tally16) <- c("COUNTY_NAME", "TOTAL_P16")

PrecintCountTable <- merge(PrecintCountTable, CP_Tally16, by = "COUNTY_NAME")
PrecintCountTable$My_Pct <- PrecintCountTable$Precincts16 / PrecintCountTable$TOTAL_P16
PrecintCountTable$HHH_Pct <- PrecintCountTable$Precincts12_HHH / PrecintCountTable$TOTAL_P16

HHH_wIDs$P_ID <- paste(HHH_wIDs$COUNTY.CODE , HHH_wIDs$PRECINCT.CODE, sep = "-")
length(unique(HHH_wIDs$P_ID)) #1494

# 

       