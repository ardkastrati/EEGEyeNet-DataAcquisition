I_GenSettings;
Instructions;

% Setting the Trigger codes
par.CD_StarT  = 94;
par.CD_blockOn = 55;
par.CD_blockOff = 56;

par.CD_StimulusOff = 41;
par.CD_StopTask = 50;
par.CD_END  = 80;


par.runID = 1;
par.useEL = 1;
par.useEL_Calib = 1;

%% Setting Par
if testmode == 1 % Testmode, modify to your liking
    par.runID = 1;
    par.recordEEG = 0;
    par.useEL = 1;
    par.useEL_Calib = 0;
else
    I_SetPar; % Setting the par file according to call
end;

par.runID= app.run{1};
par.ExaminationDate=app.run{2};
savePath = app.savePath;


%% task parameters:

TarDiameter=15;


%POSITION
TarPos(1,1)=400;TarPos(2,1)=300; %middle
TarPos(1,2)=650;TarPos(2,2)=500;
TarPos(1,3)=400;TarPos(2,3)=100;
TarPos(1,4)=100;TarPos(2,4)=450;
TarPos(1,5)=700;TarPos(2,5)=450;
TarPos(1,6)=100;TarPos(2,6)=500;
TarPos(1,7)=200;TarPos(2,7)=350;
TarPos(1,8)=300;TarPos(2,8)=400;
TarPos(1,9)=100;TarPos(2,9)=150;
TarPos(1,10)=150;TarPos(2,10)=500;
TarPos(1,11)=150;TarPos(2,11)=100;
TarPos(1,12)=700;TarPos(2,12)=100;
TarPos(1,13)=300;TarPos(2,13)=200;
TarPos(1,14)=100;TarPos(2,14)=100;
TarPos(1,15)=700;TarPos(2,15)=500;
TarPos(1,16)=500;TarPos(2,16)=400;
TarPos(1,17)=600;TarPos(2,17)=250;
TarPos(1,18)=650;TarPos(2,18)=100;
TarPos(1,19)=400;TarPos(2,19)=300; %middle
TarPos(1,20)=200;TarPos(2,20)=250;
TarPos(1,21)=400;TarPos(2,21)=500;
TarPos(1,22)=700;TarPos(2,22)=150;
TarPos(1,23)=500;TarPos(2,23)=200;
TarPos(1,24)=100;TarPos(2,24)=300;
TarPos(1,25)=700;TarPos(2,25)=300;
TarPos(1,26)=400;TarPos(2,26)=300; %middle
TarPos(1,27)=600;TarPos(2,27)=350;

%check visually:
%scatterplot(TarPos');xlim([0 800]);ylim([0 600]);
%title('normal')
%hold on;

numbers = [1:length(TarPos)]
numbers=strsplit(num2str(numbers),' ');
for i=1:length(numbers)
    text(TarPos(1,i)+5,TarPos(2,i)+5,numbers{i})
end

for i=1:length(TarPos)
    TarPosFlip(1,i)=800-TarPos(1,i);
    TarPosFlip(2,i)=600-TarPos(2,i);
end

for i=1:length(TarPos)
    TarPosBack(1,i) = TarPos(1,28-i);
    TarPosBack(2,i) = TarPos(2,28-i);
end

for i=1:length(TarPosFlip)
    TarPosFlipBack(1,i) = TarPosFlip(1,28-i);
    TarPosFlipBack(2,i) = TarPosFlip(2,28-i);
end

% %check visually:
% scatterplot(TarPosFlip');xlim([0 800]);ylim([0 600]);
% title('Flipped')
% hold on;

numbers=[1:length(TarPosFlip)]
numbers=strsplit(num2str(numbers),' ');
for i=1:length(numbers)
    text(TarPosFlip(1,i)+5,TarPosFlip(2,i)+5,numbers{i})
end

%% Screen Calculations - taken from AS task
[scresw, scresh]=Screen('WindowSize',whichScreen);  % Get screen resolution
center = [scresw scresh]/2;     % useful to have the pixel coordinates of the very center of the screen (usually where you have someone fixate)
fixRect = [center-2 center+2];  % fixation dot
hz=Screen('FrameRate', whichScreen,1);
cm2px = scresw/monitorwidth_cm;     % multiplication factor to convert cm to pixels
deg2px = dist_cm*cm2px*pi/180;      % multiplication factor to convert degrees to pixels (uses aproximation tanT ~= T).
load gammafnCRT;   % load the gamma function parameters for this monitor - or some other CRT and hope they're similar! (none of our questions rely on precise quantification of physical contrast)
maxLum = GrayLevel2Lum(255,Cg,gam,b0);
par.BGcolor=Lum2GrayLevel(maxLum/2,Cg,gam,b0);

%% Connect Eyetracker & Calibrate 
if par.useEL
    window = Screen('OpenWindow', whichScreen, par.BGcolor);
    EL_Connect; %Connect the Eytracker, it needs a window
    
    try % open file to record data to
        edfFile=['calibration_task.edf'];
        Eyelink('Openfile', edfFile);
    catch
        fprintf('Error creating the file on Tracker\n');
        EL_Cleanup;
    end;
    if par.useEL_Calib
        EL_Calibrate
    end; %If needed, run Calibration
    Eyelink('command', 'record_status_message "DOTS"');
else
    window = Screen('OpenWindow', whichScreen, par.BGcolor);
end

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


%do we really need this wav?
wavfilename_probe1 = '/home/stimuluspc/Neurometric/resting/Bildschirm.wav'; %Open Eyes
hasEyesClosed = 0;
%% Experiment Window
clc;
if ~Screen(window, 'WindowKind') %Check if Window is open
    window=Screen('OpenWindow', whichScreen, par.BGcolor);
end


%% STarT TASK

% Instructions:
Screen('TextSize', window, tSize2);
DrawFormattedText(window, ['Nun beginnt die Messung der visuell motorischen Aufgaben'...
    '\n\nEs werden Punkte an verschiedenen Orten'...
    '\nauf dem Bildschirm erscheinen.'...
    '\nVersuchen Sie, jeden Punkt so lange anzusehen'...
    '\nbis er verschwindet'...
    '\n\nDrücken Sie die linke Maustaste um zu beginnen'],...
    0.08*scresw, 0.25*scresh, colorText);
Screen('Flip', window);
SetMouse(800,600,0)
HideCursor(whichScreen);
clc;

disp('THE SUBJECT IS READING THE INSTRUCTIONS...');
[clicks,x,y,whichButton] = GetClicks(whichScreen,0); % Waits for the user to press a button before sTarting

 if par.useEL
        try % open file to record data to
            edfFile=[num2str(par.runID),'_Dots.edf'];
            Eyelink('Openfile', edfFile);
        catch
            disp('Error creating the file on Tracker');
        end;
        
        Eyelink('StartRecording'); 
 end;
if par.recordEEG, NetStation('StartRecording'); end;


%send trigger to EEG and ET 
 if par.recordEEG
     NetStation('Event', num2str(par.CD_STarT));
 end
if par.useEL
        Eyelink('Message',['TR',num2str(par.CD_STarT)]);
end; %Send Eytracker Trigger

Screen('Flip', window, [],[],1);
SetMouse(800,600,0)
HideCursor(whichScreen);

disp('calibration task  starts!');

%
%  S(t) --> punkty dla bloku 't'
%
%  S(1) --> TarPos
%  S(2) --> TarPosBack
%  ...
%

S = {TarPos, TarPosBack, TarPosFlip, TarPosFlipBack, TarPos, ...
     TarPos, TarPosBack, TarPosFlip, TarPosFlipBack, TarPos};
 
 TarPosTrigg = [101:127]
 TarPosBackTrigg = [127:-1:101]
TarPosFlipTrigg = []

 for i = 1:length(TarPosTrigg)
     
     pl = find((TarPosFlip(1,i) == TarPos(1, :)) & (TarPosFlip(2,i) == TarPos(2,:)))
     %i = 1
     TarPosFlipTrigg(i) = pl(1)
     
 end
 
 TarPosFlipBackTrigg = Flip(TarPosFlipTrigg)
 
for t=1:length(S)
    %here trigger trials dot  in the llop-ready
    if par.recordEEG,  NetStation('Event', num2str(par.CD_blockOn)); end
    points = S{t};
       if S==1 | S ==5 | S==6 | S==10
            triggers=TarPosTrigg;
       elseif S==2 | S==7 
           triggers=TarPosTriggBack;
       elseif S==3 | S==8
           triggers=TarPosFlipTrigg;
       elseif S==4 | S==9
           triggers=TarPosFlipBackTrigg;
       end
    for i=1:length(points)
        %here trigger dot on-ready
        
     
        if par.recordEEG,  NetStation('Event', num2str(triggers(i))); end
        Screen('DrawDots',window,[points(:,i)], TarDiameter, [0 150 0],[],1);
        Screen('Flip', window, [],[],1);
        pause(1.5);%zapytac
        Screen('Flip', window, [],[],1)
        if par.recordEEG,  NetStation('Event', num2str(par.CD_StimulusOff)); end
        %pause(0.5) CONFIRM WITH NICOLAS
    end
    if par.recordEEG,  NetStation('Event', num2str(par.CD_blockOff)); end

    %here pause, 20sec
    if t<10
        Screen('TextSize', window, tSize2);
        DrawFormattedText(window, ['Dies war Block ' num2str(t) ' von zehn. 20 sek Pause!' ],...
            0.18*scresw, 0.45*scresh, colorText);
        Screen('Flip', window);
        pause(20);
    end
end

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
    EL_Cleanup %Shutdown Eyetracker and close all Screens
end
save([savePath,num2str(par.runID),'_ASA'],'par');
%clearvars -except select subj_ID metafile subj_Name app event
sca; %If Eyetracker wasn't used, close the Screens now
try
    PsychPortAudio('Close');
catch
end