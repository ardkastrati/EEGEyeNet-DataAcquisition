%% Settings
I_GenSettings;
Instructions;

par.runID = 1;
par.useEL = 1;
par.useEL_Calib = 1;


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
    window=Screen('OpenWindow', whichScreen, par.BGcolor);
    EL_Connect; %Connect the Eytracker, it needs a window
    Eyelink('command', 'record_status_message "ANTISACCADE EXAMPLE"');
else
    window=Screen('OpenWindow', whichScreen, par.BGcolor);
    disp('No Eyetracker');
end;

%% Experiment Window
clc;
if ~Screen(window, 'WindowKind') %Check if Window is open
    window=Screen('OpenWindow', whichScreen, par.BGcolor);
end

%% Antisaccade Task

protocol = [1,0,];
amplitude = 10;
color = [0,0,0];
targetTimer = 1000;
rectSize = 15;

if par.useEL
    try % open file to record data to
        edfFile=['DEMOEXAMPLE.edf'];
        Eyelink('Openfile', edfFile);
    catch
        disp('Error creating the file on Tracker');
    end;
    if par.useEL_Calib
        EL_Calibrate
    end; %If needed, run Calibration
    
    Eyelink('StartRecording');
    Eyelink('command', 'record_status_message "READING INSTRUCTIONS"');
end;


for currentTask=1:size(protocol,2)
    proSaccade = protocol(currentTask);
    if proSaccade
        text = ins.anti.e_ins_p;
    else %antisaccade
        text = ins.anti.e_ins_a;
    end
    
    Screen('TextSize', window, tSize2);
    DrawFormattedText(window, text, 0.08*scresw, 0.25*scresh, colorText);
    DrawFormattedText(window, ins.misc.mouse,'center', 0.9*scresh, colorText);
    Screen('Flip', window);
    
    SetMouse(800,600,0);
    HideCursor(whichScreen);
    [clicks,x,y,whichButton] = GetClicks(whichScreen,0); % Waits for the user to press a button before starting
    SetMouse(800,600,0);
    HideCursor(whichScreen);
    
    if proSaccade
        nrTrials = 10;
        disp('Prosaccade Trial');
    else %antisaccade
        nrTrials = 4;
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
        
        par.taskInfo((currentTrial+currentTask)-1,1) = currentTask;
        par.taskInfo((currentTrial+currentTask)-1,[2,3]) = curTrialInfo;
        
        %rightgreen
        if par.useEL
            if proSaccade && (dir ~= 0)
                Eyelink('command', 'draw_filled_box %d %d %d %d 2' ,round(rect1(1)),round(rect1(2)),round(rect1(3)),round(rect1(4)));
                Eyelink('command', 'draw_filled_box %d %d %d %d 4' ,round(rect2(1)),round(rect2(2)),round(rect2(3)),round(rect2(4)));
            elseif ~proSaccade && (dir ~= 0)
                %leftgreen
                Eyelink('command', 'draw_filled_box %d %d %d %d 4' ,round(rect1(1)),round(rect1(2)),round(rect1(3)),round(rect1(4)));
                Eyelink('command', 'draw_filled_box %d %d %d %d 2' ,round(rect2(1)),round(rect2(2)),round(rect2(3)),round(rect2(4)));
            else
                Eyelink('command', 'draw_filled_box %d %d %d %d 2' ,round(rect1(1)),round(rect1(2)),round(rect1(3)),round(rect1(4)));
                Eyelink('command', 'draw_filled_box %d %d %d %d 4' ,round(rect2(1)),round(rect2(2)),round(rect2(3)),round(rect2(4)));
            end
            WaitSecs(0.1);
        end
        
        % random fixation time between 800 and 1200 ms
        fixationTime = GetSecs + ((1000 + (3500-1000) * rand)/1000);
        
        while GetSecs < fixationTime
            Screen('FillRect', window, el.backgroundcolour);
            Screen('FrameRect',window,255, rect1);
            Screen('FrameRect',window,255, rect2);
            Screen('DrawDots',window, dots(:,1),10, color );
            Screen('Flip', window);
        end
        
        targetTime = GetSecs + targetTimer/1000;
        feedbackcolor = [0,0,0];
        xaxis=1;
        yaxis=0;
        while GetSecs < targetTime
            Screen('FillRect', window, el.backgroundcolour);
            Screen('FrameRect',window,255, rect1);
            Screen('FrameRect',window,255, rect2);
            Screen('DrawDots',window, dots(:,1),10, feedbackcolor );
            Screen('DrawDots',window, dots(:,2),10, color );
            %Screen('DrawDots',window, [round(evt.gx(1)),round(evt.gy(1))]' ,1, color );
            Screen('Flip', window);
            if (xaxis && yaxis)
                pause(targetTime-GetSecs)
                break;
            end
            if (not(xaxis) && yaxis && not(centerpos))
                disp('not(xaxis) && yaxis');
                pause(targetTime-GetSecs)
                break;
            end
            evt = Eyelink('newestfloatsample');
            eyeindex= [];
            if evt.gx(1)<-10000
                eyeindex=2;
            else
                eyeindex=1;
            end
            
            if (evt.gy(eyeindex)<(scresh/2)+100) && (evt.gy(eyeindex)>(scresh/2)-100)
                yaxis = true;
            else
                yaxis = false;
            end
%             leftside = evt.gx(1) < rect2(3)+30 && evt.gx(1) > 0;
%             rightside = evt.gx(1) > rect1(1)-30 && evt.gx(1)< scresw;
%             centerpos = evt.gx(1)<(scresh/2)+100 && evt.gx(1)>(scresh/2)-100;

            leftside = evt.gx(eyeindex) < rect2(3)+30 && evt.gx(eyeindex) > 0;
            rightside = evt.gx(eyeindex) > rect1(1)-30 && evt.gx(eyeindex)< scresw;
            centerpos = evt.gx(eyeindex)<rect1(1)-30 && evt.gx(eyeindex)>rect2(3)+30;

            if proSaccade && (dir == 0) && leftside
                xaxis = true;
            elseif ~proSaccade && (dir == 0) && rightside
                xaxis = true;
            elseif proSaccade && (dir ~= 0) && rightside
                xaxis = true;
            elseif ~proSaccade && (dir ~= 0) && leftside
                xaxis = true;
            else
                xaxis = false;
            end
            
            if xaxis && yaxis
                feedbackcolor = [0,255,0];
            elseif centerpos
                feedbackcolor = [0,0,0];
            else
                feedbackcolor = [255,0,0];
            end  
        end
        %if always looked on center
        if (centerpos)
            feedbackcolor = [255,0,0];
            Screen('FillRect', window, el.backgroundcolour);
            Screen('FrameRect',window,255, rect1);
            Screen('FrameRect',window,255, rect2);
            Screen('DrawDots',window, dots(:,1),10, feedbackcolor );
            %Screen('DrawDots',window, dots(:,2),10, color );
            Screen('Flip', window);
        end
        pause(1);

    end
    %wait short time so subject can see feedback better
    Screen('FillRect', window, el.backgroundcolour);
    Screen('Flip', window);
    WaitSecs(0.2);
    
    timer=3;
    if currentTask==size(protocol,2)
        timer = 5;
        text = ins.anti.e_end;
    else
        text = ins.anti.e_end2;
    end
    
    for timeout=1:timer
        rest = timer-timeout;
        Screen('TextSize', window, tSize2);
        DrawFormattedText(window, text, 0.08*scresw, 0.25*scresh, colorText);
        DrawFormattedText(window, [ins.anti.break,num2str(rest)] ,'center', 0.9*scresh, colorText);
        Screen('Flip', window);
        HideCursor(whichScreen);
        clc;
        disp([ins.anti.break,num2str(rest)]);
        WaitSecs(1);
    end
end

WaitSecs(0.5);
%% Task Finished
if par.useEL
    fprintf('Stop Recording Track\n');
    Eyelink('StopRecording'); %Stop Recording
    Eyelink('CloseFile');
    EL_Cleanup %Shutdown Eyetracker and close all Screens
end
%rsave([savePath,num2str(par.runID),'_RES'],'par');
clearvars all
sca; %If Eyetracker wasn't used, close the Screens now

