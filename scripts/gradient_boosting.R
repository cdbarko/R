library(caret)

### Load admissions dataset. ###
mydata <- read.csv("http://www.ats.ucla.edu/stat/data/binary.csv")

### Create yes/no levels for admission. ### 
mydata$admit_factor[mydata$admit==0] <- "no"
mydata$admit_factor[mydata$admit==1] <- "yes"             

### Gradient boosting machine algorithm. ###
set.seed(123)
fitControl <- trainControl(method = 'cv', number = 5, summaryFunction=defaultSummary)
grid <- expand.grid(n.trees = seq(5000,1000000,5000), interaction.depth = 2, shrinkage = .001, n.minobsinnode = 20)
fit.gbm <- train(as.factor(admit_factor) ~ . - admit, data=mydata, method = 'gbm', trControl=fitControl, tuneGrid=grid, metric='Accuracy')
plot(fit.gbm)


mod = gbm(admit ~ .,
      data = mydata[,-5],
      n.trees=100000,
      shrinkage=0.001,
      interaction.depth=2,
      n.minobsinnode=10,
      cv.folds=5,
      verbose=TRUE,
      n.cores=2)

best.iter <- gbm.perf(mod, method="OOB", plot.it=TRUE, oobag.curve=TRUE, overlay=TRUE)
print(best.iter)
[1] 1487
pred = as.integer(predict(mod, newdata=mydata[,-5], n.trees=best.iter) > 0)
y = mydata[,1]
sum(pred == y)/length(y)
[1] 0.7225
