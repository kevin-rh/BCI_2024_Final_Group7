# Group 7 Final Project
## Brain Computer Interface: Fundamentals and Applications 2024

**Authors**:
Kevin Richardson Halim, Filippo Jonathan Lie, Nathan Jacky Lee

# Task
## A. Experimental Design/Paradigm 
## B. Quality Evaluation
It shows that more layers of the correct type of preprocessing of the EEG data have a direct effect on the time complexity of ICA data decomposition. In this experiment, the iteration results around 115, 75, and 55 in response to raw, filtered, and filtered+ASR(Artifact Subspace Reconstructions), respectively.

EEG: 32-channel, 44-dataset. The working enviroment for this experiment is EEGLAB on MATLAB.
Implemented with FastICA with 32 components. The table below is the average number of ICs classified by ICLabel.
| `Pre-processing` | Brain   | Muscle  | Eye    | Heart | Line Noise | Channel Noise | Other       |
|----------------|---------|---------|--------|-------|------------|---------------|-------------|
| `raw`            | 2.45    | 0.98    | 0.14   | 0     | 0.11       | 0.02          | 28.3       |
| `filtered`       | 14.86   | 6.84    | 0.5   | 0     | 0.43       | 0.11          | 9.25        |
| `ASR-corrected`  | 16.98   | 6.48    | 0.68   | 0.02  | 0.7       | 0.14          | 7        |

From the data above it really shown that the working dataset in this project has a lot of artifact. It shows preprocessing data really helps, it showed by the recognized Brain Components Value's leap from 2.45 to 14.86 even only band-pass filter and cleaning line noise. The improvment also occur on the data after getting a reconstructions by ASR algorithms. Either way the algorithm does not really a reliable way to solve these problem of artifact in EEG, it showed that it still canot recognize a 7 unclassified signal.


# 1. Experimental Design
   
   <img width="366" alt="image" src="https://github.com/kevin-rh/BCI_2024_Final_Group7/assets/134197756/4875b3b8-6af1-4c95-8dbe-fb7bdb3f1547">

The project starts from Data Preprocessing and divided into 2 methods, where 1 will immediately receive feature extraction, Model training and testing, followed by output, while the other will receive artifact removal first before the other process.

# 2. Procedure of Data Collection

Data Collection is not done manually and is taken from pre-existing data as instructed. The dataset can be accessed from : https://nemar.org/dataexplorer/detail?dataset_id=ds002723. 

Initial Collection Purpose:
To investigate the performance of a real-time and online brain-computer interface that identified the user’s emotional state and modified music on-the-fly in order to induce a target emotional state.

Experiment method:
Each participant listens to 60 seconds of music. The first 20 seconds puts the participant in emotional state A, while the last 20 seconds puts them in emotional state B. The middle 20 seconds is used to transition from A to B and to figure out what state the participant is actually in. The sampling rate is 1 kHz and all music used was generated with a synthetic music generator.

Classes/Labels: there are 9 different labels, with "valence" and "arousal" each having "low", "neutral", and "high".
Participants: 8 healthy adults 19-30 years old

# 3. Hardware and Software Used

   Hardware: Personal Laptops and devices
   
   Software: EEGlab, Matlab, Google Collab (Python), Microsoft Office
   
   Website: HackMD, Github

## I. Introduction

The project revolves around a comparison study within the model and dataset. As the flowchart provided above, the key feature of difference would be a comparison of the artifact removal, as it will prove to have/don't have an effect on the accuracy of the BCI model. The BCI system will be using Machine Learning Models, namely EEGNet [2], LightGBM, SVM, KNN, and XGBoost. These will be the models used for the comparison and find which will be the best for this project based on the accuracy. The dataset is taken from test subjects' brain waves caused by different kinds of music, resulting in a 2x2 label matrix. The labels would be High and low by Valence and Arousal. The main aim is of course, to find the best model with the highest accuracy and functionality, while also understanding the difference the process of artifact removal has effect on the model.

## II. Model Framework

### a. Input and Output mechanism
Input will be in the `.edf` format and read into EEGLAB with BIOSIG plugin. It wil went through a process where it will be formated into `.mat` to be used later in Python code.
The python will read `.mat` format file which already contain input and label data 

### b. Signal Preprocessing Techniques
Signal preprocessing will be treated with a band pass filtering from the 0.5Hz threshold below and 120Hz threshold above which done sepreately suggested from the comunity.
Using Cleanline EEGLAB plugins, the data got band pass filtered for the 50Hz and 100Hz which is the Line Noise. This information collected from the dataset's metadata.
The will got through the further artifact removal with ASR and ICA/ICLabel threshold remove bad components and reconstruction.

### c. Data Segmentation Methods
Data segmented in the EEGLAB with the help of GUI to segment the data from 0 to the 21 second from the event time onset occurence.

### d. Artifact Removal Strategy
Our approach implemented in EEGLAB (MATLAB) as the `dataPreprocess.m` where we implement Artifact Subspace Reconstruction (ASR) with a window of 20 seconds which is optimal from a paper [3].
The reconstructed data by ASR algorithm will go through Independent Component Analysis (ICA), which using FastICA algorithm provided by Picard EEGLAB plugin with a component of 32.
Removing all other data except `Other` and `Brain` signal detected by ICLabel EEGLAB plugin. The other component will be deleted if the confidentality values is 80% to 100%. We set the threshold of 0.8 to 1.

### e. Feature Extraction Approaches
Our approach on feature extration would be implementing MNE-features library. 

### f. Machine Learning Model Utilized
EEGNet [2], LightGBM, SVM, KNN, XGBoost

## III. Validation

Methods of validating the accuracy of the model will use F1-Score, MAE (Mean Absolute Error), and AUC. 

## IV. Usage

## V. Results

## VI. References
1. Williams, D., Kirke, A., Miranda, E.R., Daly, I., Hwang, F., Weaver, J., Nasuto, S.J., “Affective Calibration of Musical Feature Sets in an Emotionally Intelligent Music Composition System”, ACM Trans. Appl. Percept. 14, 3, Article 17 (May 2017), 13 pages. DOI: https://doi.org/10.1145/3059005 [ [site](https://nemar.org/dataexplorer/detail?dataset_id=ds002723
) | [PDF](https://dl.acm.org/doi/pdf/10.1145/3059005) ]

2. Lawhern VJ, Solon AJ, Waytowich NR, Gordon SM, Hung CP, Lance BJ. EEGNet: a compact convolutional neural network for EEG-based brain-computer interfaces. J Neural Eng. 2018 Oct;15(5):056013. doi: 10.1088/1741-2552/aace8c. Epub 2018 Jun 22. PMID: 29932424. DOI: https://doi.org/10.48550/arXiv.1611.08024 [ [PDF](https://arxiv.org/pdf/1611.080245) ]

3. Chang CY, Hsu SH, Pion-Tonachini L, Jung TP. Evaluation of Artifact Subspace Reconstruction for Automatic Artifact Components Removal in Multi-Channel EEG Recordings. IEEE Trans Biomed Eng. 2020 Apr;67(4):1114-1121. doi: 10.1109/TBME.2019.2930186. Epub 2019 Jul 22. PMID: 31329105. [ [site](https://pubmed.ncbi.nlm.nih.gov/31329105/) | [PDF](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8768041) ]
