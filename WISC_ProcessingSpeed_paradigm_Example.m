
%% Settings
I_GenSettings
color_white = [255 255 255];
BGcolor = color_white ;
par.nrpages = 1;
Instructions;

%Path to the WISC Files
fp = '/home/stimuluspc/Eyepredict/WISC_PS/';
ec = '/'; %Path Symbol change for Linux

%% Processing-Speed
if testmode == 1 % Testmode
    par.runID = 1;
else
    par.runID= 1;
    par.ExaminationDate =1;
end
par.recordEEG = 0;
par.useEL = 0;
par.useEL_Calib = 0;

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

%% Path Definition
filepath_stimuli  = strcat(fp,'single_stimuli',ec);
filepath_responses =  strcat(fp,'responses',ec);
files_stimuli = dir(strcat(fp,'single_stimuli',ec,'*.bmp'));
files_responses = dir(strcat(fp,'responses',ec,'*.bmp'));
filepath_page = fp;
files_page = dir(strcat(fp,'next_page.bmp'));
clear fp ec;

window = Screen('OpenWindow', whichScreen, BGcolor);

names = {};
for i = 1:size(files_stimuli,1)
    names{end+1,1} =files_stimuli(i,1).name;
    all_images(i,:,:,:)= imread([filepath_stimuli, files_stimuli(i,1).name]);
end

for i = 1:size(files_responses,1)
    responses(i,:,:,:)= imread([filepath_responses,files_responses(i,1).name]);
end

next_page = imread([filepath_page,files_page(1,1).name]);

stimrectT = [-15 -15 15 15]; % defines the rescaling / changing size of the stimuli
textures = [];
for i = 1:size(all_images,1)
    textures(i,1) = Screen('MakeTexture', window, squeeze(all_images(i,:,:,:)));
end
resp_textures = [];
for i = 1:size(responses,1)
    resp_textures(i,1) = Screen('MakeTexture', window, squeeze(responses(i,:,:,:)));
end
next_page_texture = Screen('MakeTexture', window, next_page);

pos_y = 0:-1.5:-11; %11
pos_x = [14 10.5 4 0.5 -3 -6.5 -10] ;
pos_resp =[-13, -15];
pos_line_y = 13.75:1.5:37; %3

%% Order of the Example WISC Symbol Search
order_example = [1 2 1 3 4 5 6;...
    7 3 8 9 10 11 12;...
    13 4 7 13 15 16 2;...
    17 2 18 15 19 8 1 ];

correct_resp = [1 0 1 0];

par.activated_resp = zeros(1,4,2)+2;
x = [];
y=[];
whichButton = [];
SetMouse([638-20],51,1); %SetMouse([1280+638-20],51,1

%% Start the Experiment
clc;
fprintf('THE SUBJECT IS READING THE INSTRUCTIONS AND PERFORMING THE EXAMPLE TASK');
% Screen('TextSize', window, 12);
% Screen('DrawText', window, 'The task is to figure out if either one of the two first symbols', 0.05*scresw, 0.05*scresh, 0);
% Screen('DrawText', window, 'are presented again in the same line.', 0.05*scresw, 0.10*scresh, 0);
% Screen('DrawText', window, 'Press with the left mouse button YES and NO boxes to select your answer.', 0.05*scresw, 0.15*scresh, 0);
% Screen('DrawText', window, 'If you accidently press the wrong button you can make a correction by', 0.05*scresw, 0.25*scresh, 0);
% Screen('DrawText', window, 'simply clicking on the other response.', 0.05*scresw, 0.30*scresh, 0);
% Screen('DrawText', window, 'You have 2 minutes to solve as many trials as possible.', 0.05*scresw, 0.35*scresh, 0);
% Screen('DrawText', window, 'This is just an EXAMPLE. Try it!', 0.05*scresw, 0.45*scresh, 0);
% Screen('DrawText', window, 'Do not forget to press the arrow to go to the next page', 0.05*scresw, 0.85*scresh, 0);

Screen('TextSize', window, 21);
DrawFormattedText(window, ins.proc.e_inst, 0.07*scresw, 0.08*scresh, colorText);
Screen('DrawText', window, ins.proc.e_arrow, 0.05*scresw, 0.95*scresh, colorText);

for j = 1:4
    for i = 1:7
        Screen('DrawTexture', window, textures(order_example(j,i),1), [], [center center] + [0 50 0 50] + [-deg2px*pos_x(i) -deg2px*pos_y(j) -deg2px*pos_x(i) -deg2px*pos_y(j)] + stimrectT);
    end
end

% first is NO, second is YES
% rescaling factor for response size box:
stimrectT_resp = [-40 -30 40 30];

for j = 1:4
    for i = 1:2
        Screen('DrawTexture', window, resp_textures(i,1), [], [center center]  + [0 50 0 50]+ [-deg2px*pos_resp(i)-10 -deg2px*pos_y(j) -deg2px*pos_resp(i) -deg2px*pos_y(j)+3] + stimrectT);
        % define space for response selection
        resp_size_box(j,i,:) = [center center]  + [0 50 0 50]+ [-deg2px*pos_resp(i) -deg2px*pos_y(j) -deg2px*pos_resp(i) -deg2px*pos_y(j)] + stimrectT_resp;
        resp_cross(j,i,:) = [center center]  + [0 50 0 50] + [-deg2px*pos_resp(i)-5 -deg2px*pos_y(j) -deg2px*pos_resp(i)-5 -deg2px*pos_y(j)] + stimrectT;
    end
end

for j = 1:5
    Screen('DrawLine', window,[0 0 0],50,deg2px*pos_line_y(j)+5, scresw-50, deg2px*pos_line_y(j)+5,1);
end

Screen('DrawTexture', window, next_page_texture, [], [760 565 760 565] + stimrectT_resp);
Screen('Flip', window, [],1,1); % [],1 means that it stays until the next flip
yes = zeros(4,1);
no = zeros(4,1);

%perf = 0;
ShowCursor(0,whichScreen)
bbox = [0.58*scresw 0.50*scresh 0.58*scresw+400 0.52*scresh];

for pp = 1:par.nrpages
    fine = 0;
    while fine < 1
        [clicks,x(end+1,1),y(end+1,1),whichButton(end+1,1)] = GetClicks(whichScreen,0);
        targ = 1 ;
        for resp_b = 1:4
            if par.activated_resp(pp,resp_b,1) == 2 && par.activated_resp(pp,resp_b,2) == 2 && x(end) >= resp_cross(resp_b,2,1) && x(end) <= resp_cross(resp_b,2,3) && y(end) >= resp_cross(resp_b,2,2) && y(end) <= resp_cross(resp_b,2,4);
                %yes(c,1) =1;
                targ = 0;
                par.activated_resp(pp,resp_b,1) = 1; par.activated_resp(pp,resp_b,2) = 0;
                %Screen('FillRect',window, [255 255 255], [0.58*scresw 0.50*scresh 0.58*scresw+400 0.50*scresh+20]);
                Screen('FillRect',window, [255 255 255], bbox);
                %Screen('FillRect',window, [255 255 255], [0.05*scresw 0.86*scresh 0.25*scresw+500 0.86*scresh+100]);
                Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,2,1),resp_cross(resp_b,2,2), resp_cross(resp_b,2,3), resp_cross(resp_b,2,4),2);
                Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,2,1),resp_cross(resp_b,2,4), resp_cross(resp_b,2,3), resp_cross(resp_b,2,2),2);
                
                for j = 1:5
                    Screen('DrawLine', window,[0 0 0],50,deg2px*pos_line_y(j)+5, scresw-50, deg2px*pos_line_y(j)+5,1);
                end
                
                Screen('Flip', window, [],1);
                
                if correct_resp(resp_b) == squeeze(par.activated_resp(1,resp_b ,1))
                    disp(['Trial',num2str(resp_b), ': Correct'])
                else
                    disp(['Trial',num2str(resp_b), ': Wrong'])
                end;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
                
            elseif par.activated_resp(pp,resp_b,2) == 1 && par.activated_resp(pp,resp_b,1) == 0 && x(end) >= resp_cross(resp_b,2,1) && x(end) <= resp_cross(resp_b,2,3) && y(end) >= resp_cross(resp_b,2,2) && y(end) <= resp_cross(resp_b,2,4);
                %yes(c,1) =1;
                targ = 0;
                par.activated_resp(pp,resp_b,1) = 1; par.activated_resp(pp,resp_b,2) = 0;
                %   Screen('DrawTexture', window, resp_textures(i,1), [], [center center]  + [0 50 0 50]+ [-deg2px*pos_resp(i) -deg2px*pos_y(j) -deg2px*pos_resp(i) -deg2px*pos_y(j)] + stimrectT);
                Screen('DrawTexture', window, resp_textures(1,1), [], [center center] + [0 50 0 50] + [-deg2px*pos_resp(1)-10 -deg2px*pos_y(resp_b) -deg2px*pos_resp(1) -deg2px*pos_y(resp_b)+3] + stimrectT);
                %Screen('FillRect',window, [255 255 255], [0.58*scresw 0.50*scresh 0.58*scresw+400 0.50*scresh+20]);
                Screen('FillRect',window, [255 255 255], bbox);
                %Screen('FillRect',window, [255 255 255], [0.05*scresw 0.86*scresh 0.25*scresw+500 0.86*scresh+100]);
                
                Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,2,1),resp_cross(resp_b,2,2), resp_cross(resp_b,2,3), resp_cross(resp_b,2,4),2);
                Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,2,1),resp_cross(resp_b,2,4), resp_cross(resp_b,2,3), resp_cross(resp_b,2,2),2);
                
                for j = 1:5
                    Screen('DrawLine', window,[0 0 0],50,deg2px*pos_line_y(j)+5, scresw-50, deg2px*pos_line_y(j)+5,1);
                end
                
                Screen('Flip', window, [],1);
                
                if correct_resp(resp_b) == squeeze(par.activated_resp(1,resp_b ,1))
                    disp(['Trial',num2str(resp_b), ': Correct'])
                else
                    disp(['Trial',num2str(resp_b), ': Wrong'])
                end;
                
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
                
            elseif par.activated_resp(pp,resp_b,1) == 2 && par.activated_resp(pp,resp_b,2) == 2 && x(end) >= resp_cross(resp_b,1,1) && x(end) <= resp_cross(resp_b,1,3) && y(end) >= resp_cross(resp_b,1,2) && y(end) <= resp_cross(resp_b,1,4);
                %no(c,1) = 1;
                targ = 0;
                
                par.activated_resp(pp,resp_b,2) = 1; par.activated_resp(pp,resp_b,1) = 0;
                %Screen('FillRect',window, [255 255 255], [0.58*scresw 0.50*scresh 0.58*scresw+400 0.50*scresh+20]);
                Screen('FillRect',window, [255 255 255], bbox);
                % Screen('FillRect',window, [255 255 255], [0.05*scresw 0.86*scresh 0.25*scresw+500 0.86*scresh+100]);
                
                Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,1,1),resp_cross(resp_b,1,2), resp_cross(resp_b,1,3), resp_cross(resp_b,1,4),2);
                Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,1,1),resp_cross(resp_b,1,4), resp_cross(resp_b,1,3), resp_cross(resp_b,1,2),2);
                
                for j = 1:5
                    Screen('DrawLine', window,[0 0 0],50,deg2px*pos_line_y(j)+5, scresw-50, deg2px*pos_line_y(j)+5,1);
                end
                
                Screen('Flip', window, [],1);
                
                if correct_resp(resp_b) == squeeze(par.activated_resp(1,resp_b ,1))
                    disp(['Trial',num2str(resp_b), ': Correct'])
                else
                    disp(['Trial',num2str(resp_b), ': Wrong'])
                end;
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
                
            elseif par.activated_resp(pp,resp_b,1) == 1 && par.activated_resp(pp,resp_b,2) == 0 && x(end) >= resp_cross(resp_b,1,1) && x(end) <= resp_cross(resp_b,1,3) && y(end) >= resp_cross(resp_b,1,2) && y(end) <= resp_cross(resp_b,1,4);
                targ = 0;
                par.activated_resp(pp,resp_b,2) = 1; par.activated_resp(pp,resp_b,1) = 0;
                Screen('DrawTexture', window, resp_textures(2,1), [], [center center]+ [0 50 0 50]  + [-deg2px*pos_resp(2)-10 -deg2px*pos_y(resp_b) -deg2px*pos_resp(2) -deg2px*pos_y(resp_b)+3] + stimrectT);
                %Screen('FillRect',window, [255 255 255], [0.58*scresw 0.50*scresh 0.58*scresw+400 0.50*scresh+20]);
                Screen('FillRect',window, [255 255 255], bbox);
                Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,1,1),resp_cross(resp_b,1,2), resp_cross(resp_b,1,3), resp_cross(resp_b,1,4),2);
                Screen('DrawLine', window,[0 0 0],resp_cross(resp_b,1,1),resp_cross(resp_b,1,4), resp_cross(resp_b,1,3), resp_cross(resp_b,1,2),2);
                
                for j = 1:5
                    Screen('DrawLine', window,[0 0 0],50,deg2px*pos_line_y(j)+5, scresw-50, deg2px*pos_line_y(j)+5,1);
                end
                
                Screen('Flip', window, [],1);
                
                if correct_resp(resp_b) == squeeze(par.activated_resp(1,resp_b ,1))
                    disp(['Trial',num2str(resp_b), ': Correct'])
                else
                    disp(['Trial',num2str(resp_b), ': Wrong'])
                end;
            elseif sum(sum(par.activated_resp(pp,:,:))) == 4 && x(end) >= 700 && x(end) <= 800 && y(end) >= 555 && y(end) <= 600;
                fine = 1;
                targ = 0;
                %trial_duration(pp,end+1,1) = toc;
            elseif sum(sum(par.activated_resp(pp,:,:))) < 4  && x(end) >= 700 && x(end) <= 800 && y(end) >= 555 && y(end) <= 600;
                targ = 0;
                Screen('TextSize', window, 12);
                %Screen('DrawText', window, 'You have not completed all the trials.', 0.05*scresw, 0.90*scresh, [255 0 0]);
                %Screen('DrawText', window, 'Please complete all trials before you proceed to the next page.', 0.05*scresw, 0.95*scresh, [255 0 0]);
                %Screen('FillRect',window, [255 255 255], [0.05*scresw 0.86*scresh 0.25*scresw+500 0.86*scresh+100]); Screen('Flip', window, [],1);
                Screen('Flip', window, [],1); %WaitSecs(3);
            end
        end
        if targ == 1
            Screen('TextSize', window, tSize1);
            %Screen('DrawText', window, 'No Response recognized: Try Again', 0.58*scresw, 0.50*scresh, [255 0 0]);
            Screen('FillRect',window, [255 255 255], bbox);
            [nx, ny, bbox] = DrawFormattedText(window, ins.proc.e_none,'right', 0.53*scresh, colorInfo);
            bbox = bbox + [0 -5 0 10];
            Screen('Flip', window, [],1); %WaitSecs(2);
        end
    end
end

squeeze(par.activated_resp(1,:,:));
perf = 0;
for i = 1:4
    if correct_resp(i) == squeeze(par.activated_resp(1,i,1))
        %     disp(['Trial',num2str(c), ': Correct'])
        %     par.resp_click(pp,c) = 1;
        perf = perf+1;
    end;
end;
disp(['PERFORMANCE IN THE EXAMPLE: ',num2str(perf), ' of 4', ' correct'])
Screen('TextSize', window, tSize2);
DrawFormattedText(window, ins.misc.ex_finished,'center', 0.85*scresh, colorText);
Screen('TextSize', window, tSize1);
DrawFormattedText(window, ['Sie haben: ',num2str(perf), ' von 4', ' korrekt'],'center', 0.89*scresh, colorText);
Screen('Flip', window);
[clicks,x,y,whichButton] = GetClicks(whichScreen,0);
sca;
clearvars -except select subj_ID metafile subj_Name app event
