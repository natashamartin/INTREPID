function ABC_plot_john_projections_duration_new8(ISO,mydir,scenario,pp,duration)

myfolder = pwd;
mypath=['./ABC_outputs/',ISO,'/'];


%% Load posteriors
% filename = 'New_Tanz/ABC_04-28-2021_Tanzania_15-31_1000.mat';
myfiles = dir(fullfile(myfolder, '/ABC_outputs/',ISO,'/*1000.mat'));
myfilename=[mypath,myfiles.name];
load(myfilename)
[m,~] = size(ABC);


if pp ==1
    %% create a local cluster object (john's addition)
    pc = parcluster('local');
    % explicitly set the JobStorageLocation to the temp directory that was created in your sbatch script
    pc.JobStorageLocation = strcat('.matlab/local_cluster_jobs/R2019b','/', getenv('SLURM_JOB_ID'));
    parpool(pc,24);
end

%%% need to get seed date for the given country otherwise it will crash
%%% because of plot limits
 lower_limit= Get_seed_date(ISO);
 
 
%% scenario-specific outputs folder
folder = ['Outputs/',ISO,'/',num2str(duration),'hrs/scenario_',num2str(scenario)];
if not(isfolder(folder))
    mkdir(folder)
end

folder2 = ['Outputs/',ISO,'/',num2str(duration),'hrs/scenario_',num2str(scenario),'/Histograms/'];
if not(isfolder(folder2))
    mkdir(folder2)
end

folder3 = ['Outputs/',ISO,'/',num2str(duration),'hrs/scenario_',num2str(scenario),'/Plots/'];
if not(isfolder(folder3))
    mkdir(folder3)
end



%%%% ADDED THE DURATION ARGUMENT %%%%%%%%%%%%%%%%%%
for m2 = 1:m
    if sum(ABC{m2,14}/3600)>duration, break, end;
end
%%%% ADDED THE DURATION ARGUMENT %%%%%%%%%%%%%%%%%%



samp_params = ABC{m2,4};
N = 1000; % optional
samp_params = samp_params(1:N,:); % optional
% samp_params = samp_params(988:1000,:); % optional
% 

%% Load priors
filename = ['priors_',ISO,'.mat'];
load(filename);

%% Load data for country
filename = [ISO,'_Data.mat'];
tmp = load(filename);
Data = tmp.Data;
clear tmp

%% histograms

%prior_post_histogram(N, samp_params, priors, ISO, scenario);
prior_post_histogram_duration(N, samp_params, priors, ISO, scenario,duration);


%% Setup variables
switch scenario
    case 0
        load([mydir,'/Status_quo.mat']);
        model = Status_quo;
    case 1
        load([mydir,'/OST_50_2030.mat'])
        model = OST_50_2030;
    case 2
        load([mydir,'/ART_50_2030.mat'])
        model = ART_50_2030;
    case 3
        load([mydir,'/ARTOST_50_2030.mat'])
        model = ARTOST_50_2030;
    case 4
        load([mydir,'/NSP_50_2030.mat'])
        model = NSP_50_2030;        
    case 5
        load([mydir,'/NSPART_50_2030.mat'])
        model = NSPART_50_2030;
    case 6
        load([mydir,'/NSPOST_50_2030.mat'])
        model = NSPOST_50_2030;
    case 7
        load([mydir,'/NSPARTOST_50_2030.mat'])
        model = NSPARTOST_50_2030;
end
    
    
    %% PWID Population Size
%     PWID_pop_size = sum(y_out(:,:,1,:,:,:,:,:,:,:,:),4:11);
    %% prop female
%     PWID_prop_female = sum(y_out(:,:,1,2,:,[1,3,4],:,:,:,:,:),3:11)./...
%         sum(y_out(:,:,1,:,:,[1,3,4],:,:,:,:,:),3:11)*100;
%     %% prop young
%     PWID_prop_young = sum(y_out(:,:,1,:,1,:,:,:,:,:,:),3:11)./... 
%         sum(y_out(:,:,1,:,:,:,:,:,:,:,:),3:11)*100;
% 
%     %% HIV prevalence among PWID
%     % overall
%     PWID_HIV_prevalence = sum(y_out(:,:,1,:,:,:,:,:,2:8,:,:),3:11)./... 
%         sum(y_out(:,:,1,:,:,:,:,:,:,:,:),3:11)*100;
% %     %by gender
%     PWID_HIV_prevalence_m = sum(y_out(:,:,1,1,:,:,:,:,2:8,:,:),3:11)./... 
%         sum(y_out(:,:,1,1,:,:,:,:,:,:,:),3:11)*100;
%     PWID_HIV_prevalence_f = sum(y_out(:,:,1,2,:,:,:,:,2:8,:,:),3:11)./... 
%         sum(y_out(:,:,1,2,:,:,:,:,:,:,:),3:11)*100;
%     
%     %% RR HIV prevalence female
%     RR_HIV_female = PWID_HIV_prevalence_f./PWID_HIV_prevalence_m;
%     
%     %% HCV AB prevalence among PWID
%     % overall
%     PWID_HCV_AB_prevalence = sum(y_out(:,:,1,:,:,:,:,:,:,[2,3],:),3:11)./... 
%         sum(y_out(:,:,1,:,:,:,:,:,:,:,:),3:11)*100;
%     %by gender
%     PWID_HCV_AB_prevalence_m = sum(y_out(:,:,1,1,:,:,:,:,:,[2,3],:),3:11)./...
%         sum(y_out(:,:,1,1,:,:,:,:,:,:,:),3:11)*100;
%     PWID_HCV_AB_prevalence_f = sum(y_out(:,:,1,2,:,:,:,:,:,[2,3],:),3:11)./...
%         sum(y_out(:,:,1,2,:,:,:,:,:,:,:),3:11)*100;
%   
%     % HIV coinfection
%     PWID_HCV_HIV_prev = sum(y_out(:,:,1,:,:,:,:,:,2:8,2:3,:),3:11)./...
%     sum(y_out(:,:,1,:,:,:,:,:,2:8,:,:),3:11)*100;
% 
%     %% RR HCV prevalence female
%     RR_HCV_female = PWID_HCV_AB_prevalence_f./PWID_HCV_AB_prevalence_m;
% 
%     %% Prop on OST (community)
%     PWID_prop_current_OST_com = sum(y_out(:,:,1,:,:,[1,3,4],:,[2,3],:,:,:),3:11)./...
%         sum(y_out(:,:,1,:,:,[1,3,4],:,:,:,:,:),3:11)*100;
% 
%     %% Prop ever on OST (community)
%     PWID_prop_ever_OST_com = sum(y_out(:,:,1,:,:,[1,3,4],:,[2,3,4],:,:,:),3:11)./...
%         sum(y_out(:,:,1,:,:,[1,3,4],:,:,:,:,:),3:11)*100;
%    
%     %% Prop on ART
%     PWID_prop_current_ART = sum(y_out(:,:,1,:,:,:,:,:,[4,6,8],:,:),3:11)./...
%         sum(y_out(:,:,1,:,:,:,:,:,2:8,:,:),3:11)*100;
%     
%     %% Prop of HIV infections due to sexual transmission
%     prop_HIV_sexual = hiv_sexual./(hiv_sexual + hiv_inj).*100; % john added

    
    
% PWID_prop_recently_incarcerated_NGO(isnan(PWID_prop_recently_incarcerated_NGO))=0;
% PWID_prop_short_NGO(isnan(PWID_prop_short_NGO))=0;
% PWID_prop_current_OST_com_client(isnan(PWID_prop_current_OST_com_client))=0;
% PWID_prop_current_ART_com_client(isnan(PWID_prop_current_ART_com_client))=0;
% PWID_prop_ever_OST_com_client(isnan(PWID_prop_ever_OST_com_client))=0;






%% FIGURES %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




time_end = 2030;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_field = 'Yearly_Cost_ART';
model.(data_field);
YEAR=(lower_limit):time_end;
duration=time_end-lower_limit;

for i=1:duration
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';
year_long=YEAR.';
long_df2=[[0,0,0];long_df]; %%% inserting 0s in data init?
combined_df=[year_long,long_df2];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_field = 'Yearly_Cost_OST';
model.(data_field);
YEAR=(lower_limit):time_end;
duration=time_end-lower_limit;

for i=1:duration
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';
year_long=YEAR.';
long_df2=[[0,0,0];long_df]; %%% inserting 0s in data init?
combined_df=[year_long,long_df2];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_field = 'Yearly_Cost_NSP';
model.(data_field);
YEAR=(lower_limit):time_end;
duration=time_end-lower_limit;

for i=1:duration
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';
year_long=YEAR.';
long_df2=[[0,0,0];long_df]; %%% inserting 0s in data init?
combined_df=[year_long,long_df2];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_field = 'Yearly_Cost_ALL';
model.(data_field);
YEAR=(lower_limit):time_end;
duration=time_end-lower_limit;

for i=1:duration
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';
year_long=YEAR.';
long_df2=[[0,0,0];long_df]; %%% inserting 0s in data init?
combined_df=[year_long,long_df2];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_field = 'CE_Yearly_Disability_weighted_LYs';
model.(data_field);
YEAR=(lower_limit):time_end;
duration=time_end-lower_limit;

for i=1:duration
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';
year_long=YEAR.';
long_df2=[[0,0,0];long_df]; %%% inserting 0s in data init?
combined_df=[year_long,long_df2];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_field = 'Yearly_Disability_weighted_LYs_PWID';
model.(data_field);
YEAR=(lower_limit):time_end;
duration=time_end-lower_limit;

for i=1:duration
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';
year_long=YEAR.';
long_df2=[[0,0,0];long_df]; %%% inserting 0s in data init?
combined_df=[year_long,long_df2];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_field = 'Yearly_Disability_weighted_LYs_HIV';
model.(data_field);
YEAR=(lower_limit):time_end;
duration=time_end-lower_limit;

for i=1:duration
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';
year_long=YEAR.';
long_df2=[[0,0,0];long_df]; %%% inserting 0s in data init?
combined_df=[year_long,long_df2];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_field = 'CE_Yearly_Pyrs_ART';
model.(data_field);
YEAR=(lower_limit):time_end;
duration=time_end-lower_limit;

for i=1:duration
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';
year_long=YEAR.';
long_df2=[[0,0,0];long_df]; %%% inserting 0s in data init?
combined_df=[year_long,long_df2];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_field = 'CE_Yearly_Pyrs_OST';
model.(data_field);
YEAR=(lower_limit):time_end;
duration=time_end-lower_limit;

for i=1:duration
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';
year_long=YEAR.';
long_df2=[[0,0,0];long_df]; %%% inserting 0s in data init?
combined_df=[year_long,long_df2];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_field = 'CE_Yearly_life_years';
model.(data_field);
YEAR=(lower_limit):time_end;
duration=time_end-lower_limit;

for i=1:duration
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';
year_long=YEAR.';
long_df2=[[0,0,0];long_df]; %%% inserting 0s in data init?
combined_df=[year_long,long_df2];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_field = 'CE_Yearly_Pyrs_PWID';
model.(data_field);
YEAR=(lower_limit):time_end;
duration=time_end-lower_limit;

for i=1:duration
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';
year_long=YEAR.';
long_df2=[[0,0,0];long_df]; %%% inserting 0s in data init?
combined_df=[year_long,long_df2];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







fig_multi = figure; set(fig_multi,'visible','off');
tile_m = 6;
tile_n = 7;

%% PWID population size
data_field = 'PWID_pop_size';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title('PWID pop size')
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))



if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('pop size')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T=table(model.(data_field));
% csvfilename1=[folder,'/Plots/',ISO,'.',data_field,'.data.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T,csvfilename1)
% 
% csvfilename2=[folder,'/Plots/',ISO,'.',data_field,'.time.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writematrix(model.TIME,csvfilename2)
z={'time','estimate','lower','upper'};
T2=table(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,Data.(char(data_field)).lower,Data.(char(data_field)).upper,'VariableNames', z);
csvfilename3=[folder,'/Plots/',ISO,'.',data_field,'.calibration.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T2,csvfilename3)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_trans=model.TIME.';
for i=1:length(time_trans)
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';

combined_df=[time_trans(:,1),long_df];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,1)
title('PWID pop size')
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('pop size')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;

%% <25
data_field = 'PWID_prop_young';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title('% young (com)')
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
%plot(2015,10,'d','color','black','markerfacecolor','black','markersize',5)

yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('% Young')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T=table(model.(data_field));
% csvfilename1=[folder,'/Plots/',ISO,'.',data_field,'.data.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T,csvfilename1)
% 
% csvfilename2=[folder,'/Plots/',ISO,'.',data_field,'.time.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writematrix(model.TIME,csvfilename2)
z={'time','estimate','lower','upper'};
T2=table(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,Data.(char(data_field)).lower,Data.(char(data_field)).upper,'VariableNames', z);
csvfilename3=[folder,'/Plots/',ISO,'.',data_field,'.calibration.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T2,csvfilename3)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time_trans=model.TIME.';
for i=1:length(time_trans)
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';

combined_df=[time_trans(:,1),long_df];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,3)
title('% young (com)')
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
%plot(2015,10,'d','color','black','markerfacecolor','black','markersize',5)

yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('% Young')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;

%% Ever incarcerated - comm

data_field = 'PWID_prop_ever_inc';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title({'% ever inc', '(com)'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('% ever incarcerated')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,4)
title({'% ever inc', '(com)'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('% ever incarcerated')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T=table(model.(data_field));
% csvfilename1=[folder,'/Plots/',ISO,'.',data_field,'.data.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T,csvfilename1)
% 
% csvfilename2=[folder,'/Plots/',ISO,'.',data_field,'.time.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writematrix(model.TIME,csvfilename2)
z={'time','estimate','lower','upper'};
T2=table(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,Data.(char(data_field)).lower,Data.(char(data_field)).upper,'VariableNames', z);
csvfilename3=[folder,'/Plots/',ISO,'.',data_field,'.calibration.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T2,csvfilename3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time_trans=model.TIME.';
for i=1:length(time_trans)
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';

combined_df=[time_trans(:,1),long_df];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% HIV prevalence (com)
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title('HIV prevalence (com)')

% f1 = nexttile;
data_field = 'PWID_HIV_prevalence_com';
function_plot_intervals(model.TIME,model.(data_field))
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        try
            plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
        catch
        end
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('HIV prevalence (%)')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,12)
title({'HIV prevalence', '(com)'})

% f1 = nexttile;
% data_field = 'PWID_HIV_prevalence_com';
function_plot_intervals(model.TIME,model.(data_field))
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
    for i=1:length(Data.(char(data_field)).time_pt)
        try
            plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
        catch
        end
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('HIV prevalence (%)')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T=table(model.(data_field));
% csvfilename1=[folder,'/Plots/',ISO,'.',data_field,'.data.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T,csvfilename1)
% 
% csvfilename2=[folder,'/Plots/',ISO,'.',data_field,'.time.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writematrix(model.TIME,csvfilename2)
z={'time','estimate','lower','upper'};
T2=table(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,Data.(char(data_field)).lower,Data.(char(data_field)).upper,'VariableNames', z);
csvfilename3=[folder,'/Plots/',ISO,'.',data_field,'.calibration.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T2,csvfilename3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time_trans=model.TIME.';
for i=1:length(time_trans)
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';

combined_df=[time_trans(:,1),long_df];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% OR HIV prevalence if young (com)

% data_field = 'OR_HIV_young';
% fig=figure; set(fig,'visible','off');
% % fig = tiledlayout('flow');
% % fig.Padding = 'compact';
% % fig.TileSpacing = 'compact';
% title('OR HIV prevalence young (com)')
% % nexttile;
% function_plot_intervals(model.TIME, model.(data_field))
% 
% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
%     end
% end
% yl = ylim;
% ylim([0, yl(2)]);
% xlabel('Time')
% ylabel('OR')
% xlim([lower_limit,2031])
% filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
% saveas(fig,filename)
% 
% % tiled
% set(0, 'CurrentFigure', fig_multi)
% subplot(tile_m,tile_n,13)
% title({'OR HIV prevalence', 'young (com)'})
% % nexttile;
% function_plot_intervals(model.TIME, model.(data_field))
% 
% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
%     end
% end
% yl = ylim;
% ylim([0, yl(2)]);
% xlabel('Time')
% ylabel('OR')
% xlim([lower_limit,2031])
% ax = gca;
% ax.FontSize = 6;

%% OR HIV prevalence if ever incarcerated (com)

% data_field = 'OR_HIV_ever_inc';
% fig=figure; set(fig,'visible','off');
% % fig = tiledlayout('flow');
% % fig.Padding = 'compact';
% % fig.TileSpacing = 'compact';
% title('OR HIV prev ever inc (com)')
% % nexttile;
% function_plot_intervals(model.TIME, model.(data_field))
% 
% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
%     end
% end
% yl = ylim;
% ylim([0, yl(2)]);
% xlabel('Time')
% ylabel('OR')
% xlim([lower_limit,2031])
% filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
% saveas(fig,filename)
% 
% % tiled
% set(0, 'CurrentFigure', fig_multi)
% subplot(tile_m,tile_n,14)
% title({'OR HIV prev', 'ever inc (com)'})
% % nexttile;
% function_plot_intervals(model.TIME, model.(data_field))
% 
% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
%     end
% end
% yl = ylim;
% ylim([0, yl(2)]);
% xlabel('Time')
% ylabel('OR')
% xlim([lower_limit,2031])
% ax = gca;
% ax.FontSize = 6;

%% RR HIV Incidence recently incarcerated

data_field = 'RR_HIV_Incidence_rec_inc';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title('RR HIV Incidence rec. inc.')
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('RR')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,13)
title({'RR HIV Incidence','rec inc'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('RR')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T=table(model.(data_field));
% csvfilename1=[folder,'/Plots/',ISO,'.',data_field,'.data.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T,csvfilename1)
% 
% csvfilename2=[folder,'/Plots/',ISO,'.',data_field,'.time.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writematrix(model.TIME,csvfilename2)
z={'time','estimate','lower','upper'};
T2=table(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,Data.(char(data_field)).lower,Data.(char(data_field)).upper,'VariableNames', z);
csvfilename3=[folder,'/Plots/',ISO,'.',data_field,'.calibration.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T2,csvfilename3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time_trans=model.TIME.';
for i=1:length(time_trans)
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';

combined_df=[time_trans(:,1),long_df];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% RR HIV Incidence non-recently incarcerated

data_field = 'RR_HIV_Incidence_nonrec_inc';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title('RR HIV Incidence nonrec. inc.')
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('RR')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,14)
title({'RR HIV Incidence','nonrec inc'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('RR')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;

%% RR HIV prevalence if female (com)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T=table(model.(data_field));
% csvfilename1=[folder,'/Plots/',ISO,'.',data_field,'.data.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T,csvfilename1)
% 
% csvfilename2=[folder,'/Plots/',ISO,'.',data_field,'.time.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writematrix(model.TIME,csvfilename2)
z={'time','estimate','lower','upper'};
T2=table(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,Data.(char(data_field)).lower,Data.(char(data_field)).upper,'VariableNames', z);
csvfilename3=[folder,'/Plots/',ISO,'.',data_field,'.calibration.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T2,csvfilename3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time_trans=model.TIME.';
for i=1:length(time_trans)
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';

combined_df=[time_trans(:,1),long_df];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


data_field = 'RR_HIV_prev_female';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title('RR HIV prevalence female (com)')
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('RR')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,15)
title({'RR HIV prevalence', 'female (com)'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('RR')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T=table(model.(data_field));
% csvfilename1=[folder,'/Plots/',ISO,'.',data_field,'.data.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T,csvfilename1)
% 
% csvfilename2=[folder,'/Plots/',ISO,'.',data_field,'.time.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writematrix(model.TIME,csvfilename2)
z={'time','estimate','lower','upper'};
T2=table(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,Data.(char(data_field)).lower,Data.(char(data_field)).upper,'VariableNames', z);
csvfilename3=[folder,'/Plots/',ISO,'.',data_field,'.calibration.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T2,csvfilename3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time_trans=model.TIME.';
for i=1:length(time_trans)
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';

combined_df=[time_trans(:,1),long_df];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% HCV AB Prevalence (community)

data_field = 'PWID_HCV_AB_prevalence_com';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title('HCV Prevalence (com)')
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('HCV prev')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,16)
title({'HCV Prevalence', '(com)'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('HCV prev')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;

%% OR HCV prevalence if young (com)

% data_field = 'OR_HCV_young';
% fig=figure; set(fig,'visible','off');
% % fig = tiledlayout('flow');
% % fig.Padding = 'compact';
% % fig.TileSpacing = 'compact';
% title('OR HCV prevalence if young (com)')
% % nexttile;
% function_plot_intervals(model.TIME, model.(data_field))
% 
% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
%     end
% end
% yl = ylim;
% ylim([0, yl(2)]);
% xlabel('Time')
% ylabel('OR')
% xlim([lower_limit,2031])
% filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
% saveas(fig,filename)
% 
% % tiled
% set(0, 'CurrentFigure', fig_multi)
% subplot(tile_m,tile_n,17)
% title({'OR HCV prevalence', 'if young (com)'})
% % nexttile;
% function_plot_intervals(model.TIME, model.(data_field))
% 
% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
%     end
% end
% yl = ylim;
% ylim([0, yl(2)]);
% xlabel('Time')
% ylabel('OR')
% xlim([lower_limit,2031])
% ax = gca;
% ax.FontSize = 6;

%% OR HCV prevalence if ever incarcerated (com)

% data_field = 'OR_HCV_ever_inc';
% fig=figure; set(fig,'visible','off');
% % fig = tiledlayout('flow');
% % fig.Padding = 'compact';
% % fig.TileSpacing = 'compact';
% title('OR HCV prev if ever inc (com)')
% % nexttile;
% function_plot_intervals(model.TIME, model.(data_field))
% 
% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
%     end
% end
% yl = ylim;
% ylim([0, yl(2)]);
% xlabel('Time')
% ylabel('OR')
% xlim([lower_limit,2031])
% filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
% saveas(fig,filename)
% 
% % tiled
% set(0, 'CurrentFigure', fig_multi)
% subplot(tile_m,tile_n,18)
% title({'OR HCV prev', 'if ever inc (com)'})
% % nexttile;
% function_plot_intervals(model.TIME, model.(data_field))
% 
% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
%     end
% end
% yl = ylim;
% ylim([0, yl(2)]);
% xlabel('Time')
% ylabel('OR')
% xlim([lower_limit,2031])
% ax = gca;
% ax.FontSize = 6;

%% RR HCV Incidence recently incarcerated

data_field = 'RR_HCV_Incidence_rec_inc';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title('RR HCV Incidence rec. inc.')
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('RR')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,17)
title({'RR HCV Incidence','rec inc'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('RR')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;

%% RR HCV Incidence nonrecently incarcerated

data_field = 'RR_HCV_Incidence_nonrec_inc';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title('RR HCV Incidence nonrec. inc.')
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('RR')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,18)
title({'RR HCV Incidence','nonrec inc'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('RR')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;

%% RR HCV prevalence if female (com)

data_field = 'RR_HCV_prev_female';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title('RR HCV prevalence if female (com)')
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('RR')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,19)
title({'RR HCV prevalence', 'if female (com)'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('RR')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;


%% HCV prevalence among HIV positive PWID

data_field = 'PWID_HCV_AB_prevalence_com_HIV_pos';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title({'HCV prev among','HIV+ (com)'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('prev')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,20)
title({'HCV prev among','HIV+ (com)'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('prev')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Percent of PWID who are homeless
data_field = 'PWID_prop_homeless';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title({'PWID homeless'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('% homeless')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,21)
title({'PWID homeless'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('% homeless')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T=table(model.(data_field));
% csvfilename1=[folder,'/Plots/',ISO,'.',data_field,'.data.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T,csvfilename1)
% 
% csvfilename2=[folder,'/Plots/',ISO,'.',data_field,'.time.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writematrix(model.TIME,csvfilename2)
z={'time','estimate','lower','upper'};
T2=table(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,Data.(char(data_field)).lower,Data.(char(data_field)).upper,'VariableNames', z);
csvfilename3=[folder,'/Plots/',ISO,'.',data_field,'.calibration.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T2,csvfilename3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time_trans=model.TIME.';
for i=1:length(time_trans)
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';

combined_df=[time_trans(:,1),long_df];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% RR of HIV acquisition of homeless
data_field = 'RR_HIV_Incidence_homeless';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title({'RR HIV incidence','homeless'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('RR')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,22)
title({'RR HIV','incidence','homeless'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('RR')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T=table(model.(data_field));
% csvfilename1=[folder,'/Plots/',ISO,'.',data_field,'.data.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T,csvfilename1)
% 
% csvfilename2=[folder,'/Plots/',ISO,'.',data_field,'.time.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writematrix(model.TIME,csvfilename2)
z={'time','estimate','lower','upper'};
T2=table(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,Data.(char(data_field)).lower,Data.(char(data_field)).upper,'VariableNames', z);
csvfilename3=[folder,'/Plots/',ISO,'.',data_field,'.calibration.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T2,csvfilename3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time_trans=model.TIME.';
for i=1:length(time_trans)
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';

combined_df=[time_trans(:,1),long_df];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% OST Coverage (community)

data_field = 'PWID_prop_current_OST_com';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title('OST coverage (com)')
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('OST coverage')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,25)
title({'OST coverage', '(com)'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('OST coverage')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T=table(model.(data_field));
% csvfilename1=[folder,'/Plots/',ISO,'.',data_field,'.data.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T,csvfilename1)
% 
% csvfilename2=[folder,'/Plots/',ISO,'.',data_field,'.time.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writematrix(model.TIME,csvfilename2)
z={'time','estimate','lower','upper'};
T2=table(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,Data.(char(data_field)).lower,Data.(char(data_field)).upper,'VariableNames', z);
csvfilename3=[folder,'/Plots/',ISO,'.',data_field,'.calibration.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T2,csvfilename3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time_trans=model.TIME.';
for i=1:length(time_trans)
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';

combined_df=[time_trans(:,1),long_df];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% ART coverage (com)

data_field = 'PWID_prop_current_ART_com';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title('ART coverage (com)')
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('ART coverage')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,29)
title('ART coverage (com)')
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('ART coverage')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T=table(model.(data_field));
% csvfilename1=[folder,'/Plots/',ISO,'.',data_field,'.data.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T,csvfilename1)
% 
% csvfilename2=[folder,'/Plots/',ISO,'.',data_field,'.time.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writematrix(model.TIME,csvfilename2)
z={'time','estimate','lower','upper'};
T2=table(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,Data.(char(data_field)).lower,Data.(char(data_field)).upper,'VariableNames', z);
csvfilename3=[folder,'/Plots/',ISO,'.',data_field,'.calibration.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T2,csvfilename3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time_trans=model.TIME.';
for i=1:length(time_trans)
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';

combined_df=[time_trans(:,1),long_df];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Odds ratio of ART enrollment if old vs young (com)

% data_field = 'OR_ART_old';
% fig=figure; set(fig,'visible','off');
% % fig = tiledlayout('flow');
% % fig.Padding = 'compact';
% % fig.TileSpacing = 'compact';
% title('OR ART if old vs young (com)')
% % nexttile;
% function_plot_intervals(model.TIME, model.(data_field))
% 
% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
%     end
% end
% yl = ylim;
% ylim([0, yl(2)]);
% xlabel('Time')
% ylabel('ART coverage')
% xlim([lower_limit,2031])
% filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
% saveas(fig,filename)
% 
% % tiled
% set(0, 'CurrentFigure', fig_multi)
% subplot(tile_m,tile_n,31)
% title({'OR ART if old', 'vs young (com)'})
% % nexttile;
% function_plot_intervals(model.TIME, model.(data_field))
% 
% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
%     end
% end
% yl = ylim;
% ylim([0, yl(2)]);
% xlabel('Time')
% ylabel('ART coverage')
% xlim([lower_limit,2031])
% ax = gca;
% ax.FontSize = 6;

%% OST Coverage - ever (community)
% figure;
% % fig = tiledlayout('flow');
% % fig.Padding = 'compact';
% % fig.TileSpacing = 'compact';
% title('% ever OST - Community')
% 
% data_field = 'PWID_prop_ever_OST_com';
% function_plot_intervals(TIME,PWID_prop_ever_OST_com)
% % if isempty(Data.(char(data_field)).time_pt) ==0
% %     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
% %     for i=1:length(Data.(char(data_field)).time_pt)
% %         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
% %     end
% % end
% title('Overall')
% xlabel('Time')
% ylabel('% ever OST')
% 
% xlim([2010,2021])
% filename = [char(city_name),'_ever_OST_com.png'];
% saveas(fig,filename)


%% HIV infections due to sexual transmission

data_field = 'PWID_prop_HIV_sexual';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title({'% new HIV infections', 'due to sexual transmission'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

% Data.(char(data_field)).time_pt
% Data.(char(data_field)).estimate
% 
% size(Data.(char(data_field)).estimate)
% size(Data.(char(data_field)).time_pt)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('% infections')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T=table(model.(data_field));
% csvfilename1=[folder,'/Plots/',ISO,'.',data_field,'.data.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T,csvfilename1)
% 
% csvfilename2=[folder,'/Plots/',ISO,'.',data_field,'.time.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writematrix(model.TIME,csvfilename2)
z={'time','estimate','lower','upper'};
T2=table(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,Data.(char(data_field)).lower,Data.(char(data_field)).upper,'VariableNames', z);
csvfilename3=[folder,'/Plots/',ISO,'.',data_field,'.calibration.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T2,csvfilename3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time_trans=model.TIME.';
for i=1:length(time_trans)
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';

combined_df=[time_trans(:,1),long_df];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,34)
title({'% new HIV inf.', 'from sexual trans.'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
    end
end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('% infections')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;

%% ADDITIONAL PLOTS - NOT FROM CALIBRATION
%% OST coverage - ALL PWID

data_field = 'PWID_prop_current_OST_all';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title({'OST coverage (all)'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
%     end
% end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('OST coverage')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T=table(model.(data_field));
% csvfilename1=[folder,'/Plots/',ISO,'.',data_field,'.data.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T,csvfilename1)
% 
% csvfilename2=[folder,'/Plots/',ISO,'.',data_field,'.time.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writematrix(model.TIME,csvfilename2)
% z={'time','estimate','lower','upper'};
% T2=table(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,Data.(char(data_field)).lower,Data.(char(data_field)).upper,'VariableNames', z);
% csvfilename3=[folder,'/Plots/',ISO,'.',data_field,'.calibration.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T2,csvfilename3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time_trans=model.TIME.';
for i=1:length(time_trans)
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';

combined_df=[time_trans(:,1),long_df];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,35)
title({'OST coverage (all)'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
%     end
% end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('OST coverage')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;

%% ART coverage - ALL PWID

data_field = 'PWID_prop_current_ART_all';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title({'ART coverage (all)'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
%     end
% end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('ART coverage')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T=table(model.(data_field));
% csvfilename1=[folder,'/Plots/',ISO,'.',data_field,'.data.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T,csvfilename1)
% 
% csvfilename2=[folder,'/Plots/',ISO,'.',data_field,'.time.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writematrix(model.TIME,csvfilename2)
% z={'time','estimate','lower','upper'};
% T2=table(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,Data.(char(data_field)).lower,Data.(char(data_field)).upper,'VariableNames', z);
% csvfilename3=[folder,'/Plots/',ISO,'.',data_field,'.calibration.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T2,csvfilename3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time_trans=model.TIME.';
for i=1:length(time_trans)
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';

combined_df=[time_trans(:,1),long_df];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,36)
title({'ART coverage (all)'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
%     end
% end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('ART coverage')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;

%% HIV Prevalence - ALL PWID

data_field = 'PWID_HIV_prevalence';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title({'HIV Prevalence (all)'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
%     end
% end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('Prevalence')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T=table(model.(data_field));
% csvfilename1=[folder,'/Plots/',ISO,'.',data_field,'.data.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T,csvfilename1)
% 
% csvfilename2=[folder,'/Plots/',ISO,'.',data_field,'.time.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writematrix(model.TIME,csvfilename2)
% z={'time','estimate','lower','upper'};
% T2=table(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,Data.(char(data_field)).lower,Data.(char(data_field)).upper,'VariableNames', z);
% csvfilename3=[folder,'/Plots/',ISO,'.',data_field,'.calibration.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T2,csvfilename3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time_trans=model.TIME.';
for i=1:length(time_trans)
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';

combined_df=[time_trans(:,1),long_df];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,37)
title({'HIV Prevalence (all)'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
%     end
% end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('Prevalence')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;

%% HIV Incidence - ALL PWID

data_field = 'HIV_Incidence_PWID';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title({'HIV Incidence (all)'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
%     end
% end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('Incidence')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T=table(model.(data_field));
% csvfilename1=[folder,'/Plots/',ISO,'.',data_field,'.data.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T,csvfilename1)
% 
% csvfilename2=[folder,'/Plots/',ISO,'.',data_field,'.time.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writematrix(model.TIME,csvfilename2)
% z={'time','estimate','lower','upper'};
% T2=table(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,Data.(char(data_field)).lower,Data.(char(data_field)).upper,'VariableNames', z);
% csvfilename3=[folder,'/Plots/',ISO,'.',data_field,'.calibration.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T2,csvfilename3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time_trans=model.TIME.';
for i=1:length(time_trans)
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';

combined_df=[time_trans(:,1),long_df];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,38)
title({'HIV Incidence (all)'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
%     end
% end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('Incidence')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;

%% prop female (com)
data_field = 'prop_female';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title('% female (com)')
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
%     end
% end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('pop size')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)






%% HIV infection total

data_field = 'HIV_Inf_tot';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title({'HIV infection (all)'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
%     end
% end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('Total HIV infections')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T=table(model.(data_field));
% csvfilename1=[folder,'/Plots/',ISO,'.',data_field,'.data.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T,csvfilename1)
% 
% csvfilename2=[folder,'/Plots/',ISO,'.',data_field,'.time.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writematrix(model.TIME,csvfilename2)
% z={'time','estimate','lower','upper'};
% T2=table(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,Data.(char(data_field)).lower,Data.(char(data_field)).upper,'VariableNames', z);
% csvfilename3=[folder,'/Plots/',ISO,'.',data_field,'.calibration.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T2,csvfilename3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time_trans=model.TIME.';
for i=1:length(time_trans)
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';

combined_df=[time_trans(:,1),long_df];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%% HIV infection total

data_field = 'HIV_Inf_inj';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title({'HIV Inf inj'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
%     end
% end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('HIV Inf inj')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T=table(model.(data_field));
% csvfilename1=[folder,'/Plots/',ISO,'.',data_field,'.data.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T,csvfilename1)
% 
% csvfilename2=[folder,'/Plots/',ISO,'.',data_field,'.time.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writematrix(model.TIME,csvfilename2)
% z={'time','estimate','lower','upper'};
% T2=table(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,Data.(char(data_field)).lower,Data.(char(data_field)).upper,'VariableNames', z);
% csvfilename3=[folder,'/Plots/',ISO,'.',data_field,'.calibration.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T2,csvfilename3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time_trans=model.TIME.';
for i=1:length(time_trans)
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';

combined_df=[time_trans(:,1),long_df];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% HIV infection total

data_field = 'HIV_Inf_sex';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title({'HIV infections sexual'})
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
%     end
% end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('HIV infections sexual')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T=table(model.(data_field));
% csvfilename1=[folder,'/Plots/',ISO,'.',data_field,'.data.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T,csvfilename1)
% 
% csvfilename2=[folder,'/Plots/',ISO,'.',data_field,'.time.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writematrix(model.TIME,csvfilename2)
% z={'time','estimate','lower','upper'};
% T2=table(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,Data.(char(data_field)).lower,Data.(char(data_field)).upper,'VariableNames', z);
% csvfilename3=[folder,'/Plots/',ISO,'.',data_field,'.calibration.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T2,csvfilename3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time_trans=model.TIME.';
for i=1:length(time_trans)
    median_var=median(model.(data_field));
    lower_var=prctile(model.(data_field),2.5);
    upper_var=prctile(model.(data_field),97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';

combined_df=[time_trans(:,1),long_df];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % tiled
% set(0, 'CurrentFigure', fig_multi)
% subplot(tile_m,tile_n,38)
% title({'HIV Incidence (all)'})
% % nexttile;
% function_plot_intervals(model.TIME, model.(data_field))
% 
% % if isempty(Data.(char(data_field)).time_pt) ==0
% %     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
% %     for i=1:length(Data.(char(data_field)).time_pt)
% %         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
% %     end
% % end
% yl = ylim;
% ylim([0, yl(2)]);
% xlabel('Time')
% ylabel('Incidence')
% xlim([lower_limit,2031])
% ax = gca;
% ax.FontSize = 6;

%% prop female (com)
data_field = 'prop_female';
fig=figure; set(fig,'visible','off');
% fig = tiledlayout('flow');
% fig.Padding = 'compact';
% fig.TileSpacing = 'compact';
title('% female (com)')
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
%     end
% end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('pop size')
xlim([lower_limit,2031])
filename = [folder,'/Plots/',ISO,'_',data_field,'.png'];
saveas(fig,filename)








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PWID population size
data_field = 'PWID_pop_size';
data_field2 = 'HIV_Incidence_PWID';
data_field3 = 'PWID_HIV_prevalence';

new_field='new_HIV_infection';
fig=figure; set(fig,'visible','off');

title('New HIV infections')
% nexttile;

% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,1)
title('PWID pop size')
% nexttile;
function_plot_intervals(model.TIME, model.(data_field).*(1-(model.(data_field3)/100)).*model.(data_field2)/100)

% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
%     end
% end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('Number of new HIV infections among PWID')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% z={'time','estimate','lower','upper'};
% T2=table(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate.*Data.(char(data_field2)).estimate,Data.(char(data_field)).lower.*Data.(char(data_field2)).lower,Data.(char(data_field)).upper.*Data.(char(data_field2)).upper,'VariableNames', z);
% csvfilename3=[folder,'/Plots/',ISO,'.',new_field,'.calibration.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T2,csvfilename3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_trans=model.TIME.';
for i=1:length(time_trans)
    median_var=median(model.(data_field).*(1-(model.(data_field3)/100)).*model.(data_field2)/100);
    lower_var=prctile(model.(data_field).*(1-(model.(data_field3)/100)).*model.(data_field2)/100,2.5);
    upper_var=prctile(model.(data_field).*(1-(model.(data_field3)/100)).*model.(data_field2)/100,97.5);
    
end

wide_df=vertcat(median_var,lower_var,upper_var);
long_df=wide_df.';

combined_df=[time_trans(:,1),long_df];
w={'time','median','lower','upper'};
combined_df2=array2table(combined_df,'VariableNames',w);
csvfilename4=[folder,'/Plots/',ISO,'.',new_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(combined_df2,csvfilename4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T=table(model.(data_field));
% csvfilename1=[folder,'/Plots/',ISO,'.',data_field,'.data.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T,csvfilename1)
% 
% csvfilename2=[folder,'/Plots/',ISO,'.',data_field,'.time.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writematrix(model.TIME,csvfilename2)
% z={'time','estimate','lower','upper'};
% T2=table(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,Data.(char(data_field)).lower,Data.(char(data_field)).upper,'VariableNames', z);
% csvfilename3=[folder,'/Plots/',ISO,'.',data_field,'.calibration.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T2,csvfilename3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time_trans=model.TIME.';
% for i=1:length(time_trans)
%     median_var=median(model.(data_field));
%     lower_var=prctile(model.(data_field),2.5);
%     upper_var=prctile(model.(data_field),97.5);
%     
% end
% 
% wide_df=vertcat(median_var,lower_var,upper_var);
% long_df=wide_df.';
% 
% combined_df=[time_trans(:,1),long_df];
% w={'time','median','lower','upper'};
% combined_df2=array2table(combined_df,'VariableNames',w);
% csvfilename4=[folder,'/Plots/',ISO,'.',data_field,'.datasummary.', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(combined_df2,csvfilename4)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% tiled
set(0, 'CurrentFigure', fig_multi)
subplot(tile_m,tile_n,39)
title('% female (com)')
% nexttile;
function_plot_intervals(model.TIME, model.(data_field))

% if isempty(Data.(char(data_field)).time_pt) ==0
%     plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',3)
%     for i=1:length(Data.(char(data_field)).time_pt)
%         plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',1)
%     end
% end
yl = ylim;
ylim([0, yl(2)]);
xlabel('Time')
ylabel('pop size')
xlim([lower_limit,2031])
ax = gca;
ax.FontSize = 6;

%% SAVE MULTI OUTPUT

filename = [folder,'/Plots/',ISO,'_multi.png'];
saveas(fig_multi,filename)

end

function OR = make_OR(prev1,prev2)
        odds1 = prev1/100./(1-prev1/100);
        odds2 = prev2/100./(1-prev2/100);
        OR = odds1./odds2;
end

function [] = function_plot_intervals(tSpan,y)

%%%%%% Injectors
hold on
%plot(tSpan,y,'color',[0.8 0.8 0.8]);
plot(tSpan,median(y,1),'k','linewidth',1.5);
%plot(tSpan,prctile(y,[0,100],1),'k-.','linewidth',1);
%plot(tSpan,prctile(y,[2.5,97.5],1),'k-.','linewidth'1);
% plot(tSpan,prctile(y,[25,75],1),'k--','linewidth',0.5);
plot(tSpan,prctile(y,2.5,1),'k-.','linewidth',0.5);
plot(tSpan,prctile(y,97.5,1),'k-.','linewidth',0.5);
% ciplot(prctile(y,2.5,1),prctile(y,97.5,1),tSpan,[0.5,0.5,0.5],0.3,1);
end
