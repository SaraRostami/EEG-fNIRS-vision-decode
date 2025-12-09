% Keep only events where EEG.event.type equals 'S 1'
keepIdx = strcmp({EEG.event.type}, 'S  1');

% Apply the filter
EEG.event = EEG.event(keepIdx);

% Recompute event-related indices
EEG = eeg_checkset(EEG, 'eventconsistency');

% Update the EEGLAB GUI if open
eeglab redraw;
