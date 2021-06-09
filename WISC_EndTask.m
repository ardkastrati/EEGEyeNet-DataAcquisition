if par.recordEEG
    NetStation('StopRecording');
end
if par.useEL
    fprintf('Stop Recording\n');
    Eyelink('StopRecording'); %Stop Recording
    Eyelink('Command', 'clear_screen 0');
    Eyelink('CloseFile');
    fprintf('Downloading File\n');
    EL_DownloadDataFile % Downloading the file
    EL_Cleanup;
end

save([savePath,num2str(par.runID), '_WI',num2str(par.block)],'par', 'trial_duration','perf', 'x', 'y', 'whichButton', 'pageOrders', 'errorcor','resp_cross');
clearvars -except select subj_ID metafile subj_Name app event;
close all;
sca;
try
    PsychPortAudio('Close');
catch
end