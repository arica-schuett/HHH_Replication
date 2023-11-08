# HHH Data

load("/Users/aricaschuett/Documents/3YP/dataverse_files(5)/GA-precincts-merged-census-wgt-08022019.Rdata")
head(dta.joint.35)
HHH_GA <- dta.joint.35


# distribution of Voters
(summary(HHH_GA$reg.total))

(summary(MissingRegTotal$PBOTH.V12.DEM))
(summary(HHH_GA$PBOTH.V12.DEM))

# Missing Voters: NA reg.total
HHH_GA <- mutate(HHH_GA, 
                 MissingRegTotal = ifelse(is.na(reg.total), 1, 0))

MissingRegTotal <- filter(HHH_GA, MissingRegTotal == 1)
HHH_GA_full <- filter(HHH_GA, MissingRegTotal == 0)


# Comparing the two
(summary(HHH_GA_full$PBOTH.V12.DEM))
(summary(MissingRegTotal$PBOTH.V12.DEM))
(summary(HHH_GA_full$PBOTH.V12.GOP))(summary(MissingRegTotal$P12.V12.GOP)) #these look similar-ish



(table(HHH_GA$FILTER.2012.DELTA))
(table(HHH_GA$FILTER.2013t17))
(table(HHH_GA$FILTER.2016.DELTA))
(table(HHH_GA$FILTER.2017t13))
(table(HHH_GA$FILTER.ANY))
(table(HHH_GA$FILTER.PRCT.DELTA))
(table(HHH_GA$FILTER.VF.DELTA))

(table(HHH_GA_full$FILTER.2012.DELTA))
(table(HHH_GA_full$FILTER.2013t17)) #maybe?
(table(HHH_GA_full$FILTER.2016.DELTA))
(table(HHH_GA_full$FILTER.2017t13)) #maybe?
(table(HHH_GA_full$FILTER.ANY)) #maybe
(table(HHH_GA_full$FILTER.PRCT.DELTA)) #mabye
(table(HHH_GA_full$FILTER.VF.DELTA)) #maybe?






# Constructing a total voters variable 
HHH_Filter <- subset(HHH_GA_full, PCT.SAME.PRCT.13t17 >= .80 & PCT.SAME.PRCT.17t13 >= .80)

(table(HHH_Filter$FILTER.2012.DELTA))
(table(HHH_Filter$FILTER.2013t17)) #maybe?
(table(HHH_Filter$FILTER.2016.DELTA))
(table(HHH_Filter$FILTER.2017t13)) #maybe?
(table(HHH_Filter$FILTER.ANY)) #maybe
(table(HHH_Filter$FILTER.PRCT.DELTA)) #mabye
(table(HHH_Filter$FILTER.VF.DELTA)) #maybe?


UnIDd <- read.csv("/Users/aricaschuett/Dropbox/Arica_PrecinctData/HillHopkinsHuber_2021/ReplicatingCode/HHH_GA.csv")
