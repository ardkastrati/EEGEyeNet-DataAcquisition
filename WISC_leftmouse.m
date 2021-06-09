if  whichButton == 3    
                    Screen('TextSize', window, 16);
                    Screen('DrawText', window, 'Select a new choice with the left mouse', 0.25*scresw, 0.9*scresh, [255 0 0]); Screen('Flip', window,[],1); %WaitSecs(2);
                    [clicks,x(c,1),y(c,1),whichButton] = GetClicks(whichScreen,0);
                    Screen('FillRect',window, [255 255 255], [0.25*scresw 0.86*scresh 0.25*scresw+500 0.86*scresh+100]); Screen('Flip', window, [],1);
                
                    if exist('pp','var') == 0; return; end;
                end