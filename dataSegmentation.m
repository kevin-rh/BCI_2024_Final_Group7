EEG.etc.eeglabvers = '2024.0';

% Parameter: Save Format
saveDataAsCSV = 0 % Change to 1 to format data as `.csv`, otherwise `.mat` is used.

% Parameter: File IO 
wkdirPath = '' % Set to the working directory you currently have.
filePath = [wkdirPath, 'preprocessed\'];
savePath = [wkdirPath, 'segmented\'];

files = dir(fullfile(filePath, '*.set'));
filesNames = {files.name};
numFile = size(filesNames, 2);

for fileId = 1:numFile
    % Load  dataset
    fileName = char(filesNames(fileId));   
    disp(fileName); % To Log

    EEG = pop_loadset('filename',[fileName(1:end-4), '.set'],'filepath',filePath);

    % Epoch the EEG as X data and event label as y data, both save as .mat file
    EEG = pop_epoch( EEG, {  }, [0  21], 'epochinfo', 'yes');
    EEGData = EEG.data; 
    EEGEventType = [EEG.urevent.type];
    EEGEventType = cast(EEGEventType(1:size(EEGEventType,2)-1), 'int8');
    
    % Save Segmeneted Data
    if saveDataAsCSV == 0
        save([savePath, 'X\', int2str(fileId), '.mat'],"EEGData");
        save([savePath, 'y\', int2str(fileId), '.mat'],"EEGEventType");
    else
        pop_export(EEG,[savePath, 'X\', int2str(fileId), '.csv'],'separator',',','precision',6);
        writematrix(EEGEventType,[savePath, 'y\', int2str(fileId), '.csv']) 
    end
end

% Get the EEG Channels Labels as a List of String
writecell({EEG.chanlocs.labels},[savePath, 'channelData.csv'])
