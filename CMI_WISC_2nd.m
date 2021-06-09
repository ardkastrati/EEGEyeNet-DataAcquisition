clear all

addpath('/home/eeg/PsychToolbox_Experiments/Simon/general_matlabfiles')
addpath('/home/eeg/PsychToolbox_Experiments/Simon/WISC_PS')
addpath('/home/eeg/PsychToolbox_Experiments/Simon/psychoacoustics')
addpath('/home/eeg/PsychToolbox_Experiments/Simon/Crash-files')
addpath('/home/eeg/PsychToolbox_Experiments/Simon/Clips')
% loadlibrary('iViewXAPI.dll', 'iViewXAPI.h');
% tasklist = {'Resting-EEG','Video','Change Detection', 'Surround Suppression','Learning Paradigm','Auditory Psychophysics', 'Processing Speed'};
%   
% [select] = listdlg('PromptString','Select Task', 'SelectionMode','single', 'ListSize',[150 120],'ListString',...
%                     tasklist)
% date
                
      cd /home/eeg/PsychToolbox_Experiments/Simon;
      subj_Name =inputdlg({'Enter Subjects ID:'},'CMI-EEG',1,{''});

          load([subj_Name{1,1}, '_metafile'])
      

      conn_EEG =inputdlg({'Record EEG:'},'CMI-EEG',1,{'Yes'});
      if strmatch('Yes', conn_EEG,'exact');
    NetStation('Connect','10.10.10.42')
      end
          
     
     
           start_WISC_PS =questdlg('Would you like to start the Processing Speed Task 2nd version?');
       if strmatch('Cancel', start_WISC_PS,'exact');
          return
       elseif strmatch('Yes', start_WISC_PS,'exact');
     metafile.tasks{end+1,1} = 'WISC_PS_2nd';
     metafile.tasks{end,2} = start_WISC_PS;     
       end
       
     subj_ID =inputdlg({'Enter Subjects ID:', 'Enter Date:','Use EEG:', 'Use Eye-Tracker:', 'Eye-Tracker Calibration:', 'Example Trials:', 'Drift Correction'},'CMI-EEG',1,{subj_Name{1,1},date,'y','y', 'y', 'y', 'n'});
        if strmatch('y', subj_ID(6,1),'exact');
            WISC_ProcessingSpeed_paradigm_example_new_response
        end      
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pausekey = KbName('p');
SITE = 'N';     % T = TCD, C = City College, E = EGI in City College
port=0;
par.nrpages = 4;
duration = 120 % how long the children have time to perform the task

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

if subj_ID{7,1} == 'y'
par.useDrift = 1;  % use the eye tracker?
else par.useDrift = 0; end;

monitorwidth_cm = 40;   % monitor width in cm
dist_cm = 57;  % viewing distance in cm
%%  
color_white = [255 255 255]
BGcolor = color_white ;
hz = 100;
 
whichScreen = 1;

[scresw, scresh]=Screen('WindowSize',whichScreen);  % Get screen resolution
center = [scresw scresh]/2;
fixRect = [center-2 center+2];  % fixation dot
cm2px = scresw/monitorwidth_cm;  % multiplication factor to convert cm to pixels
deg2px = dist_cm*cm2px*pi/180;      % multiplication factor to convert degrees to pixels (uses aproximation tanT ~= T).

%clear
%[X, map] = imread('Users/nicolaslanger/Desktop/AA_CCNY/WISC_Symbol_Search.bmp');

filepath_stimuli  = '/home/eeg/PsychToolbox_Experiments/Simon/WISC_PS/single_stimuli/'
filepath_responses = '/home/eeg/PsychToolbox_Experiments/Simon/WISC_PS/responses/'
filepath_eye_calib = '/home/eeg/PsychToolbox_Experiments/Simon/general_matlabfiles/'

files_stimuli = dir('/home/eeg/PsychToolbox_Experiments/Simon/WISC_PS/single_stimuli/*.bmp')
files_responses = dir('/home/eeg/PsychToolbox_Experiments/Simon/WISC_PS/responses/*.bmp')
files_eye_calib = dir('/home/eeg/PsychToolbox_Experiments/Simon/general_matlabfiles/eye_calib.bmp')

filepath_page = '/home/eeg/PsychToolbox_Experiments/Simon/WISC_PS/'
files_page = dir('/home/eeg/PsychToolbox_Experiments/Simon/WISC_PS/next_page.bmp')

names = {}
for i = 1:size(files_stimuli,1)
    
   names{end+1,1} =files_stimuli(i,1).name;
   all_images(i,:,:,:)= imread([filepath_stimuli, files_stimuli(i,1).name]);
end


for i = 1:size(files_responses,1)
   responses(i,:,:,:)= imread([filepath_responses,files_responses(i,1).name]);
end

next_page = imread([filepath_page,files_page(1,1).name]);
eye_calib_img = imread([filepath_eye_calib,files_eye_calib(1,1).name]);
%figure
%image(squeeze(all_images(1,:,:,:)));
%axis square;

%% Order of the Original WISC Symbol Search
order_page2 = [1 2 3 4 1 5 6;... 
7 8 7 9 10 11 12;... 
11 13 14 15 16 17 18;...
12 19 20 12 21 22 1;...
23 4 24 25 26 6 27;...
28 29 30 13 3 31 32;...
5 33 11 13 6 34 35;...
36 37 38 1 4 33 37;...
39 40 41 42 4 28 13;...
17 30 31 43 44 17 6;...
36 29 28 45 46 31 47;...
48 35 49 3 13 50 87;...
42 51 7 52 53 23 5;...
48 54 17 54 52 51 34;...
6 24 40 43 34 51 25];

order_page3 = [39 30 11 5 49 13 43;...
1 54 48 1 17 43 21;...
51 55 6 30 55 4 56;...
12 59 48 54 57 22 47;...
27 30 42 25 5 27 24;...
3 16 59 54 40 7 42;...
27 34 52 25 52 56 27;...
61 62 52 13 62 47 27;...
63 25 5 51 11 13 64;...
27 24 59 5 30 24 31;...
59 31 7 8 60 24 35;...
5 56 5 33 9 4 65 ;...
76 44 66 8 67 51 68;...
76 31 31 59 39 24 40;...
42 46 62 43 28 4 42];

order_page4 = [52 49 36 12 70 58 71;...
50 2 17 8 7 50 25;...
25 86 35 72 58 5 39;...
61 86 86 50 51 26 48;...
30 49 25 5 31 47 73;...
61 41 12 16 28 66 53;...
75 58 31 25 75 23 53;...
12 58 17 40 4 25 2;...
11 59 5 18 24 61 11;...
31 7 51 77 8 24 27;...
28 36 78 36 46 42 30;...
42 46 79 29 68 5 41;...
51 8 65 8 52 43 6;...
60 48 60 56 57 7 22;...
21 57 70 60 22 67 59];

order_page5 = [4 52 36 11 40 68 45;...
65 5 56 49 25 22 50;...
17 1 21 2 57 13 43;...
3 23 5 41 83 23 48;...
22 59 24 57 5 49 51;...
66 11 2 26 66 78 29;...
70 54 12 45 47 48 70;...
67 8 60 51 39 6 21;...
56 4 56 49 11 27 23;...
18 40 62 3 36 40 28;...
84 31 60 7 5 51 24;...
25 37 35 34 85 50 27;...
1 21 13 23 21 54 45;...
10 36 28 48 23 6 29;...
57 39 22 26 6 7 57];


% order_page2 = flipud(order_page2);
% order_page3 = flipud(order_page3);
% order_page4 = if par.useEL, 
                           
% order_page5 = flipud(order_page5);
%% Start Paradigm

% trigger codes - can only use these 15: [1 4 5 8 9 12 13 16 17 20 21 24 25 28 29]
par.CD_START  = 102;
par.CD_BUTTONS = [14 15 16];
par.CD_NXTPG = 20;
par.CD_DRIFT_START = 30 ;
par.CD_DRIFT_END =  31;

%Initiate NetStation Connection, Synchronization, and Recording
if par.recordEEG
  %  NetStation('Connect','10.0.0.42')
    NetStation('Synchronize')
    NetStation('StartRecording')
end



pages(1,:,:) = order_page2;
pages(2,:,:) = order_page3;
pages(3,:,:) = order_page4;
pages(4,:,:) = order_page5;

correct_resp_page2 = [1 1 0 1 0 0 0 1 0 1 0 0 0 1 0]
correct_resp_page3 = [0 1 1 0 1 0 1 1 0 1 0 1 0 1 1]
correct_resp_page4 = [0 1 0 1 0 0 1 0 1 0 1 0 1 1 0]
correct_resp_page5 = [0 0 0 1 0 1 1 0 1 1 0 0 1 0 1]

% correct_resp_page2 = fliplr(correct_resp_page2);
% correct_resp_page3 = fliplr(correct_resp_page3);
% correct_resp_page4 = fliplr(correct_resp_page4); 
% correct_resp_page5 = fliplr(correct_resp_page5); 

correct_resp(1,:) = correct_resp_page2;
correct_resp(2,:) = correct_resp_page3;
correct_resp(3,:) = correct_resp_page4;
correct_resp(4,:) = correct_resp_page5;



Screen('Preference','SkipSyncTests',1);
Screen('Preference', 'VisualDebugLevel', 0);
window = Screen('OpenWindow', whichScreen, BGcolor);
Screen('Flip', window, [],[],1); 
eye_calib = Screen('MakeTexture', window, eye_calib_img);
stimrect_calib = [-20 -20 20 20];

Screen('TextSize', window, 16);
Screen('DrawText', window, 'Now the same task again.', 0.05*scresw, 0.05*scresh, 0);
Screen('DrawText', window, 'This time there will be more trials.', 0.05*scresw, 0.15*scresh, 0);
Screen('DrawText', window, 'Try to be as accurate and fast as possible.', 0.05*scresw, 0.20*scresh, 0);
Screen('DrawText', window, 'There will be 4 pages. ', 0.05*scresw, 0.25*scresh, 0);
Screen('DrawText', window, 'Do not forget to press the arrow to proceed.', 0.05*scresw, 0.30*scresh, 0);
Screen('DrawText', window, 'You have 2 minutes to solve as many trials as possible.', 0.05*scresw, 0.35*scresh, 0);
Screen('DrawText', window, 'Check after each response if the yes or no box is marked.', 0.05*scresw, 0.45*scresh, 0);

Screen('DrawText', window, 'Press the mouse button to begin the TASK', 0.05*scresw, 0.55*scresh, 0);
if subj_ID{5,1} == 'y';
Screen('DrawText', window, 'First we have to measure the position of your eyes.', 0.05*scresw, 0.70*scresh, 0);
Screen('DrawText', window, 'Just follow with your eyes the the circle:', 0.05*scresw, 0.75*scresh, 0);
Screen('DrawTexture', window, eye_calib, [], [center(1)-10 500 center(1)+10 520] + stimrect_calib);
else par.useEL_Calib = 0; end;

Screen('Flip', window, [],[],1);  %Screen(window, 'Flip',[],1);
fprintf('THE SUBJECT IS READING THE INSTRUCTIONS...');
[clicks,x,y,whichButton] = GetClicks(whichScreen,0);



if par.useEL, open_udp_socket; end
if par.useEL && par.useEL_Calib; Eyetracker_connection_calib; 
elseif par.useEL == 1 && par.useEL_Calib == 0; Eyetracker_connection_passive; end


if par.useDrift == 1 && par.useEL == 1
    if par.recordEEG, sendtrigger(par.CD_START,port,SITE,0), end
    %calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_START))])));
     [success, ivx]=iViewX('message', ivx, [ num2str(num2str(par.CD_START))]);
                        
    wavfilename_probe1 = '/home/eeg/PsychToolbox_Experiments/Simon/general_matlabfiles/COUNTDOWN_EYETRACKER_DRIFT.wav '
    [y_probe1, freq1] = wavread(wavfilename_probe1);
    wavedata_probe1 = y_probe1';
    nrchannels = size(wavedata_probe1,1);
    sugLat = [];
if IsWin
sugLat = 0.015;
end
InitializePsychSound(0)
pamaster = PsychPortAudio('Open', [], 1+8, 1, freq1, nrchannels, [], sugLat);
PsychPortAudio('Start', pamaster, 0, 0, 1);
PsychPortAudio('Volume', pamaster, 0.5);
duration_probe1 = size(wavedata_probe1,2)/freq1
pasound_probe1 = PsychPortAudio('OpenSlave', pamaster, 1);
% Create audio buffers prefilled with the 3 sounds:
pabuffer_probe1 = PsychPortAudio('CreateBuffer', [], wavedata_probe1);

window = Screen('OpenWindow', whichScreen, BGcolor); 
eye_calib = Screen('MakeTexture', window, eye_calib_img);
Screen('DrawText', window, '', 0.05*scresw, 0.70*scresh, 0);
Screen('DrawTexture', window, eye_calib, [], [center(1) center(2) center(1) center(2)] + stimrect_calib);
Screen('Flip', window, [],[],1); 
%calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_DRIFT_START))])))
[success, ivx]=iViewX('message', ivx, [ num2str(num2str(par.CD_DRIFT_START))])
 
pahandle = PsychPortAudio('Open', [], [], 0, [], nrchannels);
                PsychPortAudio('FillBuffer', pahandle, pabuffer_probe1);
                PsychPortAudio('Start', pahandle, 1, 0, 1);
                WaitSecs(duration_probe1)
%calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_DRIFT_END))])))
 [success, ivx]=iViewX('message', ivx, [ num2str(num2str(par.CD_DRIFT_END))])
     
end


if par.recordEEG && par.useDrift == 0, sendtrigger(par.CD_START,port,SITE,0), end
%if par.useEL == 1 && par.useDrift == 0, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_START))])));end;
if par.useEL == 1 && par.useDrift == 0,  [success, ivx]=iViewX('message', ivx, [ num2str(num2str(par.CD_START))]);end;


window = Screen('OpenWindow', whichScreen, BGcolor);  

time = GetSecs;


% %restrict mouse movement (timerCallback.m needs to be in the path). there you can also define the range 
% timerObj = timer('TimerFcn',@timerCallback,'ExecutionMode','fixedRate','Period',0.001)%,'BusyMode','queue','TasksToExecute',1)
% %3. start 
% % this will run until you type stop(timerObj). You may want to have the stop callback implemented in a GUI button. 
% start(timerObj);
% %stop(timerObj)
% %timerfindall

Screen('TextSize', window, 25);
Screen('DrawText', window, 'THE TASK STARTS NOW! ', 0.25*scresw, 0.45*scresh, 0);
Screen('Flip', window, [],[],1);
WaitSecs(2)

par.activated_resp = zeros(4,15,2)+2;
x = []; y=[];whichButton = [];
for pp = 1:par.nrpages
if par.recordEEG, sendtrigger(par.CD_NXTPG,port,SITE,0), end
%if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_NXTPG))])));end;
if par.useEL, [success, ivx]=iViewX('message', ivx, [ num2str(num2str(par.CD_NXTPG))]); end

%if par.useEL, cross = [400,300];f = figure;h1 = plot(cross(1), cross(2),'+');xlim([0 800]);ylim([0 600]);hold ;end
    %window_eye = Screen('OpenWindow', whichScreen_eye, [], [0 0 1280/3 1024/3]); end;



stimrectT = [-15 -15 15 15]; % defines the rescaling / changing size of the stimuli


trial_duration = [];
textures = [];
for i = 1:size(all_images,1)
textures(i,1) = Screen('MakeTexture', window, squeeze(all_images(i,:,:,:)));
end
resp_textures = [];
for i = 1:size(responses,1)
resp_textures(i,1) = Screen('MakeTexture', window, squeeze(responses(i,:,:,:)));
end
next_page_texture = Screen('MakeTexture', window, next_page);

pos_y = 11:-1.5:-11;
pos_x = [17,13, 6 2 -2 -6 -10];
pos_resp =[-17, -14];


for j = 1:15
for i = 1:7
Screen('DrawTexture', window, textures(pages(pp,j,i),1), [], [center center] + [-deg2px*pos_x(i) -deg2px*pos_y(j) -deg2px*pos_x(i) -deg2px*pos_y(j)] + stimrectT);
end
end

% for j = 1:15
% for i = 1:7
% position_stimuli(j,i,:) = [center center] + [-deg2px*pos_x(i) -deg2px*pos_y(j) -deg2px*pos_x(i) -deg2px*pos_y(j)] + stimrectT
% end
% end

% first is NO, second is YES

% rescaling factor for response size box:
stimrectT_resp = [-40 -30 40 30];

for j = 1:15
for i = 1:2
Screen('DrawTexture', window, resp_textures(i,1), [], [center center] + [-deg2px*pos_resp(i) -deg2px*pos_y(j) -deg2px*pos_resp(i) -deg2px*pos_y(j)] + stimrectT);
% define space for response selection
resp_size_box(j,i,:) = [center center] + [-deg2px*pos_resp(i) -deg2px*pos_y(j) -deg2px*pos_resp(i) -deg2px*pos_y(j)] + stimrectT_resp;
resp_cross(j,i,:) = [center center] + [-deg2px*pos_resp(i) -deg2px*pos_y(j) -deg2px*pos_resp(i) -deg2px*pos_y(j)] + stimrectT;
end
end

pos_line_y = 3:1.5:34.5;
for j = 1:16
Screen('DrawLine', window,[0 0 0],50,deg2px*pos_line_y(j)+5, scresw-50, deg2px*pos_line_y(j)+5,1);
end

Screen('DrawTexture', window, next_page_texture, [], [760 565 760 565] + stimrectT_resp);
Screen('Flip', window, [],1); % [],1 means that it stays until the next flip
  

%Save print screen
%imageArray = Screen('GetImage', window );
%imwrite(imageArray, 'page5.jpg')

yes = zeros(15,1);
no = zeros(15,1);

%correct response for page 2

perf = 0;
correction = zeros(15,1);
whichButton = 1 ;% initially, will be updated
% get Response clicks
%calllib('iViewXAPI', 'iV_ShowTrackingMonitor')
%calllib('iViewXAPI', 'iV_ShowEyeImageMonitor') 
%% get response
HideCursor
%SetMouse(1680,300,1) % middle of the second screen
%SetMouse([1280+638-20],51,1)
SetMouse([638-20],51,1)
ShowCursor(0,whichScreen)



tic

fine = 0;
while fine < 1;
 
    
         %draw over white 

            
            
            
 [clicks,x(end+1,1),y(end+1,1),whichButton(end+1,1)] = GetClicks(whichScreen,0);    
            
 
targ = 1 ;
%     if size(x,1)>1
%         return
%     end
%     
    for resp_b = 1:15
        
   
    
if par.activated_resp(pp,resp_b,1) == 2 && par.activated_resp(pp,resp_b,2) == 2 && x(end) >= resp_cross(resp_b,2,1) && x(end) <= resp_cross(resp_b,2,3) && y(end) >= resp_cross(resp_b,2,2) && y(end) <= resp_cross(resp_b,2,4);
            %yes(c,1) =1;
            targ = 0;
            trial_duration(pp,end+1,1) = toc;
            par.activated_resp(pp,resp_b,1) = 1;  par.activated_resp(pp,resp_b,2) = 0; 
            if par.recordEEG, sendtrigger(par.CD_BUTTONS(1),port,SITE,0); end
%            if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_BUTTONS(1)))])));end;
            if par.useEL == 1,  eyetr_sendtrigger(par.CD_BUTTONS(1),sock); end;

            Screen('FillRect',window, [255 255 255], [0.58*scresw 0.05*scresh 0.58*scresw+400 0.05*scresh+20]);  
            Screen('FillRect',window, [255 255 255], [0.05*scresw 0.86*scresh 0.25*scresw+500 0.86*scresh+100]); 
             
            Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,2,1),resp_cross(resp_b,2,2), resp_cross(resp_b,2,3), resp_cross(resp_b,2,4),2);
            Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,2,1),resp_cross(resp_b,2,4), resp_cross(resp_b,2,3), resp_cross(resp_b,2,2),2);
            
            if correct_resp(pp,resp_b) == squeeze(par.activated_resp(pp,resp_b ,1))
                    disp(['Trial',num2str(resp_b), ': Correct'])
                    else
                    disp(['Trial',num2str(resp_b), ': Wrong'])
            end;
               
            
            vbl = Screen('Flip', window, [],1);
                if vbl >=time+duration %Tests if 120 secs are gone
                            if par.recordEEG, sendtrigger(par.CD_NXTPG,port,SITE,0), end
                           % if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_NXTPG))])));end;
                           if par.useEL == 1,  eyetr_sendtrigger(par.CD_NXTPG,sock); end;

                             perf = 0;
                             for pp = 1:4
                             for i = 1:15
                                if correct_resp(pp,i) == squeeze(par.activated_resp(pp,i,1))
                            %     disp(['Trial',num2str(c), ': Correct'])
                            %     par.resp_click(pp,c) = 1;
                               perf = perf+1; 
                             end;end;end
                             disp(['PERFORMANCE OVERALL: ',num2str(perf), ' of 60 possible', ' correct'])
                            
                            
                            Screen('TextSize', window, 21);
                            Screen('DrawText', window, 'TIME IS OVER - TASK FINISHED', 0.20*scresw, 0.85*scresh, [255 0 0]);
                            Screen('Flip', window, [],1); %WaitSecs(2);
                            %stop(timerObj)
                            WaitSecs(2)
                            save([par.runID , '_WISC_ProcSpeed_2nd'],'par', 'trial_duration','perf')
                            if par.useEL, 
                                % stop recording   

                            pnet(sock,'write','end');
pnet(sock,'writepacket');
                            end
                            sca;
                             %exitLoop = 1
                            NetStation('StopRecording')
                            clearvars -except select subj_ID metafile subj_Name
                            close all
                            return
                end
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5                

elseif par.activated_resp(pp,resp_b,2) == 1 && par.activated_resp(pp,resp_b,1) == 0 && x(end) >= resp_cross(resp_b,2,1) && x(end) <= resp_cross(resp_b,2,3) && y(end) >= resp_cross(resp_b,2,2) && y(end) <= resp_cross(resp_b,2,4);
            %yes(c,1) =1;
            targ = 0;
            trial_duration(pp,end+1,1) = toc;
            par.activated_resp(pp,resp_b,1) = 1; par.activated_resp(pp,resp_b,2) = 0;
            if par.recordEEG, sendtrigger(par.CD_BUTTONS(1),port,SITE,0); end
            %if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_BUTTONS(1)))])));end;
             if par.useEL, eyetr_sendtrigger(par.CD_BUTTONS(1),sock); end;

            Screen('DrawTexture', window, resp_textures(1,1), [], [center center] + [-deg2px*pos_resp(1) -deg2px*pos_y(resp_b) -deg2px*pos_resp(1) -deg2px*pos_y(resp_b)] + stimrectT);
            
            Screen('FillRect',window, [255 255 255], [0.58*scresw 0.05*scresh 0.58*scresw+400 0.05*scresh+20]);  
            Screen('FillRect',window, [255 255 255], [0.05*scresw 0.86*scresh 0.25*scresw+500 0.86*scresh+100]); 
            
            Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,2,1),resp_cross(resp_b,2,2), resp_cross(resp_b,2,3), resp_cross(resp_b,2,4),2);
            Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,2,1),resp_cross(resp_b,2,4), resp_cross(resp_b,2,3), resp_cross(resp_b,2,2),2);
            
            if correct_resp(pp,resp_b) == squeeze(par.activated_resp(pp,resp_b ,1))
                    disp(['Trial',num2str(resp_b), ': Correct'])
                    else
                    disp(['Trial',num2str(resp_b), ': Wrong'])
            end;
            
            vbl = Screen('Flip', window, [],1);
                if vbl >=time+duration %Tests if 120 secs are gone
                            if par.recordEEG, sendtrigger(par.CD_NXTPG,port,SITE,0), end
                            %if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_NXTPG))])));end;
                              if par.useEL, eyetr_sendtrigger(par.CD_NXTPG,sock); end;

                            perf = 0;
                             for pp = 1:4
                             for i = 1:15
                                if correct_resp(pp,i) == squeeze(par.activated_resp(pp,i,1))
                            %     disp(['Trial',num2str(c), ': Correct'])
                            %     par.resp_click(pp,c) = 1;
                               perf = perf+1; 
                             end;end;end
                             disp(['PERFORMANCE OVERALL: ',num2str(perf), ' of 60 possible', ' correct'])
                   
                            Screen('TextSize', window, 21);
                            Screen('DrawText', window, 'TIME IS OVER - TASK FINISHED', 0.20*scresw, 0.85*scresh, [255 0 0]);
                            Screen('Flip', window, [],1); %WaitSecs(2);
                           % stop(timerObj)
                            WaitSecs(2)
                            save([par.runID , '_WISC_ProcSpeed_2nd'],'par', 'trial_duration', 'perf')
                           if par.useEL, 
                                % stop recording   
pnet(sock,'write','end');
pnet(sock,'writepacket');
                            end
                            
                            sca;
                             %exitLoop = 1
                            NetStation('StopRecording')
                            clearvars -except select subj_ID metafile subj_Name
                            close all
                            return
                end              
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5                

  elseif par.activated_resp(pp,resp_b,1) == 2 && par.activated_resp(pp,resp_b,2) == 2 && x(end) >= resp_cross(resp_b,1,1) && x(end) <= resp_cross(resp_b,1,3) && y(end) >= resp_cross(resp_b,1,2) && y(end) <= resp_cross(resp_b,1,4);
            %no(c,1) = 1;
            targ = 0;
           trial_duration(pp,end+1,1) = toc;
            par.activated_resp(pp,resp_b,2) = 1; par.activated_resp(pp,resp_b,1) = 0;
            if par.recordEEG, sendtrigger(par.CD_BUTTONS(1),port,SITE,0); end
            %if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_BUTTONS(1)))])));end;
            if par.useEL, eyetr_sendtrigger(par.CD_BUTTONS(1),sock);end;
            
            Screen('FillRect',window, [255 255 255], [0.58*scresw 0.05*scresh 0.58*scresw+400 0.05*scresh+20]);  
            Screen('FillRect',window, [255 255 255], [0.05*scresw 0.86*scresh 0.25*scresw+500 0.86*scresh+100]); 
            
            Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,1,1),resp_cross(resp_b,1,2), resp_cross(resp_b,1,3), resp_cross(resp_b,1,4),2);
            Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,1,1),resp_cross(resp_b,1,4), resp_cross(resp_b,1,3), resp_cross(resp_b,1,2),2);
            
           if correct_resp(pp,resp_b) == squeeze(par.activated_resp(pp,resp_b ,1))
                    disp(['Trial',num2str(resp_b), ': Correct'])
                    else
                    disp(['Trial',num2str(resp_b), ': Wrong'])
            end;
            
            
            vbl =Screen('Flip', window, [],1);
            
                if vbl >=time+duration %Tests if 120 secs are gone
                        if par.recordEEG, sendtrigger(par.CD_NXTPG,port,SITE,0), end
                        %if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_NXTPG))])));end;
                        if par.useEL, eyetr_sendtrigger(par.CD_NXTPG,sock);end;
                        
                        perf = 0;
                             for pp = 1:4
                             for i = 1:15
                                if correct_resp(pp,i) == squeeze(par.activated_resp(pp,i,1))
                            %     disp(['Trial',num2str(c), ': Correct'])
                            %     par.resp_click(pp,c) = 1;
                               perf = perf+1; 
                             end;end;end
                             disp(['PERFORMANCE OVERALL: ',num2str(perf), ' of 60 possible', ' correct'])
                   
                        Screen('TextSize', window, 21);
                        Screen('DrawText', window, 'TIME IS OVER - TASK FINISHED', 0.20*scresw, 0.85*scresh, [255 0 0]);
                        Screen('Flip', window, [],1); %WaitSecs(2);
                        % stop(timerObj)
                        WaitSecs(2)
                            save([par.runID , '_WISC_ProcSpeed_2nd'],'par', 'trial_duration','perf')
                            if par.useEL, 
                                % stop recording   

                           
                                pnet(sock,'write','end');
                                pnet(sock,'writepacket');
                            end
                            
                            sca;
                             %exitLoop = 1
                            NetStation('StopRecording')
                            clearvars -except select subj_ID metafile subj_Name
                            close all
                            return
                end
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5                

  elseif par.activated_resp(pp,resp_b,1) == 1 && par.activated_resp(pp,resp_b,2) == 0 && x(end) >= resp_cross(resp_b,1,1) && x(end) <= resp_cross(resp_b,1,3) && y(end) >= resp_cross(resp_b,1,2) && y(end) <= resp_cross(resp_b,1,4);
            %no(c,1) = 1;
            targ = 0;
            trial_duration(pp,end+1,1) = toc;
            par.activated_resp(pp,resp_b,2) = 1; par.activated_resp(pp,resp_b,1) = 0;
            if par.recordEEG, sendtrigger(par.CD_BUTTONS(1),port,SITE,0); end
           % if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_BUTTONS(1)))])));end;
           if par.useEL, eyetr_sendtrigger(par.CD_BUTTONS(1),sock);end;
           
             Screen('DrawTexture', window, resp_textures(2,1), [], [center center] + [-deg2px*pos_resp(2) -deg2px*pos_y(resp_b) -deg2px*pos_resp(2) -deg2px*pos_y(resp_b)] + stimrectT);
            
            Screen('FillRect',window, [255 255 255], [0.58*scresw 0.05*scresh 0.58*scresw+400 0.05*scresh+20]);  
            Screen('FillRect',window, [255 255 255], [0.05*scresw 0.86*scresh 0.25*scresw+500 0.86*scresh+100]); 
            
            Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,1,1),resp_cross(resp_b,1,2), resp_cross(resp_b,1,3), resp_cross(resp_b,1,4),2);
            Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,1,1),resp_cross(resp_b,1,4), resp_cross(resp_b,1,3), resp_cross(resp_b,1,2),2);
            
           if correct_resp(pp,resp_b) == squeeze(par.activated_resp(pp,resp_b ,1))
                    disp(['Trial',num2str(resp_b), ': Correct'])
                    else
                    disp(['Trial',num2str(resp_b), ': Wrong'])
            end;
            
            
            vbl =Screen('Flip', window, [],1);
            
                if vbl >=time+duration %Tests if 120 secs are gone
                        if par.recordEEG, sendtrigger(par.CD_NXTPG,port,SITE,0), end
                        %if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_NXTPG))])));end;
                         if par.useEL, eyetr_sendtrigger(par.CD_NXTPG,sock);end;     
                        
                        perf = 0;
                             for pp = 1:4
                             for i = 1:15
                                if correct_resp(pp,i) == squeeze(par.activated_resp(pp,i,1))
                            %     disp(['Trial',num2str(c), ': Correct'])
                            %     par.resp_click(pp,c) = 1;
                               perf = perf+1; 
                             end;end;end
                             disp(['PERFORMANCE OVERALL: ',num2str(perf), ' of 60 possible', ' correct'])
                   
                        Screen('TextSize', window, 21);
                        Screen('DrawText', window, 'TIME IS OVER - TASK FINISHED', 0.20*scresw, 0.85*scresh, [255 0 0]);
                        Screen('Flip', window, [],1); %WaitSecs(2);
                        % stop(timerObj)
                        WaitSecs(2)
                            save([par.runID , '_WISC_ProcSpeed_2nd'],'par', 'trial_duration','perf')
                           if par.useEL, 
                                % stop recording   

                            pnet(sock,'write','end');
pnet(sock,'writepacket');
                            end
                            
                            sca;
                             %exitLoop = 1
                            NetStation('StopRecording')
                            
                            clearvars -except select subj_ID metafile subj_Name
                            close all
                            return
                end                
  
elseif sum(sum(par.activated_resp(pp,:,:))) == 15 && x(end) >= 750 && x(end) <= 800 && y(end) >= 555 && y(end) <= 600;              
fine = 1;
targ = 0;
trial_duration(pp,end+1,1) = toc;
elseif sum(sum(par.activated_resp(pp,:,:))) < 15  && x(end) >= 750 && x(end) <= 800 && y(end) >= 555 && y(end) <= 600;              
     targ = 0;
    Screen('TextSize', window, 12);
    trial_duration(pp,end+1,1) = toc;       
    Screen('DrawText', window, 'You have not completed all the trials.', 0.05*scresw, 0.90*scresh, [255 0 0]);
             Screen('DrawText', window, 'Please complete all trials before you proceed to the next page.', 0.05*scresw, 0.95*scresh, [255 0 0]);
%              Screen('FillRect',window, [255 255 255], [0.05*scresw 0.86*scresh 0.25*scresw+500 0.86*scresh+100]); Screen('Flip', window, [],1);
             Screen('Flip', window, [],1); %WaitSecs(3);
                
% elseif targ == 1 
%     
%             trial_duration(pp,end+1,1) = toc;
%             Screen('TextSize', window, 12);
%             Screen('DrawText', window, 'No Response recognized: Try Again', 0.58*scresw, 0.05*scresh, [255 0 0]);
%             Screen('Flip', window, [],1); %WaitSecs(2);
%             %[clicks,x(c,1),y(c,1),whichButton] = GetClicks(whichScreen,0);
%             %Screen('FillRect',window, [255 255 255], [0.58*scresw 0.05*scresh 0.58*scresw+400 0.05*scresh+20]);  
%             %Screen('Flip', window, [],1);    
%                 

            
            
end
    end

    
     if targ == 1 
    
            trial_duration(pp,end+1,1) = toc;
            Screen('TextSize', window, 12);
            Screen('DrawText', window, 'No Response recognized: Try Again', 0.58*scresw, 0.05*scresh, [255 0 0]);
            Screen('Flip', window, [],1); %WaitSecs(2);
            %[clicks,x(c,1),y(c,1),whichButton] = GetClicks(whichScreen,0);
            %Screen('FillRect',window, [255 255 255], [0.58*scresw 0.05*scresh 0.58*scresw+400 0.05*scresh+20]);  
            %Screen('Flip', window, [],1);    
    end    
    
    
end

 

      
  end




if par.recordEEG, sendtrigger(par.CD_NXTPG,port,SITE,0), end
%if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_NXTPG))])));end;
 if par.useEL, eyetr_sendtrigger(par.CD_NXTPG,sock); end;
                        

 perf = 0;
 for pp = 1:4
for i = 1:15
  if correct_resp(pp,i) == squeeze(par.activated_resp(pp,i,1))
%     disp(['Trial',num2str(c), ': Correct'])
%     par.resp_click(pp,c) = 1;
    perf = perf+1; 
  end;end;end
disp(['PERFORMANCE OVERALL: ',num2str(perf), ' of 60 possible', ' correct'])


                        Screen('TextSize', window, 21);
                        Screen('DrawText', window, 'TASK COMPLETED', 0.20*scresw, 0.85*scresh, [255 0 0]);
                        Screen('Flip', window, [],1); %WaitSecs(2);
                        %stop(timerObj)
                        WaitSecs(2)
                            save([par.runID , '_WISC_ProcSpeed_2nd'],'par', 'trial_duration','perf')
                            if par.useEL, 
                                % stop recording   
pnet(sock,'write','end');
pnet(sock,'writepacket');
                            end
                            
                            sca;
                             %exitLoop = 1
                            NetStation('StopRecording')
                            clearvars -except select subj_ID metafile subj_Name
                            close all      
            
            
            
            
            
            
            
            
            
            
            
            
            
