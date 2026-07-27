library(dplyr)
library(tidyr)
library(ggplot2)
library(stats)

# Load the RFM dataset
data <- read.csv("D:/Data_Projects/Marketing Project/RFM_data.csv")
head(data, 10)

# Select the RFM scores used for customer segmentation
rfm <- data %>%
  select(R.Score, 
         F.Score, 
         M.Score)

# Set a seed to ensure reproducible K-means clustering results
set.seed(123)

# Perform K-means clustering with 4 customer segments and 25 random initializations
kmeans_result <- kmeans(
  rfm,
  centers = 4,
  nstart = 25
)

# Combine the original customer data with the assigned cluster labels
rfm_segmentation <- cbind(data, kmeans_result$cluster)

# Rename the newly added cluster column
rfm_segmentation <- rfm_segmentation %>%
  rename(Cluster = 9) %>%
  
  # Select the customer ID, raw RFM metrics, and assigned cluster
  select(CustomerID,
         Recency, 
         Frequency, 
         Monetary,
         Cluster)

head(rfm_segmentation)

# Display the RFM score centers of the four clusters
kmeans_result$centers

# Assign meaningful customer segment names based on the K-means cluster results
rfm_segmentation <- rfm_segmentation %>%
  mutate(Customer_Group = ifelse(Cluster == 4, "Champion", 
                                  ifelse(Cluster == 3, "Lost Customer", 
                                         ifelse(Cluster == 2, "New Customer", "At Risk"))))

# Export the final RFM segmentation results to a CSV file
write.csv(
  rfm_segmentation,
  "D:/Data_Projects/Marketing Project/RFM_Result.csv",
  row.names = FALSE
)
