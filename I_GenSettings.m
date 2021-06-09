addpath(genpath('/home/stimuluspc/Eyepredict'));
%addpath('/home/stimuluspc/Neurometric/Clips');
addpath('/home/stimuluspc/Eyepredict/general_matlabfiles');
%addpath('/home/stimuluspc/Eyepredict/resting');
Screen('Preference','SkipSyncTests',1);
Screen('Preference', 'VisualDebugLevel', 0);

%% General Settings for CMI_EEG
% These are settings that are used for all the other Scripts
pausekey = KbName('p');  % Pausekey
port=0;                  % Netstation
monitorwidth_cm = 40;    % monitor width in cm not directly used anymore just for calculations
dist_cm = 68;            % viewing distance in cm not directly used anymore just for calculations
whichScreen = 1;         % Set Screen to run experiment on
whichScreen_eye = 0;     % 0=Left, 1=Right TODO
hz = 100;                % WISC
testmode = 0;            % running the files in testmode

% Text
tSize1 = 18;
tSize2 = 25;
tSize3 = 35;
colorText = [0,0,0];
colorBG = [];
colorBrightBG = [255,255,255];
colorInfo = [255,0,0];
colorBrightGray = [];
colorDarkGray = [];

