%%% run this code to calculate % reduction in HIV incidence from 2022 to
%%% 2030 under OST scale-up and ART scale-up scenarios (each scenario
%%% scales OST or ART to 50% coverage by 2030)

% dir='/Users/antoinechaillon/Dropbox/intrepid/matlab/Global2_R19_HIVonly/Outputs/';
% dir='/Users/antoinechaillon/Dropbox/intrepid/matlab/_github/INTREPID/INTREPID_R22_TIMESTEP/Results/05-06-2022/UA/RUNS3/'
% N=1000;
function [] = ABC_Get_ART_coverage_CI(ISO,N,dir,numrun)


%% scenario-specific outputs folder
outputfolder = ['Outputs/',ISO,'/RUNS',num2str(numrun)];
if not(isfolder(outputfolder))
    mkdir(outputfolder)
end



filename = 'Data_Files/Parameter_Data/seed_dates.csv';
dataTable = readtable(filename);
data = dataTable(strcmp(dataTable.ISO,ISO),:);
seed_date = data.Date;

% dir = 'Results';
time_step = 0.1;
ind2022 = (2022-seed_date)/time_step+1;
ind2023 = (2023-seed_date)/time_step+1;
ind2024 = (2024-seed_date)/time_step+1;
ind2025 = (2025-seed_date)/time_step+1;
ind2026 = (2026-seed_date)/time_step+1;
ind2027 = (2027-seed_date)/time_step+1;
ind2028 = (2028-seed_date)/time_step+1;
ind2029 = (2029-seed_date)/time_step+1;
ind2030 = (2030-seed_date)/time_step+1;





% load([dir,'/Status_quo.mat']);
% % HIV Incidence (all PWID)
% tmp = Status_quo.HIV_Incidence_PWID;
% tmp2 = Status_quo.PWID_HIV_prevalence;
% tmp3 = Status_quo.PWID_pop_size;
% 
% newinfections_SQ_auc= trapz(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
% newinfections_SQ_auc_final=mean(newinfections_SQ_auc,1);
% %   4.0986e+06
% 
% newinfections_SQ_cumsum=cumsum(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
% newinfections_SQ_cumsum_final=mean(newinfections_SQ_cumsum(:,size(newinfections_SQ_cumsum,2)),1);
% %   4.1500e+06
% 
% 


%% ARTOST
load([dir,'/ARTOST_50_2030.mat']);


% ARTOST coverage (all PWID)
tmp = ARTOST_50_2030.PWID_prop_current_OST_all;
ARTOST_OST_2022 = mean(tmp(:,ind2022),1);
ARTOST_OST_2022_CI=prctile(tmp(:,ind2022),[2.5  97.5]);
ARTOST_OST_2023 = mean(tmp(:,ind2023),1);
ARTOST_OST_2023_CI=prctile(tmp(:,ind2023),[2.5  97.5]);
ARTOST_OST_2024 = mean(tmp(:,ind2024),1);
ARTOST_OST_2024_CI=prctile(tmp(:,ind2024),[2.5  97.5]);
ARTOST_OST_2025 = mean(tmp(:,ind2025),1);
ARTOST_OST_2025_CI=prctile(tmp(:,ind2025),[2.5  97.5]);
ARTOST_OST_2026 = mean(tmp(:,ind2026),1);
ARTOST_OST_2026_CI=prctile(tmp(:,ind2026),[2.5  97.5]);
ARTOST_OST_2027 = mean(tmp(:,ind2027),1);
ARTOST_OST_2027_CI=prctile(tmp(:,ind2027),[2.5  97.5]);
ARTOST_OST_2028 = mean(tmp(:,ind2028),1);
ARTOST_OST_2028_CI=prctile(tmp(:,ind2028),[2.5  97.5]);
ARTOST_OST_2029 = mean(tmp(:,ind2029),1);
ARTOST_OST_2029_CI=prctile(tmp(:,ind2029),[2.5  97.5]);
ARTOST_OST_2030 = mean(tmp(:,ind2030),1);
ARTOST_OST_2030_CI=prctile(tmp(:,ind2030),[2.5  97.5]);

tmp2 = ARTOST_50_2030.PWID_prop_current_ART_all;
ARTOST_ART_2022 = mean(tmp2(:,ind2022),1);
ARTOST_ART_2022_CI=prctile(tmp2(:,ind2022),[2.5  97.5]);
ARTOST_ART_2023 = mean(tmp2(:,ind2023),1);
ARTOST_ART_2023_CI=prctile(tmp2(:,ind2023),[2.5  97.5]);
ARTOST_ART_2024 = mean(tmp2(:,ind2024),1);
ARTOST_ART_2024_CI=prctile(tmp2(:,ind2024),[2.5  97.5]);
ARTOST_ART_2025 = mean(tmp2(:,ind2025),1);
ARTOST_ART_2025_CI=prctile(tmp2(:,ind2025),[2.5  97.5]);
ARTOST_ART_2026 = mean(tmp2(:,ind2026),1);
ARTOST_ART_2026_CI=prctile(tmp2(:,ind2026),[2.5  97.5]);
ARTOST_ART_2027 = mean(tmp2(:,ind2027),1);
ARTOST_ART_2027_CI=prctile(tmp2(:,ind2027),[2.5  97.5]);
ARTOST_ART_2028 = mean(tmp2(:,ind2028),1);
ARTOST_ART_2028_CI=prctile(tmp2(:,ind2028),[2.5  97.5]);
ARTOST_ART_2029 = mean(tmp2(:,ind2029),1);
ARTOST_ART_2029_CI=prctile(tmp2(:,ind2029),[2.5  97.5]);
ARTOST_ART_2030 = mean(tmp2(:,ind2030),1);
ARTOST_ART_2030_CI=prctile(tmp2(:,ind2030),[2.5  97.5]);



clear tmp
clear tmp2
%%%%%% ARTOST TABLE

ARTOST_ART_2022_withCI=join(horzcat(round(ARTOST_ART_2022,3)," [95%CI:", round(ARTOST_ART_2022_CI(1),3),"-",round(ARTOST_ART_2022_CI(2),3),"]"));
ARTOST_ART_2023_withCI=join(horzcat(round(ARTOST_ART_2023,3)," [95%CI:", round(ARTOST_ART_2023_CI(1),3),"-",round(ARTOST_ART_2023_CI(2),3),"]"));
ARTOST_ART_2024_withCI=join(horzcat(round(ARTOST_ART_2024,3)," [95%CI:", round(ARTOST_ART_2024_CI(1),3),"-",round(ARTOST_ART_2024_CI(2),3),"]"));
ARTOST_ART_2025_withCI=join(horzcat(round(ARTOST_ART_2025,3)," [95%CI:", round(ARTOST_ART_2025_CI(1),3),"-",round(ARTOST_ART_2025_CI(2),3),"]"));
ARTOST_ART_2026_withCI=join(horzcat(round(ARTOST_ART_2026,3)," [95%CI:", round(ARTOST_ART_2026_CI(1),3),"-",round(ARTOST_ART_2026_CI(2),3),"]"));
ARTOST_ART_2027_withCI=join(horzcat(round(ARTOST_ART_2027,3)," [95%CI:", round(ARTOST_ART_2027_CI(1),3),"-",round(ARTOST_ART_2027_CI(2),3),"]"));
ARTOST_ART_2028_withCI=join(horzcat(round(ARTOST_ART_2028,3)," [95%CI:", round(ARTOST_ART_2028_CI(1),3),"-",round(ARTOST_ART_2028_CI(2),3),"]"));
ARTOST_ART_2029_withCI=join(horzcat(round(ARTOST_ART_2029,3)," [95%CI:", round(ARTOST_ART_2029_CI(1),3),"-",round(ARTOST_ART_2029_CI(2),3),"]"));
ARTOST_ART_2030_withCI=join(horzcat(round(ARTOST_ART_2030,3)," [95%CI:", round(ARTOST_ART_2030_CI(1),3),"-",round(ARTOST_ART_2030_CI(2),3),"]"));

ARTOST_OST_2022_withCI=join(horzcat(round(ARTOST_OST_2022,3)," [95%CI:", round(ARTOST_OST_2022_CI(1),3),"-",round(ARTOST_OST_2022_CI(2),3),"]"));
ARTOST_OST_2023_withCI=join(horzcat(round(ARTOST_OST_2023,3)," [95%CI:", round(ARTOST_OST_2023_CI(1),3),"-",round(ARTOST_OST_2023_CI(2),3),"]"));
ARTOST_OST_2024_withCI=join(horzcat(round(ARTOST_OST_2024,3)," [95%CI:", round(ARTOST_OST_2024_CI(1),3),"-",round(ARTOST_OST_2024_CI(2),3),"]"));
ARTOST_OST_2025_withCI=join(horzcat(round(ARTOST_OST_2025,3)," [95%CI:", round(ARTOST_OST_2025_CI(1),3),"-",round(ARTOST_OST_2025_CI(2),3),"]"));
ARTOST_OST_2026_withCI=join(horzcat(round(ARTOST_OST_2026,3)," [95%CI:", round(ARTOST_OST_2026_CI(1),3),"-",round(ARTOST_OST_2026_CI(2),3),"]"));
ARTOST_OST_2027_withCI=join(horzcat(round(ARTOST_OST_2027,3)," [95%CI:", round(ARTOST_OST_2027_CI(1),3),"-",round(ARTOST_OST_2027_CI(2),3),"]"));
ARTOST_OST_2028_withCI=join(horzcat(round(ARTOST_OST_2028,3)," [95%CI:", round(ARTOST_OST_2028_CI(1),3),"-",round(ARTOST_OST_2028_CI(2),3),"]"));
ARTOST_OST_2029_withCI=join(horzcat(round(ARTOST_OST_2029,3)," [95%CI:", round(ARTOST_OST_2029_CI(1),3),"-",round(ARTOST_OST_2029_CI(2),3),"]"));
ARTOST_OST_2030_withCI=join(horzcat(round(ARTOST_OST_2030,3)," [95%CI:", round(ARTOST_OST_2030_CI(1),3),"-",round(ARTOST_OST_2030_CI(2),3),"]"));


Variables_names7={'2022' ;'2023';'2024';'2025';'2026';'2027';'2028';'2029';'2030'};
ARTOST_ART_coverage_withCI=[ARTOST_ART_2022_withCI; ARTOST_ART_2023_withCI; ARTOST_ART_2024_withCI; ARTOST_ART_2025_withCI; ARTOST_ART_2026_withCI; ARTOST_ART_2027_withCI; ARTOST_ART_2028_withCI; ARTOST_ART_2029_withCI; ARTOST_ART_2030_withCI];
ARTOST_OST_coverage_withCI=[ARTOST_OST_2022_withCI; ARTOST_OST_2023_withCI; ARTOST_OST_2024_withCI; ARTOST_OST_2025_withCI; ARTOST_OST_2026_withCI; ARTOST_OST_2027_withCI; ARTOST_OST_2028_withCI; ARTOST_OST_2029_withCI; ARTOST_OST_2030_withCI];

ARTOSTT7 = table(Variables_names7,ARTOST_ART_coverage_withCI,ARTOST_OST_coverage_withCI);
ARTOSTFilename7 = [outputfolder,'/2.ARTOST.summarytable.ARTandOSTcoverage2time_', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(ARTOSTT7,ARTOSTFilename7)

%% ART
load([dir,'/ART_50_2030.mat']);


% ART coverage (all PWID)
tmp = ART_50_2030.PWID_prop_current_OST_all;
ART_OST_2022 = mean(tmp(:,ind2022),1);
ART_OST_2022_CI=prctile(tmp(:,ind2022),[2.5  97.5]);
ART_OST_2023 = mean(tmp(:,ind2023),1);
ART_OST_2023_CI=prctile(tmp(:,ind2023),[2.5  97.5]);
ART_OST_2024 = mean(tmp(:,ind2024),1);
ART_OST_2024_CI=prctile(tmp(:,ind2024),[2.5  97.5]);
ART_OST_2025 = mean(tmp(:,ind2025),1);
ART_OST_2025_CI=prctile(tmp(:,ind2025),[2.5  97.5]);
ART_OST_2026 = mean(tmp(:,ind2026),1);
ART_OST_2026_CI=prctile(tmp(:,ind2026),[2.5  97.5]);
ART_OST_2027 = mean(tmp(:,ind2027),1);
ART_OST_2027_CI=prctile(tmp(:,ind2027),[2.5  97.5]);
ART_OST_2028 = mean(tmp(:,ind2028),1);
ART_OST_2028_CI=prctile(tmp(:,ind2028),[2.5  97.5]);
ART_OST_2029 = mean(tmp(:,ind2029),1);
ART_OST_2029_CI=prctile(tmp(:,ind2029),[2.5  97.5]);
ART_OST_2030 = mean(tmp(:,ind2030),1);
ART_OST_2030_CI=prctile(tmp(:,ind2030),[2.5  97.5]);

tmp2 = ART_50_2030.PWID_prop_current_ART_all;
ART_ART_2022 = mean(tmp2(:,ind2022),1);
ART_ART_2022_CI=prctile(tmp2(:,ind2022),[2.5  97.5]);
ART_ART_2023 = mean(tmp2(:,ind2023),1);
ART_ART_2023_CI=prctile(tmp2(:,ind2023),[2.5  97.5]);
ART_ART_2024 = mean(tmp2(:,ind2024),1);
ART_ART_2024_CI=prctile(tmp2(:,ind2024),[2.5  97.5]);
ART_ART_2025 = mean(tmp2(:,ind2025),1);
ART_ART_2025_CI=prctile(tmp2(:,ind2025),[2.5  97.5]);
ART_ART_2026 = mean(tmp2(:,ind2026),1);
ART_ART_2026_CI=prctile(tmp2(:,ind2026),[2.5  97.5]);
ART_ART_2027 = mean(tmp2(:,ind2027),1);
ART_ART_2027_CI=prctile(tmp2(:,ind2027),[2.5  97.5]);
ART_ART_2028 = mean(tmp2(:,ind2028),1);
ART_ART_2028_CI=prctile(tmp2(:,ind2028),[2.5  97.5]);
ART_ART_2029 = mean(tmp2(:,ind2029),1);
ART_ART_2029_CI=prctile(tmp2(:,ind2029),[2.5  97.5]);
ART_ART_2030 = mean(tmp2(:,ind2030),1);
ART_ART_2030_CI=prctile(tmp2(:,ind2030),[2.5  97.5]);



clear tmp
clear tmp2
%%%%%% ART TABLE

ART_ART_2022_withCI=join(horzcat(round(ART_ART_2022,3)," [95%CI:", round(ART_ART_2022_CI(1),3),"-",round(ART_ART_2022_CI(2),3),"]"));
ART_ART_2023_withCI=join(horzcat(round(ART_ART_2023,3)," [95%CI:", round(ART_ART_2023_CI(1),3),"-",round(ART_ART_2023_CI(2),3),"]"));
ART_ART_2024_withCI=join(horzcat(round(ART_ART_2024,3)," [95%CI:", round(ART_ART_2024_CI(1),3),"-",round(ART_ART_2024_CI(2),3),"]"));
ART_ART_2025_withCI=join(horzcat(round(ART_ART_2025,3)," [95%CI:", round(ART_ART_2025_CI(1),3),"-",round(ART_ART_2025_CI(2),3),"]"));
ART_ART_2026_withCI=join(horzcat(round(ART_ART_2026,3)," [95%CI:", round(ART_ART_2026_CI(1),3),"-",round(ART_ART_2026_CI(2),3),"]"));
ART_ART_2027_withCI=join(horzcat(round(ART_ART_2027,3)," [95%CI:", round(ART_ART_2027_CI(1),3),"-",round(ART_ART_2027_CI(2),3),"]"));
ART_ART_2028_withCI=join(horzcat(round(ART_ART_2028,3)," [95%CI:", round(ART_ART_2028_CI(1),3),"-",round(ART_ART_2028_CI(2),3),"]"));
ART_ART_2029_withCI=join(horzcat(round(ART_ART_2029,3)," [95%CI:", round(ART_ART_2029_CI(1),3),"-",round(ART_ART_2029_CI(2),3),"]"));
ART_ART_2030_withCI=join(horzcat(round(ART_ART_2030,3)," [95%CI:", round(ART_ART_2030_CI(1),3),"-",round(ART_ART_2030_CI(2),3),"]"));

ART_OST_2022_withCI=join(horzcat(round(ART_OST_2022,3)," [95%CI:", round(ART_OST_2022_CI(1),3),"-",round(ART_OST_2022_CI(2),3),"]"));
ART_OST_2023_withCI=join(horzcat(round(ART_OST_2023,3)," [95%CI:", round(ART_OST_2023_CI(1),3),"-",round(ART_OST_2023_CI(2),3),"]"));
ART_OST_2024_withCI=join(horzcat(round(ART_OST_2024,3)," [95%CI:", round(ART_OST_2024_CI(1),3),"-",round(ART_OST_2024_CI(2),3),"]"));
ART_OST_2025_withCI=join(horzcat(round(ART_OST_2025,3)," [95%CI:", round(ART_OST_2025_CI(1),3),"-",round(ART_OST_2025_CI(2),3),"]"));
ART_OST_2026_withCI=join(horzcat(round(ART_OST_2026,3)," [95%CI:", round(ART_OST_2026_CI(1),3),"-",round(ART_OST_2026_CI(2),3),"]"));
ART_OST_2027_withCI=join(horzcat(round(ART_OST_2027,3)," [95%CI:", round(ART_OST_2027_CI(1),3),"-",round(ART_OST_2027_CI(2),3),"]"));
ART_OST_2028_withCI=join(horzcat(round(ART_OST_2028,3)," [95%CI:", round(ART_OST_2028_CI(1),3),"-",round(ART_OST_2028_CI(2),3),"]"));
ART_OST_2029_withCI=join(horzcat(round(ART_OST_2029,3)," [95%CI:", round(ART_OST_2029_CI(1),3),"-",round(ART_OST_2029_CI(2),3),"]"));
ART_OST_2030_withCI=join(horzcat(round(ART_OST_2030,3)," [95%CI:", round(ART_OST_2030_CI(1),3),"-",round(ART_OST_2030_CI(2),3),"]"));


Variables_names7={'2022' ;'2023';'2024';'2025';'2026';'2027';'2028';'2029';'2030'};
ART_ART_coverage_withCI=[ART_ART_2022_withCI; ART_ART_2023_withCI; ART_ART_2024_withCI; ART_ART_2025_withCI; ART_ART_2026_withCI; ART_ART_2027_withCI; ART_ART_2028_withCI; ART_ART_2029_withCI; ART_ART_2030_withCI];
ART_OST_coverage_withCI=[ART_OST_2022_withCI; ART_OST_2023_withCI; ART_OST_2024_withCI; ART_OST_2025_withCI; ART_OST_2026_withCI; ART_OST_2027_withCI; ART_OST_2028_withCI; ART_OST_2029_withCI; ART_OST_2030_withCI];

ARTT7 = table(Variables_names7,ART_ART_coverage_withCI,ART_OST_coverage_withCI);
ARTFilename7 = [outputfolder,'/2.ART.summarytable.ARTandOSTcoverage2time_', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(ARTT7,ARTFilename7)



%% OST
load([dir,'/OST_50_2030.mat']);


% OST coverage (all PWID)
tmp = OST_50_2030.PWID_prop_current_OST_all;
OST_OST_2022 = mean(tmp(:,ind2022),1);
OST_OST_2022_CI=prctile(tmp(:,ind2022),[2.5  97.5]);
OST_OST_2023 = mean(tmp(:,ind2023),1);
OST_OST_2023_CI=prctile(tmp(:,ind2023),[2.5  97.5]);
OST_OST_2024 = mean(tmp(:,ind2024),1);
OST_OST_2024_CI=prctile(tmp(:,ind2024),[2.5  97.5]);
OST_OST_2025 = mean(tmp(:,ind2025),1);
OST_OST_2025_CI=prctile(tmp(:,ind2025),[2.5  97.5]);
OST_OST_2026 = mean(tmp(:,ind2026),1);
OST_OST_2026_CI=prctile(tmp(:,ind2026),[2.5  97.5]);
OST_OST_2027 = mean(tmp(:,ind2027),1);
OST_OST_2027_CI=prctile(tmp(:,ind2027),[2.5  97.5]);
OST_OST_2028 = mean(tmp(:,ind2028),1);
OST_OST_2028_CI=prctile(tmp(:,ind2028),[2.5  97.5]);
OST_OST_2029 = mean(tmp(:,ind2029),1);
OST_OST_2029_CI=prctile(tmp(:,ind2029),[2.5  97.5]);
OST_OST_2030 = mean(tmp(:,ind2030),1);
OST_OST_2030_CI=prctile(tmp(:,ind2030),[2.5  97.5]);

tmp2 = OST_50_2030.PWID_prop_current_ART_all;
OST_ART_2022 = mean(tmp2(:,ind2022),1);
OST_ART_2022_CI=prctile(tmp2(:,ind2022),[2.5  97.5]);
OST_ART_2023 = mean(tmp2(:,ind2023),1);
OST_ART_2023_CI=prctile(tmp2(:,ind2023),[2.5  97.5]);
OST_ART_2024 = mean(tmp2(:,ind2024),1);
OST_ART_2024_CI=prctile(tmp2(:,ind2024),[2.5  97.5]);
OST_ART_2025 = mean(tmp2(:,ind2025),1);
OST_ART_2025_CI=prctile(tmp2(:,ind2025),[2.5  97.5]);
OST_ART_2026 = mean(tmp2(:,ind2026),1);
OST_ART_2026_CI=prctile(tmp2(:,ind2026),[2.5  97.5]);
OST_ART_2027 = mean(tmp2(:,ind2027),1);
OST_ART_2027_CI=prctile(tmp2(:,ind2027),[2.5  97.5]);
OST_ART_2028 = mean(tmp2(:,ind2028),1);
OST_ART_2028_CI=prctile(tmp2(:,ind2028),[2.5  97.5]);
OST_ART_2029 = mean(tmp2(:,ind2029),1);
OST_ART_2029_CI=prctile(tmp2(:,ind2029),[2.5  97.5]);
OST_ART_2030 = mean(tmp2(:,ind2030),1);
OST_ART_2030_CI=prctile(tmp2(:,ind2030),[2.5  97.5]);



clear tmp
clear tmp2
%%%%%% OST TABLE

OST_ART_2022_withCI=join(horzcat(round(OST_ART_2022,3)," [95%CI:", round(OST_ART_2022_CI(1),3),"-",round(OST_ART_2022_CI(2),3),"]"));
OST_ART_2023_withCI=join(horzcat(round(OST_ART_2023,3)," [95%CI:", round(OST_ART_2023_CI(1),3),"-",round(OST_ART_2023_CI(2),3),"]"));
OST_ART_2024_withCI=join(horzcat(round(OST_ART_2024,3)," [95%CI:", round(OST_ART_2024_CI(1),3),"-",round(OST_ART_2024_CI(2),3),"]"));
OST_ART_2025_withCI=join(horzcat(round(OST_ART_2025,3)," [95%CI:", round(OST_ART_2025_CI(1),3),"-",round(OST_ART_2025_CI(2),3),"]"));
OST_ART_2026_withCI=join(horzcat(round(OST_ART_2026,3)," [95%CI:", round(OST_ART_2026_CI(1),3),"-",round(OST_ART_2026_CI(2),3),"]"));
OST_ART_2027_withCI=join(horzcat(round(OST_ART_2027,3)," [95%CI:", round(OST_ART_2027_CI(1),3),"-",round(OST_ART_2027_CI(2),3),"]"));
OST_ART_2028_withCI=join(horzcat(round(OST_ART_2028,3)," [95%CI:", round(OST_ART_2028_CI(1),3),"-",round(OST_ART_2028_CI(2),3),"]"));
OST_ART_2029_withCI=join(horzcat(round(OST_ART_2029,3)," [95%CI:", round(OST_ART_2029_CI(1),3),"-",round(OST_ART_2029_CI(2),3),"]"));
OST_ART_2030_withCI=join(horzcat(round(OST_ART_2030,3)," [95%CI:", round(OST_ART_2030_CI(1),3),"-",round(OST_ART_2030_CI(2),3),"]"));

OST_OST_2022_withCI=join(horzcat(round(OST_OST_2022,3)," [95%CI:", round(OST_OST_2022_CI(1),3),"-",round(OST_OST_2022_CI(2),3),"]"));
OST_OST_2023_withCI=join(horzcat(round(OST_OST_2023,3)," [95%CI:", round(OST_OST_2023_CI(1),3),"-",round(OST_OST_2023_CI(2),3),"]"));
OST_OST_2024_withCI=join(horzcat(round(OST_OST_2024,3)," [95%CI:", round(OST_OST_2024_CI(1),3),"-",round(OST_OST_2024_CI(2),3),"]"));
OST_OST_2025_withCI=join(horzcat(round(OST_OST_2025,3)," [95%CI:", round(OST_OST_2025_CI(1),3),"-",round(OST_OST_2025_CI(2),3),"]"));
OST_OST_2026_withCI=join(horzcat(round(OST_OST_2026,3)," [95%CI:", round(OST_OST_2026_CI(1),3),"-",round(OST_OST_2026_CI(2),3),"]"));
OST_OST_2027_withCI=join(horzcat(round(OST_OST_2027,3)," [95%CI:", round(OST_OST_2027_CI(1),3),"-",round(OST_OST_2027_CI(2),3),"]"));
OST_OST_2028_withCI=join(horzcat(round(OST_OST_2028,3)," [95%CI:", round(OST_OST_2028_CI(1),3),"-",round(OST_OST_2028_CI(2),3),"]"));
OST_OST_2029_withCI=join(horzcat(round(OST_OST_2029,3)," [95%CI:", round(OST_OST_2029_CI(1),3),"-",round(OST_OST_2029_CI(2),3),"]"));
OST_OST_2030_withCI=join(horzcat(round(OST_OST_2030,3)," [95%CI:", round(OST_OST_2030_CI(1),3),"-",round(OST_OST_2030_CI(2),3),"]"));


Variables_names7={'2022' ;'2023';'2024';'2025';'2026';'2027';'2028';'2029';'2030'};
OST_ART_coverage_withCI=[OST_ART_2022_withCI; OST_ART_2023_withCI; OST_ART_2024_withCI; OST_ART_2025_withCI; OST_ART_2026_withCI; OST_ART_2027_withCI; OST_ART_2028_withCI; OST_ART_2029_withCI; OST_ART_2030_withCI];
OST_OST_coverage_withCI=[OST_OST_2022_withCI; OST_OST_2023_withCI; OST_OST_2024_withCI; OST_OST_2025_withCI; OST_OST_2026_withCI; OST_OST_2027_withCI; OST_OST_2028_withCI; OST_OST_2029_withCI; OST_OST_2030_withCI];

OSTT7 = table(Variables_names7,OST_ART_coverage_withCI,OST_OST_coverage_withCI);
OSTFilename7 = [outputfolder,'/2.OST.summarytable.ARTandOSTcoverage2time_', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(OSTT7,OSTFilename7)

%% NSPART
load([dir,'/NSPART_50_2030.mat']);


% OST coverage (all PWID)
tmp = NSPART_50_2030.PWID_prop_current_OST_all;
NSPART_OST_2022 = mean(tmp(:,ind2022),1);
NSPART_OST_2022_CI=prctile(tmp(:,ind2022),[2.5  97.5]);
NSPART_OST_2023 = mean(tmp(:,ind2023),1);
NSPART_OST_2023_CI=prctile(tmp(:,ind2023),[2.5  97.5]);
NSPART_OST_2024 = mean(tmp(:,ind2024),1);
NSPART_OST_2024_CI=prctile(tmp(:,ind2024),[2.5  97.5]);
NSPART_OST_2025 = mean(tmp(:,ind2025),1);
NSPART_OST_2025_CI=prctile(tmp(:,ind2025),[2.5  97.5]);
NSPART_OST_2026 = mean(tmp(:,ind2026),1);
NSPART_OST_2026_CI=prctile(tmp(:,ind2026),[2.5  97.5]);
NSPART_OST_2027 = mean(tmp(:,ind2027),1);
NSPART_OST_2027_CI=prctile(tmp(:,ind2027),[2.5  97.5]);
NSPART_OST_2028 = mean(tmp(:,ind2028),1);
NSPART_OST_2028_CI=prctile(tmp(:,ind2028),[2.5  97.5]);
NSPART_OST_2029 = mean(tmp(:,ind2029),1);
NSPART_OST_2029_CI=prctile(tmp(:,ind2029),[2.5  97.5]);
NSPART_OST_2030 = mean(tmp(:,ind2030),1);
NSPART_OST_2030_CI=prctile(tmp(:,ind2030),[2.5  97.5]);

tmp2 = NSPART_50_2030.PWID_prop_current_ART_all;
NSPART_ART_2022 = mean(tmp2(:,ind2022),1);
NSPART_ART_2022_CI=prctile(tmp2(:,ind2022),[2.5  97.5]);
NSPART_ART_2023 = mean(tmp2(:,ind2023),1);
NSPART_ART_2023_CI=prctile(tmp2(:,ind2023),[2.5  97.5]);
NSPART_ART_2024 = mean(tmp2(:,ind2024),1);
NSPART_ART_2024_CI=prctile(tmp2(:,ind2024),[2.5  97.5]);
NSPART_ART_2025 = mean(tmp2(:,ind2025),1);
NSPART_ART_2025_CI=prctile(tmp2(:,ind2025),[2.5  97.5]);
NSPART_ART_2026 = mean(tmp2(:,ind2026),1);
NSPART_ART_2026_CI=prctile(tmp2(:,ind2026),[2.5  97.5]);
NSPART_ART_2027 = mean(tmp2(:,ind2027),1);
NSPART_ART_2027_CI=prctile(tmp2(:,ind2027),[2.5  97.5]);
NSPART_ART_2028 = mean(tmp2(:,ind2028),1);
NSPART_ART_2028_CI=prctile(tmp2(:,ind2028),[2.5  97.5]);
NSPART_ART_2029 = mean(tmp2(:,ind2029),1);
NSPART_ART_2029_CI=prctile(tmp2(:,ind2029),[2.5  97.5]);
NSPART_ART_2030 = mean(tmp2(:,ind2030),1);
NSPART_ART_2030_CI=prctile(tmp2(:,ind2030),[2.5  97.5]);



clear tmp
clear tmp2
%%%%%% NSPART TABLE

NSPART_ART_2022_withCI=join(horzcat(round(NSPART_ART_2022,3)," [95%CI:", round(NSPART_ART_2022_CI(1),3),"-",round(NSPART_ART_2022_CI(2),3),"]"));
NSPART_ART_2023_withCI=join(horzcat(round(NSPART_ART_2023,3)," [95%CI:", round(NSPART_ART_2023_CI(1),3),"-",round(NSPART_ART_2023_CI(2),3),"]"));
NSPART_ART_2024_withCI=join(horzcat(round(NSPART_ART_2024,3)," [95%CI:", round(NSPART_ART_2024_CI(1),3),"-",round(NSPART_ART_2024_CI(2),3),"]"));
NSPART_ART_2025_withCI=join(horzcat(round(NSPART_ART_2025,3)," [95%CI:", round(NSPART_ART_2025_CI(1),3),"-",round(NSPART_ART_2025_CI(2),3),"]"));
NSPART_ART_2026_withCI=join(horzcat(round(NSPART_ART_2026,3)," [95%CI:", round(NSPART_ART_2026_CI(1),3),"-",round(NSPART_ART_2026_CI(2),3),"]"));
NSPART_ART_2027_withCI=join(horzcat(round(NSPART_ART_2027,3)," [95%CI:", round(NSPART_ART_2027_CI(1),3),"-",round(NSPART_ART_2027_CI(2),3),"]"));
NSPART_ART_2028_withCI=join(horzcat(round(NSPART_ART_2028,3)," [95%CI:", round(NSPART_ART_2028_CI(1),3),"-",round(NSPART_ART_2028_CI(2),3),"]"));
NSPART_ART_2029_withCI=join(horzcat(round(NSPART_ART_2029,3)," [95%CI:", round(NSPART_ART_2029_CI(1),3),"-",round(NSPART_ART_2029_CI(2),3),"]"));
NSPART_ART_2030_withCI=join(horzcat(round(NSPART_ART_2030,3)," [95%CI:", round(NSPART_ART_2030_CI(1),3),"-",round(NSPART_ART_2030_CI(2),3),"]"));

NSPART_OST_2022_withCI=join(horzcat(round(NSPART_OST_2022,3)," [95%CI:", round(NSPART_OST_2022_CI(1),3),"-",round(NSPART_OST_2022_CI(2),3),"]"));
NSPART_OST_2023_withCI=join(horzcat(round(NSPART_OST_2023,3)," [95%CI:", round(NSPART_OST_2023_CI(1),3),"-",round(NSPART_OST_2023_CI(2),3),"]"));
NSPART_OST_2024_withCI=join(horzcat(round(NSPART_OST_2024,3)," [95%CI:", round(NSPART_OST_2024_CI(1),3),"-",round(NSPART_OST_2024_CI(2),3),"]"));
NSPART_OST_2025_withCI=join(horzcat(round(NSPART_OST_2025,3)," [95%CI:", round(NSPART_OST_2025_CI(1),3),"-",round(NSPART_OST_2025_CI(2),3),"]"));
NSPART_OST_2026_withCI=join(horzcat(round(NSPART_OST_2026,3)," [95%CI:", round(NSPART_OST_2026_CI(1),3),"-",round(NSPART_OST_2026_CI(2),3),"]"));
NSPART_OST_2027_withCI=join(horzcat(round(NSPART_OST_2027,3)," [95%CI:", round(NSPART_OST_2027_CI(1),3),"-",round(NSPART_OST_2027_CI(2),3),"]"));
NSPART_OST_2028_withCI=join(horzcat(round(NSPART_OST_2028,3)," [95%CI:", round(NSPART_OST_2028_CI(1),3),"-",round(NSPART_OST_2028_CI(2),3),"]"));
NSPART_OST_2029_withCI=join(horzcat(round(NSPART_OST_2029,3)," [95%CI:", round(NSPART_OST_2029_CI(1),3),"-",round(NSPART_OST_2029_CI(2),3),"]"));
NSPART_OST_2030_withCI=join(horzcat(round(NSPART_OST_2030,3)," [95%CI:", round(NSPART_OST_2030_CI(1),3),"-",round(NSPART_OST_2030_CI(2),3),"]"));


Variables_names7={'2022' ;'2023';'2024';'2025';'2026';'2027';'2028';'2029';'2030'};
NSPART_ART_coverage_withCI=[NSPART_ART_2022_withCI; NSPART_ART_2023_withCI; NSPART_ART_2024_withCI; NSPART_ART_2025_withCI; NSPART_ART_2026_withCI; NSPART_ART_2027_withCI; NSPART_ART_2028_withCI; NSPART_ART_2029_withCI; NSPART_ART_2030_withCI];
NSPART_OST_coverage_withCI=[NSPART_OST_2022_withCI; NSPART_OST_2023_withCI; NSPART_OST_2024_withCI; NSPART_OST_2025_withCI; NSPART_OST_2026_withCI; NSPART_OST_2027_withCI; NSPART_OST_2028_withCI; NSPART_OST_2029_withCI; NSPART_OST_2030_withCI];

NSPARTT7 = table(Variables_names7,NSPART_ART_coverage_withCI,NSPART_OST_coverage_withCI);
NSPARTFilename7 = [outputfolder,'/2.NSPART.summarytable.ARTandOSTcoverage2time_', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(NSPARTT7,NSPARTFilename7)






%% NSP
load([dir,'/NSP_50_2030.mat']);


% OST coverage (all PWID)
tmp = NSP_50_2030.PWID_prop_current_OST_all;
NSP_OST_2022 = mean(tmp(:,ind2022),1);
NSP_OST_2022_CI=prctile(tmp(:,ind2022),[2.5  97.5]);
NSP_OST_2023 = mean(tmp(:,ind2023),1);
NSP_OST_2023_CI=prctile(tmp(:,ind2023),[2.5  97.5]);
NSP_OST_2024 = mean(tmp(:,ind2024),1);
NSP_OST_2024_CI=prctile(tmp(:,ind2024),[2.5  97.5]);
NSP_OST_2025 = mean(tmp(:,ind2025),1);
NSP_OST_2025_CI=prctile(tmp(:,ind2025),[2.5  97.5]);
NSP_OST_2026 = mean(tmp(:,ind2026),1);
NSP_OST_2026_CI=prctile(tmp(:,ind2026),[2.5  97.5]);
NSP_OST_2027 = mean(tmp(:,ind2027),1);
NSP_OST_2027_CI=prctile(tmp(:,ind2027),[2.5  97.5]);
NSP_OST_2028 = mean(tmp(:,ind2028),1);
NSP_OST_2028_CI=prctile(tmp(:,ind2028),[2.5  97.5]);
NSP_OST_2029 = mean(tmp(:,ind2029),1);
NSP_OST_2029_CI=prctile(tmp(:,ind2029),[2.5  97.5]);
NSP_OST_2030 = mean(tmp(:,ind2030),1);
NSP_OST_2030_CI=prctile(tmp(:,ind2030),[2.5  97.5]);

tmp2 = NSP_50_2030.PWID_prop_current_ART_all;
NSP_ART_2022 = mean(tmp2(:,ind2022),1);
NSP_ART_2022_CI=prctile(tmp2(:,ind2022),[2.5  97.5]);
NSP_ART_2023 = mean(tmp2(:,ind2023),1);
NSP_ART_2023_CI=prctile(tmp2(:,ind2023),[2.5  97.5]);
NSP_ART_2024 = mean(tmp2(:,ind2024),1);
NSP_ART_2024_CI=prctile(tmp2(:,ind2024),[2.5  97.5]);
NSP_ART_2025 = mean(tmp2(:,ind2025),1);
NSP_ART_2025_CI=prctile(tmp2(:,ind2025),[2.5  97.5]);
NSP_ART_2026 = mean(tmp2(:,ind2026),1);
NSP_ART_2026_CI=prctile(tmp2(:,ind2026),[2.5  97.5]);
NSP_ART_2027 = mean(tmp2(:,ind2027),1);
NSP_ART_2027_CI=prctile(tmp2(:,ind2027),[2.5  97.5]);
NSP_ART_2028 = mean(tmp2(:,ind2028),1);
NSP_ART_2028_CI=prctile(tmp2(:,ind2028),[2.5  97.5]);
NSP_ART_2029 = mean(tmp2(:,ind2029),1);
NSP_ART_2029_CI=prctile(tmp2(:,ind2029),[2.5  97.5]);
NSP_ART_2030 = mean(tmp2(:,ind2030),1);
NSP_ART_2030_CI=prctile(tmp2(:,ind2030),[2.5  97.5]);



clear tmp
clear tmp2
%%%%%% NSP TABLE

NSP_ART_2022_withCI=join(horzcat(round(NSP_ART_2022,3)," [95%CI:", round(NSP_ART_2022_CI(1),3),"-",round(NSP_ART_2022_CI(2),3),"]"));
NSP_ART_2023_withCI=join(horzcat(round(NSP_ART_2023,3)," [95%CI:", round(NSP_ART_2023_CI(1),3),"-",round(NSP_ART_2023_CI(2),3),"]"));
NSP_ART_2024_withCI=join(horzcat(round(NSP_ART_2024,3)," [95%CI:", round(NSP_ART_2024_CI(1),3),"-",round(NSP_ART_2024_CI(2),3),"]"));
NSP_ART_2025_withCI=join(horzcat(round(NSP_ART_2025,3)," [95%CI:", round(NSP_ART_2025_CI(1),3),"-",round(NSP_ART_2025_CI(2),3),"]"));
NSP_ART_2026_withCI=join(horzcat(round(NSP_ART_2026,3)," [95%CI:", round(NSP_ART_2026_CI(1),3),"-",round(NSP_ART_2026_CI(2),3),"]"));
NSP_ART_2027_withCI=join(horzcat(round(NSP_ART_2027,3)," [95%CI:", round(NSP_ART_2027_CI(1),3),"-",round(NSP_ART_2027_CI(2),3),"]"));
NSP_ART_2028_withCI=join(horzcat(round(NSP_ART_2028,3)," [95%CI:", round(NSP_ART_2028_CI(1),3),"-",round(NSP_ART_2028_CI(2),3),"]"));
NSP_ART_2029_withCI=join(horzcat(round(NSP_ART_2029,3)," [95%CI:", round(NSP_ART_2029_CI(1),3),"-",round(NSP_ART_2029_CI(2),3),"]"));
NSP_ART_2030_withCI=join(horzcat(round(NSP_ART_2030,3)," [95%CI:", round(NSP_ART_2030_CI(1),3),"-",round(NSP_ART_2030_CI(2),3),"]"));

NSP_OST_2022_withCI=join(horzcat(round(NSP_OST_2022,3)," [95%CI:", round(NSP_OST_2022_CI(1),3),"-",round(NSP_OST_2022_CI(2),3),"]"));
NSP_OST_2023_withCI=join(horzcat(round(NSP_OST_2023,3)," [95%CI:", round(NSP_OST_2023_CI(1),3),"-",round(NSP_OST_2023_CI(2),3),"]"));
NSP_OST_2024_withCI=join(horzcat(round(NSP_OST_2024,3)," [95%CI:", round(NSP_OST_2024_CI(1),3),"-",round(NSP_OST_2024_CI(2),3),"]"));
NSP_OST_2025_withCI=join(horzcat(round(NSP_OST_2025,3)," [95%CI:", round(NSP_OST_2025_CI(1),3),"-",round(NSP_OST_2025_CI(2),3),"]"));
NSP_OST_2026_withCI=join(horzcat(round(NSP_OST_2026,3)," [95%CI:", round(NSP_OST_2026_CI(1),3),"-",round(NSP_OST_2026_CI(2),3),"]"));
NSP_OST_2027_withCI=join(horzcat(round(NSP_OST_2027,3)," [95%CI:", round(NSP_OST_2027_CI(1),3),"-",round(NSP_OST_2027_CI(2),3),"]"));
NSP_OST_2028_withCI=join(horzcat(round(NSP_OST_2028,3)," [95%CI:", round(NSP_OST_2028_CI(1),3),"-",round(NSP_OST_2028_CI(2),3),"]"));
NSP_OST_2029_withCI=join(horzcat(round(NSP_OST_2029,3)," [95%CI:", round(NSP_OST_2029_CI(1),3),"-",round(NSP_OST_2029_CI(2),3),"]"));
NSP_OST_2030_withCI=join(horzcat(round(NSP_OST_2030,3)," [95%CI:", round(NSP_OST_2030_CI(1),3),"-",round(NSP_OST_2030_CI(2),3),"]"));


Variables_names7={'2022' ;'2023';'2024';'2025';'2026';'2027';'2028';'2029';'2030'};
NSP_ART_coverage_withCI=[NSP_ART_2022_withCI; NSP_ART_2023_withCI; NSP_ART_2024_withCI; NSP_ART_2025_withCI; NSP_ART_2026_withCI; NSP_ART_2027_withCI; NSP_ART_2028_withCI; NSP_ART_2029_withCI; NSP_ART_2030_withCI];
NSP_OST_coverage_withCI=[NSP_OST_2022_withCI; NSP_OST_2023_withCI; NSP_OST_2024_withCI; NSP_OST_2025_withCI; NSP_OST_2026_withCI; NSP_OST_2027_withCI; NSP_OST_2028_withCI; NSP_OST_2029_withCI; NSP_OST_2030_withCI];

NSPT7 = table(Variables_names7,NSP_ART_coverage_withCI,NSP_OST_coverage_withCI);
NSPFilename7 = [outputfolder,'/2.NSP.summarytable.ARTandOSTcoverage2time_', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(NSPT7,NSPFilename7)



%% OST
load([dir,'/NSPARTOST_50_2030.mat']);


% OST coverage (all PWID)
tmp = NSPARTOST_50_2030.PWID_prop_current_OST_all;
NSPARTOST_OST_2022 = mean(tmp(:,ind2022),1);
NSPARTOST_OST_2022_CI=prctile(tmp(:,ind2022),[2.5  97.5]);
NSPARTOST_OST_2023 = mean(tmp(:,ind2023),1);
NSPARTOST_OST_2023_CI=prctile(tmp(:,ind2023),[2.5  97.5]);
NSPARTOST_OST_2024 = mean(tmp(:,ind2024),1);
NSPARTOST_OST_2024_CI=prctile(tmp(:,ind2024),[2.5  97.5]);
NSPARTOST_OST_2025 = mean(tmp(:,ind2025),1);
NSPARTOST_OST_2025_CI=prctile(tmp(:,ind2025),[2.5  97.5]);
NSPARTOST_OST_2026 = mean(tmp(:,ind2026),1);
NSPARTOST_OST_2026_CI=prctile(tmp(:,ind2026),[2.5  97.5]);
NSPARTOST_OST_2027 = mean(tmp(:,ind2027),1);
NSPARTOST_OST_2027_CI=prctile(tmp(:,ind2027),[2.5  97.5]);
NSPARTOST_OST_2028 = mean(tmp(:,ind2028),1);
NSPARTOST_OST_2028_CI=prctile(tmp(:,ind2028),[2.5  97.5]);
NSPARTOST_OST_2029 = mean(tmp(:,ind2029),1);
NSPARTOST_OST_2029_CI=prctile(tmp(:,ind2029),[2.5  97.5]);
NSPARTOST_OST_2030 = mean(tmp(:,ind2030),1);
NSPARTOST_OST_2030_CI=prctile(tmp(:,ind2030),[2.5  97.5]);

tmp2 = NSPARTOST_50_2030.PWID_prop_current_ART_all;
NSPARTOST_ART_2022 = mean(tmp2(:,ind2022),1);
NSPARTOST_ART_2022_CI=prctile(tmp2(:,ind2022),[2.5  97.5]);
NSPARTOST_ART_2023 = mean(tmp2(:,ind2023),1);
NSPARTOST_ART_2023_CI=prctile(tmp2(:,ind2023),[2.5  97.5]);
NSPARTOST_ART_2024 = mean(tmp2(:,ind2024),1);
NSPARTOST_ART_2024_CI=prctile(tmp2(:,ind2024),[2.5  97.5]);
NSPARTOST_ART_2025 = mean(tmp2(:,ind2025),1);
NSPARTOST_ART_2025_CI=prctile(tmp2(:,ind2025),[2.5  97.5]);
NSPARTOST_ART_2026 = mean(tmp2(:,ind2026),1);
NSPARTOST_ART_2026_CI=prctile(tmp2(:,ind2026),[2.5  97.5]);
NSPARTOST_ART_2027 = mean(tmp2(:,ind2027),1);
NSPARTOST_ART_2027_CI=prctile(tmp2(:,ind2027),[2.5  97.5]);
NSPARTOST_ART_2028 = mean(tmp2(:,ind2028),1);
NSPARTOST_ART_2028_CI=prctile(tmp2(:,ind2028),[2.5  97.5]);
NSPARTOST_ART_2029 = mean(tmp2(:,ind2029),1);
NSPARTOST_ART_2029_CI=prctile(tmp2(:,ind2029),[2.5  97.5]);
NSPARTOST_ART_2030 = mean(tmp2(:,ind2030),1);
NSPARTOST_ART_2030_CI=prctile(tmp2(:,ind2030),[2.5  97.5]);



clear tmp
clear tmp2
%%%%%% NSPARTOST TABLE

NSPARTOST_ART_2022_withCI=join(horzcat(round(NSPARTOST_ART_2022,3)," [95%CI:", round(NSPARTOST_ART_2022_CI(1),3),"-",round(NSPARTOST_ART_2022_CI(2),3),"]"));
NSPARTOST_ART_2023_withCI=join(horzcat(round(NSPARTOST_ART_2023,3)," [95%CI:", round(NSPARTOST_ART_2023_CI(1),3),"-",round(NSPARTOST_ART_2023_CI(2),3),"]"));
NSPARTOST_ART_2024_withCI=join(horzcat(round(NSPARTOST_ART_2024,3)," [95%CI:", round(NSPARTOST_ART_2024_CI(1),3),"-",round(NSPARTOST_ART_2024_CI(2),3),"]"));
NSPARTOST_ART_2025_withCI=join(horzcat(round(NSPARTOST_ART_2025,3)," [95%CI:", round(NSPARTOST_ART_2025_CI(1),3),"-",round(NSPARTOST_ART_2025_CI(2),3),"]"));
NSPARTOST_ART_2026_withCI=join(horzcat(round(NSPARTOST_ART_2026,3)," [95%CI:", round(NSPARTOST_ART_2026_CI(1),3),"-",round(NSPARTOST_ART_2026_CI(2),3),"]"));
NSPARTOST_ART_2027_withCI=join(horzcat(round(NSPARTOST_ART_2027,3)," [95%CI:", round(NSPARTOST_ART_2027_CI(1),3),"-",round(NSPARTOST_ART_2027_CI(2),3),"]"));
NSPARTOST_ART_2028_withCI=join(horzcat(round(NSPARTOST_ART_2028,3)," [95%CI:", round(NSPARTOST_ART_2028_CI(1),3),"-",round(NSPARTOST_ART_2028_CI(2),3),"]"));
NSPARTOST_ART_2029_withCI=join(horzcat(round(NSPARTOST_ART_2029,3)," [95%CI:", round(NSPARTOST_ART_2029_CI(1),3),"-",round(NSPARTOST_ART_2029_CI(2),3),"]"));
NSPARTOST_ART_2030_withCI=join(horzcat(round(NSPARTOST_ART_2030,3)," [95%CI:", round(NSPARTOST_ART_2030_CI(1),3),"-",round(NSPARTOST_ART_2030_CI(2),3),"]"));

NSPARTOST_OST_2022_withCI=join(horzcat(round(NSPARTOST_OST_2022,3)," [95%CI:", round(NSPARTOST_OST_2022_CI(1),3),"-",round(NSPARTOST_OST_2022_CI(2),3),"]"));
NSPARTOST_OST_2023_withCI=join(horzcat(round(NSPARTOST_OST_2023,3)," [95%CI:", round(NSPARTOST_OST_2023_CI(1),3),"-",round(NSPARTOST_OST_2023_CI(2),3),"]"));
NSPARTOST_OST_2024_withCI=join(horzcat(round(NSPARTOST_OST_2024,3)," [95%CI:", round(NSPARTOST_OST_2024_CI(1),3),"-",round(NSPARTOST_OST_2024_CI(2),3),"]"));
NSPARTOST_OST_2025_withCI=join(horzcat(round(NSPARTOST_OST_2025,3)," [95%CI:", round(NSPARTOST_OST_2025_CI(1),3),"-",round(NSPARTOST_OST_2025_CI(2),3),"]"));
NSPARTOST_OST_2026_withCI=join(horzcat(round(NSPARTOST_OST_2026,3)," [95%CI:", round(NSPARTOST_OST_2026_CI(1),3),"-",round(NSPARTOST_OST_2026_CI(2),3),"]"));
NSPARTOST_OST_2027_withCI=join(horzcat(round(NSPARTOST_OST_2027,3)," [95%CI:", round(NSPARTOST_OST_2027_CI(1),3),"-",round(NSPARTOST_OST_2027_CI(2),3),"]"));
NSPARTOST_OST_2028_withCI=join(horzcat(round(NSPARTOST_OST_2028,3)," [95%CI:", round(NSPARTOST_OST_2028_CI(1),3),"-",round(NSPARTOST_OST_2028_CI(2),3),"]"));
NSPARTOST_OST_2029_withCI=join(horzcat(round(NSPARTOST_OST_2029,3)," [95%CI:", round(NSPARTOST_OST_2029_CI(1),3),"-",round(NSPARTOST_OST_2029_CI(2),3),"]"));
NSPARTOST_OST_2030_withCI=join(horzcat(round(NSPARTOST_OST_2030,3)," [95%CI:", round(NSPARTOST_OST_2030_CI(1),3),"-",round(NSPARTOST_OST_2030_CI(2),3),"]"));


Variables_names7={'2022' ;'2023';'2024';'2025';'2026';'2027';'2028';'2029';'2030'};
NSPARTOST_ART_coverage_withCI=[NSPARTOST_ART_2022_withCI; NSPARTOST_ART_2023_withCI; NSPARTOST_ART_2024_withCI; NSPARTOST_ART_2025_withCI; NSPARTOST_ART_2026_withCI; NSPARTOST_ART_2027_withCI; NSPARTOST_ART_2028_withCI; NSPARTOST_ART_2029_withCI; NSPARTOST_ART_2030_withCI];
NSPARTOST_OST_coverage_withCI=[NSPARTOST_OST_2022_withCI; NSPARTOST_OST_2023_withCI; NSPARTOST_OST_2024_withCI; NSPARTOST_OST_2025_withCI; NSPARTOST_OST_2026_withCI; NSPARTOST_OST_2027_withCI; NSPARTOST_OST_2028_withCI; NSPARTOST_OST_2029_withCI; NSPARTOST_OST_2030_withCI];

NSPARTOSTT7 = table(Variables_names7,NSPARTOST_ART_coverage_withCI,NSPARTOST_OST_coverage_withCI);
NSPARTOSTFilename7 = [outputfolder,'/2.NSPARTOST.summarytable.ARTandOSTcoverage2time_', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(NSPARTOSTT7,NSPARTOSTFilename7)




%% OST
load([dir,'/NSPOST_50_2030.mat']);


% OST coverage (all PWID)
tmp = NSPOST_50_2030.PWID_prop_current_OST_all;
NSPOST_OST_2022 = mean(tmp(:,ind2022),1);
NSPOST_OST_2022_CI=prctile(tmp(:,ind2022),[2.5  97.5]);
NSPOST_OST_2023 = mean(tmp(:,ind2023),1);
NSPOST_OST_2023_CI=prctile(tmp(:,ind2023),[2.5  97.5]);
NSPOST_OST_2024 = mean(tmp(:,ind2024),1);
NSPOST_OST_2024_CI=prctile(tmp(:,ind2024),[2.5  97.5]);
NSPOST_OST_2025 = mean(tmp(:,ind2025),1);
NSPOST_OST_2025_CI=prctile(tmp(:,ind2025),[2.5  97.5]);
NSPOST_OST_2026 = mean(tmp(:,ind2026),1);
NSPOST_OST_2026_CI=prctile(tmp(:,ind2026),[2.5  97.5]);
NSPOST_OST_2027 = mean(tmp(:,ind2027),1);
NSPOST_OST_2027_CI=prctile(tmp(:,ind2027),[2.5  97.5]);
NSPOST_OST_2028 = mean(tmp(:,ind2028),1);
NSPOST_OST_2028_CI=prctile(tmp(:,ind2028),[2.5  97.5]);
NSPOST_OST_2029 = mean(tmp(:,ind2029),1);
NSPOST_OST_2029_CI=prctile(tmp(:,ind2029),[2.5  97.5]);
NSPOST_OST_2030 = mean(tmp(:,ind2030),1);
NSPOST_OST_2030_CI=prctile(tmp(:,ind2030),[2.5  97.5]);

tmp2 = NSPOST_50_2030.PWID_prop_current_ART_all;
NSPOST_ART_2022 = mean(tmp2(:,ind2022),1);
NSPOST_ART_2022_CI=prctile(tmp2(:,ind2022),[2.5  97.5]);
NSPOST_ART_2023 = mean(tmp2(:,ind2023),1);
NSPOST_ART_2023_CI=prctile(tmp2(:,ind2023),[2.5  97.5]);
NSPOST_ART_2024 = mean(tmp2(:,ind2024),1);
NSPOST_ART_2024_CI=prctile(tmp2(:,ind2024),[2.5  97.5]);
NSPOST_ART_2025 = mean(tmp2(:,ind2025),1);
NSPOST_ART_2025_CI=prctile(tmp2(:,ind2025),[2.5  97.5]);
NSPOST_ART_2026 = mean(tmp2(:,ind2026),1);
NSPOST_ART_2026_CI=prctile(tmp2(:,ind2026),[2.5  97.5]);
NSPOST_ART_2027 = mean(tmp2(:,ind2027),1);
NSPOST_ART_2027_CI=prctile(tmp2(:,ind2027),[2.5  97.5]);
NSPOST_ART_2028 = mean(tmp2(:,ind2028),1);
NSPOST_ART_2028_CI=prctile(tmp2(:,ind2028),[2.5  97.5]);
NSPOST_ART_2029 = mean(tmp2(:,ind2029),1);
NSPOST_ART_2029_CI=prctile(tmp2(:,ind2029),[2.5  97.5]);
NSPOST_ART_2030 = mean(tmp2(:,ind2030),1);
NSPOST_ART_2030_CI=prctile(tmp2(:,ind2030),[2.5  97.5]);



clear tmp
clear tmp2
%%%%%% NSPOST TABLE

NSPOST_ART_2022_withCI=join(horzcat(round(NSPOST_ART_2022,3)," [95%CI:", round(NSPOST_ART_2022_CI(1),3),"-",round(NSPOST_ART_2022_CI(2),3),"]"));
NSPOST_ART_2023_withCI=join(horzcat(round(NSPOST_ART_2023,3)," [95%CI:", round(NSPOST_ART_2023_CI(1),3),"-",round(NSPOST_ART_2023_CI(2),3),"]"));
NSPOST_ART_2024_withCI=join(horzcat(round(NSPOST_ART_2024,3)," [95%CI:", round(NSPOST_ART_2024_CI(1),3),"-",round(NSPOST_ART_2024_CI(2),3),"]"));
NSPOST_ART_2025_withCI=join(horzcat(round(NSPOST_ART_2025,3)," [95%CI:", round(NSPOST_ART_2025_CI(1),3),"-",round(NSPOST_ART_2025_CI(2),3),"]"));
NSPOST_ART_2026_withCI=join(horzcat(round(NSPOST_ART_2026,3)," [95%CI:", round(NSPOST_ART_2026_CI(1),3),"-",round(NSPOST_ART_2026_CI(2),3),"]"));
NSPOST_ART_2027_withCI=join(horzcat(round(NSPOST_ART_2027,3)," [95%CI:", round(NSPOST_ART_2027_CI(1),3),"-",round(NSPOST_ART_2027_CI(2),3),"]"));
NSPOST_ART_2028_withCI=join(horzcat(round(NSPOST_ART_2028,3)," [95%CI:", round(NSPOST_ART_2028_CI(1),3),"-",round(NSPOST_ART_2028_CI(2),3),"]"));
NSPOST_ART_2029_withCI=join(horzcat(round(NSPOST_ART_2029,3)," [95%CI:", round(NSPOST_ART_2029_CI(1),3),"-",round(NSPOST_ART_2029_CI(2),3),"]"));
NSPOST_ART_2030_withCI=join(horzcat(round(NSPOST_ART_2030,3)," [95%CI:", round(NSPOST_ART_2030_CI(1),3),"-",round(NSPOST_ART_2030_CI(2),3),"]"));

NSPOST_OST_2022_withCI=join(horzcat(round(NSPOST_OST_2022,3)," [95%CI:", round(NSPOST_OST_2022_CI(1),3),"-",round(NSPOST_OST_2022_CI(2),3),"]"));
NSPOST_OST_2023_withCI=join(horzcat(round(NSPOST_OST_2023,3)," [95%CI:", round(NSPOST_OST_2023_CI(1),3),"-",round(NSPOST_OST_2023_CI(2),3),"]"));
NSPOST_OST_2024_withCI=join(horzcat(round(NSPOST_OST_2024,3)," [95%CI:", round(NSPOST_OST_2024_CI(1),3),"-",round(NSPOST_OST_2024_CI(2),3),"]"));
NSPOST_OST_2025_withCI=join(horzcat(round(NSPOST_OST_2025,3)," [95%CI:", round(NSPOST_OST_2025_CI(1),3),"-",round(NSPOST_OST_2025_CI(2),3),"]"));
NSPOST_OST_2026_withCI=join(horzcat(round(NSPOST_OST_2026,3)," [95%CI:", round(NSPOST_OST_2026_CI(1),3),"-",round(NSPOST_OST_2026_CI(2),3),"]"));
NSPOST_OST_2027_withCI=join(horzcat(round(NSPOST_OST_2027,3)," [95%CI:", round(NSPOST_OST_2027_CI(1),3),"-",round(NSPOST_OST_2027_CI(2),3),"]"));
NSPOST_OST_2028_withCI=join(horzcat(round(NSPOST_OST_2028,3)," [95%CI:", round(NSPOST_OST_2028_CI(1),3),"-",round(NSPOST_OST_2028_CI(2),3),"]"));
NSPOST_OST_2029_withCI=join(horzcat(round(NSPOST_OST_2029,3)," [95%CI:", round(NSPOST_OST_2029_CI(1),3),"-",round(NSPOST_OST_2029_CI(2),3),"]"));
NSPOST_OST_2030_withCI=join(horzcat(round(NSPOST_OST_2030,3)," [95%CI:", round(NSPOST_OST_2030_CI(1),3),"-",round(NSPOST_OST_2030_CI(2),3),"]"));


Variables_names7={'2022' ;'2023';'2024';'2025';'2026';'2027';'2028';'2029';'2030'};
NSPOST_ART_coverage_withCI=[NSPOST_ART_2022_withCI; NSPOST_ART_2023_withCI; NSPOST_ART_2024_withCI; NSPOST_ART_2025_withCI; NSPOST_ART_2026_withCI; NSPOST_ART_2027_withCI; NSPOST_ART_2028_withCI; NSPOST_ART_2029_withCI; NSPOST_ART_2030_withCI];
NSPOST_OST_coverage_withCI=[NSPOST_OST_2022_withCI; NSPOST_OST_2023_withCI; NSPOST_OST_2024_withCI; NSPOST_OST_2025_withCI; NSPOST_OST_2026_withCI; NSPOST_OST_2027_withCI; NSPOST_OST_2028_withCI; NSPOST_OST_2029_withCI; NSPOST_OST_2030_withCI];

NSPOSTT7 = table(Variables_names7,NSPOST_ART_coverage_withCI,NSPOST_OST_coverage_withCI);
NSPOSTFilename7 = [outputfolder,'/2.NSPOST.summarytable.ARTandOSTcoverage2time_', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(NSPOSTT7,NSPOSTFilename7)

close all

end
% find(isnan(scale_OST_cat))
