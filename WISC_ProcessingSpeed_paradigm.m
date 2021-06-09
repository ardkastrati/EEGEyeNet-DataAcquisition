%% Settings
I_GenSettings
color_white = [255 255 255];
BGcolor = color_white ;
par.BGcolor = colorBrightBG ;
par.nrpages = 4;
duration = 120; % how long the subjects have time to perform the task
Instructions;
par.block=app.run{6};

%Path to the WISC Files
fp = '/home/stimuluspc/Eyepredict/WISC_PS/';
ec = '/'; %Path Symbol change for Linux

% trigger codes - can only use these 15: [1 4 5 8 9 12 13 16 17 20 21 24 25 28 29]
if par.block==1
par.CD_START  = 921;
elseif par.block==2
    par.CD_START  = 922;
end
    
par.CD_BUTTONS = [14 15 16];
par.CD_NXTPG = 20;
par.CD_DRIFT_START = 30 ;
par.CD_DRIFT_END =  31;

savePath = app.savePath;


%% Processing-Speed
if testmode == 1 % Testmode, modify to your liking
    par.runID = 1;
    par.recordEEG = 0;
    par.useEL = 0;
    par.useEL_Calib = 0;
    par.useDrift = 0;
else
    I_SetPar; % Setting the par file according to call
end;

par.runID= app.run{1};
par.ExaminationDate=app.run{2};
savePath = ['All_Subjects/',par.runID,'/'];

%% Screen Calculations TODO Just added to TEST
[scresw, scresh]=Screen('WindowSize',whichScreen);  % Get screen resolution
center = [scresw scresh]/2;     % useful to have the pixel coordinates of the very center of the screen (usually where you have someone fixate)
fixRect = [center-2 center+2];  % fixation dot
hz=Screen('FrameRate', whichScreen,1);
cm2px = scresw/monitorwidth_cm;  % multiplication factor to convert cm to pixels
deg2px = dist_cm*cm2px*pi/180;      % multiplication factor to convert degrees to pixels (uses aproximation tanT ~= T).

load gammafnCRT;   % load the gamma function parameters for this monitor - or some other CRT and hope they're similar! (none of our questions rely on precise quantification of physical contrast)
maxLum = GrayLevel2Lum(255,Cg,gam,b0);
par.BGcolor=Lum2GrayLevel(maxLum/2,Cg,gam,b0);

%% Path Definition
filepath_stimuli  = strcat(fp,'single_stimuli',ec);
filepath_responses =  strcat(fp,'responses',ec);
files_stimuli = dir(strcat(fp,'single_stimuli',ec,'*.bmp'));
files_responses = dir(strcat(fp,'responses',ec,'*.bmp'));
filepath_page = fp;
files_page = dir(strcat(fp,'next_page.bmp'));
clear fp ec;

%% Connect and Calibrate Eyetracker
if par.useEL
    window = Screen('OpenWindow', whichScreen, par.BGcolor);
    EL_Connect; %Connect the Eytracker, it needs a window
    try % open file to record data to
        edfFile=[num2str(par.runID),'_WI',num2str(par.block),'.edf'];
        Eyelink('Openfile', edfFile);
    catch
        fprintf('Error creating the file on Tracker\n');
    end;
    if par.useEL_Calib
        EL_Calibrate
    end; %If needed, run Calibration
    Eyelink('command', 'record_status_message "PROCESSING SPEED"');
else
    window = Screen('OpenWindow', whichScreen, par.BGcolor);
    disp('No Eyetracker');
end

%% Initiate NetStation Connection, Synchronization, and Recording
if par.recordEEG
    %[status,info] = NetStation('Connect','100.1.1.3',55513);
    NetStation('Synchronize');
    WaitSecs(1);
else
    disp('No EEG');
end

%% WIDC Calc
names = {};
for i = 1:size(files_stimuli,1)
    names{end+1,1} =files_stimuli(i,1).name;
    all_images(i,:,:,:)= imread([filepath_stimuli, files_stimuli(i,1).name]);
end

for i = 1:size(files_responses,1)
    responses(i,:,:,:)= imread([filepath_responses,files_responses(i,1).name]);
end

next_page = imread([filepath_page,files_page(1,1).name]);

%% Order of the Original WISC Symbol Search
if par.block == 1
    if startsWith(par.runID,'A') == 1 || startsWith(par.runID,'L')
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
    correct_resp_page2 = [1 1 0 1 0 0 0 1 0 1 0 0 0 1 0];
   
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
    correct_resp_page3 = [0 1 1 0 1 0 1 1 0 1 0 1 0 1 1];
   
    order_page4 = [72 80 8 35 23 70 38;...
        80 12 23 13 12 76 51;...
        45 13 75 55 31 45 35;...
        7 5 11 16 21 37 9;...
        79 83 43 44 30 79 33;...
        10 68 34 22 36 9 12;...
        82 84 51 6 21 31 72;...
        2 40 15 57 64 57 40;...
        48 26 65 17 60 16 33;...
        55 68 8 81 68 43 38;...
        39 27 45 47 72 70 57;...
        33 71 47 31 82 77 48;...
        55 52 19 27 41 21 74;...
        17 28 15 20 38 28 81;...
        38 10 79 86 39 10 23];
    correct_resp_page4 = [0 1 1 0 1 0 0 1 0 1 0 0 0 1 1];
   
    order_page5 = [36 62 23 53 62 20 11;...
        26 28 37 45 8 23 70;...
        5 82 64 43 51 21 40;...
        55 48 46 21 43 55 60;...
        35 32 86 4 78 80 70;...
        9 23 30 60 23 63 10;...
        30 43 68 63 79 78 30;...
        61 18 3 65 44 42 79;...
        2 54 75 71 51 16 21;...
        78 3 43 15 82 63 44;...
        41 6 60 4 7 46 9;...
        58 63 14 58 46 85 57;...
        70 16 38 72 8 12 16;...
        35 6 70 6 35 46 37;...
        58 55 26 38 2 81 72];
    correct_resp_page5 = [1 0 0 1 0 1 1 0 0 0 0 1 1 1 0];
  
    elseif startsWith(par.runID,'B') == 1 %% page 2 = page 3 & page 4 = page 5 plus 1. Trial ist der letzte und der letzte ist der erste
   
    order_page3 = [1 2 3 4 1 5 6;...
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
    order_page3 = flipud(order_page3 );
    correct_resp_page3 = [1 1 0 1 0 0 0 1 0 1 0 0 0 1 0];
    correct_resp_page3 = fliplr(correct_resp_page3);
   
    order_page2 = [39 30 11 5 49 13 43;...
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
       order_page2 = flipud(order_page2 );
    correct_resp_page2 = [0 1 1 0 1 0 1 1 0 1 0 1 0 1 1];
    correct_resp_page2 = fliplr(correct_resp_page2);
   
    order_page5 = [72 80 8 35 23 70 38;...
        80 12 23 13 12 76 51;...
        45 13 75 55 31 45 35;...
        7 5 11 16 21 37 9;...
        79 83 43 44 30 79 33;...
        10 68 34 22 36 9 12;...
        82 84 51 6 21 31 72;...
        2 40 15 57 64 57 40;...
        48 26 65 17 60 16 33;...
        55 68 8 81 68 43 38;...
        39 27 45 47 72 70 57;...
        33 71 47 31 82 77 48;...
        55 52 19 27 41 21 74;...
        17 28 15 20 38 28 81;...
        38 10 79 86 39 10 23];
       order_page5 = flipud(order_page5 );
    correct_resp_page5 = [0 1 1 0 1 0 0 1 0 1 0 0 0 1 1];
        correct_resp_page5 = fliplr(correct_resp_page5);
       
    order_page4 = [36 62 23 53 62 20 11;...
        26 28 37 45 8 23 70;...
        5 82 64 43 51 21 40;...
        55 48 46 21 43 55 60;...
        35 32 86 4 78 80 70;...
        9 23 30 60 23 63 10;...
        30 43 68 63 79 78 30;...
        61 18 3 65 44 42 79;...
        2 54 75 71 51 16 21;...
        78 3 43 15 82 63 44;...
        41 6 60 4 7 46 9;...
        58 63 14 58 46 85 57;...
        70 16 38 72 8 12 16;...
        35 6 70 6 35 46 37;...
        58 55 26 38 2 81 72];
      order_page4 = flipud(order_page4 );
    correct_resp_page4 = [1 0 0 1 0 1 1 0 0 0 0 1 1 1 0];
           correct_resp_page4 = fliplr(correct_resp_page4);
    end
   
elseif par.block==2
  
  if startsWith(par.runID,'A') == 1 || startsWith(par.runID,'L')
     order_page2 = [52 49 36 12 70 58 71;...
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
    correct_resp_page2 = [0 1 0 1 0 0 1 0 1 0 1 0 1 1 0];
   
    order_page3 = [4 52 36 11 40 68 45;...
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
    correct_resp_page3 = [0 0 0 1 0 1 1 0 1 1 0 0 1 0 1];
   
    order_page4 = [15 10 33 18 43 30 83;...
        81 5 65 24 37 48 81;...
        37 86 29 61 58 37 61;...
        58 16 12 87 15 3 49;...
        77 59 17 33 41 86 14;...
        75 57 33 75 38 42 11;...
        52 20 34 51 22 52 54;...
        24 86 86 64 30 51 10;...
        79 77 72 23 52 2 37;...
        28 15 16 37 9 53 41;...
        61 7 56 3 6 28 47;...
        36 47 72 63 85 47 29;...
        10 54 5 37 8 24 14;...
        25 39 46 40 77 46 83;...
        56 84 21 56 26 59 61];
    correct_resp_page4 = [0 1 1 0 0 1 1 1 0 0 0 1 0 0 1];
   
    order_page5 = [74 23 20 59 74 30 68;...
        59 1 53 34 80 1 41;...
        37 41 68 29 69 42 4;...
        16 63 42 14 30 53 17;...
        67 22 80 24 67 17 26;...
        8 51 60 48 38 55 57;...
        60 56 83 19 62 21 11;...
        53 40 40 58 68 31 58;...
        51 74 73 23 54 51 48;...
        76 24 28 11 82 57 42;...
        56 48 57 48 63 46 87;...
        20 10 6 10 36 40 32;...
        67 59 68 82 85 17 13;...
        61 47 46 47 75 43 35;...
        59 65 46 31 14 51 23];
    correct_resp_page5 = [1 1 0 0 1 0 0 1 1 0 1 1 0 1 0];  
   
   
   elseif startsWith(par.runID,'B') == 1
    order_page3 = [52 49 36 12 70 58 71;...
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
     order_page3 = flipud(order_page3 );
    correct_resp_page3 = [0 1 0 1 0 0 1 0 1 0 1 0 1 1 0];
     correct_resp_page3 = fliplr(correct_resp_page3);
    
    order_page2 = [4 52 36 11 40 68 45;...
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
    order_page2 = flipud(order_page2 );
    correct_resp_page2 = [0 0 0 1 0 1 1 0 1 1 0 0 1 0 1];
     correct_resp_page2 = fliplr(correct_resp_page2);
    
    order_page5 = [15 10 33 18 43 30 83;...
        81 5 65 24 37 48 81;...
        37 86 29 61 58 37 61;...
        58 16 12 87 15 3 49;...
        77 59 17 33 41 86 14;...
        75 57 33 75 38 42 11;...
        52 20 34 51 22 52 54;...
        24 86 86 64 30 51 10;...
        79 77 72 23 52 2 37;...
        28 15 16 37 9 53 41;...
        61 7 56 3 6 28 47;...
        36 47 72 63 85 47 29;...
        10 54 5 37 8 24 14;...
        25 39 46 40 77 46 83;...
        56 84 21 56 26 59 61];
    order_page5 = flipud(order_page5 );
    correct_resp_page5 = [0 1 1 0 0 1 1 1 0 0 0 1 0 0 1];
     correct_resp_page5 = fliplr(correct_resp_page5);
    
    order_page4 = [74 23 20 59 74 30 68;...
        59 1 53 34 80 1 41;...
        37 41 68 29 69 42 4;...
        16 63 42 14 30 53 17;...
        67 22 80 24 67 17 26;...
        8 51 60 48 38 55 57;...
        60 56 83 19 62 21 11;...
        53 40 40 58 68 31 58;...
        51 74 73 23 54 51 48;...
        76 24 28 11 82 57 42;...
        56 48 57 48 63 46 87;...
        20 10 6 10 36 40 32;...
        67 59 68 82 85 17 13;...
        61 47 46 47 75 43 35;...
        59 65 46 31 14 51 23];
    order_page4 = flipud(order_page4 );
    correct_resp_page4 = [1 1 0 0 1 0 0 1 1 0 1 1 0 1 0];  
     correct_resp_page4 = fliplr(correct_resp_page4);
       
    end
end

order_page2 = flipud(order_page2);
order_page3 = flipud(order_page3);
order_page4 = flipud(order_page4);
order_page5 = flipud(order_page5);

%% Start Paradigm
pages(1,:,:) = order_page2;
pages(2,:,:) = order_page3;
pages(3,:,:) = order_page4;
pages(4,:,:) = order_page5;

correct_resp_page2 = fliplr(correct_resp_page2);
correct_resp_page3 = fliplr(correct_resp_page3);
correct_resp_page4 = fliplr(correct_resp_page4);
correct_resp_page5 = fliplr(correct_resp_page5);

pageOrders=struct('Page2',order_page2,...
    'CorrectPage2',correct_resp_page2,...
    'Page3', order_page3,...
    'CorrectPage3',correct_resp_page3,...
    'Page4', order_page4,...
    'CorrectPage4',correct_resp_page4,...
    'Page5', order_page5,...
    'CorrectPage5',correct_resp_page5);

correct_resp(1,:) = correct_resp_page2;
correct_resp(2,:) = correct_resp_page3;
correct_resp(3,:) = correct_resp_page4;
correct_resp(4,:) = correct_resp_page5;

%window = Screen('OpenWindow', whichScreen, BGcolor);

if ~Screen(window, 'WindowKind') %Check if Window is open
    window=Screen('OpenWindow', whichScreen, par.BGcolor);
end
Screen('Flip', window, [],[],1);

%% Drift Correction
%%if par.useDrift == 1 && par.useEL == 1
disp('Drift correction not implemented!');
%     disp('Drift Correction');
%     Screen('DrawText', window, 'Drift Correction', 0.05*scresw, 0.05*scresh, 0);
%     Screen('DrawText', window, '.', 0.05*scresw, 0.15*scresh, 0);
%     EyelinkDoDriftCorrect(el)
%end

if ~Screen(window, 'WindowKind') %Check if Window is open
    window=Screen('OpenWindow', whichScreen, par.BGcolor);
end

if par.useEL
    Eyelink('Command', 'set_idle_mode'); %Send Image to Eyetracker
    ts = Eyelink('ImageTransfer','/home/stimuluspc/Eyepredict/PSPEED.bmp');
end

clc;


Screen('FillRect', window, colorBrightBG);
Screen('TextSize', window, tSize2);
DrawFormattedText(window, ins.proc.inst, 0.08*scresw, 0.25*scresh, colorText);
DrawFormattedText(window, ins.misc.mouse,'center', 0.9*scresh, colorText);

Screen('Flip', window, [],[],1);  %Screen(window, 'Flip',[],1);

HideCursor(whichScreen);
SetMouse(400,300,whichScreen);
clc;
disp('THE SUBJECT IS READING THE INSTRUCTIONS...');
if par.useEL,  Eyelink('StartRecording'); end;
if par.recordEEG, NetStation('StartRecording'); end
disp('DID THE EEG START RECORDING DATA? IF NOT, PRESS THE RECORD BUTTON!');
% Waits for the user to press a button before starting
[clicks,~,~,~] = GetClicks(whichScreen,0);

if par.recordEEG,  NetStation('Event', num2str(par.CD_START)); end;
if par.useEL, Eyelink('Message',['TR',num2str(par.CD_START)]); end; %Send Triggers

%% Start the Experiment
errorcor = NaN(4,15);

if ~Screen(window, 'WindowKind') %Check if Window is open
    window=Screen('OpenWindow', whichScreen, par.BGcolor);
end

Screen('TextSize', window, tSize2);
Screen('FillRect', window, colorBrightBG);
DrawFormattedText(window, ins.misc.start,'center', 0.45*scresh, colorText);
Screen('Flip', window, [],[],1);

ShowCursor('CrossHair', whichScreen);
SetMouse(400,300,whichScreen);
WaitSecs(2);

par.activated_resp = zeros(4,15,2)+2;
x = []; y=[];whichButton = [];
trial_duration = [];
time = GetSecs;

for pp = 1:par.nrpages
    Screen('FillRect', window, colorBrightBG);
    if par.recordEEG,  NetStation('Event', num2str(par.CD_NXTPG)); end;
    if par.useEL, Eyelink('Message',['TR',num2str(par.CD_NXTPG)]); end; %Send Triggers
    
    stimrectT = [-14.5 -14.5 14.5 14.5]; % defines the rescaling / changing size of the stimuli
    
    textures = [];
    for i = 1:size(all_images,1)
        textures(i,1) = Screen('MakeTexture', window, squeeze(all_images(i,:,:,:)));
    end
    resp_textures = [];
    for i = 1:size(responses,1)
        resp_textures(i,1) = Screen('MakeTexture', window, squeeze(responses(i,:,:,:)));
    end
    next_page_texture = Screen('MakeTexture', window, next_page);
    
    pos_y = 10.2:-1.4:-12;
    pos_x = [14 10.5 4 0.5 -3 -6.5 -10] ;
    pos_resp =[-13, -15];
    pos_line_y = 1.6:1.4:32;
    
    for j = 1:15
        for i = 1:7
            Screen('DrawTexture', window, textures(pages(pp,j,i),1), [], [center center] + [-deg2px*pos_x(i) -deg2px*pos_y(j) -deg2px*pos_x(i) -deg2px*pos_y(j)] + stimrectT);
            %position_stimuli(j,i,:)= [center center] + [-deg2px*pos_x(i) -deg2px*pos_y(j) -deg2px*pos_x(i) -deg2px*pos_y(j)] + stimrectT;
        end
    end
    
    stimrectT_resp = [-55 -30 40 30];
    
    for j = 1:15
        for i = 1:2
            Screen('DrawTexture', window, resp_textures(i,1), [], [center center] + [-deg2px*pos_resp(i)-10  -deg2px*pos_y(j) -deg2px*pos_resp(i) -deg2px*pos_y(j)+3] + stimrectT);
            %REAL resp_size_box(j,i,:) = [center center] + [-deg2px*pos_resp(i)-10  -deg2px*pos_y(j) -deg2px*pos_resp(i) -deg2px*pos_y(j)+3] + stimrectT;
            resp_size_box(j,i,:) = [center center] + [-deg2px*pos_resp(i)-10  -deg2px*pos_y(j) -deg2px*pos_resp(i) -deg2px*pos_y(j)] + stimrectT_resp;
            resp_cross(j,i,:) = [center center] + [-deg2px*pos_resp(i)-5 -deg2px*pos_y(j) -deg2px*pos_resp(i)-5 -deg2px*pos_y(j)] + stimrectT;
        end
    end
    
    Screen('DrawTexture', window, next_page_texture, [], [760 575 760 570] + stimrectT_resp);
    
    for j = 1:16
        Screen('DrawLine', window,[0 0 0],50,deg2px*pos_line_y(j)+5, scresw-30, deg2px*pos_line_y(j)+5,1);
    end
    Screen('Flip', window, [],1); % [],1 means that it stays until the next flip
    
    %Save printscreen
    %[width, height]=Screen('WindowSize', whichScreen);
    %Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, width-1, height-1);
    %imageArray = Screen('GetImage', window);
    %imwrite(imageArray, 'current.bmp');
    %Eyelink('Command', 'set_idle_mode');
    %transferimginfo=imfinfo('PSPEE.bmp');
    % WaitSecs(0.2);
    %     if ts ~= 0
    %         fprintf('*****Image transfer Failed*****-------\n');
    %     end
    
    yes = zeros(15,1);
    no = zeros(15,1);
    
    %correct response for page 2
    perf = 0;
    correction = zeros(15,1);
    whichButton = 1 ;% initially, will be updated
    
    %% Get Response
    ShowCursor('CrossHair', whichScreen);
    tic
    fine = 0;
    while fine < 1
        [clicks,x(end+1,1),y(end+1,1),whichButton(end+1,1)] = GetClicks(whichScreen,0);
        
        targ = 1 ;
        %     if size(x,1)>1
        %         return
        %     end
        for resp_b = 1:15
            if par.activated_resp(pp,resp_b,1) == 2 && par.activated_resp(pp,resp_b,2) == 2 && x(end) >= resp_cross(resp_b,2,1) && x(end) <= resp_cross(resp_b,2,3) && y(end) >= resp_cross(resp_b,2,2) && y(end) <= resp_cross(resp_b,2,4);
                %yes(c,1) =1;
                targ = 0;
                trial_duration(pp,end+1,1) = toc;
                par.activated_resp(pp,resp_b,1) = 1;  par.activated_resp(pp,resp_b,2) = 0;
                
                if par.recordEEG,  NetStation('Event', num2str(par.CD_BUTTONS(1))); end;
                if par.useEL, Eyelink('Message',['TR',num2str(par.CD_BUTTONS(1))]); end; %Send Triggers
                
                Screen('FillRect',window, [255 255 255], [0.02*scresw 0.91*scresh 0.25*scresw+500 0.86*scresh+100]);
                Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,2,1),resp_cross(resp_b,2,2), resp_cross(resp_b,2,3), resp_cross(resp_b,2,4),2);
                Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,2,1),resp_cross(resp_b,2,4), resp_cross(resp_b,2,3), resp_cross(resp_b,2,2),2);
                
                WISC_ErrorRecording
                
                vbl = Screen('Flip', window, [],1);
                if vbl >=time+duration %Tests if 120 secs are gone
                    
                    if par.recordEEG,  NetStation('Event', num2str(par.CD_NXTPG)); end;
                    if par.useEL, Eyelink('Message',['TR',num2str(par.CD_NXTPG)]); end; %Send Triggers
                    
                    perf = 0;
                    for pp = 1:4
                        for i = 1:15
                            if correct_resp(pp,i) == squeeze(par.activated_resp(pp,i,1))
                                %disp(['Trial',num2str(c), ': Correct'])
                                %     par.resp_click(pp,c) = 1;
                                perf = perf+1;
                            end;
                        end;
                    end;
                    disp(['PERFORMANCE OVERALL: ',num2str(perf), ' of 60 possible', ' correct'])
                    Screen('FillRect', window, colorBrightBG)
                    Screen('TextSize', window, tSize3);
                    DrawFormattedText(window, ins.proc.timeup,'center', 0.5*scresh, colorText);
                    Screen('Flip', window, [],1);
                    WaitSecs(2);
                    WISC_EndTask
                    return;
                end
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
                
            elseif par.activated_resp(pp,resp_b,2) == 1 && par.activated_resp(pp,resp_b,1) == 0 && x(end) >= resp_cross(resp_b,2,1) && x(end) <= resp_cross(resp_b,2,3) && y(end) >= resp_cross(resp_b,2,2) && y(end) <= resp_cross(resp_b,2,4);
                %yes(c,1) =1;
                targ = 0;
                trial_duration(pp,end+1,1) = toc;
                par.activated_resp(pp,resp_b,1) = 1; par.activated_resp(pp,resp_b,2) = 0;
                
                if par.recordEEG,  NetStation('Event', num2str(par.CD_BUTTONS(1))); end;
                if par.useEL, Eyelink('Message',['TR',num2str(par.CD_BUTTONS(1))]); end; %Send Triggers
                
                Screen('DrawTexture', window, resp_textures(1,1), [], [center center] + [-deg2px*pos_resp(1)-10 -deg2px*pos_y(resp_b) -deg2px*pos_resp(1) -deg2px*pos_y(resp_b)+3] + stimrectT);
                Screen('FillRect',window, [255 255 255], [0.02*scresw 0.91*scresh 0.25*scresw+500 0.86*scresh+100]);
                Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,2,1),resp_cross(resp_b,2,2), resp_cross(resp_b,2,3), resp_cross(resp_b,2,4),2);
                Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,2,1),resp_cross(resp_b,2,4), resp_cross(resp_b,2,3), resp_cross(resp_b,2,2),2);
                
                WISC_ErrorRecording
                
                vbl = Screen('Flip', window, [],1);
                if vbl >=time+duration %Tests if 120 secs are gone
                    
                    if par.recordEEG,  NetStation('Event', num2str(par.CD_NXTPG)); end;
                    if par.useEL, Eyelink('Message',['TR',num2str(par.CD_NXTPG)]); end; %Send Triggers
                    
                    perf = 0;
                    for pp = 1:4
                        for i = 1:15
                            if correct_resp(pp,i) == squeeze(par.activated_resp(pp,i,1))
                                perf = perf+1;
                            end;
                        end;end
                    
                    disp(['PERFORMANCE OVERALL: ',num2str(perf), ' of 60 possible', ' correct'])
                    Screen('FillRect', window, colorBrightBG)
                    Screen('TextSize', window, tSize3);
                    DrawFormattedText(window, ins.proc.timeup,'center', 0.5*scresh, colorText);
                    Screen('Flip', window, [],1);
                    WaitSecs(2);
                    WISC_EndTask
                    return;
                end
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
                
            elseif par.activated_resp(pp,resp_b,1) == 2 && par.activated_resp(pp,resp_b,2) == 2 && x(end) >= resp_cross(resp_b,1,1) && x(end) <= resp_cross(resp_b,1,3) && y(end) >= resp_cross(resp_b,1,2) && y(end) <= resp_cross(resp_b,1,4);
                %no(c,1) = 1;
                targ = 0;
                trial_duration(pp,end+1,1) = toc;
                par.activated_resp(pp,resp_b,2) = 1; par.activated_resp(pp,resp_b,1) = 0;
                
                if par.recordEEG,  NetStation('Event', num2str(par.CD_BUTTONS(1))); end;
                if par.useEL, Eyelink('Message',['TR',num2str(par.CD_BUTTONS(1))]); end;
                
                Screen('FillRect',window, [255 255 255], [0.02*scresw 0.91*scresh 0.25*scresw+500 0.86*scresh+100]);
                Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,1,1),resp_cross(resp_b,1,2), resp_cross(resp_b,1,3), resp_cross(resp_b,1,4),2);
                Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,1,1),resp_cross(resp_b,1,4), resp_cross(resp_b,1,3), resp_cross(resp_b,1,2),2);
                
                WISC_ErrorRecording
                
                vbl =Screen('Flip', window, [],1);
                if vbl >=time+duration %Tests if 120 secs are gone
                    
                    if par.recordEEG,  NetStation('Event', num2str(par.CD_NXTPG)); end;
                    if par.useEL, Eyelink('Message',['TR',num2str(par.CD_NXTPG)]); end; %Send Triggers
                    
                    perf = 0;
                    for pp = 1:4
                        for i = 1:15
                            if correct_resp(pp,i) == squeeze(par.activated_resp(pp,i,1))
                                %     disp(['Trial',num2str(c), ': Correct'])
                                %     par.resp_click(pp,c) = 1;
                                perf = perf+1;
                            end;
                        end
                    end
                    disp(['PERFORMANCE OVERALL: ',num2str(perf), ' of 60 possible', ' correct'])
                    Screen('FillRect', window, colorBrightBG)
                    Screen('TextSize', window, tSize3);
                    DrawFormattedText(window, ins.proc.timeup,'center', 0.5*scresh, colorText);
                    Screen('Flip', window, [],1);
                    WaitSecs(2);
                    WISC_EndTask
                    return;
                end
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
                
            elseif par.activated_resp(pp,resp_b,1) == 1 && par.activated_resp(pp,resp_b,2) == 0 && x(end) >= resp_cross(resp_b,1,1) && x(end) <= resp_cross(resp_b,1,3) && y(end) >= resp_cross(resp_b,1,2) && y(end) <= resp_cross(resp_b,1,4);
                %no(c,1) = 1;
                targ = 0;
                trial_duration(pp,end+1,1) = toc;
                par.activated_resp(pp,resp_b,2) = 1;
                par.activated_resp(pp,resp_b,1) = 0;
                
                if par.recordEEG,  NetStation('Event', num2str(par.CD_BUTTONS(1))); end;
                if par.useEL, Eyelink('Message',['TR',num2str(par.CD_BUTTONS(1))]); end; %Send Triggers
                
                Screen('DrawTexture', window, resp_textures(2,1), [], [center center] + [-deg2px*pos_resp(2)-10 -deg2px*pos_y(resp_b) -deg2px*pos_resp(2) -deg2px*pos_y(resp_b)+3] + stimrectT);
                Screen('FillRect',window, [255 255 255], [0.02*scresw 0.91*scresh 0.25*scresw+500 0.86*scresh+100]);
                Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,1,1),resp_cross(resp_b,1,2), resp_cross(resp_b,1,3), resp_cross(resp_b,1,4),2);
                Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,1,1),resp_cross(resp_b,1,4), resp_cross(resp_b,1,3), resp_cross(resp_b,1,2),2);
                
                WISC_ErrorRecording
                
                vbl = Screen('Flip', window, [],1);
                
                if vbl >=time+duration %Tests if 120 secs are gone
                    if par.recordEEG,  NetStation('Event', num2str(par.CD_NXTPG)); end;
                    if par.useEL, Eyelink('Message',['TR',num2str(par.CD_NXTPG)]); end; %Send Triggers
                    perf = 0;
                    for pp = 1:4
                        for i = 1:15
                            if correct_resp(pp,i) == squeeze(par.activated_resp(pp,i,1))
                                %     disp(['Trial',num2str(c), ': Correct'])
                                %     par.resp_click(pp,c) = 1;
                                perf = perf+1;
                            end;
                        end;
                    end
                    disp(['PERFORMANCE OVERALL: ',num2str(perf), ' of 60 possible', ' correct'])
                    Screen('FillRect', window, colorBrightBG)
                    Screen('TextSize', window, tSize3);
                    DrawFormattedText(window, ins.proc.timeup,'center', 0.5*scresh, colorText);
                    Screen('Flip', window, [],1);
                    WaitSecs(2);
                    WISC_EndTask
                    return;
                end
                
            elseif sum(sum(par.activated_resp(pp,:,:))) == 15 && x(end) >= 700 && x(end) <= 800 && y(end) >= 555 && y(end) <= 600;
                fine = 1;
                targ = 0;
                trial_duration(pp,end+1,1) = toc;
            elseif sum(sum(par.activated_resp(pp,:,:))) ~= 15  && x(end) >= 700 && x(end) <= 800 && y(end) >= 555 && y(end) <= 600;
                %targ = 0;
                Screen('TextSize', window, 15);
                trial_duration(pp,end+1,1) = toc;
                Screen('FillRect',window, [255 255 255], [0.02*scresw 0.91*scresh 0.25*scresw+500 0.86*scresh+100]);
                Screen('DrawText', window, ins.proc.none1, 0.07*scresw, 0.92*scresh, [255 0 0]);
                Screen('DrawText', window, ins.proc.none2, 0.07*scresw, 0.95*scresh, [255 0 0]);
                Screen('Flip', window, [],1);
            elseif targ == 1
                %
                trial_duration(pp,end+1,1) = toc;
                %                            Screen('TextSize', window, 12);
                %                             Screen('DrawText', window, 'No Response recognized: Try Again', 0.58*scresw, 0.05*scresh, [255 0 0]);
                %                             Screen('Flip', window, [],1); %WaitSecs(2);
                %                             [clicks,x(c,1),y(c,1),whichButton] = GetClicks(whichScreen,0);
                %                             Screen('FillRect',window, [255 255 255], [0.58*scresw 0.05*scresh 0.58*scresw+400 0.05*scresh+20]);
                %                             Screen('Flip', window, [],1);
                
                %
            end
        end
        
        if targ == 1
            trial_duration(pp,end+1,1) = toc;
            %             tPos = [0.45 0.04];
            %             %Screen('TextSize', window, 12);
            %             %Screen('DrawText', window, 'No Response recognized: Try Again', tPos(1)*scresw, tPos(2)*scresh, [255 0 0]);
            %             Screen('Flip', window, [],1); %WaitSecs(2);
            %             [clicks,x,y,whichButton] = GetClicks(whichScreen,0);
            %             Screen('FillRect',window, [255 255 255], [tPos(1)*scresw tPos(2)*scresh tPos(1)*scresw+400 tPos(2)*scresh+11]);
            %             Screen('Flip', window, [],1);
            %             clear tPos;
        end
    end
end

if par.recordEEG,  NetStation('Event', num2str(par.CD_NXTPG)); end;
if par.useEL, Eyelink('Message',['TR',num2str(par.CD_NXTPG)]); end; %Send Triggers

perf = 0;
for pp = 1:4
    for i = 1:15
        if correct_resp(pp,i) == squeeze(par.activated_resp(pp,i,1))
            %     disp(['Trial',num2str(c), ': Correct'])
            %     par.resp_click(pp,c) = 1;
            perf = perf+1;
        end;
    end;
end;

disp(['PERFORMANCE OVERALL: ',num2str(perf), ' of 60 possible', ' correct'])
Screen('FillRect', window, colorBrightBG)
Screen('TextSize', window, tSize3);
DrawFormattedText(window, ins.misc.finished,'center', 0.5*scresh, colorText);
Screen('Flip', window, [],1);
%stop(timerObj)
WaitSecs(2)
WISC_EndTask