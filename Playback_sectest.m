%close all
%clear all
pausekey = KbName('p');
SITE = 'N';     % T = TCD, C = City College, E = EGI in City College
port=0;
par.nrpages = 4;

par.runID= subj_ID{1,1};
par.ExaminationDate =subj_ID{2,1};
if subj_ID{3,1} == 'y'
par.recordEEG = 1;
else par.recordEEG = 0; end;

if subj_ID{4,1} == 'y'
par.useEL = 1;  % use the eye tracker?
else  par.useEL = 0; end;

if subj_ID{5,1} == 'y'
par.useEL_Calib = 1;  % use the eye tracker?
else par.useEL_Calib = 0; end;

monitorwidth_cm = 40;   % monitor width in cm
dist_cm = 57;  % viewing distance in cm
%%
color_white = [255 255 255]
BGcolor = color_white ;
hz = 100;
 
whichScreen = 2;

par.CD_START  = 1;
 par.CD_SECONDS = 44;


%Initiate NetStation Connection, Synchronization, and Recording
if par.recordEEG
    NetStation('Connect','10.0.0.42')
    NetStation('Synchronize')
    NetStation('StartRecording')
end

if par.useEL && par.useEL_Calib; Eyetracker_connection_calib, 
elseif par.useEL == 1 && par.useEL_Calib == 0; Eyetracker_connection_passive; end


%Place full path for movie here.  For example, 
% moviename = 'C:\Users\Desktop\moviename.avi'

moviename = 'C:\PsychToolbox_Experiments\Simon\Dramatic_Chipmunk.mov';
hsc = Screen('OpenWindow',whichScreen);

[moviePtr duration fps count] = Screen('OpenMovie',hsc,moviename);
Screen('PlayMovie',moviePtr,1);
format long;
sec1 = zeros(count,1);
i = 1;
time = GetSecs;

 if par.recordEEG, sendtrigger(par.CD_START,port,SITE,0), end
    if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_START))])));end;


while ~KbCheck
    tex = Screen('GetMovieImage', hsc, moviePtr);
    
    if tex<=0
        break
    end
    Screen('DrawTexture',hsc,tex);
    vbl = Screen('Flip',hsc);
    if vbl >=time+1 %Tests if a second has passed 
        time = vbl; %changes testing value of time    
       
if par.recordEEG, sendtrigger(par.CD_SECONDS(1),port,SITE,0); end
            if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_SECONDS(1)))])));end;
            
        sec1(i) = vbl; %here you can change what you want done at per second 
        i = i+1;% In this case it gives the time that is detected as 1 second
                       
    end
    Screen('Close',tex);
end
        
Screen('PlayMovie', moviePtr, 0);
Screen('CloseMovie', moviePtr);
Screen('CloseAll');
sca
% j = find(sec1);
% sec1 = sec1(j);
% timediff = diff(sec1); % will give the difference of each value of sec1
