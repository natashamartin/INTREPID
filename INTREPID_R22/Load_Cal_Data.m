function Load_Cal_Data(ISO)

%% Setup the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 9);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A2:I1274";

% Specify column names and types
opts.VariableNames = ["Year", "Gender", "Variable", "N", "n", "Est", "LI", "UI", "Notes_from_Adam"];
opts.VariableTypes = ["double", "categorical", "string", "double", "double", "double", "double", "double", "string"];

% Specify variable properties
opts = setvaropts(opts, ["Variable", "Notes_from_Adam"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Gender", "Variable", "Notes_from_Adam"], "EmptyFieldRule", "auto");


%% Population size
data_field = 'PWID_pop_size';
Filename = ['Data_Files/Calibration_Data/',data_field,'_data.csv'];
opts = detectImportOptions(Filename);
opts = setvartype(opts,{'Est','LI','UI'},'double');
Cal_data_temp = readtable(Filename,opts);
ind = strcmp(Cal_data_temp.ISO, ISO);
Data.(char(data_field)).time_pt = Cal_data_temp.Date(ind);
Data.(char(data_field)).estimate = Cal_data_temp.Est(ind);
Data.(char(data_field)).lower = Cal_data_temp.LI(ind);
Data.(char(data_field)).upper = Cal_data_temp.UI(ind);

% %% Prop ever incarcerated
% % overall
data_field = 'PWID_prop_ever_inc';
Filename = ['Data_Files/Calibration_Data/',data_field,'_data.csv'];
opts = detectImportOptions(Filename);
opts = setvartype(opts,{'Est','LI','UI'},'double');
Cal_data_temp = readtable(Filename,opts);
ind = strcmp(Cal_data_temp.ISO, ISO);
Data.(char(data_field)).time_pt = Cal_data_temp.Date(ind);
Data.(char(data_field)).estimate = Cal_data_temp.Est(ind)*100;
Data.(char(data_field)).lower = Cal_data_temp.LI(ind)*100;
Data.(char(data_field)).upper = Cal_data_temp.UI(ind)*100;
% 
% 
data_field = 'PWID_prop_recent_inc';
Filename = ['Data_Files/Calibration_Data/',data_field,'_data.csv'];
opts = detectImportOptions(Filename);
opts = setvartype(opts,{'Est','LI','UI'},'double');
Cal_data_temp = readtable(Filename,opts);
ind = strcmp(Cal_data_temp.ISO, ISO);
Data.(char(data_field)).time_pt = Cal_data_temp.Date(ind);
Data.(char(data_field)).estimate = Cal_data_temp.Est(ind)*100;
Data.(char(data_field)).lower = Cal_data_temp.LI(ind)*100;
Data.(char(data_field)).upper = Cal_data_temp.UI(ind)*100;
% 


%% Proportion that are young
data_field = 'PWID_prop_young';
Filename = ['Data_Files/Calibration_Data/',data_field,'_data.csv'];
opts = detectImportOptions(Filename);
opts = setvartype(opts,{'Est','LI','UI'},'double');
Cal_data_temp = readtable(Filename,opts);
ind = strcmp(Cal_data_temp.ISO, ISO);
Data.(char(data_field)).time_pt = Cal_data_temp.Date(ind);
Data.(char(data_field)).estimate = Cal_data_temp.Est(ind)*100;
Data.(char(data_field)).lower = Cal_data_temp.LI(ind)*100;
Data.(char(data_field)).upper = Cal_data_temp.UI(ind)*100;

%% Homelessness
% Overall (Community)
data_field = 'PWID_prop_homeless';
Filename = ['Data_Files/Calibration_Data/',data_field,'_data.csv'];
opts = detectImportOptions(Filename);
opts = setvartype(opts,{'Est','LI','UI'},'double');
Cal_data_temp = readtable(Filename,opts);
ind = strcmp(Cal_data_temp.ISO, ISO);
Data.(char(data_field)).time_pt = Cal_data_temp.Date(ind);
Data.(char(data_field)).estimate = Cal_data_temp.Est(ind)*100;
Data.(char(data_field)).lower = Cal_data_temp.LI(ind)*100;
Data.(char(data_field)).upper = Cal_data_temp.UI(ind)*100;

% RR HIV incidence if homeless
data_field = 'RR_HIV_Incidence_homeless';
Data.(char(data_field)).time_pt = 2020;
Data.(char(data_field)).estimate = 1.39;
Data.(char(data_field)).lower = 1.06;
Data.(char(data_field)).upper = 1.84;

% RR HCV incidence if homeless
data_field = 'RR_HCV_Incidence_homeless';
Data.(char(data_field)).time_pt = 2020;
Data.(char(data_field)).estimate = 1.60;
Data.(char(data_field)).lower = 1.39;
Data.(char(data_field)).upper = 1.83;



%% HIV prevalence - community
% Overall (individual estimates)
data_field = 'PWID_HIV_prevalence_com';
Filename = ['Data_Files/Calibration_Data/',data_field,'_data.csv'];
opts = detectImportOptions(Filename);
opts = setvartype(opts,{'N','Est','LI','UI'},'double');
Cal_data_temp = readtable(Filename,opts);
%ind1 = find(~isnan(Cal_data_temp.N)); % indices of estimates WITH sample sizes
ind1 = find(~isnan(Cal_data_temp.Est)); % indices of estimates WITH estimates
Cal_data_temp = Cal_data_temp(ind1,:); % filter
ind2 = strcmp(Cal_data_temp.ISO, ISO); % indices of relevant country
Data.(char(data_field)).time_pt = Cal_data_temp.Date(ind2);
Data.(char(data_field)).estimate = Cal_data_temp.Est(ind2)*100;
Data.(char(data_field)).lower = Cal_data_temp.LI(ind2)*100;
Data.(char(data_field)).upper = Cal_data_temp.UI(ind2)*100;
nvec = Cal_data_temp.N; % vector of population sizes
ind3 = find(ind2);

for i=1:length(ind3)
    if ~isnan(Cal_data_temp.N(ind3(i)))
        if isempty(Cal_data_temp.LI(ind3(i))) || isempty(Cal_data_temp.UI(ind3(i))) % check for missing CIs among estimates WITH sample sizes
            n = nvec(ind3(i)); % population size
            x = round(Cal_data_temp.Est(ind3(i)) * n); % positive results
            [~,ci] = binofit(x,n,.05);
            Data.(char(data_field)).lower(i) = ci(1)*100;
            Data.(char(data_field)).upper(i) = ci(2)*100;
        end
    end
end     
for i=1:length(ind3)
    if ~isnan(Cal_data_temp.N(ind3(i)))    
        if isnan(Cal_data_temp.LI(ind3(i))) || isnan(Cal_data_temp.UI(ind3(i))) % check for missing CIs among estimates WITH sample sizes
            n = nvec(ind3(i)); % population size
            x = round(Cal_data_temp.Est(ind3(i)) * n); % positive results
            [~,ci] = binofit(x,n,.05);
            Data.(char(data_field)).lower(i) = ci(1)*100;
            Data.(char(data_field)).upper(i) = ci(2)*100;
        end
    end
end 

for i=1:length(ind3)
    if isnan(Cal_data_temp.N(ind3(i)))
        if isempty(Cal_data_temp.LI(ind3(i))) || isempty(Cal_data_temp.UI(ind3(i))) % check for missing CIs among estimates WITH sample sizes
%             n = nvec(ind3(i)); % population size
%             x = round(Cal_data_temp.Est(ind3(i)) * n); % positive results
%             [~,ci] = binofit(x,n,.05);
            Data.(char(data_field)).lower(i) = Cal_data_temp.Est(ind3(i))*0.8;
            Data.(char(data_field)).upper(i) = Cal_data_temp.Est(ind3(i))*1.2;
        end
    end
end  
for i=1:length(ind3)
    if isnan(Cal_data_temp.N(ind3(i)))
        if isnan(Cal_data_temp.LI(ind3(i))) || isnan(Cal_data_temp.UI(ind3(i))) % check for missing CIs among estimates WITH sample sizes
%             n = nvec(ind3(i)); % population size
%             x = round(Cal_data_temp.Est(ind3(i)) * n); % positive results
%             [~,ci] = binofit(x,n,.05);
            Data.(char(data_field)).lower(i) = Cal_data_temp.Est(ind3(i))*0.8;
            Data.(char(data_field)).upper(i) = Cal_data_temp.Est(ind3(i))*1.2;
        end
    end
end  



% Overall (pooled estimates)
data_field = 'PWID_HIV_prevalence_com_pooled';
Filename = ['Data_Files/Calibration_Data/',data_field,'_data.csv'];
opts = detectImportOptions(Filename);
opts = setvartype(opts,{'Est','LI','UI'},'double');
Cal_data_temp = readtable(Filename,opts);
ind = strcmp(Cal_data_temp.ISO, ISO);
Data.(char(data_field)).time_pt = Cal_data_temp.Date(ind);
Data.(char(data_field)).estimate = Cal_data_temp.Est(ind)*100;
Data.(char(data_field)).lower = Cal_data_temp.LI(ind)*100;
Data.(char(data_field)).upper = Cal_data_temp.UI(ind)*100;


% 
% RR HIV incidence recently incarcerated
data_field = 'RR_HIV_Incidence_rec_inc';
Data.(char(data_field)).time_pt = 2020;
Data.(char(data_field)).estimate = 1.81;
Data.(char(data_field)).lower = 1.40;
Data.(char(data_field)).upper = 2.43;
% 
% RR HIV incidence non-recently incarcerated
data_field = 'RR_HIV_Incidence_nonrec_inc';
Data.(char(data_field)).time_pt = 2020;
Data.(char(data_field)).estimate = 1.25;
Data.(char(data_field)).lower = 0.94;
Data.(char(data_field)).upper = 1.65;

% RR HIV prevalence if female
data_field = 'RR_HIV_prev_female';
Filename = ['Data_Files/Calibration_Data/',data_field,'_data.csv'];
opts = detectImportOptions(Filename);
opts = setvartype(opts,{'Est','LI','UI'},'double');
Cal_data_temp = readtable(Filename,opts);
ind = strcmp(Cal_data_temp.ISO, ISO);
Data.(char(data_field)).time_pt = Cal_data_temp.Date(ind);
Data.(char(data_field)).estimate = Cal_data_temp.Est(ind);
Data.(char(data_field)).lower = Cal_data_temp.LI(ind);
Data.(char(data_field)).upper = Cal_data_temp.UI(ind);



%% HCV_AB prevalence - community
% Overall
data_field = 'PWID_HCV_AB_prevalence_com';
Filename = ['Data_Files/Calibration_Data/',data_field,'_data.csv'];
opts = detectImportOptions(Filename);
opts = setvartype(opts,{'Est','LI','UI'},'double');
Cal_data_temp = readtable(Filename,opts);
ind = strcmp(Cal_data_temp.ISO, ISO);
Data.(char(data_field)).time_pt = Cal_data_temp.Date(ind);
Data.(char(data_field)).estimate = Cal_data_temp.Est(ind)*100;
Data.(char(data_field)).lower = Cal_data_temp.LI(ind)*100;
Data.(char(data_field)).upper = Cal_data_temp.UI(ind)*100;

% HCV prevalence among HIV+ PWID
data_field = 'PWID_HCV_AB_prevalence_com_HIV_pos';
Filename = ['Data_Files/Calibration_Data/',data_field,'_data.csv'];
opts = detectImportOptions(Filename);
opts = setvartype(opts,{'Est','LI','UI'},'double');
Cal_data_temp = readtable(Filename,opts);
ind = strcmp(Cal_data_temp.ISO, ISO);
Data.(char(data_field)).time_pt = Cal_data_temp.Date(ind);
Data.(char(data_field)).estimate = Cal_data_temp.Est(ind)*100;
Data.(char(data_field)).lower = Cal_data_temp.LI(ind)*100;
Data.(char(data_field)).upper = Cal_data_temp.UI(ind)*100;

%% current OST
% Overall
data_field = 'PWID_prop_current_OST_com';
Filename = ['Data_Files/Calibration_Data/',data_field,'_data.csv'];
opts = detectImportOptions(Filename);
opts = setvartype(opts,{'Est','LI','UI'},'double');
Cal_data_temp = readtable(Filename,opts);
ind = strcmp(Cal_data_temp.ISO, ISO);
Data.(char(data_field)).time_pt = Cal_data_temp.Date(ind);
Data.(char(data_field)).estimate = Cal_data_temp.Est(ind)*100;
Data.(char(data_field)).lower = Cal_data_temp.LI(ind)*100;
Data.(char(data_field)).upper = Cal_data_temp.UI(ind)*100;



% %% current ART
% Overall
data_field = 'PWID_prop_current_ART_com';
Filename = ['Data_Files/Calibration_Data/',data_field,'_data.csv'];
opts = detectImportOptions(Filename);
opts = setvartype(opts,{'Est','LI','UI'},'double');
Cal_data_temp = readtable(Filename,opts);
ind = strcmp(Cal_data_temp.ISO, ISO);
Data.(char(data_field)).time_pt = Cal_data_temp.Date(ind);
Data.(char(data_field)).estimate = Cal_data_temp.Est(ind)*100;
Data.(char(data_field)).lower = Cal_data_temp.LI(ind)*100;
Data.(char(data_field)).upper = Cal_data_temp.UI(ind)*100;


%%Proportion HIV sexual transmission 
data_field = 'PWID_prop_HIV_sexual';
Filename = ['Data_Files/Calibration_Data/',data_field,'_data.csv'];
opts = detectImportOptions(Filename);
opts = setvartype(opts,{'Est','LI','UI'},'double');
Cal_data_temp = readtable(Filename,opts);
ind = strcmp(Cal_data_temp.ISO, ISO);
Data.(char(data_field)).time_pt = Cal_data_temp.Date(ind);
% Data.(char(data_field)).estimate = Cal_data_temp.Est(ind)*100;
% Data.(char(data_field)).lower = Cal_data_temp.LI(ind)*100;
% Data.(char(data_field)).upper = Cal_data_temp.UI(ind)*100;


if ~isnan(Cal_data_temp.Est(ind))    
    Data.(char(data_field)).estimate = Cal_data_temp.Est(ind)*100;
    Data.(char(data_field)).lower = Cal_data_temp.LI(ind)*100;
    Data.(char(data_field)).upper = Cal_data_temp.UI(ind)*100;
end

if isnan(Cal_data_temp.Est(ind))    
    [estimate_tmp,lower_tmp,upper_tmp] = prop_sexual(Data.PWID_HIV_prevalence_com_pooled.estimate/100,...
                                                     Data.PWID_HCV_AB_prevalence_com.estimate/100,...
                                                     Data.PWID_HCV_AB_prevalence_com_HIV_pos.estimate/100);
    Data.(char(data_field)).estimate = estimate_tmp*100;
    Data.(char(data_field)).lower = lower_tmp*100;
    Data.(char(data_field)).upper = upper_tmp*100;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






%% get unique time_pts
fields = fieldnames(Data);
Time_pts = [];
for i=1:numel(fields)
    Time_pts = [Time_pts,Data.(char(fields(i))).time_pt'];
end
Data.Time_pts = unique(Time_pts);
%% Save Data as .mat
Filename = [ISO,'_Data.mat'];
save(Filename,'Data')
end
