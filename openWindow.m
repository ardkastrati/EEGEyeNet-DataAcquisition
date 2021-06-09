function win = openWindow(p,whichScreen) % open up the window! 

win.screenNumber = whichScreen%(Screen('Screens')); % may need to change for multiscreen displays

%   p.windowed = 0; %%% 1  == smaller screen for debugging; 0 === full-sized screen for experiment
if p.windowed
    x_size=  800; y_size = 600;
    [win.onScreen,rect] = Screen('OpenWindow', win.screenNumber, [128 128 128],[0 0 x_size y_size],[],[],[]);
    win.screenX = x_size;
    win.screenY = y_size;
    win.screenRect = [0 0 x_size y_size];
    win.centerX = (x_size)/2; % center of screen in X direction
    win.centerY = (y_size)/2; % center of screen in Y direction
    win.centerXL = floor(mean([0 win.centerX])); % center of left half of screen in X direction
    win.centerXR = floor(mean([win.centerX win.screenX])); % center of right half of screen in X direction
        % % Compute foreground and fixation rectangles
    win.foreRect = round(win.screenRect./1.5/1.57);
    win.foreRect = CenterRect(win.foreRect,win.screenRect);
else
    [win.onScreen rect] = Screen('OpenWindow', win.screenNumber, [128 128 128],[],[],[],[]);
    [win.screenX, win.screenY] = Screen('WindowSize', win.onScreen); % check resolution
    win.screenRect  = [0 0 win.screenX win.screenY]; % screen rect
    win.centerX = win.screenX * 0.5; % center of screen in X direction
    win.centerY = win.screenY * 0.5; % center of screen in Y direction
    win.centerXL = floor(mean([0 win.centerX])); % center of left half of screen in X direction
    win.centerXR = floor(mean([win.centerX win.screenX])); % center of right half of screen in X direction
    % % Compute foreground and fixation rectangles
    win.foreRect = round(win.screenRect./1.5/1.57);
    win.foreRect = CenterRect(win.foreRect,win.screenRect);

   % HideCursor; % hide the cursor since we're not debugging
end

Screen('BlendFunction', win.onScreen, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% basic drawing and screen variables
win.black    = BlackIndex(win.onScreen);
win.white    = WhiteIndex(win.onScreen);
load gammafnCRT;   % load the gamma function parameters for this monitor - or some other CRT and hope they're similar! (none of our questions rely on precise quantification of physical contrast)
maxLum = GrayLevel2Lum(255,Cg,gam,b0);
win.gray=Lum2GrayLevel(maxLum/2,Cg,gam,b0);
%win.gray     = mean([win.black win.white]);

win.backColor = win.gray;
win.foreColor = win.gray;

%%% 9 colors mat
win.colors_9 = [255 0 0; ... % red
    0 255 0; ...% green
    0 0 255; ...% blue
    255 255 0; ... % yellow
    255 0 255; ... % magenta
    0 255 255; ... % cyan 
    255 255 255; ... % white
    1 1 1; ... %black
    255 128 0]; % orange! 

%%%% 7 colors mat
win.colors_7 = [255 0 0;... % red
    0 255 0;... %green
    0 0 255;... % blue
    255 255 0;... % yellow
    255 0 255; ... % magenta
    255 255 255;... % white
    0 0 0]; % black

win.fontsize = 24;

% make a dummy call to GetSecs to load the .dll before we need it
dummy = GetSecs; clear dummy;
end