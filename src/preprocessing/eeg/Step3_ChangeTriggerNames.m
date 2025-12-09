%% Load the event file
% E = readtable('EventFile.csv', 'TextType', 'string');
E = EventFile;

% Extract useful columns
trialNum  = E.trial_number;
imgName   = E.image_name;
blockNum  = E.block_number;
category  = E.image_category;

% Pre-generate new trigger labels
newNames = strings(height(E), 1);

%% Category abbreviation dictionary
for i = 1:height(E)
    
    % Extract numeric part from the filename
    token = regexp(imgName(i), '(\d+)', 'match');

    if isempty(token)
        % For fixationCross / null
        if imgName(i) == "fixationCross.png"
            imgCode = "fix";
        elseif imgName(i) == "null.png"
            imgCode = "null";
        else
            imgCode = "xxx"; % fallback
        end
    else
        % numeric part -> zero-pad to 3 digits
        imgCode = sprintf('%03d', str2double(token{1}));
    end

    % Category abbreviation
    switch category(i)
        case "Animals"
            catCode = "ANIM";
        case "Objects"
            catCode = "OBJ";
        case "Scenes"
            catCode = "SCENE";
        case "People"
            catCode = "PPL";
        case "Faces"
            catCode = "FACE";
        case "fixationCross"
            catCode = "FIX";
        case "null"
            catCode = "NULL";
        otherwise
            catCode = "UNK";
    end

    % Build full trigger name
    newNames(i) = "B" + blockNum(i) + ...
                  "_T" + sprintf('%03d', trialNum(i)) + ...
                  "_IMG" + imgCode + ...
                  "_" + catCode;
end

%% Rename EEG events
if length(EEG.event) ~= height(E)
    error('Mismatch: EEG.event (%d) ≠ CSV trials (%d).', ...
          length(EEG.event), height(E));
end

for n = 1:length(EEG.event)
    EEG.event(n).type = newNames(n);
end

EEG = eeg_checkset(EEG, 'eventconsistency');
eeglab redraw;

disp('EEG events updated with new trigger names.');

%%
% Extract all event type names
types = {EEG.event.type};

% Convert to string array for easier handling
types = string(types);

% Find events containing banned category codes
removeIdx = endsWith(types, "_FIX") | ...
            endsWith(types, "_NULL") | ...
            endsWith(types, "_UNK");

% Keep only events NOT in removeIdx
EEG.event = EEG.event(~removeIdx);

% Recompute consistency fields
EEG = eeg_checkset(EEG, 'eventconsistency');

eeglab redraw;

fprintf('Removed %d FIX/NULL/UNK events.\n', sum(removeIdx));
