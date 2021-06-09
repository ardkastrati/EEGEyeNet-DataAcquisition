
if   whichButton == 1 && correction(c,1) == 0 ;
        if x(c) >= resp_cross(c,2,1) && x(c) <= resp_cross(c,2,3) && y(c) >= resp_cross(c,2,2) && y(c) <= resp_cross(c,2,4);
            yes(c,1) =1;
            trial_duration(pp,c,1) = toc;
            if par.recordEEG, sendtrigger(par.CD_BUTTONS(1),port,SITE,0); end
            if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_BUTTONS(1)))])));end;

            Screen('DrawLine', window,[0 0 0],resp_cross(c,2,1),resp_cross(c,2,2), resp_cross(c,2,3), resp_cross(c,2,4),2);
            Screen('DrawLine', window,[0 0 0],resp_cross(c,2,1),resp_cross(c,2,4), resp_cross(c,2,3), resp_cross(c,2,2),2);
            vbl = Screen('Flip', window, [],1);
            if vbl >=time+duration %Tests if 120 secs are gone
                if par.recordEEG, sendtrigger(par.CD_NXTPG,port,SITE,0), end
                if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_NXTPG))])));end;

                Screen('TextSize', window, 21);
            Screen('DrawText', window, 'TIME IS OVER - TASK FINISHED', 0.20*scresw, 0.85*scresh, [255 0 0]);
            Screen('Flip', window, [],1); %WaitSecs(2);
            stop(timerObj)
            WaitSecs(2)
             save([par.runID , '_WISC_ProcSpeed'],'par', 'trial_duration')
                        if par.useEL, 
                        % stop recording
                        calllib('iViewXAPI', 'iV_StopRecording');

                         % save recorded data
                         eyetr_data = formatString(64, int8('User1'));
                        description = formatString(64, int8('Description1'));
                        ovr = int32(1);
                        filename = formatString(256, int8(['C:\PsychToolbox_Experiments\Simon\AA_eyetracker_data\' subj_ID{1,1} '_WISC_ProcSpeed' '.idf']));
                        calllib('iViewXAPI', 'iV_SaveData', filename, description, eyetr_data, ovr)
                        calllib('iViewXAPI', 'iV_Disconnect'); end; %unloadlibrary('iViewXAPI');end
                        sca;
                         %exitLoop = 1
                        NetStation('StopRecording')
                        clearvars -except select subj_ID metafile subj_Name
                        close all
                        return
            end

        elseif x(c) >= resp_cross(c,1,1) && x(c) <= resp_cross(c,1,3) && y(c) >= resp_cross(c,1,2) && y(c) <= resp_cross(c,1,4);
            no(c,1) = 1;
            trial_duration(pp,c,1) = toc;
            if par.recordEEG, sendtrigger(par.CD_BUTTONS(1),port,SITE,0); end
            if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_BUTTONS(1)))])));end;
            Screen('DrawLine', window,[0 0 0],resp_cross(c,1,1),resp_cross(c,1,2), resp_cross(c,1,3), resp_cross(c,1,4),2);
            Screen('DrawLine', window,[0 0 0],resp_cross(c,1,1),resp_cross(c,1,4), resp_cross(c,1,3), resp_cross(c,1,2),2);
            vbl =Screen('Flip', window, [],1);
            
             if vbl >=time+duration %Tests if 120 secs are gone
                if par.recordEEG, sendtrigger(par.CD_NXTPG,port,SITE,0), end
                if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_NXTPG))])));end;

                 Screen('TextSize', window, 21);
            Screen('DrawText', window, 'TIME IS OVER - TASK FINISHED', 0.20*scresw, 0.85*scresh, [255 0 0]);
            Screen('Flip', window, [],1); %WaitSecs(2);
             stop(timerObj)
            WaitSecs(2)
                        save([par.runID , '_WISC_ProcSpeed'],'par', 'trial_duration')
                        if par.useEL, 
                        % stop recording
                        calllib('iViewXAPI', 'iV_StopRecording');

                         % save recorded data
                         eyetr_data = formatString(64, int8('User1'));
                        description = formatString(64, int8('Description1'));
                        ovr = int32(1);
                        filename = formatString(256, int8(['C:\PsychToolbox_Experiments\Simon\AA_eyetracker_data\' subj_ID{1,1} '_WISC_ProcSpeed' '.idf']));
                        calllib('iViewXAPI', 'iV_SaveData', filename, description, eyetr_data, ovr)
                        calllib('iViewXAPI', 'iV_Disconnect'); end; %unloadlibrary('iViewXAPI');end
                        sca;
                         %exitLoop = 1
                        NetStation('StopRecording')
                        clearvars -except select subj_ID metafile subj_Name
                        close all
                        return
            end
    
        else
   
            Screen('TextSize', window, 12);
            Screen('DrawText', window, 'No Response recognized: Try Again', 0.58*scresw, 0.05*scresh, [255 0 0]);
            Screen('Flip', window, [],1); %WaitSecs(2);
            [clicks,x(c,1),y(c,1),whichButton] = GetClicks(whichScreen,0);
            Screen('FillRect',window, [255 255 255], [0.58*scresw 0.05*scresh 0.58*scresw+400 0.05*scresh+20]);  
            Screen('Flip', window, [],1);    
    
            if  whichButton == 3
            Screen('DrawText', window, 'Select a new choice with the left mouse', 0.25*scresw, 0.9*scresh, [255 0 0]); Screen('Flip', window,[],1); %WaitSecs(2);
            [clicks,x(c,1),y(c,1),whichButton] = GetClicks(whichScreen,0);
            Screen('FillRect',window, [255 255 255], [0.25*scresw 0.86*scresh 0.25*scresw+600 0.95*scresh+100]); Screen('Flip', window, [],1);

                WISC_leftmouse
                WISC_leftmouse
                WISC_leftmouse
                WISC_leftmouse
                WISC_leftmouse
                WISC_leftmouse
                WISC_leftmouse
                WISC_leftmouse
                WISC_leftmouse
                WISC_leftmouse
                WISC_leftmouse
                WISC_leftmouse

            elseif  whichButton == 1
                if par.recordEEG, sendtrigger(par.CD_BUTTONS(2),port,SITE,0); end
                if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_BUTTONS(2)))])));end;
                check_response;
            end
        end 

%% Corrected Answer
elseif whichButton == 1 && correction(c,1) == 1 ;
     
    if x(c) >= resp_cross(c,2,1) && x(c) <= resp_cross(c,2,3) && y(c) >= resp_cross(c,2,2) && y(c) <= resp_cross(c,2,4);
            yes(c,1) =1;
            temp_dur = toc;
            trial_duration(pp,c,1) = temp_dur + trial_duration(pp,c,1);
            if par.recordEEG, sendtrigger(par.CD_BUTTONS(3),port,SITE,0); end
            if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_BUTTONS(3)))])));end;
            % make new choice green:
            Screen('DrawLine', window,[124 252 0],resp_cross(c,2,1),resp_cross(c,2,2), resp_cross(c,2,3), resp_cross(c,2,4),2);
            Screen('DrawLine', window,[124 252 0],resp_cross(c,2,1),resp_cross(c,2,4), resp_cross(c,2,3), resp_cross(c,2,2),2);
            Screen('Flip', window, [],1);
    
        
    elseif x(c) >= resp_cross(c,1,1) && x(c) <= resp_cross(c,1,3) && y(c) >= resp_cross(c,1,2) && y(c) <= resp_cross(c,1,4);
            no(c,1) = 1;
            temp_dur = toc;
            trial_duration(pp,c,1) = temp_dur + trial_duration(pp,c,1);
            if par.recordEEG, sendtrigger(par.CD_BUTTONS(3),port,SITE,0); end
          if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_BUTTONS(3)))])));end;
            % make new choice green:
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


 
%              if  whichButton == 3
%              Screen('DrawText', window, 'Select a new choice with the left mouse', 0.25*scresw, 0.9*scresh, [255 0 0]); Screen('Flip', window,[],1); %WaitSecs(2);
%              [clicks,x(c,1),y(c,1),whichButton] = GetClicks(whichScreen,0);
%              Screen('FillRect',window, [255 255 255], [0.25*scresw 0.86*scresh 0.25*scresw+600 0.86*scresh+100]); Screen('Flip', window, [],1);

        
            
            
%                 WISC_leftmouse
%                 WISC_leftmouse
%                 WISC_leftmouse
%                 WISC_leftmouse
%                 WISC_leftmouse
%                 WISC_leftmouse
%                 WISC_leftmouse
%                 WISC_leftmouse
%                 WISC_leftmouse
%                 WISC_leftmouse
%                 WISC_leftmouse
%                 WISC_leftmouse

  %  elseif  whichButton == 1
   %             if par.recordEEG, sendtrigger(par.CD_BUTTONS(2),port,SITE,0); end
   %             if par.useEL, calllib('iViewXAPI', 'iV_SendImageMessage', formatString(256, int8([ num2str(num2str(par.CD_BUTTONS(2)))])));end;
   %             check_response;
    end
    
elseif  whichButton == 3 && correction(c,1) == 1 ; 
            Screen('TextSize', window, 16);
              Screen('DrawText', window, 'Select a new choice with the left mouse', 0.25*scresw, 0.9*scresh, [255 0 0]); Screen('Flip', window,[],1); %WaitSecs(2);
             [clicks,x(c,1),y(c,1),whichButton] = GetClicks(whichScreen,0);
             Screen('FillRect',window, [255 255 255], [0.25*scresw 0.86*scresh 0.25*scresw+500 0.86*scresh+100]); Screen('Flip', window, [],1);
 
 end 
 
      if correction(c,1) == 1 && correct_resp(pp,c) == yes(c)
    disp(['Correction for Trial',num2str(c), ': Correct'])
    par.resp_click(pp,c) = 1;
perf = perf+1;   
      elseif correction(c,1) == 1 
    disp(['Correction for Trial',num2str(c), ': Wrong'])
    par.resp_click(pp,c) = 0;
     end
     
%   end



     