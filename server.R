# Load the shiny library
library(shiny)

# source("process.R") command will take more time to process; 
# hence use load command to load RData saved by running process.R
# "cleandata.RData" is also uploaded to shiny apps website 
# to speed up processing instead of uploading process.R
load("cleandata.RData")

# create empty dataframe
cordf <- data.frame()
# calculate and store r and r-squared values for each predictor in dataframe
for(j in 1:102){
    r <- cor(cleandat[, j], cleandat[, 103])
    cordf <- rbind(cordf, data.frame(var = colnames(cleandat)[j], r = r, rsq = r^2))
}

# keep only one goal variable for murders (column 103) and remove others
mcleandat <- cleandat[, -c(104:120)]

# fit 3 linear models
all.fit <- lm(numMurders ~ ., data = mcleandat)
top8.fit <- lm(numMurders ~ numKidsBornNeverMar + numUnderPov + population 
             + numUrban + numImmig + numInShelters + numHouseVacant 
             + numStreet, data = mcleandat)
approx.fit <- lm(numMurders ~ numKidsBornNeverMar + numImmig + numInShelters 
              + numHouseVacant + numStreet, data = mcleandat)

# function to output a list containing prediction, model and message
# for the given input
murders <- function(selModel, values = NULL){
    if(selModel == "all"){
        sum <- all.fit$coefficients[1]
        for(j in 1:102){
            coeff <- all.fit$coefficients[j+1]
            if(is.na(coeff)) coeff <- 0
            sum <- sum + coeff * mean(mcleandat[,j])
        }
        model <- all.fit
        msg <- "NOTE: Mean of each predictor was used for calculation instead of entered values"
    }
    else if(selModel == "top8"){
        sum <- top8.fit$coefficients[1]
        for(j in 1:8){
            sum <- sum + top8.fit$coefficients[j+1] * values[j]
        }
        model <- top8.fit
        msg <- ""
    }
    else{
        sum <- approx.fit$coefficients[1]
        for(j in 1:5){
            sum <- sum + approx.fit$coefficients[j+1] * values[j]
        }
        model <- approx.fit
        msg <- ""
    }
    # murders cannot be negative
    if(sum < 0) sum <- 0
    # return a list with the necessary details
    list(prediction = ceiling(sum), model = model, message = msg)
}

shinyServer(
    function(input, output) {
        # get inputs and call murders function
        predMurders <- reactive({murders(input$modelSelected, 
                        c(input$numKidsBornNeverMar, input$numUnderPov, 
                        input$population, input$numUrban, input$numImmig, 
                        input$numInShelters, input$numHouseVacant, 
                        input$numStreet))})
        # save prediction with any message to output
        output$prediction <- renderPrint({cat(paste(predMurders()[[1]], 
                                                predMurders()[[3]], sep="\n"))})
        # save dataframe with r and r-squared values to output
        output$rsq <- renderPrint({
            library(plyr)
            arrange(cordf, desc(rsq), desc(r))
        })
        # save data table to output
        output$table <- renderDataTable({
            if(input$modelSelected == "all"){
                outdat <- mcleandat
            }
            else if(input$modelSelected == "top8"){
                top8 <- c("population", "numUrban", "numUnderPov", "numImmig", 
                          "numKidsBornNeverMar", "numHouseVacant", 
                          "numInShelters", "numStreet")
                outdat <- mcleandat[, c(top8, "numMurders")]
            }
            else{
                top5 <- c("numImmig", "numKidsBornNeverMar", "numHouseVacant", 
                          "numInShelters", "numStreet")
                outdat <- mcleandat[, c(top5, "numMurders")]
            }
            outdat
        })
        # save exploratory plots to output
        output$plots <- renderPlot({
            library(ggplot2)
            # (1, 1)
            gp11 <- ggplot(mcleandat, aes(x = numKidsBornNeverMar, y = numMurders))
            gp11 <- gp11 + geom_point() + geom_smooth(method = "lm", formula = y ~ x)
            # (1, 2)
            gp12 <- ggplot(mcleandat, aes(x = numKidsBornNeverMar, y = numMurders))
            gp12 <- gp12 + geom_point() + geom_smooth(method = "lm", formula = y ~ x)
            gp12 <- gp12 + xlim(0,150000)
            # (2, 1)
            gp21 <- ggplot(mcleandat, aes(x = numImmig, y = numMurders))
            gp21 <- gp21 + geom_point() + geom_smooth(method = "lm", formula = y ~ x)
            # (2, 2)
            gp22 <- ggplot(mcleandat, aes(x = numImmig, y = numMurders))
            gp22 <- gp22 + geom_point() + geom_smooth(method = "lm", formula = y ~ x)
            gp22 <- gp22 + xlim(0,250000)
            # (3, 1)
            gp31 <- ggplot(mcleandat, aes(x = numInShelters, y = numMurders))
            gp31 <- gp31 + geom_point() + geom_smooth(method = "lm", formula = y ~ x)
            # (3, 2)
            gp32 <- ggplot(mcleandat, aes(x = numInShelters, y = numMurders))
            gp32 <- gp32 + geom_point() + geom_smooth(method = "lm", formula = y ~ x)
            gp32 <- gp32 + xlim(0,4750)
            # (4, 1)
            gp41 <- ggplot(mcleandat, aes(x = numHouseVacant, y = numMurders))
            gp41 <- gp41 + geom_point() + geom_smooth(method = "lm", formula = y ~ x)
            # (4, 2)
            gp42 <- ggplot(mcleandat, aes(x = numHouseVacant, y = numMurders))
            gp42 <- gp42 + geom_point() + geom_smooth(method = "lm", formula = y ~ x)
            gp42 <- gp42 + xlim(0,85000)
            # (5, 1)
            gp51 <- ggplot(mcleandat, aes(x = numStreet, y = numMurders))
            gp51 <- gp51 + geom_point() + geom_smooth(method = "lm", formula = y ~ x)
            # (5, 2)
            gp52 <- ggplot(mcleandat, aes(x = numStreet, y = numMurders))
            gp52 <- gp52 + geom_point() + geom_smooth(method = "lm", formula = y ~ x)
            gp52 <- gp52 + xlim(0,3250)
            # arrange plots in a 5x2 grid
            library(gridExtra)
            grid.arrange(gp11, gp12, gp21, gp22, gp31, gp32, gp41, gp42, 
                         gp51, gp52, nrow = 5, ncol = 2, widths = c(1000,1000))
        })
        # save model summary to output
        output$model <- renderPrint({summary(predMurders()[[2]])})
    }
)