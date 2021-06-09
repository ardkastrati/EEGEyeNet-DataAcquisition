clear global;
cd /home/stimuluspc/Dropbox/StimulusPresentation;

input = questdlg('Start new session or pick up on existing one?','CMI-EEG','New','Existing','New');
switch input
    case 'New'
        metafile.entryPoint = 0;
        subj_Name =inputdlg({'Enter Subjects ID:'},'CMI-EEG',1,{''});
        metafile.tasks = {};
        metafile.subject = subj_Name;
        if str2double(subj_Name{1,1}) > 999, error('Invalid Subject ID'), end;
        
        cd /home/stimuluspc/Dropbox/StimulusPresentation;
        while exist(['All_Subjects/',subj_Name{1,1},'/',subj_Name{1,1}, '_metafile.mat'],'file')~=0
            subj_Name =inputdlg({'Subject ID already taken! Choose a different one:'},'CMI-EEG',1,{''});
            if str2double(subj_Name{1,1}) > 999, error('Invalid Subject ID'), end;
        end
        mkdir(['All_Subjects/',subj_Name{1,1}])
        save(['All_Subjects/',subj_Name{1,1},'/',subj_Name{1,1}, '_metafile'],'metafile');
        
    case 'Existing'
        subj_Name =inputdlg({'Enter Subjects ID:'},'CMI-EEG',1,{''});
        
        if ~exist(['All_Subjects/',subj_Name{1,1},'/',subj_Name{1,1}, '_metafile.mat'],'file') >0
            error('Subject ID doesnt exist');
        else
            load(['All_Subjects/',subj_Name{1,1},'/',subj_Name{1,1}, '_metafile.mat']);
            if metafile.entryPoint
                selected = listdlg('PromptString','Where to pick up?','SelectionMode','single','ListString', {'Resting State EEG',...
                    'Visual Learning','Processing Speed','Surround Supp. 1','Contrast Change 1',...
                    'Contrast Change 2','Contrast Change3','Surround Supp. 2','Antisaccade','Simple Span'},'InitialValue',metafile.entryPoint);
                if selected ~= metafile.entryPoint
                    input = questdlg('You selected a different paradigm than the one you stopped on on the previous run, is this correct?','CMI-EEG','Yes','No','Yes');
                    switch input
                        case 'No'
                            selected = listdlg('PromptString','Please RESELECT','SelectionMode','single','ListString', {'Resting State EEG',...
                                'Visual Learning','Processing Speed','Surround Supp. 1','Contrast Change 1',...
                                'Contrast Change 2','Contrast Change3','Surround Supp. 2','Antisaccade','Simple Span'},'InitialValue',metafile.entryPoint);
                    end
                end
                
                
            else
                selected = listdlg('PromptString','Where to pick up?','SelectionMode','single','ListString', {'Resting State EEG',...
                    'Visual Learning','Processing Speed','Surround Supp. 1','Contrast Change 1',...
                    'Contrast Change 2','Contrast Change3','Surround Supp. 2','Antisaccade','Simple Span'});
            end
            metafile.entryPoint = selected;
            clear selected;
        end
end

if metafile.entryPoint == 0
    input = questdlg('Will EEG be recorded?','CMI-EEG','Yes','No','Yes');
    switch input
        case 'Yes'
            questdlg('Have you started a Session in Netstation','CMI-EEG','YES','YES');
            [status,info] = NetStation('Connect','100.1.1.3',55513);
            NetStation('Synchronize');
            WaitSecs(1);
            if status ~= 0
                error(info);
            end
        case 'No'
    end
else
    input = questdlg('Is the NetStation Session still running an connected?','CMI-EEG','Yes','No','Yes');
    switch input
        case 'No'
            subj_Name{1,2}=1;
            questdlg('Start a Session in Netstation','CMI-EEG','OK','OK');
            [status,info] = NetStation('Connect','100.1.1.3',55513);
            NetStation('Synchronize');
            WaitSecs(1);
            if status ~= 0
                error(info);
            end
    end
end
%% PANAS
if metafile.entryPoint<1
    input=questdlg('Would you like to start with the PANAS','CMI-EEG');
    switch input
        case 'Cancel'
            return;
        case 'Yes'
            metafile.tasks{end+1,1} = 'Panas';
            metafile.tasks{end,2} = input;
            subj_ID=inputdlg({'Enter Subjects ID:', 'Enter Date:'},'CMI-EEG',1,{subj_Name{1,1},date});
            clc;
            disp('Starting PANAS');
            PANAS;
            %movefile([subj_Name{1,1},'_RES.mat'],['All_Subjects/',subj_Name{1,1},'/']); %FEHLER DATEI VERZ
    end
    save(['All_Subjects/',subj_Name{1,1},'/',subj_Name{1,1}, '_metafile'],'metafile');
    
end

%% Resting State EEG
if metafile.entryPoint<2
    input=questdlg('Would you like to start the Resting-EEG?','CMI-EEG');
    switch input
        case 'Cancel'
            return;
        case 'Yes'
            metafile.tasks{end+1,1} = 'Resting';
            metafile.tasks{end,2} = input;
            subj_ID=inputdlg({'Enter Subjects ID:', 'Enter Date:','Use EEG:', 'Use Eye-Tracker:', 'Eye-Tracker Calibration:'},'CMI-EEG',1,{subj_Name{1,1},date,'y','y', 'y'});
            clc;
            disp('Starting Resting EEG');
            Resting_EEG;
            %movefile([subj_Name{1,1},'_RES.mat'],['All_Subjects/',subj_Name{1,1},'/']); %FEHLER DATEI VERZ
    end
    save(['All_Subjects/',subj_Name{1,1},'/',subj_Name{1,1}, '_metafile'],'metafile');
    
end
%% Visual Learning
if metafile.entryPoint<3
    input=questdlg('Would you like to start the Visual Learning Paradigm?');
    switch input
        case 'Cancel'
            return;
        case 'Yes'
            metafile.tasks{end+1,1} = 'Visual_Learning';
            metafile.tasks{end,2} =  input;
            subj_ID =inputdlg({'Enter Subjects ID:', 'Enter Date:','Use EEG:', 'Use Eye-Tracker:', 'Eye-Tracker Calibration:'},'CMI-EEG',1,{subj_Name{1,1},date,'y','y', 'y'});
            if strcmp(subj_ID(6,1),'y')
                clc;
                disp('Starting Visual Learning Example');
                Sequence_Learning_CMI_Circle_Example
            end
            input2=questdlg('Would you like to start the actual task?');
            switch input2
                case 'Cancel'
                    return;
                case 'Yes'
                    clc;
                    disp('Starting Visual Learning Task');
                    
                    seqBlock=1;
                    Sequence_Learning_CMI_Circle
                    seqBlock=2;
                    Sequence_Learning_CMI_Circle
                    seqBlock=3;
                    Sequence_Learning_CMI_Circle
                    
                case 'No'
                    input3=questdlg('Would you like to start the the practice task again?');
                    if strcmp(input3,'Yes')
                        clc;
                        disp('Starting Visual Learning Example');
                        Explicit_Sequence_Learning_CMI_Square_Example
                    end
                    input4 =questdlg('Would you like to start the actual task?');
                    if strcmp(input4, 'Yes')
                        clc;
                        disp('Starting Visual Learning Task');
                    seqBlock=1;
                    Sequence_Learning_CMI_Circle
                    seqBlock=2;
                    Sequence_Learning_CMI_Circle
                    seqBlock=3;
                    Sequence_Learning_CMI_Circle
                    end
            end
    end
    cd /home/stimuluspc/Dropbox/StimulusPresentation;
    save(['All_Subjects/',subj_Name{1,1},'/',subj_Name{1,1}, '_metafile'],'metafile');
end
%% WISC Processing Speed
if metafile.entryPoint<4
    input=questdlg('Would you like to start the Procesing Speed Paradigm?');
    switch input
        case 'Cancel'
            return;
        case 'Yes'
            metafile.tasks{end+1,1} = 'WISC';
            metafile.tasks{end,2} =  input;
            subj_ID =inputdlg({'Enter Subjects ID:', 'Enter Date:','Use EEG:', 'Use Eye-Tracker:', 'Eye-Tracker Calibration:', 'Example Trials:', 'Drift Correction'},'CMI-EEG',1,{subj_Name{1,1},date,'y','y', 'y', 'y', 'n'});
            if strcmp(subj_ID(6,1),'y')
                clc;
                disp('Starting Processing Speed Example');
                WISC_ProcessingSpeed_paradigm_Example
            end
            input2=questdlg('Would you like to start the actual task?');
            switch input2
                case 'Cancel'
                    return;
                case 'Yes'
                    clc;
                    disp('Starting Processing Speed Task');
                    procBlock=1;
                    WISC_ProcessingSpeed_paradigm
                    procBlock=2;
                    WISC_ProcessingSpeed_paradigm
                case 'No'
                    input3=questdlg('Would you like to start the the practice task again?');
                    if strcmp(input3,'Yes')
                        clc;
                        disp('Starting Processing Speed Example');
                        WISC_ProcessingSpeed_paradigm_Example
                    end
                    input4 =questdlg('Would you like to start the actual task?');
                    if strcmp(input4, 'Yes')
                        clc;
                        disp('Starting Processing Speed Task');
                    procBlock=1;
                    WISC_ProcessingSpeed_paradigm
                    procBlock=2;
                    WISC_ProcessingSpeed_paradigm
                    end
            end
    end
    cd /home/stimuluspc/Dropbox/StimulusPresentation;
    save(['All_Subjects/',subj_Name{1,1},'/',subj_Name{1,1}, '_metafile'],'metafile');
end
%% Surround Suppression 1
if metafile.entryPoint<5
    input=questdlg('Would you like to start the Surroud Suppression (1st Block)?');
    switch input
        case 'Cancel'
            return;
        case 'Yes'
            metafile.tasks{end+1,1} = 'Surr_Supp1';
            metafile.tasks{end,2} = input;
            subj_ID =inputdlg({'Enter Subjects ID:', 'Enter Date:','Use EEG:', 'Use Eye-Tracker:', 'Eye-Tracker Calibration:'},'CMI-EEG',1,{subj_Name{1,1},date,'y','y', 'y'});
            surSupBlock = 1;
            SurroundSupp4circCMI_new_fixed_order_BothBlocks
    end
    
    cd /home/stimuluspc/Dropbox/StimulusPresentation;
    save(['All_Subjects/',subj_Name{1,1},'/',subj_Name{1,1}, '_metafile'],'metafile');
end
%% Contrast 1
if metafile.entryPoint<6
    input=questdlg('Would you like to start the Contrast Change Detection (1st Block) ?');
    switch input
        case 'Cancel'
            return;
        case 'Yes'
            metafile.tasks{end+1,1} = 'Contrast1';
            metafile.tasks{end,2} =  input;
            subj_ID =inputdlg({'Enter Subjects ID:', 'Enter Date:','Use EEG:', 'Use Eye-Tracker:', 'Eye-Tracker Calibration:', 'Example Trials:'},'CMI-EEG',1,{subj_Name{1,1},date,'y','y', 'y', 'y'});
            if strcmp(subj_ID(6,1),'y')
                clc;
                disp('Starting Contrast Detection Example');
                ccdBlock = 0;
                ContrastChangeDetect_2AFC_CMI_new_AllBlocks
            end
            input2=questdlg('Would you like to start the actual task?');
            switch input2
                case 'Cancel'
                    return;
                case 'Yes'
                    clc;
                    disp('Starting Contrast Detection Task');
                    ccdBlock = 1;
                    ContrastChangeDetect_2AFC_CMI_new_AllBlocks
                case 'No'
                    input3=questdlg('Would you like to start the the practice task again?');
                    if strcmp(input3,'Yes')
                        clc;
                        disp('Starting Contrast Detection Example');
                        ccdBlock = 0;
                        ContrastChangeDetect_2AFC_CMI_new_AllBlocks
                    end
                    input4 =questdlg('Would you like to start the actual task?');
                    if strcmp(input4, 'Yes')
                        clc;
                        disp('Starting Contrast Detection Task');
                        ccdBlock = 1;
                        ContrastChangeDetect_2AFC_CMI_new_AllBlocks
                    end
            end
    end
    cd /home/stimuluspc/Dropbox/StimulusPresentation;
    save(['All_Subjects/',subj_Name{1,1},'/',subj_Name{1,1}, '_metafile'],'metafile');
    
    %% BREAK
    questdlg('Time for a break. Break Over?','CMI-EEG','Yes','Yes');
end


%% Contrast 2
if metafile.entryPoint<7
    input=questdlg('Would you like to start the Contrast Change Detection (2nd Block) ?');
    switch input
        case 'Cancel'
            return;
        case 'Yes'
            metafile.tasks{end+1,1} = 'Contrast2';
            metafile.tasks{end,2} =  input;
            subj_ID =inputdlg({'Enter Subjects ID:', 'Enter Date:','Use EEG:', 'Use Eye-Tracker:', 'Eye-Tracker Calibration:', 'Example Trials:'},'CMI-EEG',1,{subj_Name{1,1},date,'y','y', 'y', 'y'});
            if strcmp(subj_ID(6,1),'y')
                clc;
                disp('Starting Contrast Detection Example');
                ccdBlock = 0;
                ContrastChangeDetect_2AFC_CMI_new_AllBlocks
            end
            input2=questdlg('Would you like to start the actual task?');
            switch input2
                case 'Cancel'
                    return;
                case 'Yes'
                    clc;
                    disp('Starting Contrast Detection Task');
                    ccdBlock = 2;
                    ContrastChangeDetect_2AFC_CMI_new_AllBlocks
                case 'No'
                    input3=questdlg('Would you like to start the the practice task again?');
                    if strcmp(input3,'Yes')
                        clc;
                        disp('Starting Contrast Detection Example');
                        ccdBlock = 0;
                        ContrastChangeDetect_2AFC_CMI_new_AllBlocks
                    end
                    input4 =questdlg('Would you like to start the actual task?');
                    if strcmp(input4, 'Yes')
                        clc;
                        disp('Starting Contrast Detection Task');
                        ccdBlock = 2;
                        ContrastChangeDetect_2AFC_CMI_new_AllBlocks
                    end
            end
    end
    save(['All_Subjects/',subj_Name{1,1},'/',subj_Name{1,1}, '_metafile'],'metafile');
end
%% Contrast 3
if metafile.entryPoint<8
    input =questdlg('Would you like to start the Contrast Change Detection (3rd Block) ?');
    switch input
        case 'Cancel'
            return;
        case 'Yes'
            metafile.tasks{end+1,1} = 'Contrast3';
            metafile.tasks{end,2} =  input;
            subj_ID =inputdlg({'Enter Subjects ID:', 'Enter Date:','Use EEG:', 'Use Eye-Tracker:', 'Eye-Tracker Calibration:', 'Example Trials:'},'CMI-EEG',1,{subj_Name{1,1},date,'y','y', 'y', 'y'});
            if strcmp(subj_ID(6,1),'y')
                disp('Starting Contrast Detection Example');
                ccdBlock = 0;
                ContrastChangeDetect_2AFC_CMI_new_AllBlocks
            end
            input2=questdlg('Would you like to start the actual task?');
            switch input2
                case 'Cancel'
                    return;
                case 'Yes'
                    disp('Starting Contrast Detection Task');
                    ccdBlock = 3;
                    ContrastChangeDetect_2AFC_CMI_new_AllBlocks
                case 'No'
                    input3=questdlg('Would you like to start the the practice task again?');
                    if strcmp(input3,'Yes')
                        disp('Starting Contrast Detection Example');
                        ccdBlock = 0;
                        ContrastChangeDetect_2AFC_CMI_new_AllBlocks
                    end
                    input4 =questdlg('Would you like to start the actual task?');
                    if strcmp(input4, 'Yes')
                        disp('Starting Contrast Detection Task');
                        ccdBlock = 3;
                        ContrastChangeDetect_2AFC_CMI_new_AllBlocks
                    end
            end
    end
    cd /home/stimuluspc/Dropbox/StimulusPresentation;
    save(['All_Subjects/',subj_Name{1,1},'/',subj_Name{1,1}, '_metafile'],'metafile');
end
%% Surround Suppression 2
if metafile.entryPoint<9
    input=questdlg('Would you like to start the Surroud Suppression (2nd Block)?');
    switch input
        case 'Cancel'
            return;
        case 'Yes'
            metafile.tasks{end+1,1} = 'Surr_Supp2';
            metafile.tasks{end,2} = input;
            subj_ID =inputdlg({'Enter Subjects ID:', 'Enter Date:','Use EEG:', 'Use Eye-Tracker:', 'Eye-Tracker Calibration:'},'CMI-EEG',1,{subj_Name{1,1},date,'y','y', 'y'});
            surSupBlock = 2;
            SurroundSupp4circCMI_new_fixed_order_BothBlocks
    end
    
    cd /home/stimuluspc/Dropbox/StimulusPresentation;
    save(['All_Subjects/',subj_Name{1,1},'/',subj_Name{1,1}, '_metafile'],'metafile');
end

%% Antisaccade
if metafile.entryPoint<10
    input =questdlg('Would you like to start the Antisaccade Task ?');
    switch input
        case 'Cancel'
            return;
        case 'Yes'
            metafile.tasks{end+1,1} = 'Antisaccade';
            metafile.tasks{end,2} =  input;
            subj_ID =inputdlg({'Enter Subjects ID:', 'Enter Date:','Use EEG:', 'Use Eye-Tracker:', 'Eye-Tracker Calibration:', 'Example Trials:'},'CMI-EEG',1,{subj_Name{1,1},date,'y','y', 'y', 'y'});
            if strcmp(subj_ID(6,1),'y')
                disp('Starting Antisaccade Example');
                AntiSaccade_Example
            end
            input2=questdlg('Would you like to start the actual task?');
            switch input2
                case 'Cancel'
                    return;
                case 'Yes'
                    disp('Starting Antisaccade Task');
                    AntiSaccade
                case 'No'
                    input3=questdlg('Would you like to start the the practice task again?');
                    if strcmp(input3,'Yes')
                        disp('Starting Antisaccade Example');
                        AntiSaccade_Example
                    end
                    input4 =questdlg('Would you like to start the actual task?');
                    if strcmp(input4, 'Yes')
                        disp('Starting Antisaccade Task');
                        AntiSaccade
                    end
            end
    end
    cd /home/stimuluspc/Dropbox/StimulusPresentation;
    save(['All_Subjects/',subj_Name{1,1},'/',subj_Name{1,1}, '_metafile'],'metafile');
end

%% Simple Span
if metafile.entryPoint<11
    input=questdlg('Would you like to start the Simple Span task?','SimpleSpan');
    switch input
        case 'Cancel'
            return;
        case 'Yes'
            metafile.tasks{end+1,1} = 'RSimpleSpan';
            metafile.tasks{end,2} = input;
            subj_ID=inputdlg({'Enter Subjects ID:', 'Enter Date:','Use EEG:', 'Use Eye-Tracker:', 'Eye-Tracker Calibration:'},'SimpleSpan',1,{subj_Name{1,1},date,'y','y','y'});
            clc;
            disp('Starting Simple Span');
            SimpleSpan;
            %      movefile([subj_Name{1,1},'_RestingEEG.mat'],['All_Subjects/',subj_Name{1,1},'/']);
    end
    cd /home/stimuluspc/Dropbox/StimulusPresentation;
    save(['All_Subjects/',subj_Name{1,1},'/',subj_Name{1,1}, '_metafile'],'metafile');
    
end

try
    NetStation('StopRecording'); %Stop Recording
    NetStation('Disconnect');
catch
end
