# Group 7 Final Project
## Brain-Computer Interface: Fundamentals and Applications 2024

**Authors**:
Kevin Richardson Halim, Filippo Jonathan Lie, Nathan Jacky Lee

# A. Overview 
## 1. Experimental Design
<img width="366" alt="image" src="https://github.com/kevin-rh/BCI_2024_Final_Group7/assets/134197756/4875b3b8-6af1-4c95-8dbe-fb7bdb3f1547">

The project starts with Data Preprocessing is divided into 2 methods, where 1 will immediately receive feature extraction, model training-testing, followed by output, while the other will receive artifact removal first before the other process.

## 2. Procedure of Data Collection
Data Collection is not done manually and is taken from pre-existing data as instructed. 

Initial Collection Purpose:
To investigate the performance of a real-time and online brain-computer interface that identified the user’s emotional state and modified music on-the-fly in order to induce a target emotional state.

Experiment method:
Each participant listens to 60 seconds of music. The first 20 seconds put the participant in emotional state A, while the last 20 seconds put them in emotional state B. The middle 20 seconds are used to transition from A to B and to figure out what state the participant is actually in. The sampling rate is 1 kHz and all music used was generated with a synthetic music generator.

Classes/Labels: there are 9 different labels, with "valence" and "arousal" each having "low", "neutral", and "high".
Participants: 8 healthy adults 19-30 years old

## 3. Hardware and Software Used
- Hardware: Personal Laptop (AMD Ryzen 9 4900H, clockspeed of 3.30 GHz, memory of 16.0 GB).
- Software:
- Operating System: Windows 10 (v19045.4412, 64-bit).
- Internal Software: EEGLAB, MATLAB, Microsoft Office, Python (conda).
- Website: HackMD, Github, Google Collab Notebook (Python). 

## 4. Data Information
The dataset comprises data from 8 subjects. The sampling rate is 1 kHz and the music listening task corresponding to a music clip is 60 s long (clip duration). 
Each subject consists of multiple runs. the total run from all the patients is 44 runs. In a run, it can consist of multiple epochs of music-listening tasks where it the patients are asked to input the emotion state. 

Later the input state from the patients will be the label to be predicted in this project. The dataset has nine emotional states at the start of each trial: 1-LVLA, 2-NVLA, 3-HVLA, 4-LVNA, 5-NVNA, 6-HVNA, 7-LVHA, 8-NVHA, and 9-HVHA. Each label combines valence (positive or negative) and arousal (intensity).

EEG waves were collected with a 10-20 System of EEG Electrode Placement. In this dataset it has 32 channels: FP1, FPz, FP2, F7, F3, Fz, F4, F8, FT9, FC5, FC1, FC2, FC6, FT10, T7, C3, Cz, C4, T8, TP9, CP5, CP1, CP2, CP6, TP10, P7, P3, Pz, P4, P8, O1, O2. The powerline frequency in the data experiment is 50Hz. More detailed information can be gathered in their paper [1].

## 5. Website Origin 
Williams, D., Kirke, A., Miranda, E.R., Daly, I., Hwang, F., Weaver, J., Nasuto, S.J., “Affective Calibration of Musical Feature Sets in an Emotionally Intelligent Music Composition System”, ACM Trans. Appl. Percept. 14, 3, Article 17 (May 2017), 13 pages. DOI: https://doi.org/10.1145/3059005 [ [site](https://nemar.org/dataexplorer/detail?dataset_id=ds002723
) | [PDF](https://dl.acm.org/doi/pdf/10.1145/3059005) ]

# B. Data Quality Evaluation
It shows that more layers of the correct type of preprocessing of the EEG data have a direct effect on the time complexity of ICA data decomposition. In this experiment, the iteration results around 115, 75, and 55 in response to raw, filtered, and filtered+ASR(Artifact Subspace Reconstructions), respectively.

EEG: 32-channel, 44-dataset. The working environment for this experiment is EEGLAB on MATLAB.
Implemented with FastICA with 32 components. The table below is the average number of ICs classified by ICLabel.
| `Pre-processing` | Brain   | Muscle  | Eye    | Heart | Line Noise | Channel Noise | Other       |
|----------------|---------|---------|--------|-------|------------|---------------|-------------|
| `raw`            | 2.45    | 0.98    | 0.14   | 0     | 0.11       | 0.02          | 28.3       |
| `Band-pass filtered`       | 14.86   | 6.84    | 0.5   | 0     | 0.43       | 0.11          | 9.25        |
| `ASR-corrected`  | 16.98   | 6.48    | 0.68   | 0.02  | 0.7       | 0.14          | 7        |

The data above shows that the working dataset in this project has a lot of artifacts. It shows preprocessing data has a positive effect towards the dataset. It showed by the recognized Brain Components Value's leap from 2.45 to 14.86 even with only the band-pass filter and cleaning line noise. The improvement also occurs on the data after getting a reconstruction by ASR algorithms. Either way, the algorithm does not have a reliable way to solve these problems of artifacts in EEG, it showed that it still cannot recognize a 7 unclassified signal.

# C. Report

## I. Introduction

The project revolves around a comparison study within the model and dataset. As the flowchart provided above, the key feature of difference would be a comparison of the artifact removal, as it will prove to have/do not effect on the accuracy of the BCI model. The BCI system will be using Machine Learning Models, namely EEGNet [2], LightGBM, SVM, KNN, and XGBoost. These will be the models used for the comparison and find which will be the best for this project based on the accuracy. The dataset is taken from test subjects' brain waves caused by different kinds of music, resulting in a 2x2 label matrix. The labels would be High and low by Valence and Arousal. The main aim is, of course, to find the best model with the highest accuracy and functionality, while also understanding the difference the process of artifact removal affect on the model.

## II. Model Framework

### a. Input and Output mechanism
Input will be in the `.edf` format and read into EEGLAB with the BIOSIG plugin. It will go through a process where it will be formatted into `.mat` to be used later in Python code.
The python will read the `.mat` format file which already contains input and label data. The data is then processed in Python and will go into each code's format with the help of `pandas` and `numpy`.

### b. Signal Preprocessing Techniques
Signal preprocessing will be treated with a band pass filtering from the 0.5Hz threshold below and 120Hz threshold above which is done separately suggested by the community.
Using Cleanline EEGLAB plugins, the data got bandpass filtered for 50Hz and 100Hz which is the Line Noise. This information is collected from the dataset's metadata.
They will go through further artifact removal with ASR and ICA/ICLabel threshold to remove bad components and reconstruction.

### c. Data Segmentation Methods
Data is segmented in the EEGLAB with the help of GUI to segment the data from 0 to 21 seconds from the event time onset occurrence.
As a result, the data is segmented by Epoch and saved in a `.mat` format.

### d. Artifact Removal Strategy
Our approach is implemented in EEGLAB (MATLAB) as the `dataPreprocess.m` where we implement Artifact Subspace Reconstruction (ASR) with a window of 20 seconds which is optimal from a paper [3].
The reconstructed data by ASR algorithm will go through Independent Component Analysis (ICA), which uses the FastICA algorithm provided by the Picard EEGLAB plugin with a component of 32.
Removing all other data except the `Other` and `Brain` signals detected by the ICLabel EEGLAB plugin. The other component will be deleted if the confidentiality value is 80% to 100%. We set the threshold of 0.8 to 1.
### e. Feature Extraction Approaches
Our approach to feature extraction would be implementing an MNE-features library. 

### f. Machine Learning Model Utilized
EEGNet [2], LightGBM, SVM, KNN, XGBoost.

## III. Validation
Methods of validating the accuracy of the model will use F1-Score, MAE (Mean Absolute Error), and AUC. 

## IV. Usage
With the file structure of the `ds002723` dataset, the working directory inside each MATLAB code and Python code needs to be changed accordingly.

### Dependency
```
MATLAB Plugins:
- EEGLab v2024.0

EEGLAB Plugins:
- Included: ICLabel, ICA, ChannelLocate, etc.
- BIOSIG (to read data)
- Cleanline v2.00 (to clean 50Hz 100Hz line noise)
- PICARD v1.0 (to use the implementation of FastICA decomposing)

Python v3.9.7. Libraries:
- MNE https://mne.tools/stable/install/index.html
- PyTorch https://pytorch.org/
- Scikit-Learn https://scikit-learn.org/stable/index.html
- LightGBM https://lightgbm.readthedocs.io/en/latest/index.html
- XGBoost https://xgboost.readthedocs.io/en/stable/install.html

Channel location (in this case .ced is used):
- Set the channel location for one dataset then save the channel location. 
- Done by GUI of EEGLab on the: https://eeglab.org/tutorials/04_Import/Channel_Locations.html

File Structure and Access:
- Provided in a MATLAB code file in this repo named as `runICAExperiment.m`.
- Each patient is denoted as `sub-` or subject.
- Each inside of `sub-` has multiple runs in the folder distinct as `run-`.
- Data is inside the `.esd` format read with BIOSIG in MATLAB.
```

### Code Instructions and Configurations
```
MATLAB:
Run `dataPreprocess.m` in MATLAB:
1. Pre-processing:
 a. Filter (Low, High Pass, Line Noise Removal).
 b. Data correction by ASR Algorithm.
2. IC Labeling: by the ICA and ICLabel functions.
3. Reject bad components which set 0.8-1 as the threshold to all, except EEG and Other.
4. Save the Pre-processed dataset in a folder `/preprocessed`.

Run `dataSegmentation.m` in MATLAB:
1. Segment the data by the event `.tsv` data.

Python:
Run `featureExtractions.py` in python3:
1. Feature extract
2. Separated train and test data.
3. Save the data with format.

Run files on folder '\model' in python3:
1. To train the model.
2. Predict and validate/test model.
3. Output matrix that will be compared later.
```


## V. Results

## VI. References
1. Williams, D., Kirke, A., Miranda, E.R., Daly, I., Hwang, F., Weaver, J., Nasuto, S.J., “Affective Calibration of Musical Feature Sets in an Emotionally Intelligent Music Composition System”, ACM Trans. Appl. Percept. 14, 3, Article 17 (May 2017), 13 pages. DOI: https://doi.org/10.1145/3059005 [ [site](https://nemar.org/dataexplorer/detail?dataset_id=ds002723
) | [PDF](https://dl.acm.org/doi/pdf/10.1145/3059005) ]

2. Lawhern VJ, Solon AJ, Waytowich NR, Gordon SM, Hung CP, Lance BJ. EEGNet: a compact convolutional neural network for EEG-based brain-computer interfaces. J Neural Eng. 2018 Oct;15(5):056013. doi: 10.1088/1741-2552/aace8c. Epub 2018 Jun 22. PMID: 29932424. DOI: https://doi.org/10.48550/arXiv.1611.08024 [ [PDF](https://arxiv.org/pdf/1611.080245) ]

3. Chang CY, Hsu SH, Pion-Tonachini L, Jung TP. Evaluation of Artifact Subspace Reconstruction for Automatic Artifact Components Removal in Multi-Channel EEG Recordings. IEEE Trans Biomed Eng. 2020 Apr;67(4):1114-1121. doi: 10.1109/TBME.2019.2930186. Epub 2019 Jul 22. PMID: 31329105. [ [site](https://pubmed.ncbi.nlm.nih.gov/31329105/) | [PDF](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8768041) ]
