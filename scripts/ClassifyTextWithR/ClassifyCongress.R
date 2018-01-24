library(RTextTools)

data(USCongress)
# CREATE THE DOCUMENT-TERM MATRIX
doc_matrix <- create_matrix(USCongress$text, language="english", removeNumbers=TRUE, stemWords=TRUE, removeSparseTerms=.998)

head(doc_matrix, n = 10L)

container <- create_container(doc_matrix, USCongress$major, trainSize=1:4000, testSize=4001:4449, virgin=FALSE)

SVM <- train_model(container,"SVM")
GLMNET <- train_model(container,"GLMNET")
MAXENT <- train_model(container,"MAXENT")

SVM_CLASSIFY <- classify_model(container, SVM)
GLMNET_CLASSIFY <- classify_model(container, GLMNET)
MAXENT_CLASSIFY <- classify_model(container, MAXENT)

analytics <- create_analytics(container, cbind(SVM_CLASSIFY, GLMNET_CLASSIFY, MAXENT_CLASSIFY))

summary(analytics)

# CREATE THE data.frame SUMMARIES
topic_summary <- analytics@label_summary
alg_summary <- analytics@algorithm_summary
ens_summary <-analytics@ensemble_summary
doc_summary <- analytics@document_summary

write.csv(analytics@document_summary, "DocumentSummary.csv")
