clear

monitorwidth_cm = 35;   % monitor width in cm
dist_cm = 57;  % viewing distance in cm

whichScreen = 0;
%whichScreen_eye = 1;

[scresw, scresh]=Screen('WindowSize',whichScreen);  % Get screen resolution
center = [scresw scresh]/2;     % useful to have the pixel coordinates of the very center of the screen (usually where you have someone fixate)
fixRect = [center-2 center+2];  % fixation dot
hz=Screen('FrameRate', whichScreen,1);

cm2px = scresw/monitorwidth_cm;  % multiplication factor to convert cm to pixels
deg2px = dist_cm*cm2px*pi/180;      % multiplication factor to convert degrees to pixels (uses aproximation tanT ~= T).

load gammafnCRT   % load the gamma function parameters for this monitor - or some other CRT and hope they're similar! (none of our questions rely on precise quantification of physical contrast)
maxLum = GrayLevel2Lum(255,Cg,gam,b0);
par.BGcolor=Lum2GrayLevel(maxLum/2,Cg,gam,b0);

 
whichScreen = 2;

par.CD_START  = 90;
 par.CD_eyeO = 20;
 par.CD_eyeC = 30
 
%% Sound Stuff


wavfilename_probe1 = 'C:\PsychToolbox_Experiments\Simon\resting\open_eyes.wav'
wavfilename_probe2 = 'C:\PsychToolbox_Experiments\Simon\resting\close_eyes.wav'
 [y_probe1, freq1] = wavread(wavfilename_probe1);
 [y_probe2, freq2] = wavread(wavfilename_probe2);
    wavedata_probe1 = y_probe1';
     wavedata_probe2 = y_probe2';
     
     
     
    nrchannels = size(wavedata_probe1,1); % Number of rows == number of channels.

 
% Add 15 msecs latency on Windows, to protect against shoddy drivers:
sugLat = [];
if IsWin
    sugLat = 0.015;
end

InitializePsychSound(0)

pamaster = PsychPortAudio('Open', [], 1+8, 1, freq1, nrchannels, [], sugLat);

% Start master immediately, wait for it to be started. We won't stop the
% master until the end of the session.
PsychPortAudio('Start', pamaster, 0, 0, 1);

% Set the masterVolume for the master: This volume setting affects all
% attached sound devices. We set this to 0.5, so it doesn't blow out the
% ears of our listeners...
PsychPortAudio('Volume', pamaster, 0.5);

duration_probe1 = size(wavedata_probe1,2)/freq1
duration_probe2 = size(wavedata_probe2,2)/freq1

pasound_probe1 = PsychPortAudio('OpenSlave', pamaster, 1);
pasound_probe2 = PsychPortAudio('OpenSlave', pamaster, 1);


% Create audio buffers prefilled with the 3 sounds:
pabuffer_probe1 = PsychPortAudio('CreateBuffer', [], wavedata_probe1);
pabuffer_probe2 = PsychPortAudio('CreateBuffer', [], wavedata_probe2);

%%

%Place full path for movie here.  For example, 
% moviename = 'C:\Users\Desktop\moviename.avi'
Screen('Preference','SkipSyncTests',1)
Screen('Preference', 'VisualDebugLevel', 0);
window = Screen('OpenWindow', whichScreen, par.BGcolor);

eyeO = [10:60:310];
eyeC = [30:60:330];


  % tex = Screen('GetMovieImage', hsc, moviePtr);
    Screen('DrawLine', window,[0 0 0],center(1)-7,center(2), center(1)+7,center(2));
    Screen('DrawLine', window,[0 0 0],center(1),center(2)-7, center(1),center(2)+7);
    
  vbl = Screen('Flip',window);
 
        pahandle = PsychPortAudio('Open', [], [], 0, [], nrchannels);
        PsychPortAudio('FillBuffer', pahandle, pasound_probe1);
        PsychPortAudio('Start', pahandle, 1, 0, 1);
        
        
        
        pahandle = PsychPortAudio('Open', [], [], 0, [], nrchannels);
        PsychPortAudio('FillBuffer', pahandle, pasound_probe2);
        PsychPortAudio('Start', pahandle, 1, 0, 1);
        