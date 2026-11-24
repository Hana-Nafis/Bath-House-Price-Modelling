# Bath-House-Price-Modelling

## Project Overview

This project was completed as part of the MA52115 Applied Statistics module for the MSc Statistics and Data Science programme at the University of Bath.

The study investigates the relationship between residential property characteristics and sale prices in Bath, using a dataset of 350 property transactions. The analysis applies exploratory data analysis and multiple linear regression to identify key structural and locational factors associated with property values.

Particular attention is given to logarithmic transformations and interaction effects to investigate how the relationship between living area and sale price varies according to garden availability.

## Project Objectives

- Explore the distribution and characteristics of Bath property prices.
- Investigate relationships between sale prices and property features.
- Examine correlations between numerical predictors.
- Address skewness and heteroscedasticity through logarithmic transformations.
- Compare additive and interaction-based regression models.
- Interpret regression coefficients and assess statistical significance.
- Evaluate model assumptions through diagnostic analysis.

## Methodology

The analysis was conducted in R using an exploratory and inferential statistical modelling approach.

Key stages included:

1. Data inspection and preparation – examining the structure, variables, and summary statistics of the Bath property dataset.
2. Exploratory data analysis – investigating sale prices, living area, bedrooms, garage spaces, garden availability, and distance from schools.
3. Correlation analysis – using a correlation matrix and heatmap to examine relationships between numerical variables.
4. Distribution analysis – exploring sale price distributions and identifying skewness and potential heteroscedasticity.
5. Data transformation – applying logarithmic transformations to sale price and living area to improve linearity and variance stability.
6. Model specification – developing and comparing additive and interaction-based multiple linear regression models.
7. Model selection – using the Akaike Information Criterion (AIC) to compare candidate specifications.
8. Statistical inference – interpreting regression coefficients, standard errors, t-statistics, and p-values.
9. Interaction analysis – examining how the association between living area and sale price differs according to garden availability.
10. Model diagnostics – assessing linearity, residual normality, homoscedasticity, and influential observations.

## Model Selection

Two regression specifications were compared:

- Additive Model: assumes that the included property characteristics have separate additive effects on log sale price.
- Interaction Model: includes an interaction between log living area and garden availability to investigate whether the association between property size and price differs depending on garden presence.

The interaction model was selected based on its lower Akaike Information Criterion.

| Model | Degrees of Freedom | AIC |
|---|---:|---:|
| Additive Model | 7 | -766.17 |
| Interaction Model | 8 | -799.44 |

## Key Findings

- The dataset contained 350 property transactions, with sale prices ranging from £222,500 to £1,000,000.
- Living area showed a strong positive correlation with sale price (r = 0.80), while distance from schools also showed a strong positive correlation (r = 0.74).
- Sale prices were right-skewed, and the relationship between living area and sale price showed evidence of non-linearity and heteroscedasticity on the original scale.
- Logarithmic transformations helped improve the linear relationship and stabilise variance.
- The interaction model achieved a lower AIC (-799.44) than the additive model (-766.17), supporting its selection for the final analysis.
- The final model explained approximately 81.9% of the variation in sale prices on the logarithmic scale.
- For properties without large gardens, a 1% increase in living area was associated with approximately a 0.18% increase in sale price. For properties with large gardens, the estimated association increased to approximately 0.53%.
- Each additional garage space was associated with an estimated 5.4% increase in sale price, holding other predictors constant.
- Each additional mile from a school was associated with an estimated 1.8% increase in sale price, conditional on the other model variables.
- The bedroom coefficient was negative (-0.0362), corresponding to an approximate 3.6% lower sale price per additional bedroom, holding living area and the other predictors constant.

The results highlight the importance of property size and its interaction with garden availability in explaining differences in sale prices. These findings represent statistical associations within the sample and should not be interpreted as causal effects.

## Model Diagnostics

The selected interaction model was assessed using standard regression diagnostic plots:

- Residuals vs Fitted – examined linearity and systematic patterns in residuals.
- Normal Q-Q – assessed the normality of residuals.
- Scale-Location – examined the consistency of residual variance.
- Residuals vs Leverage – investigated potentially influential observations using Cook's Distance.

The diagnostic assessment was used to evaluate whether the fitted model reasonably satisfied the assumptions of multiple linear regression.

## Tools and Libraries

- R
- RStudio
- tidyverse
- ggplot2
- modelr
- dplyr
- patchwork
- scales
- kableExtra
- janitor
- reshape2
- mgcv

## Repository Structure

```text
MSc-Applied-Statistics-Bath-House-Price-Modelling/
│
├── README.md
├── bath_house_price_analysis.R
│
└── data/
    └── README.md
```

## Dataset Information

The project uses the `BathHousePrices` dataset, supplied as an R data file named `BathHousePrices.r
