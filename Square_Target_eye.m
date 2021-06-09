[~, TGonT(n)] = Screen('Flip', window);
if par.recordEEG,  NetStation('Event', num2str(par.CD_Dot_ON(pos_num))); end;
if par.useEL, Eyelink('Message',['TR',num2str(par.CD_Dot_ON(pos_num))]); end; %Sending Starttrigger

%WaitSecs(duration);
Square_background
Screen('FillRect', window, color , squares(:,pos_num));
Screen('Flip', window, [],1);
WaitSecs(fading);

Square_background;
[~, ITIstartT(n)] = Screen('Flip', window);

if par.recordEEG,  NetStation('Event', num2str(par.CD_Dot_OFF(pos_num))); end;
if par.useEL, Eyelink('Message',['TR',num2str(num2str(par.CD_Dot_OFF(pos_num)))]); end; %Sending

%Square_iti TODO DELETE
WaitSecs(ITI);
Square_background