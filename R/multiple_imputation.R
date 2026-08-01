library(mice)
library(survey)
library(mitools)
library(ggplot2)
library(dplyr)
library(haven)


dhs <- read_dta("data/processed/dhs_combined.dta")

# Build imputation dataset including design vars (but not to be imputed)
imp_vars <- c("haz","height_usable","child_age_months","orig_mother_edu",
              "child_gender","orig_wealth_index","currently_pregnant",
              "child_illness","residence_type","children_under_5_in_hh",
              "mother_age","sex_of_hh_head","stratum_id","psu_id","sw")

### imputed with the original variables as imputation should use full information.

imp_data <- dhs %>% select(all_of(imp_vars))

# MICE setup
methods <- make.method(imp_data)
methods["haz"] <- "pmm"
methods["child_age_months"] <- "pmm"
methods[names(methods) != "haz" & names(methods) != "child_age_months"] <- ""

pred <- make.predictorMatrix(imp_data)
pred[,] <- 1
pred[, c("stratum_id","psu_id","sw")] <- 0
pred[c("stratum_id","psu_id","sw"), ] <- 0

# Run PMM(Predictive mean matching)
imp_pmm <- mice(imp_data, 
                m = 20, 
                maxit = 10, 
                method = methods,
                predictorMatrix = pred,
                pmm.k = 3,   # smaller donor pool
                seed = 123)


completed_list <- complete(imp_pmm, action = "all")


## Extract HAZ from each imputed dataset
 
haz_all <- lapply(1:20, function(i){
  complete(imp_pmm, i)$haz
})


## Extract ONLY imputed HAZ values (those originally missing)
 
original_missing <- is.na(imp_data$haz)

imputed_only <- lapply(1:20, function(i){
  complete(imp_pmm, i)$haz[original_missing]
})

## Summary of observed vs imputed HAZ (dataset 1)

observed_haz <- imp_data$haz[!is.na(imp_data$haz)]
imputed_haz_1 <- complete(imp_pmm, 1)$haz[original_missing]

summary(observed_haz)
summary(imputed_haz_1)


## Density plot for your paper (Observed vs Imputed HAZ)

df_plot <- data.frame(
  value = c(observed_haz, imputed_haz_1),
  group = c(rep("Observed", length(observed_haz)),
            rep("Imputed", length(imputed_haz_1)))
)


ggplot(df_plot, aes(x=value, color=group, fill=group)) +
  geom_density(alpha=0.2, lwd = .8) +
  theme_minimal() +
  labs(title="Observed vs Imputed HAZ Distribution",
       x="HAZ", y="Density")+
  theme(legend.position = "top")+
  scale_fill_manual(values = c("Imputed" = "lightgreen", "Observed" = "blue"))+
  scale_color_manual(values = c("Imputed" = "green", "Observed" = "blue"))
  






df_plot %>%
  ggplot(aes(x = value, fill = group, color = group)) +
  geom_density(alpha = 0.1, lwd = .9) +
  labs(title="Observed vs Imputed HAZ Distribution",
       x="HAZ", y="Density") +
  theme(legend.position = "top", panel.grid = element_line(color = "grey"),
        panel.background = element_rect(fill = "white"))


## Compare Observed vs Imputed Distributions

plot(imp_pmm, "haz")

densityplot(imp_pmm, ~haz)                  # the imputed distribution overlaps observed


 
## Get pooled summary statistics across all 5 imputations

haz_stats <- sapply(1:20, function(i){
  x <- complete(imp_pmm, i)$haz
  c(mean = mean(x, na.rm=TRUE),
    sd = sd(x, na.rm=TRUE))
})

haz_stats




write_dta(imp_data, "C:/Users/tahsi/OneDrive/Desktop/AST_450(Project)/dhsRimp.dta")





