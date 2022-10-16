function ABC_Combine_Results_iterative(ISO,numrun,pp)

if pp==1
    %% create a local cluster object (john's addition)
    pc = parcluster('local');
    % explicitly set the JobStorageLocation to the temp directory that was created in your sbatch script
    pc.JobStorageLocation = strcat('.matlab/local_cluster_jobs/R2019b','/', getenv('SLURM_JOB_ID'));
    parpool(pc,24);
end

  
currentFolder = pwd;

ABC_filename=[currentFolder,'/ABC_outputs_combined/',ISO,'/ABC.',num2str(numrun),'.mat'];
load(ABC_filename);
   % [m,~] = size(ABC);
 par = vertcat(newABC{:,4});
    
%% 
N = 100 % size(par,1);

tmp = [];
tmp2 = [];
Get_Disability_Weights_ISO(N,ISO);
Get_HCV_progress_params_dist(N);

%subdir1 = datestr(now,'mm-dd-yyyy_HH-MM');
%subdir1 = datestr(now,'mm-dd-yyyy_HH');
subdir1 = datestr(now,'mm-dd-yyyy');

subdir = append(subdir1,'/',ISO,'/RUNS',num2str(numrun),'/');


%subdir = datestr(now,'mm-dd-yyyy_HH-MM','_',ISO,'/');


dir = ['Results/',subdir];

if not(isfolder(dir))
    mkdir(dir)
end


parfor k=1:N
    
fname1 = [dir,'/Status_quo_',num2str(k),'.mat'];
fname2 = [dir,'/OST_50_2030_',num2str(k),'.mat'];
fname3 = [dir,'/ART_50_2030_',num2str(k),'.mat'];
fname4 = [dir,'/ARTOST_50_2030_',num2str(k),'.mat'];
fname5 = [dir,'/NSP_50_2030_',num2str(k),'.mat'];
fname6 = [dir,'/NSPART_50_2030_',num2str(k),'.mat'];
fname7 = [dir,'/NSPOST_50_2030_',num2str(k),'.mat'];
fname8 = [dir,'/NSPARTOST_50_2030_',num2str(k),'.mat'];

files = [isfile(fname1)==0,isfile(fname2)==0,isfile(fname3)==0,isfile(fname4)==0,isfile(fname5)==0,isfile(fname6)==0,isfile(fname7)==0,isfile(fname8)==0];

   if sum(files) >1  
       files;
       tmp = [tmp,k];
       tmp2 = [tmp2,sum(files)];
%        try
        Results_Disability_concatenated5(k,ABC_filename,ISO,dir)
%        catch 
%          sprintf(['error',num2str(k)])
%        end
   end
    
end
[sum(tmp2),length(tmp)];

for k=1:N
     filename4 = [dir,'/scale_OST_50_2030_',num2str(k),'.mat'];
    delete(filename4)
     filename5 = [dir,'/scale_ART_50_2030_',num2str(k),'.mat'];
    delete(filename5)
    filename6b = [dir,'/scale_ARTOST_50_2030_',num2str(k),'.mat'];
    delete(filename6b)
    filename8b = [dir,'/scale_NSPART_50_2030_',num2str(k),'.mat'];
    delete(filename8b)
    filename9b = [dir,'/scale_NSPOST_50_2030_',num2str(k),'.mat'];
    delete(filename9b)
     filename10b = [dir,'/scale_NSPARTOST_50_2030_',num2str(k),'.mat'];
    delete(filename10b)
end



%%
filename = [dir,'/Status_quo_',num2str(1),'.mat'];
load(filename,'Status_quo');
fields = fieldnames(Status_quo);

for k = 1:numel(fields)
    Status_quo_tmp.(char(fields(k))) = nan(N,length(Status_quo.(char(fields(k)))));

end
for j=1:N
    
    filename = [dir,'/Status_quo_',num2str(j),'.mat'];
    load(filename)
    for k = 1:numel(fields)
        Status_quo_tmp.(char(fields(k)))(j,:) = Status_quo.(char(fields(k)));
    end
end

%%
Status_quo = Status_quo_tmp;
clear Status_quo_tmp 

Status_quo.TIME = Status_quo.TIME(1,:);

% pause(300)

save([dir,'/Status_quo.mat'],'Status_quo')


for k=1:N
    filename1 = [dir,'/Status_quo_',num2str(k),'.mat'];
    delete(filename1)
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
filename = [dir,'/OST_50_2030_',num2str(1),'.mat'];
load(filename,'OST_50_2030');
fields = fieldnames(OST_50_2030);

for k = 1:numel(fields)
    OST_50_2030_tmp.(char(fields(k))) = nan(N,length(OST_50_2030.(char(fields(k)))));

end
for j=1:N
    
    filename = [dir,'/OST_50_2030_',num2str(j),'.mat'];
    load(filename)
    for k = 1:numel(fields)
        OST_50_2030_tmp.(char(fields(k)))(j,:) = OST_50_2030.(char(fields(k)));
    end
end

%%
OST_50_2030 = OST_50_2030_tmp;
clear OST_50_2030_tmp 


% pause(300)

save([dir,'/OST_50_2030.mat'],'OST_50_2030')


for k=1:N
    filename1 = [dir,'/OST_50_2030_',num2str(k),'.mat'];
    delete(filename1)
%     filename2 = [dir,'/scale_OST_50_2030_',num2str(k),'.mat'];
%     delete(filename2)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pause(180)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
filename = [dir,'/ART_50_2030_',num2str(1),'.mat'];
load(filename,'ART_50_2030');
fields = fieldnames(ART_50_2030);

for k = 1:numel(fields)
    ART_50_2030_tmp.(char(fields(k))) = nan(N,length(ART_50_2030.(char(fields(k)))));

end
for j=1:N
    
    filename = [dir,'/ART_50_2030_',num2str(j),'.mat'];
    load(filename)
    for k = 1:numel(fields)
        ART_50_2030_tmp.(char(fields(k)))(j,:) = ART_50_2030.(char(fields(k)));
    end
end

%%
ART_50_2030 = ART_50_2030_tmp;
clear ART_50_2030_tmp 


% pause(300)

save([dir,'/ART_50_2030.mat'],'ART_50_2030')


for k=1:N
    filename1 = [dir,'/ART_50_2030_',num2str(k),'.mat'];
    delete(filename1)
%     filename2 = [dir,'/scale_ART_50_2030_',num2str(k),'.mat'];
%     delete(filename2)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pause(300)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
filename = [dir,'/ARTOST_50_2030_',num2str(1),'.mat'];
load(filename,'ARTOST_50_2030');
fields = fieldnames(ARTOST_50_2030);

for k = 1:numel(fields)
    ARTOST_50_2030_tmp.(char(fields(k))) = nan(N,length(ARTOST_50_2030.(char(fields(k)))));

end
for j=1:N
    
    filename = [dir,'/ARTOST_50_2030_',num2str(j),'.mat'];
    load(filename)
    for k = 1:numel(fields)
        ARTOST_50_2030_tmp.(char(fields(k)))(j,:) = ARTOST_50_2030.(char(fields(k)));
    end
end

%%
ARTOST_50_2030 = ARTOST_50_2030_tmp;
clear ARTOST_50_2030_tmp 


% pause(300)

save([dir,'/ARTOST_50_2030.mat'],'ARTOST_50_2030')


for k=1:N
    filename1 = [dir,'/ARTOST_50_2030_',num2str(k),'.mat'];
    delete(filename1)
%     filename2 = [dir,'/scale_ARTOST_50_2030_',num2str(k),'.mat'];
%     delete(filename2)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
filename = [dir,'/NSP_50_2030_',num2str(1),'.mat'];
load(filename,'NSP_50_2030');
fields = fieldnames(NSP_50_2030);

for k = 1:numel(fields)
    NSP_50_2030_tmp.(char(fields(k))) = nan(N,length(NSP_50_2030.(char(fields(k)))));

end
for j=1:N
    
    filename = [dir,'/NSP_50_2030_',num2str(j),'.mat'];
    load(filename)
    for k = 1:numel(fields)
        NSP_50_2030_tmp.(char(fields(k)))(j,:) = NSP_50_2030.(char(fields(k)));
    end
end

%%
NSP_50_2030 = NSP_50_2030_tmp;
clear NSP_50_2030_tmp 


% pause(300)

save([dir,'/NSP_50_2030.mat'],'NSP_50_2030')


for k=1:N
    filename1 = [dir,'/NSP_50_2030_',num2str(k),'.mat'];
    delete(filename1)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
filename = [dir,'/NSPART_50_2030_',num2str(1),'.mat'];
load(filename,'NSPART_50_2030');
fields = fieldnames(NSPART_50_2030);

for k = 1:numel(fields)
    NSPART_50_2030_tmp.(char(fields(k))) = nan(N,length(NSPART_50_2030.(char(fields(k)))));

end
for j=1:N
    
    filename = [dir,'/NSPART_50_2030_',num2str(j),'.mat'];
    load(filename)
    for k = 1:numel(fields)
        NSPART_50_2030_tmp.(char(fields(k)))(j,:) = NSPART_50_2030.(char(fields(k)));
    end
end

%%
NSPART_50_2030 = NSPART_50_2030_tmp;
clear NSPART_50_2030_tmp 


% pause(300)

save([dir,'/NSPART_50_2030.mat'],'NSPART_50_2030')


for k=1:N
    filename1 = [dir,'/NSPART_50_2030_',num2str(k),'.mat'];
    delete(filename1)
%     filename2 = [dir,'/scale_NSPART_50_2030_',num2str(k),'.mat'];
%     delete(filename2)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
filename = [dir,'/NSPOST_50_2030_',num2str(1),'.mat'];
load(filename,'NSPOST_50_2030');
fields = fieldnames(NSPOST_50_2030);

for k = 1:numel(fields)
    NSPOST_50_2030_tmp.(char(fields(k))) = nan(N,length(NSPOST_50_2030.(char(fields(k)))));

end
for j=1:N
    
    filename = [dir,'/NSPOST_50_2030_',num2str(j),'.mat'];
    load(filename)
    for k = 1:numel(fields)
        NSPOST_50_2030_tmp.(char(fields(k)))(j,:) = NSPOST_50_2030.(char(fields(k)));
    end
end

%%
NSPOST_50_2030 = NSPOST_50_2030_tmp;
clear NSPOST_50_2030_tmp 


% pause(300)

save([dir,'/NSPOST_50_2030.mat'],'NSPOST_50_2030')


for k=1:N
    filename1 = [dir,'/NSPOST_50_2030_',num2str(k),'.mat'];
    delete(filename1)
%     filename2 = [dir,'/scale_NSPOST_50_2030_',num2str(k),'.mat'];
%     delete(filename2)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
filename = [dir,'/NSPARTOST_50_2030_',num2str(1),'.mat'];
load(filename,'NSPARTOST_50_2030');
fields = fieldnames(NSPARTOST_50_2030);

for k = 1:numel(fields)
    NSPARTOST_50_2030_tmp.(char(fields(k))) = nan(N,length(NSPARTOST_50_2030.(char(fields(k)))));

end
for j=1:N
    
    filename = [dir,'/NSPARTOST_50_2030_',num2str(j),'.mat'];
    load(filename)
    for k = 1:numel(fields)
        NSPARTOST_50_2030_tmp.(char(fields(k)))(j,:) = NSPARTOST_50_2030.(char(fields(k)));
    end
end

%%
NSPARTOST_50_2030 = NSPARTOST_50_2030_tmp;
clear NSPARTOST_50_2030_tmp 


% pause(300)

save([dir,'/NSPARTOST_50_2030.mat'],'NSPARTOST_50_2030')


for k=1:N
    filename1 = [dir,'/NSPARTOST_50_2030_',num2str(k),'.mat'];
    delete(filename1)
%     filename2 = [dir,'/scale_NSPARTOST_50_2030_',num2str(k),'.mat'];
%     delete(filename2)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


pause(600)

ABC_Get_HIV_reduction_combined_CI(ISO,N,dir,numrun);
ABC_Get_HCV_reduction_combined_CI(ISO,N,dir,numrun);




