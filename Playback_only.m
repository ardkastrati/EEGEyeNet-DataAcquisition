close all
clear all

%Place full path for movie here.  For example, 
% moviename = 'C:\Users\Desktop\moviename.avi'

moviename = '';
hsc = Screen('OpenWindow',0);

[moviePtr duration fps count] = Screen('OpenMovie',hsc,moviename);
Screen('PlayMovie',moviePtr,1);


while ~KBCheck
    tex = Screen('GetMovieImage', hsc, moviePtr);
    
    if tex<=0
        break
    end
    Screen('DrawTexture',hsc,tex);
    Screen('Flip',hsc);
    Screen('Close',tex);
end
        
Screen('PlayMovie', moviePtr, 0);
Screen('CloseMovie', moviePtr);
Screen('CloseAll');
sca
