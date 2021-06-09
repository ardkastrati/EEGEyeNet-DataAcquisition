I_GenSettings;
Instructions;



par.runID = 1;
par.useEL = 1;
par.useEL_Calib = 1;



%% task parameters:
nTrials=1; % show the 10 targets 1 Trials times.


tarDiameter=15;


%tu wpisz moje pozcje
tarPos(1,1)=400;tarPos(2,1)=300; %middle
tarPos(1,2)=650;tarPos(2,2)=500;
tarPos(1,3)=400;tarPos(2,3)=100;
tarPos(1,4)=100;tarPos(2,4)=450;
tarPos(1,5)=700;tarPos(2,5)=450;
tarPos(1,6)=100;tarPos(2,6)=500;
tarPos(1,7)=200;tarPos(2,7)=350;
tarPos(1,8)=300;tarPos(2,8)=400;
tarPos(1,9)=100;tarPos(2,9)=150;
tarPos(1,10)=150;tarPos(2,10)=500;




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



%% Connect Eyetracker & Calibrate - check with Marius
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
    Eyelink('command', 'record_status_message "SEQUENCE LEARNING"');
else
    window = Screen('OpenWindow', whichScreen, par.BGcolor);
end


%% Experiment Window
clc;
if ~Screen(window, 'WindowKind') %Check if Window is open
    window=Screen('OpenWindow', whichScreen, par.BGcolor);
end


%% START TASK

% Instructions:
Screen('TextSize', window, tSize2);
DrawFormattedText(window, ['Übungsaufgabe zur Augenbewegungskamera.'...
    '\n\nEs werden schwarze Punkte an verschiedenen Orten'...
    '\nauf dem Bildschirm erscheinen.'...
    '\nVersuchen Sie, jeden schwarzen Punkt so lange anzusehen'...
    '\nbis er verschwindet'...
    '\n\nDrücken Sie die linke Maustaste um zu beginnen.'],...
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

disp('calibration task  STARTS!');
targetTimer = 1500;
eyeoff=30;

for t=1:nTrials %in example only one time
for i=1:length(tarPos)
    Screen('DrawDots',window,[tarPos(:,i)], tarDiameter, [0 0 0],[],1);
    Screen('Flip', window, [],[],1);
    targetTime = GetSecs + targetTimer/1000;
    while GetSecs < targetTime
        evt = Eyelink('newestfloatsample');
        eyeindex= [];
       if evt.gx(1)<-10000
         eyeindex=2;
        else
         eyeindex=1;
       end
       
       if evt.gx(eyeindex) < tarPos(1,i)+ eyeoff && evt.gx(eyeindex) > tarPos(1,i)- eyeoff && ...
       evt.gy(eyeindex) < tarPos(2,i)+ eyeoff && evt.gy(eyeindex) > tarPos(2,i)- eyeoff
   
           Screen('DrawDots',window,[tarPos(:,i)], tarDiameter, [0 150 0],[],1);
           Screen('Flip', window, [],[],1);  
       else
           Screen('DrawDots',window,[tarPos(:,i)], tarDiameter, [0 0 0],[],1);
           Screen('Flip', window, [],[],1);  
       end
    end
    
    
    Screen('Flip', window, [],[],1);
    

end
end

if par.useEL
    fprintf('Stop Recording Track\n');
    Eyelink('StopRecording'); %Stop Recording
    Eyelink('CloseFile');
    EL_Cleanup %Shutdown Eyetracker and close all Screens
end

