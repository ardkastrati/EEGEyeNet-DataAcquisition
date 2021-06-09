global h fileID %Define those globally to not pass them through all functions
clc;
pathAllSubjects = '/home/stimuluspc/Eyepredict/All_Subjects/';
addpath(genpath('/home/stimuluspc/Tools/Tooboxes/eeglab'))
subjectToProcess = inputdlg('Please enter Subject ID','SORT',1);
if exist(strjoin([pathAllSubjects subjectToProcess],''))~=7 %Checks wheter Dubject ID Folder exists
    error('SUBJECT ID DOESNT EXIST');
elseif isempty(subjectToProcess{1})
    error('SUBJECT ID DOESNT EXIST');
end
fileID = fopen(strjoin([pathAllSubjects subjectToProcess '/SORT.log'],''),'a'); %Logfile
choice = questdlg('Which ones to sort?', ...
    'SORT', ...
    'ET Only','EEG Only','Both','Both');
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


msgbox('DONE');

function SortEEGFiles(pathAllSubjects, subjectToProcess)
if exist(strjoin([pathAllSubjects subjectToProcess '/ARCHIVE'],''))~=7 %Check wheter ARCHIVE Directory exists
    mkdir(strjoin([pathAllSubjects subjectToProcess '/ARCHIVE'],''));
end
global h fileID;
antisaccCounter=1;
trigger = [... % DEFINING TRIGGERS
    90 ...  % Resting EEG
    921 ... % Processing Speed 1
    922 ... % Processing Speed 2 %ASK MARIUS
    94 ...  % Antisaccade
    12 ...%Start dot1
    13 ... %Start dot2
    14 ...%start dot3
    201 ...%start videonicolas
    203 ... %start vid nicolas2
    190 ...%start reading
    951 ... % VWM1
    952 ... % VWM2
    953 ...% VWM3
    954 ...% VWM4   
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
                out = MoveFile(current,destination,'_WI1_EEG');
                SaveArchive(EEG, out);
            case trigger(3)
                out = MoveFile(current,destination,'_WI2_EEG');
                SaveArchive(EEG, out);
            case trigger(4)
                if antisaccCounter<=4
                    %Antisaccade has 5 Files with same Trigger Info, name them
                    %accordingly
                    out = MoveFile(current,destination,['_AS' num2str(antisaccCounter) '_EEG']);
                    antisaccCounter = antisaccCounter+1;
                else
                    out = MoveFile(current,destination,['_AS' num2str(antisaccCounter) '_EEG']);
                end
                SaveArchive(EEG, out);

            case trigger(5)
                out = MoveFile(current,destination,'_Dots1_EEG');
                SaveArchive(EEG, out);
          
            case trigger(6)
                out = MoveFile(current,destination,'_Dots2_EEG');
                SaveArchive(EEG, out);
            case trigger(7)
                out = MoveFile(current,destination,'_Dots3_EEG');
                SaveArchive(EEG, out);
            case trigger(8)
                out = MoveFile(current,destination,'_MOV1_EEG');
                SaveArchive(EEG, out);
            case trigger(9)
                out = MoveFile(current,destination,'_MOV2_EEG');
                SaveArchive(EEG, out);
            case trigger(10)
                out = MoveFile(current,destination,'_NR1_EEG');
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

