%% Settings
I_GenSettings;
testmode=0;
Instructions;
% Setting the Trigger codes
par.CD_START  = 94;
par.CD_StartPro = 20;
par.CD_ShowStim = [10;11];
par.CD_StartAnti = 30;
par.CD_Fixation = 40;
par.CD_StopTask = 50;
par.CD_END  = 80;

%% Setting Par
if testmode == 1 % Testmode, modify to your liking
    par.runID = 1;
    par.recordEEG = 0;
    par.useEL = 1;
    par.useEL_Calib = 1;
else
    I_SetPar; % Setting the par file according to call
end;

par.runID= app.run{1};
par.ExaminationDate=app.run{2};
savePath = app.savePath;

%% Screen Calculations
[scresw, scresh]=Screen('WindowSize',whichScreen);  % Get screen resolution
center = [scresw scresh]/2;     % useful to have the pixel coordinates of the very center of the screen (usually where you have someone fixate)
fixRect = [center-2 center+2];  % fixation dot
hz=Screen('FrameRate', whichScreen,1);
cm2px = scresw/monitorwidth_cm;     % multiplication factor to convert cm to pixels
deg2px = dist_cm*cm2px*pi/180;      % multiplication factor to convert degrees to pixels (uses aproximation tanT ~= T).
load gammafnCRT;   % load the gamma function parameters for this monitor - or some other CRT and hope they're similar! (none of our questions rely on precise quantification of physical contrast)
maxLum = GrayLevel2Lum(255,Cg,gam,b0);
par.BGcolor=Lum2GrayLevel(maxLum/2,Cg,gam,b0);
par.screensize = [scresw, scresh];

%% Connect Eyetracker & Calibrate
if par.useEL
    window=Screen('OpenWindow', whichScreen, par.BGcolor);
    EL_Connect; %Connect the Eytracker, it needs a window
    Eyelink('command', 'record_status_message "ANTISACCADE TASK"');
else
    window=Screen('OpenWindow', whichScreen, par.BGcolor);
    disp('No Eyetracker');
end;

%% Initiate NetStation Connection, Synchronization, and Recording
if par.recordEEG
    %[status,info] = NetStation('Connect','100.1.1.3',55513);
    NetStation('Synchronize');
    WaitSecs(1);
    %     if status ~= 0
    %         error(info);
    %     end
else
    disp('No EEG');
end


wavfilename_probe1 = '/home/stimuluspc/Neurometric/resting/Bildschirm.wav'; %Open Eyes
hasEyesClosed = 0;
%% Experiment Window
clc;
if ~Screen(window, 'WindowKind') %Check if Window is open
    window=Screen('OpenWindow', whichScreen, par.BGcolor);
end

disp('THE SUBJECT IS READING THE INSTRUCTIONS');
%if par.useEL
%    Eyelink('StartRecording');
%    Eyelink('command', 'record_status_message "READING INSTRUCTIONS"');
%end;
%if par.recordEEG, NetStation('StartRecording'); end;
disp('DID THE EEG START RECORDING DATA? IF NOT, PRESS THE RECORD BUTTON!');


%% Antisaccade Task
protocol = [1,0,0,0,1];
amplitude = 10;
color = [0,0,0];
targetTimer = 1000;
rectSize = 15;

par.amplitude = amplitude;

for currentTask=1:size(protocol,2)
    proSaccade = protocol(currentTask);
    
    if par.useEL
        try % open file to record data to
            edfFile=[num2str(par.runID),'_AS',num2str(currentTask),'.edf'];
            Eyelink('Openfile', edfFile);
        catch
            disp('Error creating the file on Tracker');
        end;
        if par.useEL_Calib
            EL_Calibrate
        end; %If needed, run Calibration
        
        
        %do the sound init stuff (again):
        try
            PsychPortAudio('Close');
        catch
        end
        %try
        [y_probe1, freq1] = audioread(wavfilename_probe1);
        wavedata_probe1 = y_probe1';
        nrchannels = size(wavedata_probe1,1); % Number of rows == number of channels.
        % Add 15 msecs latency on Windows, to protect against shoddy drivers:
        sugLat = [];
        if IsWin
            sugLat = 0.015;
        end
        try
            InitializePsychSound;
            pahandle = PsychPortAudio('Open', [], [], 0, freq1, nrchannels, [], sugLat);
            duration_probe1 = size(wavedata_probe1,2)/freq1;
        catch
            error('Sound Initialisation Error');
        end
        
        
        Eyelink('StartRecording');
        Eyelink('command', 'record_status_message "READING INSTRUCTIONS"');
    end;
    
    if par.recordEEG, NetStation('StartRecording'); end;
    disp('DID THE EEG START RECORDING DATA? IF NOT, PRESS THE RECORD BUTTON!');
    
    if proSaccade
        text = ins.anti.ins_p;
    else %antisaccade
        text = ins.anti.ins_a;
    end
    

    
    Screen('TextSize', window, tSize2);
    DrawFormattedText(window, text, 0.08*scresw, 0.25*scresh, colorText);
    DrawFormattedText(window, ins.misc.mouse,'center', 0.9*scresh, colorText);
    Screen('Flip', window);
     SetMouse(800,600,0);
    HideCursor(whichScreen);
    [clicks,x,y,whichButton] = GetClicks(whichScreen,0); % Waits for the user to press a button before starting
    
    %after instructions are read, send triggers, hide mouse and prepare trial 
    if par.recordEEG,  NetStation('Event', num2str(par.CD_START)); end
    if par.useEL
        Eyelink('Message',['TR',num2str(par.CD_START)]);
    end; %Send Eytracker Trigger
    SetMouse(800,600,0);
    HideCursor(whichScreen);
    
    if proSaccade
        nrTrials = 60;
        if testmode == 1; nrTrials = 5; end;
        if par.recordEEG,  NetStation('Event', num2str(par.CD_StartPro)); end
        if par.useEL
            Eyelink('Message',['TR',num2str(par.CD_StartPro)]);
            Eyelink('command', 'record_status_message "Prosaccade Trial"');
        end; %Send Eytracker Trigger
        disp('Prosaccade Trial');
    else %antisaccade
        nrTrials = 40;
        if testmode == 1; nrTrials = 5; end;
        if par.recordEEG,  NetStation('Event', num2str(par.CD_StartAnti)); end
        if par.useEL
            Eyelink('Message',['TR',num2str(par.CD_StartAnti)]);
            Eyelink('command', 'record_status_message "Antisaccade Trial"');
        end; %Send Eytracker Trigger
        disp('Antisaccade Trial');
    end
    
    task = zeros(nrTrials, 1);
    task((nrTrials/2):nrTrials,1)   = 1;   % 0=left, 1=right This makes half left, half right
    saccade = '';
    feedbackpos = '';
    
    % setup a random permutation of the trials
    order = randperm(nrTrials);
    dots = zeros(2,2);
    dots(2,:) = scresh/2;
    dots(1,1) = scresw/2;
    
    rect = zeros(2,2);
    rect(2,:) = scresh/2;
    rect(1,2) = scresw/2 - amplitude * deg2px; % left
    rect(1,1) = scresw/2 + amplitude * deg2px; % lef
    rect1 = [rect(1,1)-rectSize, rect(2,1)-rectSize, rect(1,1)+rectSize, rect(2,1) + rectSize]; %Rectangles for Eyetracker
    rect2 = [rect(1,2)-rectSize, rect(2,2)-rectSize, rect(1,2)+rectSize, rect(2,2) + rectSize];
    
    % Now starts running individual trials;
    for currentTrial=1:nrTrials
        dir = task(order(currentTrial));
        curTrialInfo = nan(1,2); %First 0=prosac 1=antisac Second 0=left 1=right
        %        Eyelink('Message', 'permutation number %d', order(i));
        
        if proSaccade
            curTrialInfo(1) = 0; %Prosaccade
        else %antisaccade
            curTrialInfo(1) = 1; %Antisaccade
        end
        if dir == 0  %0=left, 1=right
            curTrialInfo(2) = 0; %Left
            dots(1,2) = scresw/2 - amplitude * deg2px; % left
        else
            curTrialInfo(2) = 1; %Right
            dots(1,2) = scresw/2 + amplitude * deg2px; % right
        end
        
        par.taskInfo(currentTask,currentTrial, 1) = currentTask;
        par.taskInfo(currentTask,currentTrial,[2,3]) = curTrialInfo;
        
        %rightgreen
        if par.useEL
            if proSaccade && (dir ~= 0) %pros/rechts
                %rightgreen
                Eyelink('command', 'draw_filled_box %d %d %d %d 2' ,round(rect1(1)),round(rect1(2)),round(rect1(3)),round(rect1(4)));
                Eyelink('command', 'draw_filled_box %d %d %d %d 4' ,round(rect2(1)),round(rect2(2)),round(rect2(3)),round(rect2(4)));
            elseif proSaccade && (dir == 0) %pros/links
                %leftgreen
                Eyelink('command', 'draw_filled_box %d %d %d %d 4' ,round(rect1(1)),round(rect1(2)),round(rect1(3)),round(rect1(4)));
                Eyelink('command', 'draw_filled_box %d %d %d %d 2' ,round(rect2(1)),round(rect2(2)),round(rect2(3)),round(rect2(4)));
            elseif ~proSaccade && (dir ~= 0) %antis/rechts
                %leftgreen
                Eyelink('command', 'draw_filled_box %d %d %d %d 4' ,round(rect1(1)),round(rect1(2)),round(rect1(3)),round(rect1(4)));
                Eyelink('command', 'draw_filled_box %d %d %d %d 2' ,round(rect2(1)),round(rect2(2)),round(rect2(3)),round(rect2(4)));
            else %antis/links
                %rightgreen
                Eyelink('command', 'draw_filled_box %d %d %d %d 2' ,round(rect1(1)),round(rect1(2)),round(rect1(3)),round(rect1(4)));
                Eyelink('command', 'draw_filled_box %d %d %d %d 4' ,round(rect2(1)),round(rect2(2)),round(rect2(3)),round(rect2(4)));
            end
            WaitSecs(0.1);
        end
        
        % random fixation time between 800 and 1200 ms
        fixationTime = GetSecs + ((1000 + (3500-1000) * rand)/1000);
        
        if par.recordEEG,  NetStation('Event', num2str(par.CD_Fixation)); end
        if par.useEL
            Eyelink('Message',['TR',num2str(par.CD_Fixation)]);
        end; %Send Eytracker Trigger
        
        while GetSecs < fixationTime
            Screen('FillRect', window, el.backgroundcolour);
            Screen('FrameRect',window,255, rect1);
            Screen('FrameRect',window,255, rect2);
            Screen('DrawDots',window, dots(:,1),10, color );
            Screen('Flip', window);
        end
        
        targetTime = GetSecs + targetTimer/1000;
        
        if par.useEL
            if hasEyesClosed >= 2
                hasEyesClosed = 0;
                warning('Eyes not on screen, playing audio instruction!');
                PsychPortAudio('FillBuffer', pahandle,wavedata_probe1);
                PsychPortAudio('Start', pahandle, 1, 0, 1);
                WaitSecs(3);
                %if par.recordEEG,  NetStation('Event', num2str(par.CD_EYEC)); end;
                %if par.useEL, Eyelink('Message',['TR',num2str(par.CD_EYEC)]); end; % Send Triggers
            end
            evt = Eyelink('newestfloatsample');
            if ~(evt.pa(1)>0)
                disp('Subject has eyes closed!');
                hasEyesClosed = hasEyesClosed + 1;
            else
                hasEyesClosed = 0;
            end
            clear evt;
        end
        
        
        %%TODO FEHLER HIER!!
        if dir == 0 % Left
            if par.recordEEG,  NetStation('Event', num2str(par.CD_ShowStim(1))); end
            if par.useEL
                Eyelink('Message',['TR',num2str(par.CD_ShowStim(1))]);
            end; %Send Eytracker Trigger
        elseif dir==1 %Right
            if par.recordEEG,  NetStation('Event', num2str(par.CD_ShowStim(2))); end
            if par.useEL
                Eyelink('Message',['TR',num2str(par.CD_ShowStim(2))]);
            end; %Send Eytracker Trigger
        end;
        
        while GetSecs < targetTime
            Screen('FillRect', window, el.backgroundcolour);
            Screen('FrameRect',window,255, rect1);
            Screen('FrameRect',window,255, rect2);
            Screen('DrawDots',window, dots(:,1),10, color );
            Screen('DrawDots',window, dots(:,2),10, color );
            Screen('Flip', window);
        end
    end
    
    if par.recordEEG,  NetStation('Event', num2str(par.CD_StopTask)); end
    if par.useEL
        Eyelink('Message',['TR',num2str(par.CD_StopTask)]);
    end; %Send Eytracker Trigger
    
    Screen('FillRect', window, el.backgroundcolour);
    Screen('Flip', window);
    WaitSecs(0.2);
    
    if par.recordEEG
        fprintf('Stop Recording EEG\n');
        NetStation('StopRecording'); %Stop Recording
        %NetStation('Disconnect');
    end
    
    if par.useEL
        fprintf('Stop Recording Track\n');
        Eyelink('StopRecording'); %Stop Recording
        Eyelink('CloseFile');
        fprintf('Downloading File\n');
        EL_DownloadDataFile % Downloading the file
    end
    

    
    if testmode == 1; timer = 10; else timer = 60; end;
    if currentTask==size(protocol,2)
        timer = 5;
        text = ins.anti.end;
    else
        text = ins.anti.end2;
    end
    
    for timeout=1:timer
        rest = timer-timeout;
        Screen('TextSize', window, tSize2);
        DrawFormattedText(window, text, 0.08*scresw, 0.25*scresh, colorText);
        DrawFormattedText(window, num2str(rest) ,'center', 0.9*scresh, colorText);
        Screen('Flip', window);
         SetMouse(800,600,0);
        HideCursor(whichScreen);
        clc;
        disp(['Pause für: ',num2str(rest),' Sekunden']);
        WaitSecs(1);
    end
end

WaitSecs(0.5);
%% Task Finished

if par.recordEEG
    fprintf('Stop Recording EEG\n');
    NetStation('StopRecording'); %Stop Recording
    %NetStation('Disconnect');
end

if par.useEL
    EL_Cleanup %Shutdown Eyetracker and close all Screens
end
save([savePath,num2str(par.runID),'_ASA'],'par');
clearvars -except select subj_ID metafile subj_Name app event
sca; %If Eyetracker wasn't used, close the Screens now

