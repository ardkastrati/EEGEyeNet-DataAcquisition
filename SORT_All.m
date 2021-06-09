global h fileID %Define those globally to not pass them through all functions
clc;
pathAllSubjects = '/home/stimuluspc/Eyepredict/All_Subjects/';
addpath(genpath('/home/stimuluspc/Tools/Tooboxes/eeglab'))

%allSubs={'BN8','AR2','LP3','AN8','BJ9','AG4','LU8','BC4','BV3','BM3'};

%allSubs={'AH8','AB7','AV5','BR0','AY6','BW9','AI0'}

%allSubs = {'BM1','AR0','BX8','AW9','BS7','AB9','AM1','AX8','AS7','LE6'};

%allSubs = {'LL4','BZ9','BZ5','LX3','BX2','BN5','AZ9','AZ5','AX2','LC1'};

%allSubs = {'BG2','AN5', 'BN2','AG2','BS4','LW6','BB1','BL6'};
%allSubs = {'BK5','AN2','AB1','AL6','LW4'};

%allSubs= {'BS3','BE4','BI8', 'BK1','AS5','AE4','AI8','BI6','AK1','BD4','BH8',...
%    'BP2','AI6','AD4','BE5','AP2','BB7','BY6','AE5'};
    
%allSubs={'AB3','BB3','LB5','AP3','AM4','AH3','BP3','AR8','BH3','LF6'...
    %'LL8','BM4','AP1','BR8','AJ6','AH5','AP1','AV4'};

allSubs={'BP1'};
for s=[1:length(allSubs)]
    
subjectToProcess = allSubs(s);
if exist(strjoin([pathAllSubjects subjectToProcess],''))~=7 %Checks wheter Dubject ID Folder exists
    error('SUBJECT ID DOESNT EXIST');
elseif isempty(subjectToProcess{1})
    error('SUBJECT ID DOESNT EXIST');
end
fileID = fopen(strjoin([pathAllSubjects subjectToProcess '/SORT.log'],''),'a'); %Logfile
choice = 'Both';

% Handle response
switch choice
    case 'ET Only'
        fprintf(fileID, '--------- ET ---------\n');
        h = waitbar(0,'ET Files sortieren');
        SortETFiles(pathAllSubjects, subjectToProcess);
    case 'EEG Only'
        fprintf(fileID, '--------- EEG --------\n');
        h = waitbar(0,'EEG Files sortieren');
        SortEEGFiles(pathAllSubjects, subjectToProcess);
    case 'Both'
        
        fprintf(fileID, '--------- BOTH -------\n');
        h = waitbar(0,'Alle Files sortieren');
        SortEEGFiles(pathAllSubjects, subjectToProcess);
        SortETFiles(pathAllSubjects, subjectToProcess);
    otherwise
        error('CANCELLED');
end
clc;
close(h);
fclose(fileID);

load gong.mat
sound(y);


msgbox(['DONE with ' allSubs{s} ', (' num2str(s) '/' num2str(length(allSubs)) ')']);
end

function SortEEGFiles(pathAllSubjects, subjectToProcess)
if exist(strjoin([pathAllSubjects subjectToProcess '/ARCHIVE'],''))~=7 %Check wheter ARCHIVE Directory exists
    mkdir(strjoin([pathAllSubjects subjectToProcess '/ARCHIVE'],''));
end
global h fileID;
antisaccCounter=1;
trigger = [... % DEFINING TRIGGERS
    90 ...  % Resting EEG
    911 ... % Sequence Learning 1
    912 ... % Sequence Learning 2
    913 ... % Sequence Learning 3
    921 ... % Processing Speed 1
    922 ... % Processing Speed 2
    931 ... % Surround Suppression 1
    932 ... % Surround Suppression 2
    94 ...  % Antisaccade
    95 ...  % Simple Span
    951 ... % VWM1
    952 ... % VWM2
    953 ...% VWM3
    954 ...% VWM4
    933 ... % Surround Suppression 3
    ];
files = dir(fullfile(strjoin([pathAllSubjects subjectToProcess '/'],''),'*.RAW'));
files = {files.name}; %Loading List of Files
for i=1:length(files) %And Looping through it
    waitbar(i/length(files),h,'EEG Files');
    filePath = strjoin([pathAllSubjects subjectToProcess '/' char(files(i))],'');
    current = strjoin([pathAllSubjects subjectToProcess '/' char(files(i))],'');
    EEG = pop_readegi(current, [],[],'auto');
    destination = strjoin([pathAllSubjects subjectToProcess '/' subjectToProcess],'');
    if not(isempty(EEG.event))
        switch str2num(EEG.event(1).type)%First event is Trigger, Move accordingly
            case trigger(1)
                out = MoveFile(current,destination,'_RES_EEG'); %Tests for File duplicates recursively
                SaveArchive(EEG, out);
            case trigger(2)
                out = MoveFile(current,destination,'_SL1_EEG');
                SaveArchive(EEG, out);
            case trigger(3)
                out = MoveFile(current,destination,'_SL2_EEG');
                SaveArchive(EEG, out);
            case trigger(4)
                out = MoveFile(current,destination,'_SL3_EEG');
                SaveArchive(EEG, out);
            case trigger(5)
                out = MoveFile(current,destination,'_WI1_EEG');
                SaveArchive(EEG, out);
            case trigger(6)
                out = MoveFile(current,destination,'_WI2_EEG');
                SaveArchive(EEG, out);
            case trigger(7)
                out = MoveFile(current,destination,'_SP1_EEG');
                SaveArchive(EEG, out);
            case trigger(8)
                out = MoveFile(current,destination,'_SP2_EEG');
                SaveArchive(EEG, out);
            case trigger(9)
                if antisaccCounter<=4
                    %Antisaccade has 5 Files with same Trigger Info, name them
                    %accordingly
                    out = MoveFile(current,destination,['_AS' num2str(antisaccCounter) '_EEG']);
                    antisaccCounter = antisaccCounter+1;
                else
                    out = MoveFile(current,destination,['_AS' num2str(antisaccCounter) '_EEG']);
                end
                SaveArchive(EEG, out);
            case trigger(10)
                out = MoveFile(current,destination,'_SIS_EEG');
                SaveArchive(EEG, out);
            case trigger(11)
                out = MoveFile(current,destination,'_VWM1_EEG');
                SaveArchive(EEG, out);
            case trigger(12)
                out = MoveFile(current,destination,'_VWM2_EEG');
                SaveArchive(EEG, out);
            case trigger(13)
                out = MoveFile(current,destination,'_VWM3_EEG');
                SaveArchive(EEG, out);
            case trigger(14)
                out = MoveFile(current,destination,'_VWM4_EEG');
                SaveArchive(EEG, out);
            case trigger(15)
                out = MoveFile(current,destination,'_SP3_EEG');
                SaveArchive(EEG, out);
            otherwise
                out = MoveFile(current,destination,'_unknown_EEG');
                SaveArchive(EEG, out);
        end
    else
        out = MoveFile(current,destination,'_unknown_EEG');
        SaveArchive(EEG, out);
    end
    
end
end
function SortETFiles(pathAllSubjects, subjectToProcess)
global h fileID;
pathEdf2Asc = '/home/stimuluspc/Tools/Tools/edf2asc'; %Path of EDF2ASC CLI

if exist(strjoin([pathAllSubjects subjectToProcess '/ARCHIVE'],''))~=7 %Check wheter ARCHIVE Directory exists
    mkdir(strjoin([pathAllSubjects subjectToProcess '/ARCHIVE'],''));
end

files = dir(fullfile(strjoin([pathAllSubjects subjectToProcess '/'],''),'*.edf'));
files = {files.name}; %Get Files

for i=1:length(files) %Loop through files
    waitbar(i/length(files),h,'ET Files');
    disp(['Processing File: ' i ' of ' length(files)]);
    filePath = strjoin([pathAllSubjects subjectToProcess '/' char(files(i))],'');
    fprintf(fileID, [datestr(datetime('now')) ' EDF2ASC: ' filePath '\n']);
    system([pathEdf2Asc ' "' filePath '" -y']); %Convert Files to ASC using EDF2ASC CLI
    fprintf(fileID, [datestr(datetime('now')) ' ARCHIVE: ' filePath '\n']);
    movefile(filePath,strjoin([pathAllSubjects subjectToProcess '/ARCHIVE/' char(files(i))],'')); %Move Files to Archive
    parseeyelink(strrep(filePath,'.edf','.asc'),[strrep(filePath,'.edf','') '_ET.mat'],'TR');
    fprintf(fileID, [datestr(datetime('now')) ' PARSE: ' strrep(filePath,'.edf','.asc') '\n']);
    movefile(strrep(filePath,'.edf','.asc'),strjoin([pathAllSubjects subjectToProcess '/ARCHIVE/' strrep(char(files(i)),'.edf', '.asc')],'')); %Move Files to Archive
    fprintf(fileID, [datestr(datetime('now')) ' ARCHIVE: ' strrep(filePath,'.edf','.asc') '\n']);
end
end
function out = MoveFile(current, destination, name, iter)
% Recursively checks wheter File exists and names it accordingly _x where X
% is revision of the File...
global fileID
if nargin < 4
    iter =  0; %if called with 3 Arguments it's first iteration
end
if iter==0
    fullName= [name '.RAW'];
else
    fullName= [name '_' num2str(iter) '.RAW']; %not in First iteration anymore
end
paths = strsplit(destination,'/');
subjNr = [paths(end)'];
archivePath = [strjoin([paths(1:end-1)'],'/') '/ARCHIVE' '/'];
if ~(exist(strjoin([archivePath subjNr fullName],''), 'file') == 2)
    if ~strcmp(strjoin({[destination fullName]},''),current)
        movefile(current,[destination fullName]);
        fprintf(fileID, [datestr(datetime('now')) ' RENAME: ' current ' TO: ' fullName '\n']);
    end
    out = [destination fullName];
else
    out = MoveFile(current, destination, name ,iter+1); %Recursion with iterator
end
end
function SaveArchive(EEG, in)
global fileID
paths = strsplit(in,'/');
filename = strsplit(paths{end},'.');
path = [strjoin([paths(1:end-1)'],'/') '/'];
if ~(exist([path filename{1} '.mat'], 'file') == 2) && (exist([in], 'file') == 2)
    fprintf(fileID, [datestr(datetime('now')) ' TOMAT: ' in '\n']);
    save([path filename{1} '.mat'], 'EEG');
    movefile([in],[path 'ARCHIVE/' [filename{1} '.' filename{2}]]); %Move Files to Archive
    fprintf(fileID, [datestr(datetime('now')) ' ARCHIVE: ' in '\n']);
elseif (exist([clepath filename{1} '.mat'], 'file') == 2) && (exist([in], 'file') == 2)
    movefile([in],[path 'ARCHIVE/' [filename{1} '.' filename{2}]]); %Move Files to Archive
    fprintf(fileID, [datestr(datetime('now')) ' ARCHIVE: ' in '\n']);
end
end

