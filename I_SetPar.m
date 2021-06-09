par.runID= app.run{1};
par.ExaminationDate =app.run{2};
if app.run{3} == 'y'
    par.recordEEG = 1; %  use the EEG tracker?
else
    par.recordEEG = 0;
end;

if app.run{4} == 'y'
    par.useEL = 1;  %  use the eye tracker?
else
    par.useEL = 0;
end;

if app.run{5} == 'y'
    par.useEL_Calib = 1;  %  calibrate the eye tracker?
else
    par.useEL_Calib = 0;
end;
try
    if subj_ID{7,1} == 'y'
        par.useDrift = 1;  % use Drift Correction
    else
        par.useDrift = 0;
    end;
catch
end;