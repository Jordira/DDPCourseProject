

<style>
.small-code pre code {
  font-size: 0.9em;
}
</style>

Communities & Crime
========================================================
transition: rotate
transition-speed: slow
navigation: slide
width: 1280
height: 930

author: JDP<br/>
date:   20/05/2015<br/>
job:    Student@Coursera

***
![justice-balance-icon](justice-balance-icon.png)

Shiny App
========================================================
**Predicting crime**
<hr color=red></hr>

Prediction of murders is based on communities and crime data collected in the 1990s in the USA.
<br/><br/>
The application auto-generates prediction on number of murders along with data table, exploratory plots and model summary for the keyed in values of eight predictors and the selected model.
<br/><br/>
It also displays data frame in the descending order of values of $$R^2$$

Details of the data and its analysis follows next.

Processing data
========================================================
<hr color=red></hr>

The dataset on *Communities and Crime* was downloaded from **UCI Machine Learning Repository**. It contains data on 147 attributes for 2215 instances with some missing values.  

The first 4 attributes were non-predictive. The fifth one was for creation of folds. Next 124 attributes were predictive and the last 18 attributes were potential goals.

Attributes relating to Police have lots of missing data (column numbers 104-120, 124-127, 129). Hence these attributes were not considered for analysis.

Some of the goal and predictive variables have few missing values. Corresponding cases were also eliminated.

For this short project, only *numMurders* goal variable was considered as response variable of a linear model.

Fitting linear models
========================================================
class: small-code
<hr color=red></hr>

<small>3 models were fitted (choose any one on shiny app). Below is summary of  approximate model.</small>


```r
approx.fit <- lm(numMurders ~ numKidsBornNeverMar + numImmig + numInShelters + numHouseVacant + numStreet, data = mcleandat)
summary(approx.fit)$coeff
cat(paste("Multiple R-squared:", summary(approx.fit)$r.squared, ", Adjusted R-squared:", summary(approx.fit)$adj.r.squared))
```

```
                         Estimate   Std. Error    t value      Pr(>|t|)
(Intercept)         -2.1573124829 2.280162e-01  -9.461226  8.679260e-21
numKidsBornNeverMar  0.0029271109 6.204952e-05  47.173791 6.027601e-322
numImmig             0.0002958114 1.162598e-05  25.443994 4.227789e-123
numInShelters        0.0056818325 1.466513e-03   3.874384  1.105289e-04
numHouseVacant       0.0013168923 8.046534e-05  16.365958  2.057266e-56
numStreet           -0.0506776978 3.520560e-03 -14.394781  1.156972e-44
```

```
Multiple R-squared: 0.973534020613406 , Adjusted R-squared: 0.97346418953323
```

Bibliography
========================================================

<hr color=red></hr>

<ol>
<li><em>justice-balance-icon.png</em> image was downloaded from <a href="http://www.iconarchive.com/show/or-icons-by-iconleak/justice-balance-icon.html">http://www.iconarchive.com/show/or-icons-by-iconleak/justice-balance-icon.html</a></li>
<li>Redmond, M. (n.d.). Computer Science, La Salle University, Philadelphia, PA, 19141, USA.</li>
<li>UCI Machine Learning Repository (2011). <em>Communities and Crime Dataset</em>. Downloaded from <a href="http://archive.ics.uci.edu/ml/datasets/Communities+and+Crime+Unnormalized">http://archive.ics.uci.edu/ml/datasets/Communities+and+Crime+Unnormalized</a></li>
</ol>
