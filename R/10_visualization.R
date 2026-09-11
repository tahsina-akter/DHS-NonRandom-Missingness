library(tidyverse)
library(haven)     # read_dta()
library(scales)    # percent_format(), label_percent()



dhs <- read_dta("../data/processed/selected/dhs_combined.dta")

dhs <- dhs %>%
  mutate(height_usable = factor(height_usable,
                                levels = c("0","1"),
                                labels = c("Not usable","Usable")))


colors_binary <- c("Not usable" = "#1F3B73", "Usable" = "#E07A5F")

dhs <- dhs %>%
  mutate(height_usable_num = as.numeric(height_usable))

fig1_data <- dhs %>%
  filter(!is.na(height_usable_num), !is.na(sw)) %>%
  group_by(height_usable) %>%
  summarise(
    weighted_n = sum(sw),
    .groups = "drop"
  ) %>%
  mutate(
    percent = weighted_n / sum(weighted_n) * 100
  )

fig1 <- fig1_data %>%
  ggplot(aes(x = height_usable, y = percent, fill = height_usable)) +
  geom_col(width = 0.4) +
  coord_fixed(ratio = 0.02) +
  geom_text(
    aes(label = sprintf("%.1f%%", percent)),
    vjust = -0.5,
    size = 5
  ) +
  labs(
    title = "Percentage of Children With and Without Usable Height",
    x = NULL,
    y = "Percent"
  ) +
  theme_minimal(base_size = 16) +
  theme(
    legend.position = "none",
    plot.title = element_text(size = 15),
    axis.title = element_text(size = 15)
  ) +
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
    mother_education = factor(mother_education,
                             levels = c(0, 1, 2, 3),
                             labels = c("No education", "Primary", "Secondary", "Higher"))
  ) %>%
  filter(!is.na(mother_education)) %>%
  ggplot(aes(x = mother_education, fill = height_usable)) +
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
    residence_type = factor(residence_type, levels = c(1, 2),
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
    wealth_index = factor(wealth_index,
                               levels = c(1, 2, 3, 4, 5),
                               labels = c("Poorest", "Poorer", "Middle", "Richer", "Richest"))
  ) %>%
  filter(!is.na(wealth_index)) %>%
  ggplot(aes(x = wealth_index, fill = height_usable)) +
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



fig_haz_wealth <- dhs %>%
  filter(!is.na(haz), !is.na(wealth_index)) %>%
  mutate(wealth_index = factor(wealth_index,
                                    levels = c(1,2,3,4,5),
                                    labels = c("Poorest","Poorer","Middle","Richer","Richest"))) %>%
  ggplot(aes(x = haz, color = wealth_index)) +
  geom_density(linewidth = 0.9) +
  labs(title = "HAZ Distribution by Wealth Quintile",
       x = "HAZ", y = "Density", color = NULL) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "top")

fig_haz_wealth

