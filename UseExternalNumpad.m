%[~,code]=KbWait();
%index = find(code,1);
%Eyelink('SendKeyButton', code, mods, state)

 Eyelink('Initialize')
Eyelink('StartSetup' , 0)
 Eyelink('DriftCorrStart', x, y ,0 , 1, 0)
 Eyelink('ApplyDriftCorr')
 Eyelink('TargetCheck')
 Eyelink('AcceptTrigger')
Eyelink('CalMessage')
