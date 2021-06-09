I_GenSettings;
Instructions;

par.runID = 1;
par.useEL = 1;
par.useEL_Calib = 1;

%% task parameters:
nTrials=3; % show the 5 targets #nTrials times.

tarCnt=35; % how many samples in a row have to be on target before it disappers

tarDiameter=50;
cueDiameter=7; %size of the red dot indicatin fixation position

tarPos(1,1)=150;tarPos(2,1)=100;
tarPos(1,2)=650;tarPos(2,2)=100;
tarPos(1,3)=400;tarPos(2,3)=300;
tarPos(1,4)=150;tarPos(2,4)=500;
tarPos(1,5)=650;tarPos(2,5)=500;

tarDiameter=50;
cueDiameter=7;

tarCnt=35; % how many samples in a row have to be on target before it disappears



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

%% Connect Eyetracker & Calibrate
if par.useEL
    window = Screen('OpenWindow', whichScreen, par.BGcolor);
    EL_Connect; %Connect the Eytracker, it needs a window
    
    try % open file to record data to
        edfFile=['SQLEARNING_EXAMPLE.edf'];
        Eyelink('Openfile', edfFile);
    catch
        fprintf('Error creating the file on Tracker\n');
        EL_Cleanup;
    end;
    if par.useEL_Calib
        EL_Calibrate
    end; %If needed, run Calibration
    Eyelink('command', 'record_status_message "SEQUENCE LEARNING"');
else
    window = Screen('OpenWindow', whichScreen, par.BGcolor);
end

%% START TASK

% Instructions:
Screen('TextSize', window, tSize2);
DrawFormattedText(window, ['Übungsaufgabe zur Augenbewegungskamera.'...
    '\n\nEs werden schwarze Punkte an verchiedenen Orten'...
    '\nauf dem Bildschirm erscheinen.'...
    '\nEin roter Punkt zeigt laufend an,'...
    '\nan welchen Ort des Bildschirms sie sehen.'...
    '\nVersuchen Sie, jeden schwarzen Punkt so lange anzusehen'...
    '\nbis er verschwindet'...
    '\n\nDrücken Sie die linke Maustaste um zu beginnen'],...
    0.08*scresw, 0.25*scresh, colorText);
Screen('Flip', window);
SetMouse(800,600,0)
HideCursor(whichScreen);
clc;
disp('THE SUBJECT IS READING THE INSTRUCTIONS...');
[clicks,x,y,whichButton] = GetClicks(whichScreen,0); % Waits for the user to press a button before starting


if par.useEL, Eyelink('StartRecording'); end;

Screen('Flip', window, [],[],1);
SetMouse(800,600,0)
HideCursor(whichScreen);

disp('ET PRACTICE STARTS!');


for t=1:nTrials
for i=1:length(tarPos)
    
    cnt=0;
    while true
        evt = Eyelink('newestfloatsample');
        x=evt.gx(1);
        y=evt.gy(1);
        %disp(['x: ' num2str(x) ', y: ' num2str(y)]);
        if cnt>0
        Screen('DrawDots',window,[tarPos(:,i)], tarDiameter, [0 150 0],[],1);
        else
           Screen('DrawDots',window,[tarPos(:,i)], tarDiameter, [0 0 0],[],1);
        end
        Screen('DrawDots',window,[x;y], cueDiameter, [255 0 0],[],1);
        Screen('DrawDots',window,[tarPos(:,i)], cueDiameter, [255 255 255],[],1);

        Screen('Flip', window, [],[],1);
        if (x>=tarPos(1,i)-tarDiameter/2 && x<=tarPos(1,i)+tarDiameter/2) && (y>=tarPos(2,i)-tarDiameter/2 && y<=tarPos(2,i)+tarDiameter/2)
            cnt=cnt+1;
            if cnt>tarCnt
                Screen('DrawDots',window,[tarPos(:,i)], tarDiameter, [0 255 0],[],1);
                Screen('Flip', window, [],[],1);
                pause(1);
                break;
            end
        else
            cnt=0;
        end
        pause(0.05);
    end
    
end
end

if par.useEL
    fprintf('Stop Recording Track\n');
    Eyelink('StopRecording'); %Stop Recording
    Eyelink('CloseFile');
    EL_Cleanup %Shutdown Eyetracker and close all Screens
end
