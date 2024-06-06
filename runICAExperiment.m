% Initialize
ICLabelCount = zeros(3,7);

totalData = 0;

% Set file access parameter
savePath = 'C:\Users\kevin\Downloads\ds002723\preprocessed\';

filePath = 'C:\Users\kevin\Downloads\ds002723\ds002723';
patientFolders = dir(fullfile(filePath, 'sub-*'));
patientFolders = {patientFolders.name};
numPatient = size(patientFolders, 2);

EEG.etc.eeglabvers = '2024.0';


for folderId = 1:numPatient
    curPath = [filePath, '\', char(patientFolders(folderId)), '\eeg'];
    files = dir(fullfile(curPath, '*.edf'));

    filesNames = {files.name};
    numFile = size(filesNames, 2);
    totalData = totalData + numFile;

    for fileId = 1:numFile
        % Load  dataset
        fileName = char(filesNames(fileId));
        curFile = [curPath, '\', fileName];   
        EEG = pop_biosig(curFile);       

        % Remove non-EEG Channels
        EEG = pop_select( EEG, 'rmchannel',{'GSR','ECG','VA1','VA2'});

        % Set Channels Location
        EEG = pop_chanedit(EEG, 'load',{'C:\Users\kevin\Downloads\ds002723\ds002723\channel-we-use.ced','filetype','autodetect'});
        EEG = pop_runica(EEG, 'pca', 32, 'icatype', 'picard', 'maxiter',500);
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
        
        EEG = pop_runica(EEG, 'icatype', 'picard', 'maxiter',500);
        EEG = pop_iclabel(EEG, 'default');
        [~, rowIndices] = max(EEG.etc.ic_classification.ICLabel.classifications, [], 2);
        for rowIndId = 1:size(rowIndices)
            maxId = rowIndices(rowIndId);
            ICLabelCount(2, maxId) = ICLabelCount(2, maxId) + 1;
        end

        % ASR-Corrected the EEG
        EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion','off','ChannelCriterion','off','LineNoiseCriterion','off','Highpass','off','BurstCriterion',20,'WindowCriterion','off','BurstRejection','off','Distance','Euclidian');
        
        EEG = pop_runica(EEG, 'icatype', 'picard', 'maxiter',500);
        EEG = pop_iclabel(EEG, 'default');
        [~, rowIndices] = max(EEG.etc.ic_classification.ICLabel.classifications, [], 2);
        for rowIndId = 1:size(rowIndices)
            maxId = rowIndices(rowIndId);
            ICLabelCount(3, maxId) = ICLabelCount(3, maxId) + 1;
        end
        
        EEG = pop_saveset( EEG, 'filename',[fileName(1:end-4), '.set'],'filepath',savePath);
    end
end

avgICLabelCount = ICLabelCount/totalData;
disp(avgICLabelCount);
