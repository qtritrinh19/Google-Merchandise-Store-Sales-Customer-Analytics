library(dplyr)
library(tidyr)
library(ggplot2)
library(stats)
library(arules)

# Load the transaction dataset
data <- read.csv("D:/Data_Projects/Marketing Project/RS_data.csv")
head(data, 5)

# Create a product lookup table containing unique product SKUs and descriptions 
products <- data %>%
  select(Product_SKU, 
         Product_Description) %>%
  distinct()

# Select transaction IDs and product SKUs for association rule analysis
rs <- data %>%
  select(Transaction_ID,
         Product_SKU)

head(rs, 5)

# Group product SKUs by transaction ID to create a list of products purchased in each transaction
transactions_list <- split(
  rs$Product_SKU,
  rs$Transaction_ID
)

# Convert the transaction list into an arules transactions object
transactions <- as(
  transactions_list,
  "transactions"
)

# Calculate and display the 30 most frequently purchased products based on relative transaction frequency
head(sort(
  itemFrequency(transactions, type = "relative"),
  decreasing = TRUE
), 30)

# Generate association rules using a 1% minimum support and 10% minimum confidence
rules <- apriori(
  transactions,
  parameter = list(
    support = 0.01,
    confidence = 0.1, 
    minlen = 2
  )
)

# Display the generated association rules
inspect(rules)

# Convert the association rules into a data frame and separate the left-hand and right-hand sides of each rule
rules_df <- as(rules, "data.frame") %>%
  separate(
    rules,
    into = c("lhs", "rhs"),
    sep = " => "
  )

# Generate a second set of association rules using stricter support and confidence thresholds
rules_2 <- apriori(
  transactions,
  parameter = list(
    support = 0.007,
    confidence = 0.5, 
    minlen = 2
  )
)

# Display the second set of generated association rules
inspect(rules_2)

# Convert the second set of association rules into a data frame and separate the left-hand and right-hand sides
rules_df_2 <- as(rules_2, "data.frame") %>%
  separate(
    rules,
    into = c("lhs", "rhs"),
    sep = " => "
  )

# Combine the association rules generated from both parameter settings
rules_df <- rbind(rules_df_2, rules_df)

# Remove curly brackets from the left-hand and right-hand product SKU values
rules_df <- rules_df %>%
  mutate(
    lhs = gsub("[{}]", "", lhs),
    rhs = gsub("[{}]", "", rhs)
  )

# Match the left-hand product SKU with the product lookup table to retrieve its product description
rules_df <- rules_df %>%
  left_join(
    products %>%
      select(Product_SKU, Product_Description),
    by = c("lhs" = "Product_SKU")
  ) %>%
  rename(lhsName = Product_Description) %>%
  
  # Match the right-hand product SKU with the product lookup table to retrieve its product description
  left_join(
    products %>%
      select(Product_SKU, Product_Description),
    by = c("rhs" = "Product_SKU")
  ) %>%
  rename(rhsName = Product_Description)


# Export the final association rule results to a CSV file
write.csv(
  rules_df,
  "D:/Data_Projects/Marketing Project/RS_Result.csv",
  row.names = FALSE
)
