# Generate data

set.seed(1234)
ids <- sample(1000000:9999999, size = 40000)

prevalence <- 0.2

historical <- rep(c(1,0), times = c(floor(length(ids)*0.2), length(ids) - floor(length(ids)*0.2)))

historical_df <- as.data.frame(cbind(ids, historical))
write.csv(historical_df, "historical.csv", row.names = FALSE)


# Generate fake scores

fake_risk <- c(runif(floor(length(ids)*0.2), 0.4, 0.8), runif((length(ids) - floor(length(ids)*0.2)), 0.2, 0.6))

fake_df <- as.data.frame(cbind(ids, fake_risk))

write.csv(fake_df, "fake.csv", row.names = FALSE)
