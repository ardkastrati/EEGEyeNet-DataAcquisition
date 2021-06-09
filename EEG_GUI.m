clear all;
cd /home/stimuluspc/Eyepredict;
input = questdlg('Start new session or pick up on existing one?','CMI-EEG','New','Existing','New');
existing=0;

%set mouse speed: (the larger the last value, the slower)
%mouse speed on exerimenter screen (do not slow down)
system('xinput set-prop "11" "Device Accel Constant Deceleration" 1');
%mouse speed on subject screen (slow down by factor slowFact 
slowFact=5;
system(['xinput set-prop "13" "Device Accel Constant Deceleration" ' num2str(slowFact)]);

switch input
    case 'New'
        metafile.entryPoint = 0;
        subj_Name =inputdlg({'Enter Subjects ID:'},'CMI-EEG',1,{''});
        metafile.tasks = {};
        
        metafile.subject = subj_Name;
        if str2double(subj_Name{1,1}) > 999, error('Invalid Subject ID'), end;
        
        cd /home/stimuluspc/Eyepredict;
      while exist(['All_Subjects/',subj_Name{1,1},'/',subj_Name{1,1}, '_metafile.mat'],'file')~=0
            subj_Name =inputdlg({'Subject ID already taken! Choose a different one:'},'CMI-EEG',1,{''});
            if str2double(subj_Name{1,1}) > 999, error('Invalid Subject ID'), end;
        end
        mkdir(['All_Subjects/',subj_Name{1,1}])
        Done=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        save(['All_Subjects/',subj_Name{1,1},'/',subj_Name{1,1}, '_metafile'],'metafile','Done');
    case 'Existing'
        existing = 1;
        subj_Name =inputdlg({'Enter Subjects ID:'},'CMI-EEG',1,{''});
        
        if ~exist(['All_Subjects/',subj_Name{1,1},'/',subj_Name{1,1}, '_metafile.mat'],'file') >0
            error('Subject ID doesnt exist');
        else
            load(['All_Subjects/',subj_Name{1,1},'/',subj_Name{1,1}, '_metafile.mat']);
            clear selected;
        end
end

m = Eyepredict;
m.ID = subj_Name;
if existing
    load(['All_Subjects/',subj_Name{1,1},'/',subj_Name{1,1}, '_metafile.mat']);
    m.Done = Done;
end
m.savePath = ['All_Subjects/',subj_Name,'/'];
m.savePath = strjoin(m.savePath,'');
m.refresh();
