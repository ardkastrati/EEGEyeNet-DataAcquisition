% Show TARGET            

%if par.useEL, if (calllib('iViewXAPI', 'iV_GetSample', pSampleData) == 1); Smp = libstruct('SampleStruct', pSampleData); x0 = Smp.leftEye.gazeX;	y0 = Smp.leftEye.gazeY;	
%              	Screen('DrawDots', window_eye, pos(pos_num,:), radius/3, color, [center_eye/3], [1]); Screen('DrawDots', window_eye, [x0/2,y0/2], 20, [255 0 0]); Screen(window_eye, 'Flip');end; end;

Screen('DrawDots', window, pos(pos_num,:), radius, color, center, [1]);

[VBLTimestamp TGonT(n)] = Screen('Flip', window); 
%if par.recordEEG, sendtrigger(par.CD_Dot_ON(pos_num),port,SITE,1); end
%if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_Dot_ON(pos_num)))])));end;

% Fading
WaitSecs(duration - 1.5/par.videoFrate);
fadefr = round(fading*par.videoFrate);
for i = 1:fadefr-1 % adapt that to the flicker rate
    background
    %if par.useEL, if (calllib('iViewXAPI', 'iV_GetSample', pSampleData) == 1); Smp = libstruct('SampleStruct', pSampleData); x0 = Smp.leftEye.gazeX;	y0 = Smp.leftEye.gazeY;	
    %          	Screen('DrawDots', window_eye, pos(pos_num,:), radius_in/3, color - (i*((color-color_gray)/(fadefr))), [center_eye/3], [1]); Screen('DrawDots', window_eye, [x0/2,y0/2], 20, [255 0 0]); Screen(window_eye, 'Flip');end; end;

    Screen('DrawDots', window, pos(pos_num,:), radius_in, color - (i*((color-color_gray)/(fadefr))), center, [1]);
    Screen('Flip', window);
end
background
%if par.useEL, if (calllib('iViewXAPI', 'iV_GetSample', pSampleData) == 1); Smp = libstruct('SampleStruct', pSampleData); x0 = Smp.leftEye.gazeX;	y0 = Smp.leftEye.gazeY;	
 %             	Screen('DrawDots', window_eye, pos(pos_num,:), radius_in/3, BGcolor, [center_eye/3], [1]); Screen('DrawDots', window_eye, [x0/2,y0/2], 20, [255 0 0]); Screen(window_eye, 'Flip');end; end;

Screen('DrawDots', window, pos(pos_num,:), radius_in, BGcolor, center, [1]);
[VBLTimestamp ITIstartT(n)] = Screen('Flip', window);
%if par.recordEEG, sendtrigger(par.CD_Dot_OFF(pos_num),port,SITE,1); end
%if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_Dot_OFF(pos_num)))])));end;

iti
background
    