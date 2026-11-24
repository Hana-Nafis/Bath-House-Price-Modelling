
# Load required libraries
library(tidyverse)
library(ggplot2)
library(modelr)
library(dplyr)
library(patchwork)
library(scales)
library(kableExtra)
library(janitor)
library(reshape2)
library(mgcv)

# Read in the data
load("BathHousePrices.rda")

# Exploratory Data Analysis

# Viewing the first 5 rows of the dataset to understand its structure
# Viewing the first 5 rows of the dataset with professional formatting
BathHousePrices %>%
  head(5) %>%
  # Explicitly calling scales:: ensures it works even if the library isn't attached
  mutate(
    SalePrice = scales::dollar(SalePrice, prefix = "£"),
    LivingArea = scales::comma(LivingArea)
  ) %>%
  kable(
    caption = "Table 1: Preview of the Bath Property Dataset",
    col.names = c("Sale Price", "Bedrooms", "Living Area (sq ft)", "Garage Spaces", "Garden", "Dist. to School (miles)"),
    align = "lcccccc"
  ) %>%
  kable_styling(
    bootstrap_options = c("striped", "hover", "condensed"),
    full_width = F,
    position = "center"
  )

# Calculate the statistics
summary_stats <- BathHousePrices %>%
  summarise(
    Variable = c("Sale Price (£)", "Living Area (sq ft)", "Bedrooms", "Garage Spaces", "Dist. to School (miles)"),
    Mean = c(mean(SalePrice), mean(LivingArea), mean(Bedrooms), mean(GarageCars), mean(DistFromSchool)),
    Median = c(median(SalePrice), median(LivingArea), median(Bedrooms), median(GarageCars), median(DistFromSchool)),
    Min = c(min(SalePrice), min(LivingArea), min(Bedrooms), min(GarageCars), min(DistFromSchool)),
    Max = c(max(SalePrice), max(LivingArea), max(Bedrooms), max(GarageCars), max(DistFromSchool)),
    SD = c(sd(SalePrice), sd(LivingArea), sd(Bedrooms), sd(GarageCars), sd(DistFromSchool))
  )

# Format the table using kableExtra
summary_stats %>%
  kable(
    digits = 0,
    format.args = list(big.mark = ","),
    caption = "Table 2: Summary Statistics for Bath Property Features",
    align = "lccccc"
  ) %>%
  kable_styling(
    bootstrap_options = c("striped", "hover", "condensed"),
    full_width = F,
    position = "center"
  ) %>%
  add_header_above(c(" " = 1, "Central Tendency" = 2, "Range" = 2, "Spread" = 1))

# Create the correlation matrix
cor_matrix <- BathHousePrices %>%
  select(SalePrice, LivingArea, Bedrooms, GarageCars, DistFromSchool) %>%
  cor()
melted_cor <- melt(cor_matrix)

# Create the Heatmap
ggplot(data = melted_cor, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "yellow", high = "blue", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Correlation") +
  theme_minimal() +
  coord_fixed() +
  geom_text(aes(Var1, Var2, label = round(value, 2)), color = "black", size = 4) +
  labs(title = "Heatmap: Strength of Property Value Drivers",
       subtitle = "Identifying which variables have the strongest impact on Price",
       x = "", 
       y = "",
       caption = "Figure 1: Correlation Heatmap") +
  theme(
    axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1),
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5),
    plot.caption = element_text(hjust = 0.5, face = "italic"))

# Plot 1: The Primary Driver
s1 <- ggplot(BathHousePrices, aes(x = LivingArea, y = SalePrice)) +
  geom_point(alpha = 0.4, color = "midnightblue") +
  geom_smooth(method = "lm", color = "maroon") +
  scale_y_continuous(labels = scales::label_dollar(prefix = "£")) +
  labs(title = "Scale vs. Sale Price", x = "Living Area (sq ft)", y = "Sale Price") +
  theme_minimal()

# Plot 2: The Locational Driver
s2 <- ggplot(BathHousePrices, aes(x = DistFromSchool, y = SalePrice)) +
  geom_point(alpha = 0.4, color = "darkgreen") +
  geom_smooth(method = "lm", color = "maroon") +
  scale_y_continuous(labels = scales::label_dollar(prefix = "£")) +
  labs(title = "Location vs. Sale Price", x = "Distance to School (miles)", y = "") +
  theme_minimal()

s1 + s2 + plot_annotation(caption = "Figure 2: Visualizing the Two Strongest Price Drivers in Bath",
                          theme = theme(plot.caption = element_text(hjust = 0.5, face = "italic")))

# Plot to analyse the impact of Garden on Price distribution
ggplot(BathHousePrices, aes(x = Garden, y = SalePrice, fill = Garden)) +
  geom_violin(alpha = 0.5) +
  geom_boxplot(width = 0.2, color = "black", outlier.shape = NA) +
  scale_y_continuous(labels = scales::label_dollar(prefix = "£")) +
  theme_minimal() +
  labs(title = "Impact of Large Gardens on Property Value",
       y = "Sale Price (£)",
       caption = "Figure 3: Impact of Categorical Variable") +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.caption = element_text(hjust = 0.5, face = "italic"))

# Plot to check the distribution of the target variable
ggplot(BathHousePrices, aes(x = SalePrice)) +
  geom_histogram(aes(y = ..density..), bins = 30, fill = "lightblue", alpha = 0.7) +
  geom_density(color = "red", size = 1) +
  scale_x_continuous(labels = scales::label_dollar(prefix = "£")) + 
  theme_minimal() +
  labs(title = "Distribution of Sale Prices",
       subtitle = "Checking for right-skewness",
       caption = "Figure 4: Distribution of target variable") +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5),
    plot.caption = element_text(hjust = 0.5, face = "italic"))

# Plot 1: Identifying issues in the raw data
p1 <- ggplot(BathHousePrices, aes(x = LivingArea, y = SalePrice)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "loess", color = "red") + 
  scale_y_continuous(labels = scales::label_dollar(prefix = "£")) +
  theme_minimal() +
  labs(title = "Raw Scale: LOESS Fit", subtitle = "Checking for non-linearity")

# Plot 2: Validating the Log-Log transformation
p2 <- ggplot(BathHousePrices, aes(x = log(LivingArea), y = log(SalePrice))) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", color = "blue") + 
  theme_minimal() +
  labs(title = "Log-Log Scale: Linear Fit", subtitle = "Stabilizing variance")

p1 / p2 + plot_annotation(caption = "Figure 5: Comparison between LOESS (Raw) and LM (Log-log) fits",
                          theme = theme(plot.caption = element_text(hjust = 0.5, face = "italic")))

# Model Selection & Methodology

# Model A: Additive (Assumes all variables have a constant effect)
model_add <- lm(log(SalePrice) ~ log(LivingArea) + Bedrooms + Garden + GarageCars + DistFromSchool, 
                data = BathHousePrices)

# Model B: Interaction (Assumes the value of space changes based on Garden presence)
model_int <- lm(log(SalePrice) ~ log(LivingArea) * Garden + Bedrooms + GarageCars + DistFromSchool, 
                data = BathHousePrices)

# Calculate AIC and create the data frame
aic_comparison <- AIC(model_add, model_int) %>%
  mutate(Model = c("Additive Model", "Interaction Model")) %>%
  select(Model, df, AIC)

# Format with kableExtra
aic_comparison %>%
  kable(
    digits = 2,
    caption = "Table 3: Model Comparison using Akaike Information Criterion (AIC)",
    col.names = c("Model Specification", "Degrees of Freedom", "AIC Value")
  ) %>%
  kable_styling(
    bootstrap_options = c("striped", "hover", "condensed"),
    full_width = F,
    position = "center"
  ) %>%
  footnote(general = "A lower AIC indicates a better balance between model fit and complexity.")

# Results & Inference

# Extract coefficients from the model
# Assuming 'model_int' is lm(log(SalePrice) ~ LivingArea * Garden + ...)
model_summary <- summary(model_int)$coefficients %>% 
  as.data.frame() %>%
  select(Estimate, `Std. Error`, `t value`, `Pr(>|t|)`)

# Generate the professional kable table
model_summary %>%
  kable(
    digits = 4, 
    format = "html",
    caption = "Table 4: Multiple Regression Results for log(SalePrice)",
    col.names = c("Estimate", "Std. Error", "t-statistic", "p-value")
  ) %>%
  kable_styling(
    bootstrap_options = c("striped", "hover", "condensed"),
    full_width = F,
    position = "center"
  ) %>%
  footnote(general = "Significance codes: 0 '***' 0.001 '**' 0.01 '*' 0.05")

# Generate a grid representing the 'average' Bath property
grid <- BathHousePrices %>%
  data_grid(
    LivingArea = seq_range(LivingArea, n = 100), 
    Garden, 
    # Using medians from your Summary Table makes this more realistic
    Bedrooms = median(Bedrooms), 
    GarageCars = median(GarageCars), 
    DistFromSchool = median(DistFromSchool)
  ) %>%
  add_predictions(model_int)

# Visualization of the Interaction Effect
ggplot(BathHousePrices, aes(x = LivingArea, y = log(SalePrice), color = Garden)) +
  geom_point(alpha = 0.2) +
  geom_line(data = grid, aes(y = pred), size = 1.2) +
  scale_color_manual(values = c("No" = "darkgreen", "Yes" = "darkblue")) +
  theme_minimal() +
  labs(title = "Interaction Impact of Living Area and Garden",
       subtitle = "Predicted price slopes for a median property (2-bed, 2-garage)",
       x = "Living Area (sq ft)", 
       y = "log(Sale Price)",
       caption = "Figure 6: Visualization of the Interaction Effect") +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5),
    plot.caption = element_text(hjust = 0.5, face = "italic"))

# Model Diagnostics

# Visualizing the 'Health' of the best model
par(mfrow = c(2, 2), oma = c(3, 0, 0, 0))
plot(model_int, col = "midnightblue", main = "")
mtext("Figure 7: Diagnostic plots confirming model linearity, normality, and stability.", 
      side = 1, line = 1, outer = TRUE, adj = 0.5, font = 3)
par(mfrow = c(1, 1), oma = c(0, 0, 0, 0))
