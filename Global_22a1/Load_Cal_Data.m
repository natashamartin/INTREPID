function Load_Cal_Data(ISO)
city=1;
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ANTOINE: DO WE NEED THESE FILES ? NOT IN THE HIV MODEL ANYMORE 
% Import the data 
% Filename = ['City',num2str(city),'_data.xlsx'];
% IBBS_data = readtable(Filename, opts, "UseExcel", false);
% clear opts
% 
% Filename = 'Population_sizes.xlsx';
% Pop_size_data = readtable(Filename, "UseExcel", false);
% 
% Filename = 'PUHLSE_data.xlsx';
% PUHLSE_data = readtable(Filename, "UseExcel", false);
% 
% IBBS_data.date(IBBS_data.Year==2009) = 2009;
% IBBS_data.date(IBBS_data.Year==2011) = 2011;
% IBBS_data.date(IBBS_data.Year==2013) = 2013 + 7/12; % 31st july 2013
% IBBS_data.date(IBBS_data.Year==2015) = 2015 + 7/12; % 22nd july 2015
% IBBS_data.date(IBBS_data.Year==2017) = 2017 + 10/12; %1 6th November 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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

%%%%%%%% IF NOT NEEDED WE CAN COMMENT OUT THOSE IBBS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Proportion that are female
% ind = IBBS_data.Variable=="Female";
% data_field = 'prop_female';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% %% Proportion that are young
% %male
% ind = IBBS_data.Variable=="% Male who are <25";
% data_field = 'PWID_prop_male_com_young';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% %female
% ind = IBBS_data.Variable=="% Feale who are <25";
% data_field = 'PWID_prop_female_com_young';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Prop ever incarcerated
% overall
data_field = 'PWID_prop_ever_inc';
Filename = ['Data_Files/Calibration_Data/',data_field,'_data.csv'];
opts = detectImportOptions(Filename);
opts = setvartype(opts,{'Est','LI','UI'},'double');
opts = detectImportOptions(Filename);
opts = setvartype(opts,{'Est','LI','UI'},'double');
Cal_data_temp = readtable(Filename,opts);
ind = strcmp(Cal_data_temp.ISO, ISO);
Data.(char(data_field)).time_pt = Cal_data_temp.Date(ind);
Data.(char(data_field)).estimate = Cal_data_temp.Est(ind)*100;
Data.(char(data_field)).lower = Cal_data_temp.LI(ind)*100;
Data.(char(data_field)).upper = Cal_data_temp.UI(ind)*100;


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



%%%%%%%% IF NOT NEEDED WE CAN COMMENT OUT THOSE IBBS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % young males
% ind = IBBS_data.Variable=="Ever prison, young" & IBBS_data.Gender=="Male";
% data_field = 'prop_ever_inc_young_male';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % old males
% ind = IBBS_data.Variable=="Ever prison, old" & IBBS_data.Gender=="Male";
% data_field = 'prop_ever_inc_old_male';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % young females
% ind = IBBS_data.Variable=="Ever prison, young" & IBBS_data.Gender=="Female";
% data_field = 'prop_ever_inc_young_female';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % old females
% ind = IBBS_data.Variable=="Ever prison, old" & IBBS_data.Gender=="Female";
% data_field = 'prop_ever_inc_old_female';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% %% Prop recently incarcerated
% % young male
% ind = IBBS_data.Variable=="Prison last year, young" & IBBS_data.Gender=="Male" & IBBS_data.Year~=2015;
% data_field = 'prop_rec_inc_young_male';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % old male
% ind = IBBS_data.Variable=="Prison last year, old" & IBBS_data.Gender=="Male"  & IBBS_data.Year~=2015;
% data_field = 'prop_rec_inc_old_male';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % young female
% ind = IBBS_data.Variable=="Prison last year, young" & IBBS_data.Gender=="Female"  & IBBS_data.Year~=2015;
% data_field = 'prop_rec_inc_young_female';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % old female
% ind = IBBS_data.Variable=="Prison last year, old" & IBBS_data.Gender=="Female"  & IBBS_data.Year~=2015;
% data_field = 'prop_rec_inc_old_female';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % NGO clients
% ind = IBBS_data.Variable=="Prison last year, NGO" & IBBS_data.Gender=="Both"  & IBBS_data.Year~=2015;
% data_field = 'prop_rec_inc_NGO';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % non-NGO clients
% ind = IBBS_data.Variable=="Prison last year, non-NGO" & IBBS_data.Gender=="Both"  & IBBS_data.Year~=2015;
% data_field = 'prop_rec_inc_non_NGO';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%% %% Proportion who are clinets of NGO
% Overall
% ind = IBBS_data.Variable=="NGO client" & IBBS_data.Gender=="Both";
% data_field = 'PWID_prop_NGO';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % young male
% ind = IBBS_data.Variable=="% NGO of young" & IBBS_data.Gender=="Male";
% data_field = 'PWID_prop_NGO_young_male';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % old male
% ind = IBBS_data.Variable=="% NGO of old" & IBBS_data.Gender=="Male";
% data_field = 'PWID_prop_NGO_old_male';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % young female
% ind = IBBS_data.Variable=="% NGO of young" & IBBS_data.Gender=="Female";
% data_field = 'PWID_prop_NGO_young_female';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % old female
% ind = IBBS_data.Variable=="% NGO of old" & IBBS_data.Gender=="Female";
% data_field = 'PWID_prop_NGO_old_female';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % never inc
% ind = IBBS_data.Variable=="% Never prison who are NGO clients" & IBBS_data.Gender=="Both";
% data_field = 'PWID_prop_NGO_never_inc';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % ever inc
% ind = IBBS_data.Variable=="% Ever prison who are NGO clients" & IBBS_data.Gender=="Both";
% data_field = 'PWID_prop_NGO_ever_inc';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % HIV Positive
% ind = IBBS_data.Variable=="NGO client, HIV+" & IBBS_data.Gender=="Both";
% data_field = 'PWID_prop_NGO_HIV_pos';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % HIV Negative
% ind = IBBS_data.Variable=="NGO client, HIV-" & IBBS_data.Gender=="Both";
% data_field = 'PWID_prop_NGO_HIV_neg';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % HCV AB Positive
% ind = IBBS_data.Variable=="% HCV+ who are NGO clients" & IBBS_data.Gender=="Both";
% data_field = 'PWID_prop_NGO_HCV_pos';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % HCV AB Negative
% ind = IBBS_data.Variable=="% HCV- who are NGO clients" & IBBS_data.Gender=="Both";
% data_field = 'PWID_prop_NGO_HCV_neg';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% %% Proportion of NGO clients that are short-term clients
% ind = IBBS_data.Variable=="NGO client <2 years, old" & IBBS_data.Gender=="Both";
% data_field = 'PWID_prop_short_NGO_old';
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;


%%%%%%%%%%%%%%%%%% ANTOINE NEW HOMELESS BLOCK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






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
%%%%%%%%%%%%%%%%%%%%%%%%%%%% NEW FROM HIV ONLY MODEL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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



% %Young males
% data_field = 'PWID_HIV_prevalence_com_ym';
% ind = IBBS_data.Variable=="HIV, young" & IBBS_data.Gender=="Male";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % old males
% data_field = 'PWID_HIV_prevalence_com_om';
% ind = IBBS_data.Variable=="HIV, old" & IBBS_data.Gender=="Male";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % young females
% data_field = 'PWID_HIV_prevalence_com_yf';
% ind = IBBS_data.Variable=="HIV, young" & IBBS_data.Gender=="Female";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % old females
% data_field = 'PWID_HIV_prevalence_com_of';
% ind = IBBS_data.Variable=="HIV, old" & IBBS_data.Gender=="Female";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % never incarcerated 
% data_field = 'PWID_HIV_prevalence_never_inc';
% ind = IBBS_data.Variable=="HIV, never prison" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % ever incarcerated
% data_field = 'PWID_HIV_prevalence_ever_inc';
% ind = IBBS_data.Variable=="HIV, ever prison" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % HCV ab neg
% data_field = 'PWID_HIV_prevalence_com_HCV_neg';
% ind = IBBS_data.Variable=="% HIV among HCV-" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % HCV AB pos
% data_field = 'PWID_HIV_prevalence_com_HCV_pos';
% ind = IBBS_data.Variable=="% HIV among HCV+" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % non ngo clients
% data_field = 'PWID_HIV_prevalence_com_non_client';
% ind = IBBS_data.Variable=="HIV, non-NGO" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % ngo clients
% data_field = 'PWID_HIV_prevalence_com_client';
% ind = IBBS_data.Variable=="HIV, NGO" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;

% RR HIV incidence recently incarcerated
data_field = 'RR_HIV_Incidence_rec_inc';
Data.(char(data_field)).time_pt = 2020;
Data.(char(data_field)).estimate = 1.81;
Data.(char(data_field)).lower = 1.40;
Data.(char(data_field)).upper = 2.34;

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

% %% HIV Prevalence prisoners
% % Overall
% data_field = 'PWID_HIV_prevalence_pris';
% ind = PUHLSE_data.Variable=="HIV prevalence";
% Data.(char(data_field)).time_pt = PUHLSE_data.date(ind);
% Data.(char(data_field)).estimate = PUHLSE_data.Est(ind)*100;
% Data.(char(data_field)).lower = PUHLSE_data.LI(ind)*100;
% Data.(char(data_field)).upper = PUHLSE_data.UI(ind)*100;
% 
% % Young males
% data_field = 'PWID_HIV_prevalence_pris_ym';
% ind = PUHLSE_data.Variable=="HIV prevalence, young male";
% Data.(char(data_field)).time_pt = PUHLSE_data.date(ind);
% Data.(char(data_field)).estimate = PUHLSE_data.Est(ind)*100;
% Data.(char(data_field)).lower = PUHLSE_data.LI(ind)*100;
% Data.(char(data_field)).upper = PUHLSE_data.UI(ind)*100;
% 
% % old males
% data_field = 'PWID_HIV_prevalence_pris_om';
% ind = PUHLSE_data.Variable=="HIV prevalence, old male";
% Data.(char(data_field)).time_pt = PUHLSE_data.date(ind);
% Data.(char(data_field)).estimate = PUHLSE_data.Est(ind)*100;
% Data.(char(data_field)).lower = PUHLSE_data.LI(ind)*100;
% Data.(char(data_field)).upper = PUHLSE_data.UI(ind)*100;
% 
% % Young females
% data_field = 'PWID_HIV_prevalence_pris_yf';
% ind = PUHLSE_data.Variable=="HIV prevalence, young female";
% Data.(char(data_field)).time_pt = PUHLSE_data.date(ind);
% Data.(char(data_field)).estimate = PUHLSE_data.Est(ind)*100;
% Data.(char(data_field)).lower = PUHLSE_data.LI(ind)*100;
% Data.(char(data_field)).upper = PUHLSE_data.UI(ind)*100;
% 
% % old females
% data_field = 'PWID_HIV_prevalence_pris_of';
% ind = PUHLSE_data.Variable=="HIV prevalence, old female";
% Data.(char(data_field)).time_pt = PUHLSE_data.date(ind);
% Data.(char(data_field)).estimate = PUHLSE_data.Est(ind)*100;
% Data.(char(data_field)).lower = PUHLSE_data.LI(ind)*100;
% Data.(char(data_field)).upper = PUHLSE_data.UI(ind)*100;
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





% %Young males
% data_field = 'PWID_HCV_AB_prevalence_com_ym';
% ind = IBBS_data.Variable=="HCV, young" & IBBS_data.Gender=="Male";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % old males
% data_field = 'PWID_HCV_AB_prevalence_com_om';
% ind = IBBS_data.Variable=="HCV, old" & IBBS_data.Gender=="Male";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % young females
% data_field = 'PWID_HCV_AB_prevalence_com_yf';
% ind = IBBS_data.Variable=="HCV, young" & IBBS_data.Gender=="Female";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % old females
% data_field = 'PWID_HCV_AB_prevalence_com_of';
% ind = IBBS_data.Variable=="HCV, old" & IBBS_data.Gender=="Female";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % never incarcerated 
% data_field = 'PWID_HCV_AB_prevalence_never_inc';
% ind = IBBS_data.Variable=="HCV, never prison" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % ever incarcerated
% data_field = 'PWID_HCV_AB_prevalence_ever_inc';
% ind = IBBS_data.Variable=="HCV, ever prison" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % HIV neg
% data_field = 'PWID_HCV_AB_prevalence_com_HIV_neg';
% ind = IBBS_data.Variable=="HCV, in HIV-" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;

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




% non ngo clients
% data_field = 'PWID_HCV_AB_prevalence_com_non_client';
% ind = IBBS_data.Variable=="HCV, non-NGO" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % ngo clients
% data_field = 'PWID_HCV_AB_prevalence_com_client';
% ind = IBBS_data.Variable=="HCV, NGO" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;

% RR HCV incidence recently incarcerated
data_field = 'RR_HCV_Incidence_rec_inc';
Data.(char(data_field)).time_pt = 2020;
Data.(char(data_field)).estimate = 1.62;
Data.(char(data_field)).lower = 1.28;
Data.(char(data_field)).upper = 2.05;

% RR HCV incidence non-recently incarcerated
data_field = 'RR_HCV_Incidence_nonrec_inc';
Data.(char(data_field)).time_pt = 2020;
Data.(char(data_field)).estimate = 1.21;
Data.(char(data_field)).lower = 1.02;
Data.(char(data_field)).upper = 1.43;

% RR HCV prevalence if female
data_field = 'RR_HCV_prev_female';
Filename = ['Data_Files/Calibration_Data/',data_field,'_data.csv'];
opts = detectImportOptions(Filename);
opts = setvartype(opts,{'Est','LI','UI'},'double');
Cal_data_temp = readtable(Filename,opts);
ind = strcmp(Cal_data_temp.ISO, ISO);
Data.(char(data_field)).time_pt = Cal_data_temp.Date(ind);
Data.(char(data_field)).estimate = Cal_data_temp.Est(ind);
Data.(char(data_field)).lower = Cal_data_temp.LI(ind);
Data.(char(data_field)).upper = Cal_data_temp.UI(ind);

%% HCV Prevalence prisoners
% % Overall
% data_field = 'PWID_HCV_AB_prevalence_pris';
% ind = PUHLSE_data.Variable=="HCV prevalence";
% Data.(char(data_field)).time_pt = PUHLSE_data.date(ind);
% Data.(char(data_field)).estimate = PUHLSE_data.Est(ind)*100;
% Data.(char(data_field)).lower = PUHLSE_data.LI(ind)*100;
% Data.(char(data_field)).upper = PUHLSE_data.UI(ind)*100;
% 
% % Young males
% data_field = 'PWID_HCV_AB_prevalence_pris_ym';
% ind = PUHLSE_data.Variable=="HCV prevalence, young male";
% Data.(char(data_field)).time_pt = PUHLSE_data.date(ind);
% Data.(char(data_field)).estimate = PUHLSE_data.Est(ind)*100;
% Data.(char(data_field)).lower = PUHLSE_data.LI(ind)*100;
% Data.(char(data_field)).upper = PUHLSE_data.UI(ind)*100;
% 
% % old males
% data_field = 'PWID_HCV_AB_prevalence_pris_om';
% ind = PUHLSE_data.Variable=="HCV prevalence, old male";
% Data.(char(data_field)).time_pt = PUHLSE_data.date(ind);
% Data.(char(data_field)).estimate = PUHLSE_data.Est(ind)*100;
% Data.(char(data_field)).lower = PUHLSE_data.LI(ind)*100;
% Data.(char(data_field)).upper = PUHLSE_data.UI(ind)*100;
% 
% % Young females
% data_field = 'PWID_HCV_AB_prevalence_pris_yf';
% ind = PUHLSE_data.Variable=="HCV prevalence, young female";
% Data.(char(data_field)).time_pt = PUHLSE_data.date(ind);
% Data.(char(data_field)).estimate = PUHLSE_data.Est(ind)*100;
% Data.(char(data_field)).lower = PUHLSE_data.LI(ind)*100;
% Data.(char(data_field)).upper = PUHLSE_data.UI(ind)*100;
% 
% % old females
% data_field = 'PWID_HCV_AB_prevalence_pris_of';
% ind = PUHLSE_data.Variable=="HCV prevalence, old female";
% Data.(char(data_field)).time_pt = PUHLSE_data.date(ind);
% Data.(char(data_field)).estimate = PUHLSE_data.Est(ind)*100;
% Data.(char(data_field)).lower = PUHLSE_data.LI(ind)*100;
% Data.(char(data_field)).upper = PUHLSE_data.UI(ind)*100;


% % Young males
% data_field = 'PWID_prop_current_OST_com_ym';
% ind = IBBS_data.Variable=="OST, young" & IBBS_data.Gender=="Male";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % Old males
% data_field = 'PWID_prop_current_OST_com_om';
% ind = IBBS_data.Variable=="OST, old" & IBBS_data.Gender=="Male";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % young females 
% data_field = 'PWID_prop_current_OST_com_yf';
% ind = IBBS_data.Variable=="OST, young" & IBBS_data.Gender=="Female";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % old females
% data_field = 'PWID_prop_current_OST_com_of';
% ind = IBBS_data.Variable=="OST, old" & IBBS_data.Gender=="Female";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % Ever incarcerated
% data_field = 'PWID_prop_current_OST_com_ever_inc';
% ind = IBBS_data.Variable=="OST, ever prison" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % Never incarcerated
% data_field = 'PWID_prop_current_OST_com_never_inc';
% ind = IBBS_data.Variable=="OST, never prison" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % Incarcerated last 12 months
% data_field = 'PWID_prop_current_OST_com_recent_inc';
% ind = IBBS_data.Variable=="OST, prison this year" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % Ever Incarcerated but not in last 12 months
% data_field = 'PWID_prop_current_OST_com_non_recent_inc';
% ind = IBBS_data.Variable=="OST, prison >this year" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % NGO Clients
% data_field = 'PWID_prop_current_OST_com_client';
% ind = IBBS_data.Variable=="OST, NGO" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % non-NGO Clients
% data_field = 'PWID_prop_current_OST_com_non_client';
% ind = IBBS_data.Variable=="OST, non-NGO" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% %% ever OST
% % Overall
% data_field = 'PWID_prop_ever_OST_com';
% ind = IBBS_data.Variable=="Ever OST" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % Young males
% data_field = 'PWID_prop_ever_OST_com_ym';
% ind = IBBS_data.Variable=="Ever OST, young" & IBBS_data.Gender=="Male";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % Old males
% data_field = 'PWID_prop_ever_OST_com_om';
% ind = IBBS_data.Variable=="Ever OST, old" & IBBS_data.Gender=="Male";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % young females 
% data_field = 'PWID_prop_ever_OST_com_yf';
% ind = IBBS_data.Variable=="Ever OST, young" & IBBS_data.Gender=="Female";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % old females
% data_field = 'PWID_prop_ever_OST_com_of';
% ind = IBBS_data.Variable=="Ever OST, old" & IBBS_data.Gender=="Female";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % Ever incarcerated
% data_field = 'PWID_prop_ever_OST_com_ever_inc';
% ind = IBBS_data.Variable=="Ever OST, ever prison" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % Never incarcerated
% data_field = 'PWID_prop_ever_OST_com_never_inc';
% ind = IBBS_data.Variable=="Ever OST, never prison" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % Incarcerated last 12 months
% data_field = 'PWID_prop_ever_OST_com_recent_inc';
% ind = IBBS_data.Variable=="Ever OST, prison this year" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % Ever Incarcerated but not in last 12 months
% data_field = 'PWID_prop_ever_OST_com_non_recent_inc';
% ind = IBBS_data.Variable=="Ever OST, prison >this year" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % NGO Clients
% data_field = 'PWID_prop_ever_OST_com_client';
% ind = IBBS_data.Variable=="Ever OST, NGO" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % non-NGO Clients
% data_field = 'PWID_prop_ever_OST_com_non_client';
% ind = IBBS_data.Variable=="Ever OST, non-NGO" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % Prisoners
% data_field = 'PWID_prop_ever_OST_pris';
% ind = PUHLSE_data.Variable=="Ever OST";
% Data.(char(data_field)).time_pt = PUHLSE_data.date(ind);
% Data.(char(data_field)).estimate = PUHLSE_data.Est(ind)*100;
% Data.(char(data_field)).lower = PUHLSE_data.LI(ind)*100;
% Data.(char(data_field)).upper = PUHLSE_data.UI(ind)*100;

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
%% current ART
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

% % Young males
% data_field = 'PWID_prop_current_ART_com_ym';
% ind = IBBS_data.Variable=="ART, young" & IBBS_data.Gender=="Male";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % Old males
% data_field = 'PWID_prop_current_ART_com_om';
% ind = IBBS_data.Variable=="ART, old" & IBBS_data.Gender=="Male";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % young females 
% data_field = 'PWID_prop_current_ART_com_yf';
% ind = IBBS_data.Variable=="ART, young" & IBBS_data.Gender=="Female";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % old females
% data_field = 'PWID_prop_current_ART_com_of';
% ind = IBBS_data.Variable=="ART, old" & IBBS_data.Gender=="Female";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % Ever incarcerated
% data_field = 'PWID_prop_current_ART_com_ever_inc';
% ind = IBBS_data.Variable=="ART, ever prison" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % Never incarcerated
% data_field = 'PWID_prop_current_ART_com_never_inc';
% ind = IBBS_data.Variable=="ART, never prison" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % Incarcerated last 12 months
% data_field = 'PWID_prop_current_ART_com_recent_inc';
% ind = IBBS_data.Variable=="ART, prison this year" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % Ever Incarcerated but not in last 12 months
% data_field = 'PWID_prop_current_ART_com_non_recent_inc';
% ind = IBBS_data.Variable=="ART, prison >this year" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % NGO Clients
% data_field = 'PWID_prop_current_ART_com_client';
% ind = IBBS_data.Variable=="ART, NGO" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % non-NGO Clients
% data_field = 'PWID_prop_current_ART_com_non_client';
% ind = IBBS_data.Variable=="ART, non-NGO" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).n = IBBS_data.n(ind);
% Data.(char(data_field)).N = IBBS_data.N(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind)*100;
% Data.(char(data_field)).lower = IBBS_data.LI(ind)*100;
% Data.(char(data_field)).upper = IBBS_data.UI(ind)*100;
% 
% % Prisoners
% data_field = 'PWID_prop_current_ART_pris';
% ind = PUHLSE_data.Variable=="ART";
% Data.(char(data_field)).time_pt = PUHLSE_data.date(ind);
% Data.(char(data_field)).estimate = PUHLSE_data.Est(ind)*100;
% Data.(char(data_field)).lower = PUHLSE_data.LI(ind)*100;
% Data.(char(data_field)).upper = PUHLSE_data.UI(ind)*100;


% %% ORs
% data_field = 'OR_NGO_young';
% Data.(char(data_field)).time_pt = 2015;
% Data.(char(data_field)).estimate = .4503109;
% Data.(char(data_field)).lower = .4187494;
% Data.(char(data_field)).upper = .4842513;
% 
% data_field = 'OR_NGO_HIV';
% Data.(char(data_field)).time_pt = 2015;
% Data.(char(data_field)).estimate = 2.113082;
% Data.(char(data_field)).lower = 2.005221;
% Data.(char(data_field)).upper = 2.226744;
% 
% data_field = 'OR_OST_NGO';
% Data.(char(data_field)).time_pt = 2016;
% Data.(char(data_field)).estimate = 7.997656;
% Data.(char(data_field)).lower = 6.753881;
% Data.(char(data_field)).upper = 9.470481;
% 
% data_field = 'OR_ART_NGO';
% Data.(char(data_field)).time_pt = 2016;
% Data.(char(data_field)).estimate =  3.0361;
% Data.(char(data_field)).lower = 2.72011;
% Data.(char(data_field)).upper = 3.388798;
% 
% data_field = 'OR_ART_old';
% Data.(char(data_field)).time_pt = 2016;
% Data.(char(data_field)).estimate =  3.088884;
% Data.(char(data_field)).lower = 1.946101;
% Data.(char(data_field)).upper = 4.902728; 
% 
% data_field = 'OR_HIV_female';
% ind = IBBS_data.Variable=="HIV, female OR" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind);
% Data.(char(data_field)).lower = IBBS_data.LI(ind);
% Data.(char(data_field)).upper = IBBS_data.UI(ind);
% 
% data_field = 'OR_HIV_young';
% ind = IBBS_data.Variable=="HIV, young OR" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind);
% Data.(char(data_field)).lower = IBBS_data.LI(ind);
% Data.(char(data_field)).upper = IBBS_data.UI(ind);
% 
% data_field = 'OR_HIV_ever_inc';
% ind = IBBS_data.Variable=="HIV, ever prison OR" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind);
% Data.(char(data_field)).lower = IBBS_data.LI(ind);
% Data.(char(data_field)).upper = IBBS_data.UI(ind);
% 
% data_field = 'OR_HCV_female';
% ind = IBBS_data.Variable=="HCV, female OR" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind);
% Data.(char(data_field)).lower = IBBS_data.LI(ind);
% Data.(char(data_field)).upper = IBBS_data.UI(ind);
% 
% data_field = 'OR_HCV_young';
% ind = IBBS_data.Variable=="HCV, young OR" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind);
% Data.(char(data_field)).lower = IBBS_data.LI(ind);
% Data.(char(data_field)).upper = IBBS_data.UI(ind);
% 
% data_field = 'OR_HCV_ever_inc';
% ind = IBBS_data.Variable=="HCV, ever prison OR" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind);
% Data.(char(data_field)).lower = IBBS_data.LI(ind);
% Data.(char(data_field)).upper = IBBS_data.UI(ind);
% 
% data_field = 'OR_HCV_HIV';
% ind = IBBS_data.Variable=="HCV, HIV OR" & IBBS_data.Gender=="Both";
% Data.(char(data_field)).time_pt = IBBS_data.date(ind);
% Data.(char(data_field)).estimate = IBBS_data.Est(ind);
% Data.(char(data_field)).lower = IBBS_data.LI(ind);
% Data.(char(data_field)).upper = IBBS_data.UI(ind);




data_field = 'PWID_prop_current_NSP_com';
Filename = ['Data_Files/Calibration_Data/',data_field,'_data.csv'];
opts = detectImportOptions(Filename);
opts = setvartype(opts,{'Est','LI','UI'},'double');
Cal_data_temp = readtable(Filename,opts);
ind = strcmp(Cal_data_temp.ISO, ISO);
Data.(char(data_field)).time_pt = Cal_data_temp.Date(ind);
Data.(char(data_field)).estimate = Cal_data_temp.Est(ind)*1;
Data.(char(data_field)).lower = Cal_data_temp.LI(ind)*1;
Data.(char(data_field)).upper = Cal_data_temp.UI(ind)*1;



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