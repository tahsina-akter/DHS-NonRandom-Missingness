library(tidyverse)
library(haven)     # read_dta()
library(scales)    # percent_format(), label_percent()



dhs <- read_dta("data/processed/dhs_combined.dta")

dhs <- dhs %>%
  mutate(height_usable = haven::as_factor(height_usable, levels = "values"))
dhs <- dhs %>%
  mutate(height_usable = factor(height_usable,
                                levels = c("0","1"),
                                labels = c("Not usable","Usable")))


colors_binary <- c("Not usable" = "#1F3B73", "Usable" = "#E07A5F")

fig1 <- dhs %>%
  count(height_usable, name = "n") %>%
  mutate(percent = n / sum(n) * 100) %>%
  ggplot(aes(x = height_usable, y = percent, fill = height_usable)) +
  geom_col(width = 0.4) +
  coord_fixed(ratio = 0.02)+
  geom_text(aes(label = c("17.2%", "82.8%")),
            vjust = -0.5, size = 5) +
  labs(title = "Percentage of Children With and Without Usable Height", cex = .5,
       x = NULL, y = "Percent") +
  theme_minimal(base_size = 16) +
  theme(legend.position = "none", plot.title = element_text(size = 15), axis.title = element_text(size = 15)) +
  scale_fill_manual(values = colors_binary)

fig1




fig2 <- dhs %>%
  filter(!is.na(child_age_months)) %>%
  ggplot(aes(x = child_age_months, fill = height_usable, color = height_usable)) +
  geom_density(alpha = 0.30, linewidth = 0.9) +
  geom_vline(xintercept = 24, linetype = "dashed", linewidth = 0.8) +
  scale_x_continuous(limits = c(0, 59), breaks = seq(0, 60, 12)) +
  labs(
    title = "Child Age Distribution by Height Usability",
    subtitle = "Dashed line indicates 24 months",
    x = "Age (months)", y = "Density",
    fill = NULL, color = NULL
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "top", plot.title = element_text(size = 13),
        plot.subtitle = element_text(size = 10))

fig2


fig3 <- dhs %>%
  mutate(
    orig_mother_edu = factor(orig_mother_edu,
                             levels = c(0, 1, 2, 3),
                             labels = c("No education", "Primary", "Secondary", "Higher"))
  ) %>%
  filter(!is.na(orig_mother_edu)) %>%
  ggplot(aes(x = orig_mother_edu, fill = height_usable)) +
  geom_bar(position = "fill", width = 0.75) +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  labs(
    title = "Height Usability by Mother’s Education",
    x = NULL, y = "Percentage within education category",
    fill = NULL
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "top")+
  scale_fill_manual(values = colors_binary)


fig3




fig4 <- dhs %>%
  mutate(
    residence_type = factor(residence_type, levels = c(0, 1),
                            labels = c("Urban", "Rural"))
  ) %>%
  filter(!is.na(residence_type)) %>%
  ggplot(aes(x = residence_type, fill = height_usable)) +
  geom_bar(position = "fill", width = 0.75) +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  labs(
    title = "Height Usability by Place of Residence",
    x = NULL, y = "Percentage within residence category",
    fill = NULL
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "top")+
  scale_fill_manual(values = colors_binary)


fig4



fig5 <- dhs %>%
  filter(!is.na(child_age_months)) %>%
  ggplot(aes(x = height_usable, y = child_age_months, fill = height_usable)) +
  geom_violin(trim = FALSE, alpha = 0.35) +
  geom_boxplot(width = 0.18, outlier.alpha = 0.2) +
  scale_y_continuous(limits = c(0, 59), breaks = seq(0, 60, 12)) +
  labs(
    title = "Child Age by Height Usability",
    x = NULL, y = "Age (months)",
    fill = NULL
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none")

fig5



fig6 <- dhs %>%
  mutate(
    orig_wealth_index = factor(orig_wealth_index,
                               levels = c(1, 2, 3, 4, 5),
                               labels = c("Poorest", "Poorer", "Middle", "Richer", "Richest"))
  ) %>%
  filter(!is.na(orig_wealth_index)) %>%
  ggplot(aes(x = orig_wealth_index, fill = height_usable)) +
  geom_bar(position = "fill", width = 0.75) +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  labs(
    title = "Height Usability by Wealth Quintile",
    x = NULL, y = "Percentage within wealth quintile",
    fill = NULL
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "top")+
  scale_fill_manual(values = colors_binary)


fig6



fig7 <- ggplot(fig7_dat, aes(x = p, y = country)) +
  geom_point(size = 4, color = "#1F3B73")+
  scale_x_continuous(labels = percent_format(accuracy = 1)) +
  labs(
    title = "Percentage of Non-Usable Height by Country",
    x = "Not usable (%)", y = NULL
  ) +
  theme_minimal(base_size = 14)

fig7



fig_haz_wealth <- dhs %>%
  filter(!is.na(haz), !is.na(orig_wealth_index)) %>%
  mutate(orig_wealth_index = factor(orig_wealth_index,
                                    levels = c(1,2,3,4,5),
                                    labels = c("Poorest","Poorer","Middle","Richer","Richest"))) %>%
  ggplot(aes(x = haz, color = orig_wealth_index)) +
  geom_density(linewidth = 0.9) +
  labs(title = "HAZ Distribution by Wealth Quintile",
       x = "HAZ", y = "Density", color = NULL) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "top")

fig_haz_wealth






# visually Adjusted odds ratio (95% CI)


library(ggplot2)
library(tibble)
library(dplyr)

plot_data <- tribble(
  ~label,                               ~OR,    ~lower, ~upper,
  "Place of residence: Rural",                   1.344,  1.274,  1.417,
  "Wealth quintile: Poorer",            1.052,  1.003,  1.104,
  "Wealth quintile: Middle",            0.984,  0.936,  1.034,
  "Wealth quintile: Richer",            0.958,  0.908,  1.010,
  "Wealth quintile: Richest",           0.776,  0.726,  0.830,
  "Mother currently pregnant: Yes",            1.169,  1.092,  1.250,
  "Mother's education: Primary",        1.162,  1.098,  1.229,
  "Mother's education: Secondary",      1.164,  1.111,  1.219,
  "Mother's education: Higher",         1.054,  0.982,  1.131,
  "Ill in past 2 weeks: Yes",           1.340,  1.287,  1.395,
  "Child sex: Female",                  1.079,  1.046,  1.115,
  "Number of under-5 children in household",         0.966,  0.948,  0.985
)

plot_data <- plot_data %>%
  mutate(label = factor(label, levels = rev(label)))

p <- ggplot(plot_data, aes(x = OR, y = label)) +
  geom_vline(
    xintercept = 1,
    linetype = "dashed",
    color = "gray55",
    linewidth = 0.6
  ) +
  geom_errorbarh(
    aes(xmin = lower, xmax = upper),
    height = 0.18,
    linewidth = 0.8,
    color = "#005493"
  ) +
  geom_point(
    size = 2.8,
    color = "#008080"
  ) +
  labs(
    x = "Adjusted odds ratio (95% CI)",
    y = NULL,
    title = "Adjusted predictors of height usability"
  ) +
  coord_cartesian(
    xlim = c(0.72, 1.45),
    clip = "off"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.title.x = element_text(face = "bold", size = 12),
    axis.text.y = element_text(size = 10.5, face = "bold"),
    axis.text.x = element_text(size = 10.5),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "gray90"),
    plot.margin = margin(10, 15, 10, 10)
  )

print(p)





# Data from Table 4.5
coef_wide <- tribble(
  ~term,                              ~cc,     ~mi,
  "Child age (months)",              -0.016,  -0.016,
  "Female child: Yes",                0.080,   0.080,
  "Child illness: Yes",              -0.079,  -0.075,
  "Children under five in HH",       -0.086,  -0.085,
  "Mother's age (years)",             0.008,   0.009,
  "Mother's education: Primary",      0.122,   0.115,
  "Mother's education: Secondary",    0.303,   0.303,
  "Mother's education: Higher",       0.533,   0.532,
  "Currently pregnant: Yes",         -0.235,  -0.217,
  "Wealth index: Poorer",             0.171,   0.170,
  "Wealth index: Middle",             0.312,   0.317,
  "Wealth index: Richer",             0.483,   0.481,
  "Wealth index: Richest",            0.682,   0.675
)

# Order from top to bottom in the final plot
coef_wide <- coef_wide %>%
  mutate(term = factor(
    term,
    levels = rev(c(
      "Child age (months)",
      "Female child: Yes",
      "Child illness: Yes",
      "Children under five in HH",
      "Mother's age (years)",
      "Mother's education: Primary",
      "Mother's education: Secondary",
      "Mother's education: Higher",
      "Currently pregnant: Yes",
      "Wealth index: Poorer",
      "Wealth index: Middle",
      "Wealth index: Richer",
      "Wealth index: Richest"
    ))
  ))

p <- ggplot(coef_wide, aes(y = term)) +
  geom_vline(
    xintercept = 0,
    linetype = "dashed",
    color = "gray55",
    linewidth = 0.6
  ) +
  geom_segment(
    aes(x = cc, xend = mi, yend = term),
    color = "gray65",
    linewidth = 0.9
  ) +
  geom_point(
    aes(x = cc),
    size = 5,
    color = "blue", alpha= 0.5, shape = 17
  ) +
  geom_point(
    aes(x = mi),
    size = 5,
    color = "red", alpha= 0.5, 
  ) +
  labs(
    x = expression(hat(beta)),
    y = NULL,
    title = "HAZ coefficients changed little after imputation"
  ) +
  annotate("text",
           x = max(coef_wide$cc, coef_wide$mi) + 0.03,
           y = 1,
           label = "",
           hjust = 0) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.title.x = element_text(face = "bold", size = 12),
    axis.text.y = element_text(size = 10.5),
    axis.text.x = element_text(size = 10.5),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "gray90"),
    plot.margin = margin(10, 20, 10, 10),
    legend.position = "none"
  ) +
  coord_cartesian(
    xlim = c(-0.30, 0.75),
    clip = "off"
  )

print(p)



# Optional manual legend using annotation
p_final <- p +
  annotate("point", x = 0.48, y = 13.7, color = "blue", size = 5, alpha=0.5, shape = 17) +
  annotate("text",  x = 0.505, y = 13.7, label = "Complete-case", hjust = 0, size = 3.5) +
  annotate("point", x = 0.48, y = 13.15, color = "red", size = 5, alpha= 0.5) +
  annotate("text",  x = 0.505, y = 13.15, label = "Multiple imputation", hjust = 0, size = 3.5)

print(p_final)



# Adjusted odds ratio plot fro dashboard


coef_wide <- tribble(
  ~term,               ~main,  ~adj_pooled,
  "Child age",         1.012,  1.012,
  "Child illness",     1.340,  1.326,
  "Primary education", 1.162,  1.127,
  "Richest wealth",    0.776,  0.782,
  "Rural residence",   1.344,  1.349
)

coef_wide <- coef_wide %>%
  mutate(term = factor(
    term,
    levels = rev(c(
      "Child age",
      "Child illness",
      "Primary education",
      "Richest wealth",
      "Rural residence"
    ))
  ))

p <- ggplot(coef_wide, aes(y = term)) +
  geom_vline(
    xintercept = 1,
    linetype = "dashed",
    color = "gray55",
    linewidth = 0.5
  ) +
  geom_segment(
    aes(x = main, xend = adj_pooled, yend = term),
    color = "gray65",
    linewidth = 0.8
  ) +
  geom_point(
    aes(x = main),
    color = "blue", size = 5, alpha=0.5, shape = 17
  ) +
  geom_point(
    aes(x = adj_pooled),
    color = "red", size = 5, alpha=0.5
  ) +
  labs(
    x = "Adjusted odds ratio",
    y = NULL,
    title = NULL
  ) +
  coord_cartesian(xlim = c(0.72, 1.40), clip = "off") +
  theme_minimal(base_size = 10) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "gray90"),
    axis.text.y = element_text(size = 8.5, face = "bold"),
    axis.text.x = element_text(size = 8),
    axis.title.x = element_text(size = 9, face = "bold"),
    plot.margin = margin(5, 5, 5, 5),
    legend.position = "none"
  )

p_small <- p +
  annotate("point", x = 1.26, y = 5.45, color = "blue", size = 5, alpha=0.5, shape = 17) +
  annotate("text",  x = 1.285, y = 5.45, label = "Main", hjust = 0, size = 2.8) +
  annotate("point", x = 1.26, y = 5.15, color = "red", size = 5, alpha=0.5) +
  annotate("text",  x = 1.285, y = 5.15, label = "Adj.", hjust = 0, size = 2.8)

print(p_small)



##  Unweighted Sample Size by Country and Survey Round


library(ggplot2)
library(scales)

plot_df <- data.frame(
  year = c("2011", "2011", "2012-13", "2014", "2015-16", "2016",
           "2017-18", "2017-18", "2019-21", "2022", "2022"),
  country = c("Bangladesh", "Nepal", "Pakistan", "Bangladesh", "India", "Nepal",
              "Bangladesh", "Pakistan", "India", "Bangladesh", "Nepal"),
  n = c(8753, 5306, 11725, 7886, 259536, 5038,
        8759, 12708, 232796, 8784, 5372)
)

year_order <- c("2011", "2012-13", "2014", "2015-16", "2016",
                "2017-18", "2019-21", "2022")

plot_df$year <- factor(plot_df$year, levels = year_order)
plot_df$country <- factor(
  plot_df$country,
  levels = c("Nepal", "Pakistan", "India", "Bangladesh")
)

plot_df$n_sqrt <- sqrt(plot_df$n)

p <- ggplot(plot_df, aes(x = year, y = country)) +
  geom_point(
    aes(size = n_sqrt, fill = country),
    shape = 21, color = "black", alpha = 0.85, stroke = 0.4
  ) +
  geom_text(
    aes(label = comma(n)),
    vjust = -1.1, size = 3.1
  ) +
  scale_fill_manual(
    values = c(
      "Bangladesh" = "#1b9e77",
      "India"      = "#d95f02",
      "Pakistan"   = "#7570b3",
      "Nepal"      = "#e7298a"
    ),
    name = "Country"
  ) +
  scale_size_continuous(
    range = c(5, 22),
    guide = "none"
  ) +
  coord_cartesian(clip = "off") +
  labs(
    title = "Unweighted Sample Size by Country and Survey Round",
    x = "Survey round",
    y = NULL
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.major.y = element_blank(),
    axis.text.x = element_text(angle = 30, hjust = 1),
    plot.margin = margin(10, 30, 10, 10),
    legend.position = "top",
    axis.title.y = element_text(face = "bold")
  )

print(p)
