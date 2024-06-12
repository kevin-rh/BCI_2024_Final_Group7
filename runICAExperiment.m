EEG.etc.eeglabvers = '2024.0';

% Initialize
ICLabelCount = zeros(3,7);
totalData = 0;

% Parameter: File IO 
wkdirPath = 'C:\Users\kevin\Downloads\ds002723\'; % Set to the working directory you currently have.
filePath = [wkdirPath, 'ds002723\'];
savePath = [wkdirPath, 'preprocessed\'];

patientFolders = dir(fullfile(filePath, 'sub-*'));
patientFolders = {patientFolders.name};
numPatient = size(patientFolders, 2);

for folderId = 1:numPatient
    curPath = [filePath, '\', char(patientFolders(folderId)), '\eeg'];
    filesName = dir(fullfile(curPath, '*.edf'));

    filesNames = {filesName.name};
    numFile = size(filesNames, 2);

    for fileId = 1:numFile
        % Load  dataset
        fileName = char(filesNames(fileId));
        curDataPath = [curPath, '\', fileName];   
        EEG = pop_biosig(curDataPath);       

        % Remove non-EEG Channels
        EEG = pop_select( EEG, 'rmchannel',{'GSR','ECG','VA1','VA2'});

        % Set Channels Location
        EEG = pop_chanedit(EEG, 'load',{[filePath, '\channel-we-use.ced'],'filetype','autodetect'});
        
        % Experiment 1
        EEG = pop_runica(EEG, 'icatype', 'picard', 'maxiter',500);
        EEG = pop_iclabel(EEG, 'default');
        [~, rowIndices] = max(EEG.etc.ic_classification.ICLabel.classifications, [], 2);
        for rowIndId = 1:size(rowIndices)
            maxId = rowIndices(rowIndId);
            ICLabelCount(1, maxId) = ICLabelCount(1, maxId) + 1;
        end

        % Filter the EEG 
        % Passband 0.5-120 Hz
        % % Clean Line Noise 50Hz 100Hz
        EEG = pop_eegfiltnew(EEG, 'locutoff',0.5,'plotfreqz',1);
        EEG = pop_eegfiltnew(EEG, 'hicutoff',120,'plotfreqz',1);
        EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:32] ,'computepower',1,'linefreqs',[50 100] ,'newversion',0,'normSpectrum',0,'p',0.01,'pad',2,'plotfigures',0,'scanforlines',0,'sigtype','Channels','taperbandwidth',2,'tau',100,'verb',1,'winsize',4,'winstep',1);
        
        % Experiment 2
        EEG = pop_runica(EEG, 'icatype', 'picard', 'maxiter',500);
        EEG = pop_iclabel(EEG, 'default');
        [~, rowIndices] = max(EEG.etc.ic_classification.ICLabel.classifications, [], 2);
        for rowIndId = 1:size(rowIndices)
            maxId = rowIndices(rowIndId);
            ICLabelCount(2, maxId) = ICLabelCount(2, maxId) + 1;
        end

        % ASR-Corrected the EEG
        EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion','off','ChannelCriterion','off','LineNoiseCriterion','off','Highpass','off','BurstCriterion',20,'WindowCriterion','off','BurstRejection','off','Distance','Euclidian');
        
        % Experiment 3 & ICLabel save
        EEG = pop_runica(EEG, 'icatype', 'picard', 'maxiter',500);
        EEG = pop_iclabel(EEG, 'default');
        [~, rowIndices] = max(EEG.etc.ic_classification.ICLabel.classifications, [], 2);
        for rowIndId = 1:size(rowIndices)
            maxId = rowIndices(rowIndId);
            ICLabelCount(3, maxId) = ICLabelCount(3, maxId) + 1;
        end

        % Remove Bad Components and Reconstruct Good Components
        EEG = pop_icflag(EEG, [NaN NaN; 0.8 1; 0.8 1; 0.8 1; 0.8 1; 0.8 1; NaN NaN]);
        EEG = pop_subcomp( EEG, [], 0);
        
        % Save as a MATLAB dataset (.set) format
        EEG = pop_saveset( EEG, 'filename',[fileName(1:end-4), '.set'],'filepath',savePath);

        totalData = totalData + 1;
    end
end

% Display & Save Result
avgICLabelCount = ICLabelCount/totalData;
disp(avgICLabelCount);
writecell({avgICLabelCount},[savePath, 'experimentResult.csv'])
