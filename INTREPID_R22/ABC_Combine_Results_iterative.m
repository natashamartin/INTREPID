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
N = size(par,1);
tmp = [];
tmp2 = [];
Get_Disability_Weights_ISO(N,ISO);

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

% fname2 = ['Results/No_NGO_Ever_',num2str(k),'.mat'];
% fname3 = ['Results/No_NGO_2020_2040_',num2str(k),'.mat'];
% fname4 = ['Results/No_NGO_2020_2025_',num2str(k),'.mat'];
% fname5 = ['Results/NGO_60_coverage_',num2str(k),'.mat'];
% fname6 = ['Results/Scale_NGO_OAT_ART_',num2str(k),'.mat'];
% fname7 = ['Results/Scale_OAT_ART_no_NGO_',num2str(k),'.mat'];
% fname8 = ['Results/Scale_OAT_ART_',num2str(k),'.mat'];
% fname9 = ['Results/NO_NGO_2020_2025_Scale_OAT_ART_',num2str(k),'.mat'];
% fname10 = ['Results/Remove_effect_ART_',num2str(k),'.mat'];
% fname11 = ['Results/Remove_effect_condoms_',num2str(k),'.mat'];
% fname12 = ['Results/Remove_effect_inj_risk_',num2str(k),'.mat'];
% fname13 = ['Results/Remove_effect_OST_',num2str(k),'.mat'];

% files = [isfile(fname1)==0,isfile(fname2)==0,isfile(fname3)==0,isfile(fname4)==0,isfile(fname5)==0  ...
%        ,isfile(fname6)==0,isfile(fname7)==0,isfile(fname8)==0,isfile(fname9)==0 ...
%        ,isfile(fname10)==0,isfile(fname11)==0,isfile(fname12)==0,isfile(fname13)==0 ];
files = [isfile(fname1)==0,isfile(fname2)==0,isfile(fname3)==0];

   if sum(files) >1  
       files;
       tmp = [tmp,k];
       tmp2 = [tmp2,sum(files)];
%        try
        Results_Disability_concatenated(k,ABC_filename,ISO,dir)
%        catch 
%          sprintf(['error',num2str(k)])
%        end
   end
    
end
[sum(tmp2),length(tmp)];
%%
filename = [dir,'/Status_quo_',num2str(1),'.mat'];
load(filename,'Status_quo');
fields = fieldnames(Status_quo);

for k = 1:numel(fields)
    Status_quo_tmp.(char(fields(k))) = nan(N,length(Status_quo.(char(fields(k)))));
    OST_50_2030_tmp.(char(fields(k))) = nan(N,length(Status_quo.(char(fields(k)))));
    ART_50_2030_tmp.(char(fields(k))) = nan(N,length(Status_quo.(char(fields(k)))));
%     No_NGO_Ever_tmp.(char(fields(k))) = nan(N,length(Status_quo.(char(fields(k)))));
%     No_NGO_2020_2025_tmp.(char(fields(k))) = nan(N,length(Status_quo.(char(fields(k)))));
%     No_NGO_2020_2040_tmp.(char(fields(k))) = nan(N,length(Status_quo.(char(fields(k)))));
%     NGO_60_coverage_tmp.(char(fields(k))) = nan(N,length(Status_quo.(char(fields(k)))));
%     Scale_NGO_OAT_ART_tmp.(char(fields(k))) = nan(N,length(Status_quo.(char(fields(k)))));
%     Scale_OAT_ART_no_NGO_tmp.(char(fields(k))) = nan(N,length(Status_quo.(char(fields(k)))));
%     Scale_OAT_ART_tmp.(char(fields(k))) = nan(N,length(Status_quo.(char(fields(k)))));
%     NO_NGO_2020_2025_Scale_OAT_ART_tmp.(char(fields(k))) = nan(N,length(Status_quo.(char(fields(k)))));
%     Remove_effect_ART_tmp.(char(fields(k))) = nan(N,length(Status_quo.(char(fields(k)))));
%     Remove_effect_condoms_tmp.(char(fields(k))) = nan(N,length(Status_quo.(char(fields(k)))));
%     Remove_effect_inj_risk_tmp.(char(fields(k))) = nan(N,length(Status_quo.(char(fields(k)))));
%     Remove_effect_OST_tmp.(char(fields(k))) = nan(N,length(Status_quo.(char(fields(k)))));


end
for j=1:N
    
    filename = [dir,'/Status_quo_',num2str(j),'.mat'];
    load(filename)
    filename = [dir,'/OST_50_2030_',num2str(j),'.mat'];
    load(filename)
    filename = [dir,'/ART_50_2030_',num2str(j),'.mat'];
    load(filename)
%     filename = ['Results/No_NGO_Ever_',num2str(j),'.mat'];
%     load(filename)
%     filename = ['Results/No_NGO_2020_2025_',num2str(j),'.mat'];
%     load(filename)
%     filename = ['Results/No_NGO_2020_2040_',num2str(j),'.mat'];
%     load(filename)
%     filename = ['Results/NGO_60_coverage_',num2str(j),'.mat'];
%     load(filename)
%     filename = ['Results/Scale_NGO_OAT_ART_',num2str(j),'.mat'];
%     load(filename)
%     filename = ['Results/Scale_OAT_ART_no_NGO_',num2str(j),'.mat'];
%     load(filename)
%     filename = ['Results/Scale_OAT_ART_',num2str(j),'.mat'];
%     load(filename)
%     filename = ['Results/NO_NGO_2020_2025_Scale_OAT_ART_',num2str(j),'.mat'];
%     load(filename)
%     filename = ['Results/Remove_effect_ART_',num2str(j),'.mat'];
%     load(filename)
%     filename = ['Results/Remove_effect_condoms_',num2str(j),'.mat'];
%     load(filename)
%     filename = ['Results/Remove_effect_inj_risk_',num2str(j),'.mat'];
%     load(filename)
%     filename = ['Results/Remove_effect_OST_',num2str(j),'.mat'];
%     load(filename)
    
    
    for k = 1:numel(fields)
        Status_quo_tmp.(char(fields(k)))(j,:) = Status_quo.(char(fields(k)));
        OST_50_2030_tmp.(char(fields(k)))(j,:) = OST_50_2030.(char(fields(k)));
        ART_50_2030_tmp.(char(fields(k)))(j,:) = ART_50_2030.(char(fields(k)));
%         No_NGO_Ever_tmp.(char(fields(k)))(j,:) = No_NGO_Ever.(char(fields(k)));
%         No_NGO_2020_2025_tmp.(char(fields(k)))(j,:) = No_NGO_2020_2025.(char(fields(k)));
%         No_NGO_2020_2040_tmp.(char(fields(k)))(j,:) = No_NGO_2020_2040.(char(fields(k)));
%         NGO_60_coverage_tmp.(char(fields(k)))(j,:) = NGO_60_coverage.(char(fields(k)));
%         Scale_NGO_OAT_ART_tmp.(char(fields(k)))(j,:) = Scale_NGO_OAT_ART.(char(fields(k)));
%         Scale_OAT_ART_no_NGO_tmp.(char(fields(k)))(j,:) = Scale_OAT_ART_no_NGO.(char(fields(k)));
%         Scale_OAT_ART_tmp.(char(fields(k)))(j,:) = Scale_OAT_ART.(char(fields(k)));
%         NO_NGO_2020_2025_Scale_OAT_ART_tmp.(char(fields(k)))(j,:) = NO_NGO_2020_2025_Scale_OAT_ART.(char(fields(k)));
%         Remove_effect_ART_tmp.(char(fields(k)))(j,:) = Remove_effect_ART.(char(fields(k)));
%         Remove_effect_condoms_tmp.(char(fields(k)))(j,:) = Remove_effect_condoms.(char(fields(k)));
%         Remove_effect_inj_risk_tmp.(char(fields(k)))(j,:) = Remove_effect_inj_risk.(char(fields(k)));
%         Remove_effect_OST_tmp.(char(fields(k)))(j,:) = Remove_effect_OST.(char(fields(k)));
    end
end

%%
Status_quo = Status_quo_tmp;
OST_50_2030 = OST_50_2030_tmp;
ART_50_2030 = ART_50_2030_tmp;
% No_NGO_Ever = No_NGO_Ever_tmp;
% No_NGO_2020_2025 = No_NGO_2020_2025_tmp;
% No_NGO_2020_2040 = No_NGO_2020_2040_tmp;
% NGO_60_coverage = NGO_60_coverage_tmp;
% Scale_NGO_OAT_ART = Scale_NGO_OAT_ART_tmp;
% Scale_OAT_ART_no_NGO = Scale_OAT_ART_no_NGO_tmp;
% Scale_OAT_ART = Scale_OAT_ART_tmp;
% NO_NGO_2020_2025_Scale_OAT_ART = NO_NGO_2020_2025_Scale_OAT_ART_tmp;

% Remove_effect_ART = Remove_effect_ART_tmp;
% Remove_effect_condoms = Remove_effect_condoms_tmp;
% Remove_effect_inj_risk = Remove_effect_inj_risk_tmp;
% Remove_effect_OST = Remove_effect_OST_tmp;
        
% clear Status_quo_tmp No_NGO_Ever_tmp No_NGO_2020_2025_tmp No_NGO_2020_2040_tmp ...
%     NGO_60_coverage_tmp Scale_NGO_OAT_ART_tmp Scale_NGO_OAT_ART_tmp ...
%     Scale_OAT_ART_no_NGO_tmp Scale_OAT_ART_tmp NO_NGO_2020_2025_Scale_OAT_ART_tmp ...
%     Remove_effect_ART_tmp Remove_effect_condoms_tmp Remove_effect_inj_risk_tmp Remove_effect_OST_tmp

clear Status_quo_tmp OST_50_2030_tmp ART_50_2030_tmp

Status_quo.TIME = Status_quo.TIME(1,:);

% pause(300)

save([dir,'/Status_quo.mat'],'Status_quo')
save([dir,'/OST_50_2030.mat'],'OST_50_2030')
save([dir,'/ART_50_2030.mat'],'ART_50_2030')





pause(600)


ABC_Get_HIV_reduction_combined_CI(ISO,N,dir,numrun);


for k=1:N
    filename1 = [dir,'/Status_quo_',num2str(k),'.mat'];
    delete(filename1)
    filename2 = [dir,'/OST_50_2030_',num2str(k),'.mat'];
    delete(filename2)
    filename3 = [dir,'/ART_50_2030_',num2str(k),'.mat'];
    delete(filename3)
     filename4 = [dir,'/scale_OST_50_2030_',num2str(k),'.mat'];
    delete(filename4)
     filename5 = [dir,'/scale_ART_50_2030_',num2str(k),'.mat'];
    delete(filename5)
end




% save('No_NGO_Ever.mat','No_NGO_Ever')
% save('No_NGO_2020_2025.mat','No_NGO_2020_2025')
% save('No_NGO_2020_2040.mat','No_NGO_2020_2040')
% save('NGO_60_coverage.mat','NGO_60_coverage')
% save('Scale_NGO_OAT_ART.mat','Scale_NGO_OAT_ART')
% save('Scale_OAT_ART_no_NGO.mat','Scale_OAT_ART_no_NGO')
% save('Scale_OAT_ART','Scale_OAT_ART')
% save('NO_NGO_2020_2025_Scale_OAT_ART','NO_NGO_2020_2025_Scale_OAT_ART')
% save('Remove_effect_ART','Remove_effect_ART')
% save('Remove_effect_condoms','Remove_effect_condoms')
% save('Remove_effect_inj_risk','Remove_effect_inj_risk')
% save('Remove_effect_OST','Remove_effect_OST')
