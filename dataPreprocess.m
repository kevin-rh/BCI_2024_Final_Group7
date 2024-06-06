EEG.etc.eeglabvers = '2024.0';
totalData = 0;

% Set File IO parameter
wkdirPath = 'C:\Users\kevin\Downloads\ds002723\';
filePath = [wkdirPath, 'ds002723\'];
savePath = [wkdirPath, 'preprocessed\'];

patientFolders = dir(fullfile(filePath, 'sub-*'));
patientFolders = {patientFolders.name};
numPatient = size(patientFolders, 2);

for folderId = 1:numPatient
    curPath = [filePath, '\', char(patientFolders(folderId)), '\eeg'];
    filesName = dir(fullfile(curPath, '*.edf'));

    filesName = {filesName.name};
    numFile = size(filesName, 2);
    totalData = totalData + numFile;

    for fileId = 1:numFile
        % Load  dataset
        fileName = char(filesName(fileId));
        curFile = [curPath, '\', fileName];   
        EEG = pop_biosig(curFile);       

        % Remove non-EEG Channels
        EEG = pop_select( EEG, 'rmchannel',{'GSR','ECG','VA1','VA2'});

        % Set Channels Location
        EEG = pop_chanedit(EEG, 'load',{[filePath, '\channel-we-use.ced'],'filetype','autodetect'});

        % FIR EEG
        % Passband 0.5-120 Hz
        % % Clean Line Noise 50Hz 100Hz
        EEG = pop_eegfiltnew(EEG, 'locutoff',0.5,'plotfreqz',0);
        EEG = pop_eegfiltnew(EEG, 'hicutoff',120,'plotfreqz',0);
        EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:32] ,'computepower',1,'linefreqs',[50 100] ,'newversion',0,'normSpectrum',0,'p',0.01,'pad',2,'plotfigures',0,'scanforlines',0,'sigtype','Channels','taperbandwidth',2,'tau',100,'verb',1,'winsize',4,'winstep',1);

        % ASR EEG
        EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion','off','ChannelCriterion','off','LineNoiseCriterion','off','Highpass','off','BurstCriterion',20,'WindowCriterion','off','BurstRejection','off','Distance','Euclidian');
        
        % ICLabel Reject Bad Components
        EEG = pop_runica(EEG, 'icatype', 'picard', 'maxiter',500);
        EEG = pop_iclabel(EEG, 'default');
        EEG = pop_icflag(EEG, [NaN NaN; 0.8 1; 0.8 1; 0.8 1; 0.8 1; 0.8 1; NaN NaN]);

        % Reconstruct Good Components
        EEG = pop_subcomp( EEG, [], 0);
        
        % Save as a MATLAB dataset (.set) format
        EEG = pop_saveset( EEG, 'filename',[fileName(1:end-4), '.set'],'filepath',savePath);
    end
end
