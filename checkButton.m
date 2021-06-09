% check for button down
clear buttons
[xblah,yblah,buttons] = GetMouse(whichScreen); 
if any(buttons)
    press(n) = 1;
    if ButtonDown==0
        numResp=numResp+1; RespT(numResp)=GetSecs;
        if buttons(1)
            RespLR(numResp)=1;
            disp('Button 1')
        elseif buttons(end)
            RespLR(numResp)=2;
            disp('Button 2')
        end
        if par.recordEEG,  NetStation('Event',num2str(par.CD_BUTTONS(RespLR(numResp)))); end
        if par.useEL, Eyelink('Message',['TR',num2str(par.CD_BUTTONS(RespLR(numResp)))]); end; %Send Triggers    
    end    
    ButtonDown = 1;
else
    ButtonDown = 0; 
end