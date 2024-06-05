% Set parameter
filePath = 'C:\Users\kevin\Downloads\dataset';
files = dir(fullfile(filePath, '*.set'));
filesNames = {files.name};

numData = 5 % size(filesNames) % to use all

% Initialize
rawICLabelCount = zeros(1,7);
filteredICLabelCount = zeros(1,7);
ASRfilteredICLabelCount = zeros(1,7);

for fileId = 1:numData
    % Load existing dataset
    fileName = char(filesNames(fileId))
    EEG = pop_loadset(fileName, filePath)
    EEG.etc.eeglabvers = '2022.1';
    EEG.etc.eeglabvers = '2024.0';
    
    % (RAW) Get the Label by ICA and ICLabel
    EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'rndreset','yes','interrupt','on','pca',32);
    EEG = pop_iclabel(EEG, 'default');
    [~, rowIndices] = max(EEG.etc.ic_classification.ICLabel.classifications, [], 2);
    for rowIndId = 1:size(rowIndices)
        maxId = rowIndices(rowIndId);
        rawICLabelCount(maxId) = rawICLabelCount(maxId) + 1;
    end

    % High-pass 0.5 Hz
    EEG = pop_eegfiltnew(EEG, 'locutoff',0.5,'plotfreqz',1);
    % Low-pass 120 Hz
    EEG = pop_eegfiltnew(EEG, 'hicutoff',120,'plotfreqz',1);
    % Clean Noise Line 50Hz 100Hz
    EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:33] ,'computepower',1,'linefreqs',[50 100] ,'newversion',0,'normSpectrum',0,'p',0.01,'pad',2,'plotfigures',0,'scanforlines',0,'sigtype','Channels','taperbandwidth',2,'tau',100,'verb',1,'winsize',4,'winstep',1);
    

    % (FILTERED) Get the Label by ICA and ICLabel
    EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'rndreset','yes','interrupt','on','pca',32);
    EEG = pop_iclabel(EEG, 'default');
    [~, rowIndices] = max(EEG.etc.ic_classification.ICLabel.classifications, [], 2);
    for rowIndId = 1:size(rowIndices)
        maxId = rowIndices(rowIndId);
        filteredICLabelCount(maxId) = filteredICLabelCount(maxId) + 1;
    end
    fileName = [fileName(1:end-4), '_filter', fileName(end-3:end)];
    EEG = pop_saveset( EEG, 'filename', fileName,'filepath', filePath);


    % ASR-Corrected
    EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion','off','ChannelCriterion','off','LineNoiseCriterion','off','Highpass','off','BurstCriterion',20,'WindowCriterion','off','BurstRejection','off','Distance','Euclidian');

    % (ASR-CORRECTED) Get the Label by ICA and ICLabel
    EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'rndreset','yes','interrupt','on','pca',32);
    EEG = pop_iclabel(EEG, 'default');
    [~, rowIndices] = max(EEG.etc.ic_classification.ICLabel.classifications, [], 2);
    for rowIndId = 1:size(rowIndices)
        maxId = rowIndices(rowIndId);
        ASRfilteredICLabelCount(maxId) = ASRfilteredICLabelCount(maxId) + 1;
    end
    fileName = [fileName(1:end-4), '_asr', fileName(end-3:end)];
    EEG = pop_saveset( EEG, 'filename', fileName,'filepath', filePath);

end

disp(rawICLabelCount / numData);
disp(filteredICLabelCount / numData);
disp(ASRfilteredICLabelCount / numData);


