# Threshold Tuning

Binary Classification models often output probabilties as their output, meaning that the results are between 0 and 1. Depending on what threshold is chosen, the performance of the model may change. For example, setting higher thresholds (only above .7 counts as a prediction of class 1) may have the effect of increasing the positive predictive value while lowering the recall. This tool is designed to help you select the correct threshold for your model once you have the results.

This tool was originally developed for a Machine Learning approach to Population Health via Duke Connected Care. However, it can be generalized to any binary classification model for which an optimal threshold needs to be found.

