library(shiny)
library(ggplot2)
library(dplyr)
library(readr)
library(tidyr)

overview <- read_csv("overview.csv")
subgroup <- read_csv("subgroup_summary.csv")

haz_compare <- data.frame(
  Predictor = c(
    "Child age",
    "Female child",
    "Child illness",
    "Children under five in HH",
    "Secondary education",
    "Higher education",
    "Currently pregnant",
    "Richest wealth"
  ),
  CC = c(-0.016, 0.080, -0.079, -0.086, 0.303, 0.533, -0.235, 0.682),
  MI = c(-0.016, 0.080, -0.075, -0.085, 0.303, 0.532, -0.217, 0.675),
  Conclusion = c(
    "unchanged",
    "unchanged",
    "very small change",
    "unchanged",
    "unchanged",
    "unchanged",
    "small change",
    "very small change"
  ),
  stringsAsFactors = FALSE
)

sens_compare <- data.frame(
  Predictor = c(
    "Primary education",
    "Secondary education",
    "Currently pregnant",
    "Richest wealth",
    "Rural residence"
  ),
  Main = c(1.162, 1.164, 1.169, 0.776, 1.344),
  Excl_age = c(1.171, 1.677, 0.806, 0.833, 1.215),
  Conclusion = c(
    "modest change",
    "clear increase",
    "direction reversed",
    "pattern retained",
    "attenuated"
  ),
  stringsAsFactors = FALSE
)

adj_pooled_compare <- data.frame(
  Predictor = c(
    "Child age",
    "Child illness",
    "Primary education",
    "Richest wealth",
    "Rural residence"
  ),
  Main = c(1.012, 1.340, 1.162, 0.776, 1.344),
  Adj_pooled = c(1.012, 1.326, 1.127, 0.782, 1.349),
  Conclusion = c(
    "unchanged",
    "very small change",
    "modest change",
    "unchanged",
    "unchanged"
  ),
  stringsAsFactors = FALSE
)

ui <- fluidPage(
  titlePanel("Anthropometric Measurement Usability in South Asian DHS Surveys"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "country",
        "Country:",
        choices = unique(subgroup$country),
        selected = "All"
      ),
      
      selectInput(
        "period",
        "Period:",
        choices = unique(subgroup$period),
        selected = "2011-2016"
      ),
      
      selectInput(
        "variable",
        "Subgroup variable:",
        choices = unique(subgroup$variable),
        selected = "Wealth quintile"
      ),
      
      hr(),
      
      selectInput(
        "model_view",
        "Model summary view:",
        choices = c(
          "Main usability model",
          "HAZ: Complete-case vs MI",
          "Sensitivity analysis",
          "Adjusted pooled model"
        ),
        selected = "Main usability model"
      )
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel(
          "Overview",
          plotOutput("overview_plot", height = "500px")
        ),
        
        tabPanel(
          "Structured patterning",
          plotOutput("subgroup_plot", height = "500px")
        ),
        
        tabPanel(
          "Model and robustness",
          uiOutput("model_ui")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  
  output$overview_plot <- renderPlot({
    data_use <- overview %>%
      filter(country == input$country, period != "All") %>%
      select(country, period, usable_pct, unusable_pct) %>%
      pivot_longer(
        cols = c(usable_pct, unusable_pct),
        names_to = "status",
        values_to = "percent"
      ) %>%
      mutate(
        status = recode(
          status,
          usable_pct = "Usable",
          unusable_pct = "Unusable"
        )
      )
    
    ggplot(data_use, aes(x = period, y = percent, fill = status)) +
      geom_col(position = "dodge", width = 0.65) +
      labs(
        title = paste("Usable and unusable height observations -", input$country),
        x = NULL,
        y = "Percent",
        fill = NULL
      ) +
      ylim(0, 100) +
      theme_minimal(base_size = 13)
  })
  
  output$subgroup_plot <- renderPlot({
    data_use <- subgroup %>%
      filter(
        country == input$country,
        period == input$period,
        variable == input$variable
      ) %>%
      select(level, usable_pct, unusable_pct) %>%
      pivot_longer(
        cols = c(usable_pct, unusable_pct),
        names_to = "status",
        values_to = "percent"
      ) %>%
      mutate(
        status = recode(
          status,
          usable_pct = "Usable",
          unusable_pct = "Unusable"
        )
      )
    
    ggplot(data_use, aes(x = level, y = percent, fill = status)) +
      geom_col(position = "dodge", width = 0.65) +
      labs(
        title = paste(input$variable, "-", input$country, ",", input$period),
        x = NULL,
        y = "Percent",
        fill = NULL
      ) +
      ylim(0, 100) +
      theme_minimal(base_size = 13) +
      theme(
        axis.text.x = element_text(angle = 25, hjust = 1)
      )
  })
  
  output$model_ui <- renderUI({
    if (input$model_view == "Main usability model") {
      tagList(
        h4("Adjusted predictors of height usability"),
        tags$img(src = "forest_final_clean.png",
                 width = "100%",
                 style = "max-width: 100%; height: auto;"
        )
      )
    } else if (input$model_view == "HAZ: Complete-case vs MI") {
      tagList(
        h4("HAZ coefficients: complete-case vs multiple imputation"),
        tableOutput("haz_table")
      )
    } else if (input$model_view == "Sensitivity analysis") {
      tagList(
        h4("Sensitivity analysis: excluding child age"),
        tableOutput("sens_table")
      )
    } else if (input$model_view == "Adjusted pooled model") {
      tagList(
        h4("Country- and period-adjusted pooled model"),
        tableOutput("adj_table")
      )
    }
  })
  
  output$haz_table <- renderTable({
    haz_compare
  }, striped = TRUE, bordered = TRUE, spacing = "s", width = "100%")
  
  output$sens_table <- renderTable({
    sens_compare
  }, striped = TRUE, bordered = TRUE, spacing = "s", width = "100%")
  
  output$adj_table <- renderTable({
    adj_pooled_compare
  }, striped = TRUE, bordered = TRUE, spacing = "s", width = "100%")
}

shinyApp(ui = ui, server = server)
