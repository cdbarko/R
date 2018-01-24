# Load the data from the csv file
dataDirectory <- "C:/Users/chrisbarko/Documents/R/win-library/ClassifyTextWithR/"
data <- read.csv(paste(dataDirectory, 'sunnyData.csv', sep=""), header = TRUE)

# Create the document term matrix
dtMatrix <- create_matrix(data["Text"])

# Configure the training data
container <- create_container(dtMatrix, data$IsSunny, trainSize=1:21, virgin=FALSE)

# train a SVM Model
model <- train_model(container, "SVM", kernel="linear", cost=1)

# new data
predictionData <- list("sunny sunny sunny", "rainy sunny rainy rainy", "cloudy very very snowy cloudy", "", "this is another rainy stormy world", "today is partly cloudy and windy", "rainy and cloudy cloudy")

# create a prediction document term matrix
predMatrix <- create_matrix(predictionData, originalMatrix=dtMatrix)

# create the corresponding container
predSize = length(predictionData);
predictionContainer <- create_container(predMatrix, labels=rep(0,predSize), testSize=1:predSize, virgin=FALSE)

# predict
results <- classify_model(predictionContainer, model)

# add prediction data to results
results$new_data  <- predictionData
results$prediction <- ifelse(results$SVM_LABEL == 1,"sunny", ifelse(results$SVM_LABEL == 2,"rainy","cloudy"))
results