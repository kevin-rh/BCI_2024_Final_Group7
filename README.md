# Group 7 Final Project
## Brain Computer Interface: Fundamentals and Applications 2024

**Authors**:
Kevin Richardson Halim, Filippo Jonathan Lie, Nathan Jacky Lee
Here are the Design and items used in the project:

1. Experimental Design
   
   <img width="366" alt="image" src="https://github.com/kevin-rh/BCI_2024_Final_Group7/assets/134197756/4875b3b8-6af1-4c95-8dbe-fb7bdb3f1547">

The project starts from Data Preprocessing and divided into 2 methods, where 1 will immediately receive feature extraction, Model training and testing, followed by output, while the other will receive artifact removal first before the other process.

2. Procedure of Data Collection

Data Collection is not done manually and is taken from pre-existing data as instructed. The dataset can be accessed from : https://nemar.org/dataexplorer/detail?dataset_id=ds002723. 

3. Hardware and Software Used

   Hardware: Personal Laptops and devices
   
   Software: EEGlab, Matlab, Google Collab (Python), Microsoft Office
   
   Website: HackMD, Github

I. Introduction

The project revolves around a comparison study within the model and dataset. As the flowchart provided above, the key feature of difference would be a comparison of the artifact removal, as it will prove to have/don't have an effect on the accuracy of the BCI model. The BCI system will be using Machine Learning Models, namely EEGNet, LightGBM, SVM, KNN, and XGBoost. These will be the models used for the comparison and find which will be the best for this project based on the accuracy. The dataset is taken from test subjects' brain waves caused by different kinds of music, resulting in a 2x2 label matrix. The labels would be High and low by Valence and Arousal. The main aim is of course, to find the best model with the highest accuracy and functionality, while also understanding the difference the process of artifact removal has effect on the model.

II. Model Framework

a. Input and Output mechanism: Input will be in form of CSV extraction for machine learning models and output will be in scoring matrices, namely F1-score, MAE, and AUC.

b. Signal Processing Techniques:

c. Data Segmentation Methods:

d. Artifact Removal Strategy

e. Feature Extraction Approaches:

f. Machine Learning Model Utilized: EEGNet, LightGBM, SVM, KNN, XGBoost

III. Validation

Methods of validating the accuracy of the model will use F1-Score, MAE (Mean Absolute Error), and AUC. 

IV. Usage

V. Results

VI. References
