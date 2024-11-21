
# Load necessary libraries
library(tidyverse)
library(readr)
library(kableExtra)

# Load data into RStudio
data <- read_csv("/Users/dhgu2021/Downloads/usa_00001.csv")

# Filter data for California (STATEICP == 71)
california_data <- data %>% filter(STATEICP == 71)

# Total number of respondents in California
total_respondents_california <- 391171  # Given value

# Number of respondents with doctoral degrees in California
doctoral_in_california <- california_data %>% filter(EDUCD == 116) %>% nrow()

# Calculate the ratio of doctoral degree holders to total respondents in California
ratio_california <- doctoral_in_california / total_respondents_california

# Group data by state and count respondents with doctoral degrees in each state
doctoral_by_state <- data %>%
  filter(EDUCD == 116) %>%
  group_by(STATEICP) %>%
  summarise(doctoral_count = n())

# Estimate the total number of respondents in each state using the ratio from California
estimated_total_by_state <- doctoral_by_state %>%
  mutate(Estimated_Total_Respondents = doctoral_count / ratio_california)

# Save the estimated data to a CSV file
write_csv(estimated_total_by_state, "estimated_total_by_state.csv")

actual_by_state <- data %>%
  group_by(STATEICP) %>%
  summarise(Actual_Total_Respondents = n())

# Merge the estimated data with the actual data
comparison <- estimated_total_by_state %>%
  left_join(actual_by_state, by = "STATEICP")

# Save the comparison data to a CSV file
write_csv(comparison, "comparison.csv")

