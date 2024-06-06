EEG.etc.eeglabvers = '2024.0';

% Set file access parameter
wkdirPath = 'C:\Users\kevin\Downloads\ds002723\';
filePath = [wkdirPath, 'preprocessed\'];
savePath = [wkdirPath, 'segmented\'];

files = dir(fullfile(filePath, '*.set'));

filesNames = {files.name};
numFile = size(filesNames, 2);
for fileId = 1:numFile
    % Load  dataset
    fileName = char(filesNames(fileId));
    disp(fileName);
    EEG = pop_loadset('filename',[fileName(1:end-4), '.set'],'filepath',filePath);

    % Epoch the EEG as X data and event label as y data, both save as .mat file
    EEG = pop_epoch( EEG, {  }, [0  21], 'epochinfo', 'yes');
    EEGData = EEG.data; 
    EEGEventType = [EEG.urevent.type];
    EEGEventType = cast(EEGEventType(1:size(EEGEventType,2)-1), 'int8');

    save([savePath, 'X\', int2str(fileId), '.mat'],"EEGData");
    save([savePath, 'y\', int2str(fileId), '.mat'],"EEGEventType");

    % save([savePath, 'X\', fileName(1:end-4), '.mat'],"EEGData");
    % save([savePath, 'y\', fileName(1:end-4), '.mat'],"EEGEventType");
    
end
