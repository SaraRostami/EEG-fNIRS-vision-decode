% Get a list of all .vhdr files in the current folder
eeglab;
allfiles = dir('*.vhdr');

% Loop through each file
for n = 1:length(allfiles)
    loadName = allfiles(n).name;
    dataName = loadName(1:end-5); % Optional: create a name without the extension

    % Import data using pop_loadbv function
    EEG = pop_loadbv('.', loadName);

    % Name the dataset and add it to the ALLEEG structure
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, 'setname', dataName);
end

% Merge all datasets currently in ALLEEG
EEG = pop_mergeset(ALLEEG, 1:length(ALLEEG));

% Optional: Update the EEGLAB GUI with the new merged dataset
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 0, 'setname', 'merged_dataset', 'overwrite', 'off');
eeglab redraw;
