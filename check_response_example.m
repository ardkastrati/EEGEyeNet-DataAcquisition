
if   whichButton == 1 && correction(c,1) == 0 ;
if x(c) >= resp_cross(c,2,1) && x(c) <= resp_cross(c,2,3) && y(c) >= resp_cross(c,2,2) && y(c) <= resp_cross(c,2,4);
    yes(c,1) =1;
    trial_duration(pp,c,1) = toc;
  %  if par.recordEEG, sendtrigger(par.CD_BUTTONS(1),port,SITE,0); end
  %if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_BUTTONS(1)))])));end;

    Screen('DrawLine', window,[0 0 0],resp_cross(c,2,1),resp_cross(c,2,2), resp_cross(c,2,3), resp_cross(c,2,4),2);
    Screen('DrawLine', window,[0 0 0],resp_cross(c,2,1),resp_cross(c,2,4), resp_cross(c,2,3), resp_cross(c,2,2),2);
    Screen('Flip', window, [],1);
        
elseif x(c) >= resp_cross(c,1,1) && x(c) <= resp_cross(c,1,3) && y(c) >= resp_cross(c,1,2) && y(c) <= resp_cross(c,1,4);
    no(c,1) = 1;
    trial_duration(pp,c,1) = toc;
    %if par.recordEEG, sendtrigger(par.CD_BUTTONS(1),port,SITE,0); end
 % if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_BUTTONS(1)))])));end;
    Screen('DrawLine', window,[0 0 0],resp_cross(c,1,1),resp_cross(c,1,2), resp_cross(c,1,3), resp_cross(c,1,4),2);
    Screen('DrawLine', window,[0 0 0],resp_cross(c,1,1),resp_cross(c,1,4), resp_cross(c,1,3), resp_cross(c,1,2),2);
    Screen('Flip', window, [],1);
    
else
   
  Screen('TextSize', window, 12);
Screen('DrawText', window, 'No Response recognized: Try Again', 0.58*scresw, 0.05*scresh, [255 0 0]);
Screen('Flip', window, [],1); %WaitSecs(2);
[clicks,x(c,1),y(c,1),whichButton] = GetClicks(whichScreen,0);
Screen('FillRect',window, [255 255 255], [0.58*scresw 0.05*scresh 0.58*scresw+400 0.05*scresh+20]);  
Screen('Flip', window, [],1);    
    
check_response_example
    
end


 elseif whichButton == 1 && correction(c,1) == 1 ;
     
    if x(c) >= resp_cross(c,2,1) && x(c) <= resp_cross(c,2,3) && y(c) >= resp_cross(c,2,2) && y(c) <= resp_cross(c,2,4);
    yes(c,1) =1;
    temp_dur = toc;
    trial_duration(pp,c,1) = temp_dur + trial_duration(pp,c,1);
 %   if par.recordEEG, sendtrigger(par.CD_BUTTONS(3),port,SITE,0); end
 % if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_BUTTONS(3)))])));end;

    Screen('DrawLine', window,[124 252 0],resp_cross(c,2,1),resp_cross(c,2,2), resp_cross(c,2,3), resp_cross(c,2,4),2);
    Screen('DrawLine', window,[124 252 0],resp_cross(c,2,1),resp_cross(c,2,4), resp_cross(c,2,3), resp_cross(c,2,2),2);
    Screen('Flip', window, [],1);
    
        
    elseif x(c) >= resp_cross(c,1,1) && x(c) <= resp_cross(c,1,3) && y(c) >= resp_cross(c,1,2) && y(c) <= resp_cross(c,1,4);
    no(c,1) = 1;
    temp_dur = toc;
    trial_duration(pp,c,1) = temp_dur + trial_duration(pp,c,1);
  %  if par.recordEEG, sendtrigger(par.CD_BUTTONS(3),port,SITE,0); end
  %if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_BUTTONS(3)))])));end;

    Screen('DrawLine', window,[124 252 0],resp_cross(c,1,1),resp_cross(c,1,2), resp_cross(c,1,3), resp_cross(c,1,4),2);
    Screen('DrawLine', window,[124 252 0],resp_cross(c,1,1),resp_cross(c,1,4), resp_cross(c,1,3), resp_cross(c,1,2),2);
    Screen('Flip', window, [],1);
    
else
   
  Screen('TextSize', window, 12);
Screen('DrawText', window, 'No Response recognized: Try Again', 0.58*scresw, 0.05*scresh, [255 0 0]);
Screen('Flip', window, [],1); %WaitSecs(2);
[clicks,x(c,1),y(c,1),whichButton] = GetClicks(whichScreen,0);
Screen('FillRect',window, [255 255 255], [0.58*scresw 0.05*scresh 0.58*scresw+400 0.05*scresh+20]);  
Screen('Flip', window, [],1);    
    
check_response_example
     
     
     end
 
      if correction(c,1) == 1 && correct_resp(pp,c) == yes(c)
    disp(['Correction for Trial',num2str(c), ': Correct'])
    par.resp_click(pp,c) = 1;
perf = perf+1;   
      else correction(c,1) == 1 
    disp(['Correction for Trial',num2str(c), ': Wrong'])
    par.resp_click(pp,c) = 0;
     end
     
 end


     