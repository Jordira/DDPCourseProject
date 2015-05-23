library(shiny)
shinyUI(pageWithSidebar(
            headerPanel(
                    title = h1('Communities & Crime', 
                               style = "font-style: italic; color: #f00"),
                    windowTitle = 'Developing Data Products Course Project'
        ),
            sidebarPanel(
                style="width:0.35", # min-width:235px;max-width:375px
                h3('How to use the application'),
                p('Please enter data required in the EIGHT fields provided below. 
                  Please use suggested values (interpolation) for accuracy of the model. 
                  You may, however, use values outside suggested values (extrapolation).
                  Also, please be careful to see that entered values are less 
                  than the population size entered.'),
                p('The predicted number of murders will be auto generated 
                  in the "Prediction" tab of the main panel on the right.'),
                p('DO NOT forget to select a model at the top of the "Prediction" tab'),
                h3('Please enter the required inputs'),
                numericInput('numKidsBornNeverMar', 
                             h5('Number of kids born to never married people 
                                (min = 0, max = 527600):', style = "color:blue"), 
                             357, min = 0, max = 527600, step = 1),
                numericInput('numUnderPov', 
                             h5('Number of people under poverty level 
                                (min = 78, max = 1385000):', style = "color:blue"), 
                             2197, min = 78, max = 1385000, step = 1),
                numericInput('population', 
                             h5('Number of people in the community 
                                (min = 10000, max = 7323000):', style = "color:blue"), 
                             22690, min = 10000, max = 7323000, step = 1),
                numericInput('numUrban', 
                             h5('Number of people living in urban areas 
                                (min = 0, max = 7323000):', style = "color:blue"), 
                             17340, min = 0, max = 7323000, step = 1),
                numericInput('numImmig', 
                             h5('Number of people known to be foreign born 
                                (min = 20, max = 2083000):', style = "color:blue"), 
                             1082, min = 20, max = 2083000, step = 1),
                numericInput('numInShelters', 
                             h5('Number of people in homeless shelters 
                                (min = 0, max = 23380):', style = "color:blue"), 
                             68, min = 0, max = 23380, step = 1),
                numericInput('numHouseVacant', 
                             h5('Number of vacant households 
                                (min = 36, max = 172800):', style = "color:blue"), 
                             584, min = 36, max = 172800, step = 1),
                numericInput('numStreet', 
                             h5('Number of homeless people counted in the street 
                                (min = 0, max = 10450):', style = "color:blue"), 
                             19, min = 0, max = 10450, step = 1)
        ),
        mainPanel(
            tabsetPanel(type = "tabs",
                tabPanel("Prediction",
                    selectInput('modelSelected', 
                        h4('Select a model:', style = "color:blue"), 
                        c("All predictors" = "all", 
                          "Top 8 predictors (r square >= 0.8)" = "top8", 
                          "Approximate (5 predictors with small p-values 
                          & high rsq values)" = "approx"), 
                        selected = "approx", width = "50%"),
                    h3("Predicted number of murders:"),
                    verbatimTextOutput("prediction"),
                    hr(),
                    h5("Sorted data frame based on R-squared values of 
                       102 predictors of numMurders:"),
                    verbatimTextOutput("rsq")
                ),
                tabPanel("Data Table", h3("Data table for the selected model"), 
                         dataTableOutput(outputId = "table")),
                tabPanel("Plots",
                    h3("Murders versus top 5 predictors"),
                    p("Left column has all x-values. 
                      Right column has extreme x-values removed"),
                    p("Please wait for a few seconds for the graphs to load ...", 
                      style = "font-weight: bold; color: blue"),
                    p("Thank you"),
                    plotOutput('plots')
                ),
                tabPanel("Model Summary", 
                    h3('Fitted model is:'),
                    verbatimTextOutput("model")
                ),
                tabPanel("Sources",
                    h3('Bibliography:'),
                    tags$ol(tags$li('Redmond, M. (n.d.). Computer Science, 
                                    La Salle University, Philadelphia, PA, 19141, USA'),
                            tags$li('Communities and Crime Dataset (2011). 
                                    UCI Machine Learning Repository. 
                                    Downloaded from http://archive.ics.uci.edu/ml/datasets/Communities+and+Crime+Unnormalized')
                    )
                )
            )
        )
))