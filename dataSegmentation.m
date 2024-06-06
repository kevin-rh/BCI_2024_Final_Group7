EEG.etc.eeglabvers = '2024.0';

% Set file access parameter
filePath = 'C:\Users\kevin\Downloads\ds002723\preprocessed\';
savePath = 'C:\Users\kevin\Downloads\ds002723\segmented\';

files = dir(fullfile(filePath, '*.set'));

filesNames = {files.name};
numFile = size(filesNames, 2);
for fileId = 30:numFile
    % Load  dataset
    fileName = char(filesNames(fileId));
    disp(fileName);
    EEG = pop_loadset('filename',[fileName(1:end-4), '.set'],'filepath',filePath);

    % Epoch the EEG as X data and event label as y data, both save as .mat file
    EEG = pop_epoch( EEG, {  }, [0  21], 'epochinfo', 'yes');
    EEGData = EEG.data; 
    EEGEventType = [EEG.urevent.type];
    EEGEventType = cast(EEGEventType(1:size(EEGEventType,2)-1), 'int8');

    save([savePath, 'X\', char(fileId + '0'), '.mat'],"EEGData");
    save([savePath, 'y\', char(fileId + '0'), '.mat'],"EEGEventType");

    % save([savePath, 'X\', fileName(1:end-4), '.mat'],"EEGData");
    % save([savePath, 'y\', fileName(1:end-4), '_event.mat'],"EEGEventType");
end