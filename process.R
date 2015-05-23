# read the downloaded data file
# (downloaded from http://archive.ics.uci.edu/ml/machine-learning-databases/00211/)
dat <- read.csv("CommViolPredUnnormalizedData.txt", header = FALSE)

# set names of all predictors in the dataframe
nonPredVars <- c("communityName", "state", "countyCode", "communityCode", "fold")
predVars <- c("population", "householdSize", "racePctBlack", "racePctWhite", 
              "racePctAsian", "racePctHisp", "agePct12t21", "agePct12t29", 
              "agePct16t24", "agePct65up", "numUrban", "pctUrban", "medIncome", 
              "pctWageSal", "pctFarmSelf", "pctInvRent", "pctSocSec", 
              "pctPubAsst", "pctRetire", "medFamInc", "perCapInc", "whitePerCap", 
              "blackPerCap", "indianPerCap", "asianPerCap", "otherPerCap", 
              "hispPerCap", "numUnderPov", "pctPopUnderPov", "pctLess9thGrade", 
              "pctNotHSGrad", "pctBSorMore", "pctUnemployed", "pctEmploy", 
              "pctEmplManu", "pctEmplProfServ", "pctOccupManu", 
              "pctOccupMgmtProf", "pctMaleDivorce", "pctMaleNevMarr", 
              "pctFemaleDivorce", "pctTotalDivorce", "numPerFam", "pctFam2Par", 
              "pctKids2Par", "pctYoungKids2Par", "pctTeen2Par", 
              "pctWorkMomYoungKids", "pctWorkMom", "numKidsBornNeverMar", 
              "pctKidsBornNeverMar", "numImmig", "pctImmigRecent", 
              "pctImmigRec5", "pctImmigRec8", "pctImmigRec10", "pctRecentImmig", 
              "pctRecImmig5", "pctRecImmig8", "pctRecImmig10", 
              "pctSpeakEnglOnly", "pctNotSpeakEnglWell", "pctLargeHouseFam", 
              "pctLargeHouseOccup", "avgPerOccupHouse", "avgPerOwnOccHouse", 
              "avgPerRentOccHouse", "pctPersOwnOccup", "pctPersDenseHouse", 
              "pctHouseLess3BR", "medNumBR", "numHouseVacant", "pctHouseOccup", 
              "pctHouseOwnOcc", "pctVacantBoarded", "pctVacMore6Mos", 
              "medYrHousBuilt", "pctHousNoPhone", "pctWOFullPlumb", 
              "ownOccLowQ", "ownOccMed", "ownOccHiQ", "ownOccIQR", "rentLowQ", 
              "rentMedian", "rentHighQ", "rentIQR", "medRent", 
              "medRentPctHousInc", "medOwnCostPctInc", "medOwnCostPctIncNoMtg", 
              "numInShelters", "numStreet", "pctForeignBorn", "pctBornSameState", 
              "pctSameHouse85", "pctSameCity85", "pctSameState85", 
              "numSwornFT", "numSwFTPerPop", "numSwFTFieldOps", 
              "numSwFTFieldPerPop", "numTotalReq", "numTotReqPerPop", 
              "numPolicReqPerOffic", "numPolicPerPop", "racialMatchCommPol", 
              "pctPolicWhite", "pctPolicBlack", "pctPolicHisp", "pctPolicAsian", 
              "pctPolicMinor", "numOfficAssgnDrugUnits", "numKindsDrugsSeiz", 
              "policAveOTWorked", "landArea", "popDensity", "pctUsePubTrans", 
              "numPolicCars", "policOperBudg", "pctPolicOnPatr", 
              "gangUnitDeploy", "pctOfficDrugUnits", "policBudgPerPop")
goalVars <- c("numMurders", "numMurdPerPop", "numRapes", "numRapesPerPop", 
              "numRobberies", "numRobbPerPop", "numAssaults", "numAssaultPerPop", 
              "numBurglaries", "numBurglPerPop", "numLarcenies", "numLarcPerPop", 
              "numAutoTheft", "numAutoTheftPerPop", "numArsons", 
              "numArsonsPerPop", "numViolentCrimesPerPop", "numNonViolPerPop")
colnames(dat) <- c(nonPredVars, predVars, goalVars)

# delete non-predictive attributes and attributes with lots of missing data
deleteVars <- c(1:5, 104:120, 124:127, 129)
subdat <- dat[, -deleteVars]

# eliminate cases where data was missing
rowsToExclude <- c()
for(i in 1:2215){
    found <- FALSE
    for(j in 1:120){
        if (subdat[i, j] == "?"){
            found <- TRUE
        }
    }
    if (found) rowsToExclude <- c(rowsToExclude, i)
}
cleandat <- subdat[-rowsToExclude, ]

# some numeric (integer) variables were converted to factors
# convert them back to numeric for analysis
for(j in 1:120){
    if (class(cleandat[, j]) == "factor"){
        cleandat[, j] <- as.numeric(cleandat[, j])
    }
}

# save the dataframe to RData for later reuse
save(cleandat, file = "cleandata.RData")