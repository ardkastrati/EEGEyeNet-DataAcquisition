
%clear all

%addpath(genpath('/Users/nickilanger/Documents/MATLAB/Psychtoolbox-3-PTB_Beta-2013-07-11_V3.0.11'))
%addpath(genpath('/Users/nickilanger/Desktop/AA_CCNY/AA_recorded_data/GeneralMatlab'))
%addpath(genpath('/Users/nickilanger/Documents/MATLAB/gkde2'))
%addpath(genpath('/Users/nickilanger/Documents/MATLAB/sc'))

cd C:\PsychToolbox_Experiments\Simon
load WISC_positions.mat

subj_Name =inputdlg({'Enter Subjects ID:'},'CMI-EEG',1,{''});


[wisc_sel,v] = listdlg('PromptString','Select WISC file to analyze:',...
                'SelectionMode','single','ListSize',[200,100], 'ListString',{'WISC 1st','WISC_2nd'}); 
                

if wisc_sel == 1
%load([subj_Name{1,1}, '_metafile'])
load([subj_Name{1,1} '_WISC_ProcSpeed.mat']);
elseif wisc_sel == 2
load([subj_Name{1,1} '_WISC_ProcSpeed_2nd.mat']);
end
%%% TEST
%events = {};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

position_resp = []

for i = 1:15
position_resp(i,1,1) = position_stimuli(i,7,1)+79.5870;
position_resp(i,1,2) = position_stimuli(i,7,2);
position_resp(i,1,3) = position_stimuli(i,7,3)+39.5870;
position_resp(i,1,4) = position_stimuli(i,7,4);
end

position_resp(:,2,1) = position_resp(:,1,1)+70;
position_resp(:,2,2) = position_resp(:,1,2);
position_resp(:,2,3) = position_resp(:,1,3)+70;
position_resp(:,2,4) = position_resp(:,1,4);


resp_size_box = position_resp;


%% Extract Data

idx_start = [];
idx_NEW_PAGE = [];
 idx_RESP = [];
  idx_CORR = [];
  idx_CORR_RESP = [];
  idx_header = [];
  idx_saccadeL = [];
   idx_fixationL = [];
    idx_blinkL = [];
  saccades_L = [];
  fixation_L = [];
  blinks_L = [];
  saccades_R = [];
  fixation_R = [];
   blinks_R = [];
   
   clear trial_duration
   trial_duration = [];
   
   
for i = 1:size(events,1)

if isempty(strmatch('# Message: 1', events{i,5},'exact')) == 0;
    idx_start(end+1,1) = events{i,4}; end;
    
    if isempty(strmatch('# Message: 20', events{i,5},'exact')) == 0;
    idx_NEW_PAGE(end+1,1) = events{i,4}; end;

    if isempty(strmatch('# Message: 14', events{i,5},'exact')) == 0;
    idx_RESP(end+1,1) = events{i,4}; end;

    if isempty(strmatch('# Message: 15', events{i,5},'exact')) == 0;
    idx_CORR(end+1,1) = events{i,4}; end;
    
if isempty(strmatch('# Message: 16', events{i,5},'exact')) == 0;
    idx_CORRRESP(end+1,1) = events{i,4}; end;

if isempty(strmatch('UserEvent', events{i,1},'exact')) == 0;
   idx_header(end+1,1) = i; end;

if isempty(strmatch('Saccade L', events{i,1},'exact')) == 0;
   idx_saccadeL(end+1,1) = i; end;

if isempty(strmatch('Fixation L', events{i,1},'exact')) == 0;
   idx_fixationL(end+1,1) = i; end;

if isempty(strmatch('Blink L', events{i,1},'exact')) == 0;
   idx_blinkL(end+1,1) = i; end;



if isempty(strmatch('Saccade L', events{i,1},'exact')) == 0;
   saccades_L(end+1,1).number = events{i,3};
saccades_L(end,1).start= events{i,4}; 
saccades_L(end,1).end= events{i,5};
saccades_L(end,1).duration= events{i,6}; 
saccades_L(end,1).startX= events{i,7}; 
saccades_L(end,1).startY= events{i,8};
saccades_L(end,1).endX= events{i,9}; 
saccades_L(end,1).endY= events{i,10}; 
saccades_L(end,1).amplitude = events{i,11}; 
saccades_L(end,1).peak_speed = events{i,12}; 
saccades_L(end,1).avg_speed = events{i,13}; 
saccades_L(end,1).peak_accel= events{i,14}; 
saccades_L(end,1).peak_decel= events{i,15}; 
saccades_L(end,1).avg_accel= events{i,16}; 
end


if isempty(strmatch('Fixation L', events{i,1},'exact')) == 0;
   fixation_L(end+1,1).number = events{i,3};
fixation_L(end,1).start= events{i,4}; 
fixation_L(end,1).end= events{i,5};
fixation_L(end,1).duration= events{i,6}; 
fixation_L(end,1).locationX= events{i,7}; 
fixation_L(end,1).locationY= events{i,8};
fixation_L(end,1).dispersionX= events{i,9}; 
fixation_L(end,1).dispersionY= events{i,10}; 
fixation_L(end,1).plane = events{i,11}; 
fixation_L(end,1).avg_pupilX = events{i,12}; 
fixation_L(end,1).avg_pupilY = events{i,13}; 
end


if isempty(strmatch('Blink L', events{i,1},'exact')) == 0;
   blinks_L(end+1,1).number = events{i,3};
blinks_L(end,1).start= events{i,4}; 
blinks_L(end,1).end= events{i,5};
blinks_L(end,1).duration= events{i,6}; 
end



if isempty(strmatch('Saccade R', events{i,1},'exact')) == 0;
   saccades_R(end+1,1).number = events{i,3};
saccades_R(end,1).start= events{i,4}; 
saccades_R(end,1).end= events{i,5};
saccades_R(end,1).duration= events{i,6}; 
saccades_R(end,1).startX= events{i,7}; 
saccades_R(end,1).startY= events{i,8};
saccades_R(end,1).endX= events{i,9}; 
saccades_R(end,1).endY= events{i,10}; 
saccades_R(end,1).amplitude = events{i,11}; 
saccades_R(end,1).peak_speed = events{i,12}; 
saccades_R(end,1).avg_speed = events{i,13}; 
saccades_R(end,1).peak_accel= events{i,14}; 
saccades_R(end,1).peak_decel= events{i,15}; 
saccades_R(end,1).avg_accel= events{i,16}; 
end


if isempty(strmatch('Fixation R', events{i,1},'exact')) == 0;
   fixation_R(end+1,1).number = events{i,3};
fixation_R(end,1).start= events{i,4}; 
fixation_R(end,1).end= events{i,5};
fixation_R(end,1).duration= events{i,6}; 
fixation_R(end,1).locationX= events{i,7}; 
fixation_R(end,1).locationY= events{i,8};
fixation_R(end,1).dispersionX= events{i,9}; 
fixation_R(end,1).dispersionY= events{i,10}; 
fixation_R(end,1).plane = events{i,11}; 
fixation_R(end,1).avg_pupilX = events{i,12}; 
fixation_R(end,1).avg_pupilY = events{i,13}; 
end

if isempty(strmatch('Blink R', events{i,1},'exact')) == 0;
   blinks_R(end+1,1).number = events{i,3};
blinks_R(end,1).start= events{i,4}; 
blinks_R(end,1).end= events{i,5};
blinks_R(end,1).duration= events{i,6}; 
end


%% Trial Duration
%if isempty(strmatch('UserEvent', events{i,1},'exact')) == 0 && isempty(strmatch('UserEvent', events{i+1,1},'exact')) == 0;
%   trial_duration(end+1,1)= events{i+1,4}-events{i,4};;
%end


end


%Plot the raw fixation locations for page 2
ind_page2 = [];
ind_page2_start = [];
for i = 1:size(fixation_L,1) 

    if fixation_L(i,1).start > idx_NEW_PAGE(1,1) 
    ind_page2_start(end+1) = i; end
    if fixation_L(i,1).start > idx_NEW_PAGE(2,1)
ind_page2(end+1) = i;
end
end
ind_page2_start = ind_page2_start(1,1);
ind_page2 = ind_page2(1,1);
% 
% figure
% plot([fixation_L(ind_page2_start:ind_page2,1).locationX],[fixation_L(ind_page2_start:ind_page2,1).locationY],'o')
%  xlim([0 800])
% ylim([0 600]) 
%   set(gca,'ydir','reverse')
%  set(gcf, 'color', [1 1 1])
%   
% % if only 1 page was solved:  
%   
%   figure
% plot([fixation_R(ind_page2_start:end,1).locationX],[fixation_R(ind_page2_start:end,1).locationY],'o')
%  xlim([0 800])
% ylim([0 600]) 
%   set(gca,'ydir','reverse')



       
%% Increase the Search Box 

clear new_position_stimuli

orig_position_stimuli = position_stimuli;
orig_resp_size_box = resp_size_box; 
%response box size already increased because of increased size for response otherwise we need to save
%resp_cross


squeeze(position_stimuli(1,1,:));
    
 box_size= [-20; 0; 20; 0]; % adds to the box 20 pixels on each side. be careful of overlapping boxes 
  
 
     for i = 1:size(position_stimuli,1)
     for j = 1:size(position_stimuli,2)
new_position_stimuli(i,j,:) = squeeze(position_stimuli(i,j,:)) + box_size;
     end
     end
%squeeze(new_position_stimuli(1,1,:));
%squeeze(orig_position_stimuli(1,1,:));




box_size_resp= [-20; 0; 20; 0];
% 
      for i = 1:size(resp_size_box,1)
      for j = 1:size(resp_size_box,2)
 new_resp_size_box(i,j,:) = squeeze(resp_size_box(i,j,:)) + box_size_resp;
      end
      end
%squeeze(new_resp_size_box(1,1,:));
%squeeze(orig_resp_size_box(1,1,:));



%% DEFINITION OF SCAN BOXES

%scan box x = 70 pixel wide & y = 30 pixel high

% to increase the Scan BOX:
position_stimuli = new_position_stimuli;
resp_size_box = new_resp_size_box;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%COUNT NR of PAGES processed:

nrPages = size(idx_NEW_PAGE,1)-1; % because last trigger NEW page is the END of the task 

disp(['The subject processed: ',num2str(nrPages), ' pages.' ] );
%%%%%%

%% NEW STRUCTURED  fixation.ordered MATRIX FOR SEPARATION OF EACH PAGE AND TRIAL
% fixation_L = saccades_L ;
fixation = fixation_L; 
 fixation_ordered = struct([]);
 
 % fixation_ordered(1,1).fixation = fixation_L(i,1);
 % fixation_ordered(1,1).fixation(2,1) = fixation_L(4,1);
 
j = 1; pp= 0; k = 1; f = 1; i = 1;

while i <size(fixation_L,1)+1; % alternatively we could also use idx_RESP(end) as last trigger

   if size(idx_NEW_PAGE,1) == 1;
       disp('ERROR! ONLY ONE NEW PAGE TRIGGER FOUND')
        return; 
        
           elseif size(idx_NEW_PAGE,1) == 2;

           if fixation(i).start < idx_NEW_PAGE(2,1); pp = 1; 
          % elseif fixation(i).start> idx_NEW_PAGE(2,1); pp = 2; 
           end;

           elseif size(idx_NEW_PAGE,1) == 3

            if fixation(i).start < idx_NEW_PAGE(2,1); pp = 1; 
            elseif fixation(i).start> idx_NEW_PAGE(2,1) &&  fixation(i).start < idx_NEW_PAGE(3,1); pp = 2; 
            %elseif fixation(i).start> idx_NEW_PAGE(3,1) ; pp = 3; 
            end;

             elseif size(idx_NEW_PAGE,1) == 4     

           if fixation(i).start < idx_NEW_PAGE(2,1); pp = 1; 
            elseif fixation(i).start> idx_NEW_PAGE(2,1) &&  fixation(i).start < idx_NEW_PAGE(3,1); pp = 2; 
            elseif fixation(i).start> idx_NEW_PAGE(3,1) && fixation(i).start < idx_NEW_PAGE(4,1); pp = 3; 
           %elseif fixation(i).start> idx_NEW_PAGE(4,1) && fixation(i).start < idx_RESP(end); pp = 4;
           end

            elseif size(idx_NEW_PAGE,1) == 5     

            if fixation(i).start < idx_NEW_PAGE(2,1); pp = 1; 
            elseif fixation(i).start> idx_NEW_PAGE(2,1) &&  fixation(i).start < idx_NEW_PAGE(3,1); pp = 2; 
            elseif fixation(i).start> idx_NEW_PAGE(3,1) && fixation(i).start < idx_NEW_PAGE(4,1); pp = 3; 
           elseif fixation(i).start> idx_NEW_PAGE(4,1) && fixation(i).start < idx_NEW_PAGE(5,1); pp = 4; end;

    end
   
   
   
   
    if fixation(i).start < idx_RESP(k,1) && fixation(i).start > idx_NEW_PAGE(1,1) && fixation(i).start < idx_RESP(end)
      
     fixation_ordered(pp,j).fixation_L(f,1) = fixation_L(i,1);
     f = f+1; 
     
    end
     
if fixation(i).start > idx_RESP(k,1) && fixation(i).start > idx_NEW_PAGE(1,1) && fixation(i).start < idx_RESP(end)
       k = k+1; j = j+1; f = 1;
       
        if j >15; j = 1;
        
       fixation_ordered(pp,j).fixation_L(f,1) = fixation_L(i,1);
       else
        fixation_ordered(pp,j).fixation_L(f,1) = fixation_L(i,1); 
       end
end
   
   i = i+1;
   
  end   
       
% check how many fixations are there   
   fixation_number_per_trial = []; nr_t = 0
for i = 1:size(fixation_ordered,1)
    for j = 1:size(fixation_ordered,2)
fixation_number_per_trial(i,j) = size(fixation_ordered(i,j).fixation_L,1);
nr_total = nr_t + size(fixation_ordered(i,j).fixation_L,1);
    end
end
   
 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% PLOT THE RAW DATA WITH EACH TRIAL DIFFERENT COLOR AND THE SEARCH BOX
%
% you can switch whether you want to see the y-axis taken into account or
% not.

% COLOR YES AND NO ROWS IN DIFFERENT COLORS!!!!
%
i =1; j = 1;
width = orig_position_stimuli(i,j,3)-orig_position_stimuli(i,j,1);
height = position_stimuli(i,j,4)-position_stimuli(i,j,2);

width_resp = resp_size_box(i,j,3)-resp_size_box(i,j,1);
height_resp = resp_size_box(i,j,4)-resp_size_box(i,j,2);

sb_width = new_position_stimuli(i,j,3)-new_position_stimuli(i,j,1);
sb_height = new_position_stimuli(i,j,4)-new_position_stimuli(i,j,2);


sr_width = 70;
sr_height = new_resp_size_box(i,j,4)-new_resp_size_box(i,j,2);

cc=hsv(size(fixation_ordered,2));
for pp = 1:size(fixation_ordered,1)
  figure
  hold on
  

  xlim([0 800])
ylim([0 600]) 
  set(gca,'ydir','reverse')
  
  % plot the search boxes:
 for ri = 1:size(position_stimuli,1)
    for rj = 1:size(position_stimuli,2)

  r = rectangle('Position',[new_position_stimuli(ri,rj,1),new_position_stimuli(ri,rj,2),sb_width, sb_height]);
set(r,'edgecolor','r')
f = rectangle('Position',[orig_position_stimuli(ri,rj,1),orig_position_stimuli(ri,rj,2),width, height]);

    end
 end
%  
%    % plot the response boxes:
  for ri = 1:size(resp_size_box,1)
     for rj = 1:size(resp_size_box,2)
% 
 r = rectangle('Position',[new_resp_size_box(ri,rj,1),new_resp_size_box(ri,rj,2),sr_width, sr_height]);
 set(r,'edgecolor','r')
 f = rectangle('Position',[orig_resp_size_box(ri,rj,1),orig_resp_size_box(ri,rj,2),width_resp, height_resp]);
% haha
     end
  end
  
  
  for i = 1:size(fixation_ordered,2)

% FIXATIONS:
% to plot without taking y-axis into account:
 %     plot([fixation_ordered(pp,i).fixation_L(:,1).locationX],[new_position_stimuli(i,1,2)+height/2],'+','Color',cc(i,:))

%to plot the raw data with y axis:

if isempty(fixation_ordered(pp,i).fixation_L) == 0 && par.activated_resp(pp,i,1) < 2;
plot([fixation_ordered(pp,i).fixation_L(:,1).locationX],[fixation_ordered(pp,i).fixation_L(:,1).locationY],'+','Color',cc(i,:))
% SACCADES:
%plot([fixation_ordered(pp,i).fixation_L(:,1).startX],[fixation_ordered(pp,i).fixation_L(:,1).startY],'+','Color',cc(i,:))
%plot([fixation_ordered(pp,i).fixation_L(:,1).endX],[fixation_ordered(pp,i).fixation_L(:,1).endY],'+','Color',cc(i,:))


%hold
%plot(corrected_fixationX(1:end-1),corrected_fixationY,'o',cstring(mod(n,7)+1))
 

else
 disp(['SOLVED: ', num2str(pp-1),' pages & ', num2str(i-1), ' lines'])
return  
end
  
  
  end
  
set(gcf, 'color', [1 1 1])
legend('trial1','trial2','trial3','trial4','trial5','trial6','trial7','trial8','trial9','trial10','trial11','trial12','trial13','trial14','trial15')

end
solved_pages = (pp-1); solved_lines = (i-1);
  