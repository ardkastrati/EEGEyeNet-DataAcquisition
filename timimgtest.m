I_GenSettings

par.runID = 1;
par.recordEEG = 1;
par.useEL = 1;
par.useEL_Calib = 1;
par.CD_START  = 90;
par.CD_eyeO = 20;
par.CD_eyeC = 30;
par.CD_END  = 80;

trials = 100;


%% Screen Calculations
[scresw, scresh]=Screen('WindowSize',whichScreen);  % Get screen resolution
center = [scresw scresh]/2;     % useful to have the pixel coordinates of the very center of the screen (usually where you have someone fixate)
fixRect = [center-2 center+2];  % fixation dot
hz=Screen('FrameRate', whichScreen,1);
cm2px = scresw/monitorwidth_cm;  % multiplication factor to convert cm to pixels
deg2px = dist_cm*cm2px*pi/180;      % multiplication factor to convert degrees to pixels (uses aproximation tanT ~= T).
load gammafnCRT;   % load the gamma function parameters for this monitor - or some other CRT and hope they're similar! (none of our questions rely on precise quantification of physical contrast)
maxLum = GrayLevel2Lum(255,Cg,gam,b0);
par.BGcolor=Lum2GrayLevel(maxLum/2,Cg,gam,b0);

%% Connect Eyetracker & Calibrate

window=Screen('OpenWindow', whichScreen, par.BGcolor);
EL_Connect;
edfFile=[num2str(par.runID),'_TST.edf'];
Eyelink('Openfile', edfFile);

%% Initiate NetStation Connection, Synchronization, and Recording

[status,info] = NetStation('Connect','100.1.1.3',55513);
NetStation('Synchronize');
WaitSecs(1);
if status ~= 0
    error(info);
end

time = GetSecs;
i = 1;
t = 1;
tt = 1;

eyeO = 2:2:2000;
eyeC = 3:2:2000;

Screen('DrawText', window, 'Timingtest, click to start', 0.05*scresw, 0.5*scresh, 255);
Screen('Flip', window);

if par.useEL 
    Eyelink('StartRecording');
    Eyelink('command', 'record_status_message "READING INSTRUCTIONS"');
end;

if par.recordEEG, NetStation('StartRecording'); end;

[clicks,x,y,whichButton] = GetClicks(whichScreen,0);

while t < trials
    vbl = Screen('Flip',window);
    if vbl >=time+eyeO(t)
        if par.recordEEG,  NetStation('Event', num2str(par.CD_eyeO(1))); end
        if par.useEL, Eyelink('Message',num2str(par.CD_eyeO)); end; %
        t = t+1;
        disp(t);
    end
    if vbl >=time+eyeC(tt) %Tests if a second has passed
        if par.recordEEG,  NetStation('Event', num2str(par.CD_eyeC(1))); end
        if par.useEL, Eyelink('Message',num2str(par.CD_eyeC)); end;
        tt = tt+1;
        disp(tt);
    end
end

Screen('DrawText', window, 'DONE', 0.10*scresw, 0.55*scresh, 255);
Screen('Flip', window);

WaitSecs(5);

    fprintf('Stop Recording EEG\n');
    NetStation('StopRecording'); %Stop Recording
    NetStation('Disconnect');

    fprintf('Stop Recording TRack\n');
    Eyelink('StopRecording'); %Stop Recording
    Eyelink('CloseFile');
    fprintf('Downloading File\n');
    EL_DownloadDataFile % Downloading the file
    EL_Cleanup %Shutdown Eyetracker and close all Screens

save([num2str(par.runID) , '_RestingEEG'],'par');
clearvars;
sca; 