%%% run this code to calculate % reduction in HCV incidence from 2022 to
%%% 2030 under OST scale-up and ART scale-up scenarios (each scenario
%%% scales OST or ART to 50% coverage by 2030)

% dir='/Users/antoinechaillon/Dropbox/intrepid/matlab/Global2_R19_HCVonly/Outputs/';
% N=5000;
function [] = ABC_Get_HCV_reduction_combined_CI(ISO,N,dir,numrun)


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
ind2030 = (2030-seed_date)/time_step+1;





load([dir,'/Status_quo.mat']);
% HCV Incidence (all PWID)
tmp = Status_quo.HCV_Incidence_PWID;
tmp2 = Status_quo.PWID_HCV_prevalence;
tmp3 = Status_quo.PWID_pop_size;


SQ_HCV_inc_2022 = mean(tmp(:,ind2022),1);
SQ_HCV_inc_2022_CI=prctile(tmp(:,ind2022),[2.5  97.5]);

SQ_HCV_inc_2030 = mean(tmp(:,ind2030),1);
SQ_HCV_inc_2030_CI=prctile(tmp(:,ind2030),[2.5  97.5]);


perc_HCV_red_SQ = mean((tmp(:,ind2022) - tmp(:,ind2030))./tmp(:,ind2022).*100);
perc_HCV_red_SQ_CI=prctile((tmp(:,ind2022) - tmp(:,ind2030))./tmp(:,ind2022).*100,[2.5  97.5]);

% HCV prevalence (all PWID)
SQ_HCV_prev_2022 = mean(tmp2(:,ind2022),1);
SQ_HCV_prev_2022_CI=prctile(tmp2(:,ind2022),[2.5  97.5]);

SQ_HCV_prev_2030 = mean(tmp2(:,ind2030),1);
SQ_HCV_prev_2030_CI=prctile(tmp2(:,ind2030),[2.5  97.5]);

newinfections_SQ_auc= trapz(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
newinfections_SQ_auc_final=mean(newinfections_SQ_auc,1);
%   4.0986e+06

newinfections_SQ_cumsum=cumsum(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
newinfections_SQ_cumsum_final=mean(newinfections_SQ_cumsum(:,size(newinfections_SQ_cumsum,2)),1);
%   4.1500e+06



% OST coverage (all PWID)
tmp4 = Status_quo.PWID_prop_current_OST_all;
SQscenario_OST_2022 = mean(tmp4(:,ind2022),1);
SQscenario_OST_2022_CI=prctile(tmp4(:,ind2022),[2.5  97.5]);

SQscenario_OST_2030 = mean(tmp4(:,ind2030),1);
SQscenario_OST_2030_CI=prctile(tmp4(:,ind2030),[2.5  97.5]);

% ARTscenario_HCV_OST_coverage_2022_vector=tmp4(:,ind2022);
% ARTscenario_HCV_OST_coverage_2030_vector=tmp4(:,ind2030);

% ART coverage (all PWID)
tmp5 = Status_quo.PWID_prop_current_ART_all;
SQscenario_ART_2022 = mean(tmp5(:,ind2022),1);
SQscenario_ART_2022_CI=prctile(tmp5(:,ind2022),[2.5  97.5]);

SQscenario_ART_2030 = mean(tmp5(:,ind2030),1);
SQscenario_ART_2030_CI=prctile(tmp5(:,ind2030),[2.5  97.5]);

% ARTscenario_HCV_ART_coverage_2022_vector=tmp5(:,ind2022);
% ARTscenario_OST_HCV_ART_coverage_2030_vector=tmp5(:,ind2030);

clear tmp
clear tmp2
clear tmp3
clear tmp4
clear tmp5



% HCV AB prevalence com
tmp = Status_quo.PWID_HCV_AB_prevalence_com;
HCV_AB_prevalence_com_2022_SQscenario = mean(tmp(:,ind2022),1);
HCV_AB_prevalence_com_2022_SQscenario_CI=prctile(tmp(:,ind2022),[2.5  97.5]);

HCV_AB_prevalence_com_2030_SQscenario = mean(tmp(:,ind2030),1);
HCV_AB_prevalence_com_SQscenario_CI=prctile(tmp(:,ind2030),[2.5  97.5]);

HCV_AB_prevalence_com_2022_SQscenario_vector=tmp(:,ind2022);
HCV_AB_prevalence_com_2030_SQscenario_vector=tmp(:,ind2030);

clear tmp


load([dir,'/ART_50_2030.mat']);
% HCV Incidence (all PWID)
tmp = ART_50_2030.HCV_Incidence_PWID;
tmp2 = ART_50_2030.PWID_HCV_prevalence;
tmp3 = ART_50_2030.PWID_pop_size;

ART_HCV_inc_2022 = mean(tmp(:,ind2022),1);
ART_HCV_inc_2022_CI=prctile(tmp(:,ind2022),[2.5  97.5]);

ART_HCV_inc_2030 = mean(tmp(:,ind2030),1);
ART_HCV_inc_2030_CI=prctile(tmp(:,ind2030),[2.5  97.5]);



perc_HCV_red_ART = mean((tmp(:,ind2022) - tmp(:,ind2030))./tmp(:,ind2022).*100);
perc_HCV_red_ART_CI=prctile((tmp(:,ind2022) - tmp(:,ind2030))./tmp(:,ind2022).*100,[2.5  97.5]);

% HCV prevalence (all PWID)
ART_HCV_prev_2022 = mean(tmp2(:,ind2022),1);
ART_HCV_prev_2022_CI=prctile(tmp2(:,ind2022),[2.5  97.5]);

ART_HCV_prev_2030 = mean(tmp2(:,ind2030),1);
ART_HCV_prev_2030_CI=prctile(tmp2(:,ind2030),[2.5  97.5]);

newinfections_ART_auc= trapz(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
newinfections_ART_auc_final=mean(newinfections_ART_auc,1);

newinfections_ART_cumsum=cumsum(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
newinfections_ART_cumsum_final=mean(newinfections_ART_cumsum(:,size(newinfections_ART_cumsum,2)),1);

prop_hcvnew_averted_auc_ART=(newinfections_SQ_auc_final-newinfections_ART_auc_final)/newinfections_SQ_auc_final;
prop_hcvnew_averted_auc_ART_CI=prctile((newinfections_SQ_auc-newinfections_ART_auc)./newinfections_SQ_auc,[2.5  97.5]);

prop_hcvnew_averted_cumsum_ART=(newinfections_SQ_cumsum_final-newinfections_ART_cumsum_final)/newinfections_SQ_cumsum_final;
prop_hcvnew_averted_cumsum_ART_CI=prctile((newinfections_SQ_cumsum(:,size(newinfections_SQ_cumsum,2))-newinfections_ART_cumsum(:,size(newinfections_ART_cumsum,2)))./newinfections_SQ_cumsum(:,size(newinfections_SQ_cumsum,2)),[2.5  97.5]);


% OST coverage (all PWID)
tmp4 = ART_50_2030.PWID_prop_current_OST_all;
ARTscenario_OST_2022 = mean(tmp4(:,ind2022),1);
ARTscenario_OST_2022_CI=prctile(tmp4(:,ind2022),[2.5  97.5]);

ARTscenario_OST_2030 = mean(tmp4(:,ind2030),1);
ARTscenario_OST_2030_CI=prctile(tmp4(:,ind2030),[2.5  97.5]);

% ARTscenario_HCV_OST_coverage_2022_vector=tmp4(:,ind2022);
% ARTscenario_HCV_OST_coverage_2030_vector=tmp4(:,ind2030);

% ART coverage (all PWID)
tmp5 = ART_50_2030.PWID_prop_current_ART_all;
ARTscenario_ART_2022 = mean(tmp5(:,ind2022),1);
ARTscenario_ART_2022_CI=prctile(tmp5(:,ind2022),[2.5  97.5]);

ARTscenario_ART_2030 = mean(tmp5(:,ind2030),1);
ARTscenario_ART_2030_CI=prctile(tmp5(:,ind2030),[2.5  97.5]);

% ARTscenario_HCV_ART_coverage_2022_vector=tmp5(:,ind2022);
% ARTscenario_OST_HCV_ART_coverage_2030_vector=tmp5(:,ind2030);

clear tmp
clear tmp2
clear tmp3
clear tmp4
clear tmp5

% HCV AB prevalence com
tmp = ART_50_2030.PWID_HCV_AB_prevalence_com;
HCV_AB_prevalence_com_2022_ART = mean(tmp(:,ind2022),1);
HCV_AB_prevalence_com_2022_ART_CI=prctile(tmp(:,ind2022),[2.5  97.5]);

HCV_AB_prevalence_com_2030_ART = mean(tmp(:,ind2030),1);
HCV_AB_prevalence_com_ART_CI=prctile(tmp(:,ind2030),[2.5  97.5]);

HCV_AB_prevalence_com_2022_ART_vector=tmp(:,ind2022);
HCV_AB_prevalence_com_2030_ART_vector=tmp(:,ind2030);

clear tmp



%% OST

load([dir,'/OST_50_2030.mat']);
% HCV Incidence (all PWID)
tmp = OST_50_2030.HCV_Incidence_PWID;
tmp2 = OST_50_2030.PWID_HCV_prevalence;
tmp3 = OST_50_2030.PWID_pop_size;

OST_HCV_inc_2022 = mean(tmp(:,ind2022),1);
OST_HCV_inc_2022_CI=prctile(tmp(:,ind2022),[2.5  97.5]);

OST_HCV_inc_2030 = mean(tmp(:,ind2030),1);
OST_HCV_inc_2030_CI=prctile(tmp(:,ind2030),[2.5  97.5]);


%X.Properties.VariableNames = {'incidence2022_OST','incidence2030_OST'};
% perc_HCV_red_OST = (OST_HCV_inc_2022 - OST_HCV_inc_2030)/OST_HCV_inc_2030*100;
perc_HCV_red_OST = mean((tmp(:,ind2022) - tmp(:,ind2030))./tmp(:,ind2022).*100);
perc_HCV_red_OST_CI=prctile((tmp(:,ind2022) - tmp(:,ind2030))./tmp(:,ind2022).*100,[2.5  97.5]);

% HCV prevalence (all PWID)
OST_HCV_prev_2022 = mean(tmp2(:,ind2022),1);
OST_HCV_prev_2022_CI=prctile(tmp2(:,ind2022),[2.5  97.5]);

OST_HCV_prev_2030 = mean(tmp2(:,ind2030),1);
OST_HCV_prev_2030_CI=prctile(tmp2(:,ind2030),[2.5  97.5]);

% OST_HCV_prev_2022_vector=tmp2(:,ind2022);
% OST_HCV_prev_2030_vector=tmp2(:,ind2030);

newinfections_OST_auc= trapz(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
newinfections_OST_auc_final=mean(newinfections_OST_auc,1);

newinfections_OST_cumsum=cumsum(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
newinfections_OST_cumsum_final=mean(newinfections_OST_cumsum(:,size(newinfections_OST_cumsum,2)),1);

prop_hcvnew_averted_auc_OST=(newinfections_SQ_auc_final-newinfections_OST_auc_final)/newinfections_SQ_auc_final;
prop_hcvnew_averted_auc_OST_CI=prctile((newinfections_SQ_auc-newinfections_OST_auc)./newinfections_SQ_auc,[2.5  97.5]);

prop_hcvnew_averted_cumsum_OST=(newinfections_SQ_cumsum_final-newinfections_OST_cumsum_final)/newinfections_SQ_cumsum_final;
prop_hcvnew_averted_cumsum_OST_CI=prctile((newinfections_SQ_cumsum(:,size(newinfections_SQ_cumsum,2))-newinfections_OST_cumsum(:,size(newinfections_OST_cumsum,2)))./newinfections_SQ_cumsum(:,size(newinfections_SQ_cumsum,2)),[2.5  97.5]);


% OST coverage (all PWID)
tmp4 = OST_50_2030.PWID_prop_current_OST_all;
OSTscenario_OST_2022 = mean(tmp4(:,ind2022),1);
OSTscenario_OST_2022_CI=prctile(tmp4(:,ind2022),[2.5  97.5]);

OSTscenario_OST_2030 = mean(tmp4(:,ind2030),1);
OSTscenario_OST_2030_CI=prctile(tmp4(:,ind2030),[2.5  97.5]);

% OSTscenario_HCV_OST_coverage_2022_vector=tmp4(:,ind2022);
% OSTscenario_HCV_OST_coverage_2030_vector=tmp4(:,ind2030);

% ART coverage (all PWID)
tmp5 = OST_50_2030.PWID_prop_current_ART_all;
OSTscenario_ART_2022 = mean(tmp5(:,ind2022),1);
OSTscenario_ART_2022_CI=prctile(tmp5(:,ind2022),[2.5  97.5]);

OSTscenario_ART_2030 = mean(tmp5(:,ind2030),1);
OSTscenario_ART_2030_CI=prctile(tmp5(:,ind2030),[2.5  97.5]);

% OSTscenario_HCV_ART_coverage_2022_vector=tmp5(:,ind2022);
% OSTscenario_OST_HCV_ART_coverage_2030_vector=tmp5(:,ind2030);

clear tmp
clear tmp2
clear tmp3
clear tmp4
clear tmp5

% HCV AB prevalence com
tmp = OST_50_2030.PWID_HCV_AB_prevalence_com;
HCV_AB_prevalence_com_2022_OST = mean(tmp(:,ind2022),1);
HCV_AB_prevalence_com_2022_OST_CI=prctile(tmp(:,ind2022),[2.5  97.5]);

HCV_AB_prevalence_com_2030_OST = mean(tmp(:,ind2030),1);
HCV_AB_prevalence_com_OST_CI=prctile(tmp(:,ind2030),[2.5  97.5]);

HCV_AB_prevalence_com_2022_OST_vector=tmp(:,ind2022);
HCV_AB_prevalence_com_2030_OST_vector=tmp(:,ind2030);

clear tmp


load([dir,'/ARTOST_50_2030.mat']);
% HCV Incidence (all PWID)
tmp = ARTOST_50_2030.HCV_Incidence_PWID;
tmp2 = ARTOST_50_2030.PWID_HCV_prevalence;
tmp3 = ARTOST_50_2030.PWID_pop_size;

ARTOST_HCV_inc_2022 = mean(tmp(:,ind2022),1);
ARTOST_HCV_inc_2022_CI=prctile(tmp(:,ind2022),[2.5  97.5]);

ARTOST_HCV_inc_2030 = mean(tmp(:,ind2030),1);
ARTOST_HCV_inc_2030_CI=prctile(tmp(:,ind2030),[2.5  97.5]);


%X.Properties.VariableNames = {'incidence2022_ARTOST','incidence2030_ARTOST'};
% perc_HCV_red_ARTOST = (ARTOST_HCV_inc_2022 - ARTOST_HCV_inc_2030)/ARTOST_HCV_inc_2030*100;
perc_HCV_red_ARTOST = mean((tmp(:,ind2022) - tmp(:,ind2030))./tmp(:,ind2022).*100);
perc_HCV_red_ARTOST_CI=prctile((tmp(:,ind2022) - tmp(:,ind2030))./tmp(:,ind2022).*100,[2.5  97.5]);

% HCV prevalence (all PWID)
ARTOST_HCV_prev_2022 = mean(tmp2(:,ind2022),1);
ARTOST_HCV_prev_2022_CI=prctile(tmp2(:,ind2022),[2.5  97.5]);

ARTOST_HCV_prev_2030 = mean(tmp2(:,ind2030),1);
ARTOST_HCV_prev_2030_CI=prctile(tmp2(:,ind2030),[2.5  97.5]);

% ARTOST_HCV_prev_2022_vector=tmp2(:,ind2022);
% ARTOST_HCV_prev_2030_vector=tmp2(:,ind2030);

newinfections_ARTOST_auc= trapz(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
newinfections_ARTOST_auc_final=mean(newinfections_ARTOST_auc,1);

newinfections_ARTOST_cumsum=cumsum(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
newinfections_ARTOST_cumsum_final=mean(newinfections_ARTOST_cumsum(:,size(newinfections_ARTOST_cumsum,2)),1);

prop_hcvnew_averted_auc_ARTOST=(newinfections_SQ_auc_final-newinfections_ARTOST_auc_final)/newinfections_SQ_auc_final;
prop_hcvnew_averted_auc_ARTOST_CI=prctile((newinfections_SQ_auc-newinfections_ARTOST_auc)./newinfections_SQ_auc,[2.5  97.5]);

prop_hcvnew_averted_cumsum_ARTOST=(newinfections_SQ_cumsum_final-newinfections_ARTOST_cumsum_final)/newinfections_SQ_cumsum_final;
prop_hcvnew_averted_cumsum_ARTOST_CI=prctile((newinfections_SQ_cumsum(:,size(newinfections_SQ_cumsum,2))-newinfections_ARTOST_cumsum(:,size(newinfections_ARTOST_cumsum,2)))./newinfections_SQ_cumsum(:,size(newinfections_SQ_cumsum,2)),[2.5  97.5]);


% OST coverage (all PWID)
tmp4 = ARTOST_50_2030.PWID_prop_current_OST_all;
ARTOSTscenario_OST_2022 = mean(tmp4(:,ind2022),1);
ARTOSTscenario_OST_2022_CI=prctile(tmp4(:,ind2022),[2.5  97.5]);

ARTOSTscenario_OST_2030 = mean(tmp4(:,ind2030),1);
ARTOSTscenario_OST_2030_CI=prctile(tmp4(:,ind2030),[2.5  97.5]);

% ARTOSTscenario_HCV_OST_coverage_2022_vector=tmp4(:,ind2022);
% ARTOSTscenario_HCV_OST_coverage_2030_vector=tmp4(:,ind2030);

% ART coverage (all PWID)
tmp5 = ARTOST_50_2030.PWID_prop_current_ART_all;
ARTOSTscenario_ART_2022 = mean(tmp5(:,ind2022),1);
ARTOSTscenario_ART_2022_CI=prctile(tmp5(:,ind2022),[2.5  97.5]);

ARTOSTscenario_ART_2030 = mean(tmp5(:,ind2030),1);
ARTOSTscenario_ART_2030_CI=prctile(tmp5(:,ind2030),[2.5  97.5]);

% ARTOSTscenario_HCV_ART_coverage_2022_vector=tmp5(:,ind2022);
% ARTOSTscenario_OST_HCV_ART_coverage_2030_vector=tmp5(:,ind2030);

clear tmp
clear tmp2
clear tmp3
clear tmp4
clear tmp5

% HCV AB prevalence com
tmp = ARTOST_50_2030.PWID_HCV_AB_prevalence_com;
HCV_AB_prevalence_com_2022_ARTOST = mean(tmp(:,ind2022),1);
HCV_AB_prevalence_com_2022_ARTOST_CI=prctile(tmp(:,ind2022),[2.5  97.5]);

HCV_AB_prevalence_com_2030_ARTOST = mean(tmp(:,ind2030),1);
HCV_AB_prevalence_com_ARTOST_CI=prctile(tmp(:,ind2030),[2.5  97.5]);

HCV_AB_prevalence_com_2022_ARTOST_vector=tmp(:,ind2022);
HCV_AB_prevalence_com_2030_ARTOST_vector=tmp(:,ind2030);

clear tmp


load([dir,'/NSP_50_2030.mat']);
% HCV Incidence (all PWID)
tmp = NSP_50_2030.HCV_Incidence_PWID;
tmp2 = NSP_50_2030.PWID_HCV_prevalence;
tmp3 = NSP_50_2030.PWID_pop_size;

NSP_HCV_inc_2022 = mean(tmp(:,ind2022),1);
NSP_HCV_inc_2022_CI=prctile(tmp(:,ind2022),[2.5  97.5]);

NSP_HCV_inc_2030 = mean(tmp(:,ind2030),1);
NSP_HCV_inc_2030_CI=prctile(tmp(:,ind2030),[2.5  97.5]);


%X.Properties.VariableNames = {'incidence2022_NSP','incidence2030_NSP'};
% perc_HCV_red_NSP = (NSP_HCV_inc_2022 - NSP_HCV_inc_2030)/NSP_HCV_inc_2030*100;
perc_HCV_red_NSP = mean((tmp(:,ind2022) - tmp(:,ind2030))./tmp(:,ind2022).*100);
perc_HCV_red_NSP_CI=prctile((tmp(:,ind2022) - tmp(:,ind2030))./tmp(:,ind2022).*100,[2.5  97.5]);

% HCV prevalence (all PWID)
NSP_HCV_prev_2022 = mean(tmp2(:,ind2022),1);
NSP_HCV_prev_2022_CI=prctile(tmp2(:,ind2022),[2.5  97.5]);

NSP_HCV_prev_2030 = mean(tmp2(:,ind2030),1);
NSP_HCV_prev_2030_CI=prctile(tmp2(:,ind2030),[2.5  97.5]);

% NSP_HCV_prev_2022_vector=tmp2(:,ind2022);
% NSP_HCV_prev_2030_vector=tmp2(:,ind2030);

newinfections_NSP_auc= trapz(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
newinfections_NSP_auc_final=mean(newinfections_NSP_auc,1);

newinfections_NSP_cumsum=cumsum(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
newinfections_NSP_cumsum_final=mean(newinfections_NSP_cumsum(:,size(newinfections_NSP_cumsum,2)),1);

prop_hcvnew_averted_auc_NSP=(newinfections_SQ_auc_final-newinfections_NSP_auc_final)/newinfections_SQ_auc_final;
prop_hcvnew_averted_auc_NSP_CI=prctile((newinfections_SQ_auc-newinfections_NSP_auc)./newinfections_SQ_auc,[2.5  97.5]);

prop_hcvnew_averted_cumsum_NSP=(newinfections_SQ_cumsum_final-newinfections_NSP_cumsum_final)/newinfections_SQ_cumsum_final;
prop_hcvnew_averted_cumsum_NSP_CI=prctile((newinfections_SQ_cumsum(:,size(newinfections_SQ_cumsum,2))-newinfections_NSP_cumsum(:,size(newinfections_NSP_cumsum,2)))./newinfections_SQ_cumsum(:,size(newinfections_SQ_cumsum,2)),[2.5  97.5]);


% OST coverage (all PWID)
tmp4 = NSP_50_2030.PWID_prop_current_OST_all;
NSPscenario_OST_2022 = mean(tmp4(:,ind2022),1);
NSPscenario_OST_2022_CI=prctile(tmp4(:,ind2022),[2.5  97.5]);

NSPscenario_OST_2030 = mean(tmp4(:,ind2030),1);
NSPscenario_OST_2030_CI=prctile(tmp4(:,ind2030),[2.5  97.5]);

% NSPscenario_HCV_OST_coverage_2022_vector=tmp4(:,ind2022);
% NSPscenario_HCV_OST_coverage_2030_vector=tmp4(:,ind2030);

% ART coverage (all PWID)
tmp5 = NSP_50_2030.PWID_prop_current_ART_all;
NSPscenario_ART_2022 = mean(tmp5(:,ind2022),1);
NSPscenario_ART_2022_CI=prctile(tmp5(:,ind2022),[2.5  97.5]);

NSPscenario_ART_2030 = mean(tmp5(:,ind2030),1);
NSPscenario_ART_2030_CI=prctile(tmp5(:,ind2030),[2.5  97.5]);

% NSPscenario_HCV_ART_coverage_2022_vector=tmp5(:,ind2022);
% NSPscenario_OST_HCV_ART_coverage_2030_vector=tmp5(:,ind2030);

clear tmp
clear tmp2
clear tmp3
clear tmp4
clear tmp5


% HCV AB prevalence com
tmp = NSP_50_2030.PWID_HCV_AB_prevalence_com;
HCV_AB_prevalence_com_2022_NSP = mean(tmp(:,ind2022),1);
HCV_AB_prevalence_com_2022_NSP_CI=prctile(tmp(:,ind2022),[2.5  97.5]);

HCV_AB_prevalence_com_2030_NSP = mean(tmp(:,ind2030),1);
HCV_AB_prevalence_com_NSP_CI=prctile(tmp(:,ind2030),[2.5  97.5]);

HCV_AB_prevalence_com_2022_NSP_vector=tmp(:,ind2022);
HCV_AB_prevalence_com_2030_NSP_vector=tmp(:,ind2030);

clear tmp


load([dir,'/NSPART_50_2030.mat']);
% HCV Incidence (all PWID)
tmp = NSPART_50_2030.HCV_Incidence_PWID;
tmp2 = NSPART_50_2030.PWID_HCV_prevalence;
tmp3 = NSPART_50_2030.PWID_pop_size;

NSPART_HCV_inc_2022 = mean(tmp(:,ind2022),1);
NSPART_HCV_inc_2022_CI=prctile(tmp(:,ind2022),[2.5  97.5]);

NSPART_HCV_inc_2030 = mean(tmp(:,ind2030),1);
NSPART_HCV_inc_2030_CI=prctile(tmp(:,ind2030),[2.5  97.5]);


%X.Properties.VariableNames = {'incidence2022_NSPART','incidence2030_NSPART'};
% perc_HCV_red_NSPART = (NSPART_HCV_inc_2022 - NSPART_HCV_inc_2030)/NSPART_HCV_inc_2030*100;
perc_HCV_red_NSPART = mean((tmp(:,ind2022) - tmp(:,ind2030))./tmp(:,ind2022).*100);

perc_HCV_red_NSPART_CI=prctile((tmp(:,ind2022) - tmp(:,ind2030))./tmp(:,ind2022).*100,[2.5  97.5]);

% HCV prevalence (all PWID)
NSPART_HCV_prev_2022 = mean(tmp2(:,ind2022),1);
NSPART_HCV_prev_2022_CI=prctile(tmp2(:,ind2022),[2.5  97.5]);

NSPART_HCV_prev_2030 = mean(tmp2(:,ind2030),1);
NSPART_HCV_prev_2030_CI=prctile(tmp2(:,ind2030),[2.5  97.5]);

% NSPART_HCV_prev_2022_vector=tmp2(:,ind2022);
% NSPART_HCV_prev_2030_vector=tmp2(:,ind2030);

newinfections_NSPART_auc= trapz(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
newinfections_NSPART_auc_final=mean(newinfections_NSPART_auc,1);

newinfections_NSPART_cumsum=cumsum(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
newinfections_NSPART_cumsum_final=mean(newinfections_NSPART_cumsum(:,size(newinfections_NSPART_cumsum,2)),1);

prop_hcvnew_averted_auc_NSPART=(newinfections_SQ_auc_final-newinfections_NSPART_auc_final)/newinfections_SQ_auc_final;
prop_hcvnew_averted_auc_NSPART_CI=prctile((newinfections_SQ_auc-newinfections_NSPART_auc)./newinfections_SQ_auc,[2.5  97.5]);

prop_hcvnew_averted_cumsum_NSPART=(newinfections_SQ_cumsum_final-newinfections_NSPART_cumsum_final)/newinfections_SQ_cumsum_final;
prop_hcvnew_averted_cumsum_NSPART_CI=prctile((newinfections_SQ_cumsum(:,size(newinfections_SQ_cumsum,2))-newinfections_NSPART_cumsum(:,size(newinfections_NSPART_cumsum,2)))./newinfections_SQ_cumsum(:,size(newinfections_SQ_cumsum,2)),[2.5  97.5]);


% OST coverage (all PWID)
tmp4 = NSPART_50_2030.PWID_prop_current_OST_all;
NSPARTscenario_OST_2022 = mean(tmp4(:,ind2022),1);
NSPARTscenario_OST_2022_CI=prctile(tmp4(:,ind2022),[2.5  97.5]);

NSPARTscenario_OST_2030 = mean(tmp4(:,ind2030),1);
NSPARTscenario_OST_2030_CI=prctile(tmp4(:,ind2030),[2.5  97.5]);

% NSPARTscenario_HCV_OST_coverage_2022_vector=tmp4(:,ind2022);
% NSPARTscenario_HCV_OST_coverage_2030_vector=tmp4(:,ind2030);

% ART coverage (all PWID)
tmp5 = NSPART_50_2030.PWID_prop_current_ART_all;
NSPARTscenario_ART_2022 = mean(tmp5(:,ind2022),1);
NSPARTscenario_ART_2022_CI=prctile(tmp5(:,ind2022),[2.5  97.5]);

NSPARTscenario_ART_2030 = mean(tmp5(:,ind2030),1);
NSPARTscenario_ART_2030_CI=prctile(tmp5(:,ind2030),[2.5  97.5]);

% NSPARTscenario_HCV_ART_coverage_2022_vector=tmp5(:,ind2022);
% NSPARTscenario_OST_HCV_ART_coverage_2030_vector=tmp5(:,ind2030);

clear tmp
clear tmp2
clear tmp3
clear tmp4
clear tmp5


% HCV AB prevalence com
tmp = NSPART_50_2030.PWID_HCV_AB_prevalence_com;
HCV_AB_prevalence_com_2022_NSPART = mean(tmp(:,ind2022),1);
HCV_AB_prevalence_com_2022_NSPART_CI=prctile(tmp(:,ind2022),[2.5  97.5]);

HCV_AB_prevalence_com_2030_NSPART = mean(tmp(:,ind2030),1);
HCV_AB_prevalence_com_NSPART_CI=prctile(tmp(:,ind2030),[2.5  97.5]);

HCV_AB_prevalence_com_2022_NSPART_vector=tmp(:,ind2022);
HCV_AB_prevalence_com_2030_NSPART_vector=tmp(:,ind2030);

clear tmp



load([dir,'/NSPOST_50_2030.mat']);
% HCV Incidence (all PWID)
tmp = NSPOST_50_2030.HCV_Incidence_PWID;
tmp2 = NSPOST_50_2030.PWID_HCV_prevalence;
tmp3 = NSPOST_50_2030.PWID_pop_size;

NSPOST_HCV_inc_2022 = mean(tmp(:,ind2022),1);
NSPOST_HCV_inc_2022_CI=prctile(tmp(:,ind2022),[2.5  97.5]);

NSPOST_HCV_inc_2030 = mean(tmp(:,ind2030),1);
NSPOST_HCV_inc_2030_CI=prctile(tmp(:,ind2030),[2.5  97.5]);


%X.Properties.VariableNames = {'incidence2022_NSPOST','incidence2030_NSPOST'};
% perc_HCV_red_NSPOST = (NSPOST_HCV_inc_2022 - NSPOST_HCV_inc_2030)/NSPOST_HCV_inc_2030*100;
perc_HCV_red_NSPOST = mean((tmp(:,ind2022) - tmp(:,ind2030))./tmp(:,ind2022).*100);
perc_HCV_red_NSPOST_CI=prctile((tmp(:,ind2022) - tmp(:,ind2030))./tmp(:,ind2022).*100,[2.5  97.5]);

% HCV prevalence (all PWID)
NSPOST_HCV_prev_2022 = mean(tmp2(:,ind2022),1);
NSPOST_HCV_prev_2022_CI=prctile(tmp2(:,ind2022),[2.5  97.5]);

NSPOST_HCV_prev_2030 = mean(tmp2(:,ind2030),1);
NSPOST_HCV_prev_2030_CI=prctile(tmp2(:,ind2030),[2.5  97.5]);

% NSPOST_HCV_prev_2022_vector=tmp2(:,ind2022);
% NSPOST_HCV_prev_2030_vector=tmp2(:,ind2030);

newinfections_NSPOST_auc= trapz(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
newinfections_NSPOST_auc_final=mean(newinfections_NSPOST_auc,1);

newinfections_NSPOST_cumsum=cumsum(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
newinfections_NSPOST_cumsum_final=mean(newinfections_NSPOST_cumsum(:,size(newinfections_NSPOST_cumsum,2)),1);

prop_hcvnew_averted_auc_NSPOST=(newinfections_SQ_auc_final-newinfections_NSPOST_auc_final)/newinfections_SQ_auc_final;
prop_hcvnew_averted_auc_NSPOST_CI=prctile((newinfections_SQ_auc-newinfections_NSPOST_auc)./newinfections_SQ_auc,[2.5  97.5]);

prop_hcvnew_averted_cumsum_NSPOST=(newinfections_SQ_cumsum_final-newinfections_NSPOST_cumsum_final)/newinfections_SQ_cumsum_final;
prop_hcvnew_averted_cumsum_NSPOST_CI=prctile((newinfections_SQ_cumsum(:,size(newinfections_SQ_cumsum,2))-newinfections_NSPOST_cumsum(:,size(newinfections_NSPOST_cumsum,2)))./newinfections_SQ_cumsum(:,size(newinfections_SQ_cumsum,2)),[2.5  97.5]);


% OST coverage (all PWID)
tmp4 = NSPOST_50_2030.PWID_prop_current_OST_all;
NSPOSTscenario_OST_2022 = mean(tmp4(:,ind2022),1);
NSPOSTscenario_OST_2022_CI=prctile(tmp4(:,ind2022),[2.5  97.5]);

NSPOSTscenario_OST_2030 = mean(tmp4(:,ind2030),1);
NSPOSTscenario_OST_2030_CI=prctile(tmp4(:,ind2030),[2.5  97.5]);

% NSPOSTscenario_HCV_OST_coverage_2022_vector=tmp4(:,ind2022);
% NSPOSTscenario_HCV_OST_coverage_2030_vector=tmp4(:,ind2030);

% ART coverage (all PWID)
tmp5 = NSPOST_50_2030.PWID_prop_current_ART_all;
NSPOSTscenario_ART_2022 = mean(tmp5(:,ind2022),1);
NSPOSTscenario_ART_2022_CI=prctile(tmp5(:,ind2022),[2.5  97.5]);

NSPOSTscenario_ART_2030 = mean(tmp5(:,ind2030),1);
NSPOSTscenario_ART_2030_CI=prctile(tmp5(:,ind2030),[2.5  97.5]);

% NSPOSTscenario_HCV_ART_coverage_2022_vector=tmp5(:,ind2022);
% NSPOSTscenario_OST_HCV_ART_coverage_2030_vector=tmp5(:,ind2030);

clear tmp
clear tmp2
clear tmp3
clear tmp4
clear tmp5

% HCV AB prevalence com
tmp = NSPOST_50_2030.PWID_HCV_AB_prevalence_com;
HCV_AB_prevalence_com_2022_NSPOST = mean(tmp(:,ind2022),1);
HCV_AB_prevalence_com_2022_NSPOST_CI=prctile(tmp(:,ind2022),[2.5  97.5]);

HCV_AB_prevalence_com_2030_NSPOST = mean(tmp(:,ind2030),1);
HCV_AB_prevalence_com_NSPOST_CI=prctile(tmp(:,ind2030),[2.5  97.5]);

HCV_AB_prevalence_com_2022_NSPOST_vector=tmp(:,ind2022);
HCV_AB_prevalence_com_2030_NSPOST_vector=tmp(:,ind2030);

clear tmp


load([dir,'/NSPARTOST_50_2030.mat']);
% HCV Incidence (all PWID)
tmp = NSPARTOST_50_2030.HCV_Incidence_PWID;
tmp2 = NSPARTOST_50_2030.PWID_HCV_prevalence;
tmp3 = NSPARTOST_50_2030.PWID_pop_size;

NSPARTOST_HCV_inc_2022 = mean(tmp(:,ind2022),1);
NSPARTOST_HCV_inc_2022_CI=prctile(tmp(:,ind2022),[2.5  97.5]);

NSPARTOST_HCV_inc_2030 = mean(tmp(:,ind2030),1);
NSPARTOST_HCV_inc_2030_CI=prctile(tmp(:,ind2030),[2.5  97.5]);


%X.Properties.VariableNames = {'incidence2022_NSPARTOST','incidence2030_NSPARTOST'};
% perc_HCV_red_NSPARTOST = (NSPARTOST_HCV_inc_2022 - NSPARTOST_HCV_inc_2030)/NSPARTOST_HCV_inc_2030*100;
perc_HCV_red_NSPARTOST = mean((tmp(:,ind2022) - tmp(:,ind2030))./tmp(:,ind2022).*100);

perc_HCV_red_NSPARTOST_CI=prctile((tmp(:,ind2022) - tmp(:,ind2030))./tmp(:,ind2022).*100,[2.5  97.5]);

% HCV prevalence (all PWID)
NSPARTOST_HCV_prev_2022 = mean(tmp2(:,ind2022),1);
NSPARTOST_HCV_prev_2022_CI=prctile(tmp2(:,ind2022),[2.5  97.5]);

NSPARTOST_HCV_prev_2030 = mean(tmp2(:,ind2030),1);
NSPARTOST_HCV_prev_2030_CI=prctile(tmp2(:,ind2030),[2.5  97.5]);

% NSPARTOST_HCV_prev_2022_vector=tmp2(:,ind2022);
% NSPARTOST_HCV_prev_2030_vector=tmp2(:,ind2030);

newinfections_NSPARTOST_auc= trapz(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
newinfections_NSPARTOST_auc_final=mean(newinfections_NSPARTOST_auc,1);

newinfections_NSPARTOST_cumsum=cumsum(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
newinfections_NSPARTOST_cumsum_final=mean(newinfections_NSPARTOST_cumsum(:,size(newinfections_NSPARTOST_cumsum,2)),1);

prop_hcvnew_averted_auc_NSPARTOST=(newinfections_SQ_auc_final-newinfections_NSPARTOST_auc_final)/newinfections_SQ_auc_final;
prop_hcvnew_averted_auc_NSPARTOST_CI=prctile((newinfections_SQ_auc-newinfections_NSPARTOST_auc)./newinfections_SQ_auc,[2.5  97.5]);

prop_hcvnew_averted_cumsum_NSPARTOST=(newinfections_SQ_cumsum_final-newinfections_NSPARTOST_cumsum_final)/newinfections_SQ_cumsum_final;
prop_hcvnew_averted_cumsum_NSPARTOST_CI=prctile((newinfections_SQ_cumsum(:,size(newinfections_SQ_cumsum,2))-newinfections_NSPARTOST_cumsum(:,size(newinfections_NSPARTOST_cumsum,2)))./newinfections_SQ_cumsum(:,size(newinfections_SQ_cumsum,2)),[2.5  97.5]);


% OST coverage (all PWID)
tmp4 = NSPARTOST_50_2030.PWID_prop_current_OST_all;
NSPARTOSTscenario_OST_2022 = mean(tmp4(:,ind2022),1);
NSPARTOSTscenario_OST_2022_CI=prctile(tmp4(:,ind2022),[2.5  97.5]);

NSPARTOSTscenario_OST_2030 = mean(tmp4(:,ind2030),1);
NSPARTOSTscenario_OST_2030_CI=prctile(tmp4(:,ind2030),[2.5  97.5]);

% NSPARTOSTscenario_HCV_OST_coverage_2022_vector=tmp4(:,ind2022);
% NSPARTOSTscenario_HCV_OST_coverage_2030_vector=tmp4(:,ind2030);

% ART coverage (all PWID)
tmp5 = NSPARTOST_50_2030.PWID_prop_current_ART_all;
NSPARTOSTscenario_ART_2022 = mean(tmp5(:,ind2022),1);
NSPARTOSTscenario_ART_2022_CI=prctile(tmp5(:,ind2022),[2.5  97.5]);

NSPARTOSTscenario_ART_2030 = mean(tmp5(:,ind2030),1);
NSPARTOSTscenario_ART_2030_CI=prctile(tmp5(:,ind2030),[2.5  97.5]);

% NSPARTOSTscenario_HCV_ART_coverage_2022_vector=tmp5(:,ind2022);
% NSPARTOSTscenario_OST_HCV_ART_coverage_2030_vector=tmp5(:,ind2030);

clear tmp
clear tmp2
clear tmp3
clear tmp4
clear tmp5



% HCV AB prevalence com
tmp = NSPARTOST_50_2030.PWID_HCV_AB_prevalence_com;
HCV_AB_prevalence_com_2022_NSPARTOST = mean(tmp(:,ind2022),1);
HCV_AB_prevalence_com_2022_NSPARTOST_CI=prctile(tmp(:,ind2022),[2.5  97.5]);

HCV_AB_prevalence_com_2030_NSPARTOST = mean(tmp(:,ind2030),1);
HCV_AB_prevalence_com_NSPARTOST_CI=prctile(tmp(:,ind2030),[2.5  97.5]);

HCV_AB_prevalence_com_2022_NSPARTOST_vector=tmp(:,ind2022);
HCV_AB_prevalence_com_2030_NSPARTOST_vector=tmp(:,ind2030);

clear tmp


% Variables_names={'HCV incidence  2022' ;'HCV incidence  2030' ;'HCV prevalence  2022';'HCV prevalence  2030';'percentage HCV reduction';'Coverage in 2022' ;'Coverage in 2030'};
% ART_scenario=[HCV_inc_2022 ;HCV_inc_2030 ;HCV_prev_2022_ART;HCV_prev_2030_ART;perc_HCV_red_ART;ART_2022;ART_2030];
% OST_scenario=[HCV_inc_2022_2 ;HCV_inc_2030_2 ;HCV_prev_2022_OST;HCV_prev_2030_OST;perc_HCV_red_OST;OST_2022;OST_2030];
% 
% T = table(Variables_names,ART_scenario,OST_scenario);
% Filename = [outputfolder,'/1.summarytable_', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T,Filename)
% 
% 
% HCV_inc_2022_withCI=join(horzcat(round(HCV_inc_2022,3)," [95%CI:", round(HCV_inc_2022_CI(1),3),"-",round(HCV_inc_2022_CI(2),3),"]"));
% HCV_inc_2030_withCI=join(horzcat(round(HCV_inc_2030,3)," [95%CI:", round(HCV_inc_2030_CI(1),3),"-",round(HCV_inc_2030_CI(2),3),"]"));
% HCV_prev_2022_ART_withCI=join(horzcat(round(HCV_prev_2022_ART,3)," [95%CI:", round(HCV_prev_2022_ART_CI(1),3),"-",round(HCV_prev_2022_ART_CI(2),3),"]"));
% HCV_prev_2030_ART_withCI=join(horzcat(round(HCV_prev_2030_ART,3)," [95%CI:", round(HCV_prev_2030_ART_CI(1),3),"-",round(HCV_prev_2030_ART_CI(2),3),"]"));
% perc_HCV_red_ART_withCI=join(horzcat(round(perc_HCV_red_ART,3)," [95%CI:", round(perc_HCV_red_ART_CI(1),3),"-",round(perc_HCV_red_ART_CI(2),3),"]"));
% ART_2022_withCI=join(horzcat(round(ART_2022,3)," [95%CI:", round(ART_2022_CI(1),3),"-",round(ART_2022_CI(2),3),"]"));
% ART_2030_withCI=join(horzcat(round(ART_2030,3)," [95%CI:", round(ART_2030_CI(1),3),"-",round(ART_2030_CI(2),3),"]"));
% HCV_inc_2022_2_withCI=join(horzcat(round(HCV_inc_2022_2,3)," [95%CI:", round(HCV_inc_2022_2_CI(1),3),"-",round(HCV_inc_2022_2_CI(2),3),"]"));
% HCV_inc_2030_2_withCI=join(horzcat(round(HCV_inc_2030_2,3)," [95%CI:", round(HCV_inc_2030_2_CI(1),3),"-",round(HCV_inc_2030_2_CI(2),3),"]"));
% HCV_prev_2022_OST_withCI=join(horzcat(round(HCV_prev_2022_OST,3)," [95%CI:", round(HCV_prev_2022_OST_CI(1),3),"-",round(HCV_prev_2022_OST_CI(2),3),"]"));
% HCV_prev_2030_OST_withCI=join(horzcat(round(HCV_prev_2030_OST,3)," [95%CI:", round(HCV_prev_2030_OST_CI(1),3),"-",round(HCV_prev_2030_OST_CI(2),3),"]"));
% perc_HCV_red_OST_withCI=join(horzcat(round(perc_HCV_red_OST,3)," [95%CI:", round(perc_HCV_red_OST_CI(1),3),"-",round(perc_HCV_red_OST_CI(2),3),"]"));
% OST_2022_withCI=join(horzcat(round(OST_2022,3)," [95%CI:", round(OST_2022_CI(1),3),"-",round(OST_2022_CI(2),3),"]"));
% OST_2030_withCI=join(horzcat(round(OST_2030,3)," [95%CI:", round(OST_2030_CI(1),3),"-",round(OST_2030_CI(2),3),"]"));
% 
% 
% 
% Variables_names2={'HCV incidence  2022' ;'HCV incidence  2030' ;'HCV prevalence  2022';'HCV prevalence  2030';'percentage HCV reduction';'Coverage in 2022' ;'Coverage in 2030'};
% ART_scenario_withCI=[HCV_inc_2022_withCI ;HCV_inc_2030_withCI ;HCV_prev_2022_ART_withCI;HCV_prev_2030_ART_withCI;perc_HCV_red_ART_withCI;ART_2022_withCI;ART_2030_withCI];
% OST_scenario_withCI=[HCV_inc_2022_2_withCI ;HCV_inc_2030_2_withCI ;HCV_prev_2022_OST_withCI;HCV_prev_2030_OST_withCI;perc_HCV_red_OST_withCI;OST_2022_withCI;OST_2030_withCI];
% 
% T2 = table(Variables_names2,ART_scenario_withCI,OST_scenario_withCI);
% Filename2 = [outputfolder,'/1.summarytable2_', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T2,Filename2)


%%%%%%% SQ TABLE   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SQ_HCV_inc_2022_withCI=join(horzcat(round(SQ_HCV_inc_2022,3)," [95%CI:", round(SQ_HCV_inc_2022_CI(1),3),"-",round(SQ_HCV_inc_2022_CI(2),3),"]"));
SQ_HCV_inc_2030_withCI=join(horzcat(round(SQ_HCV_inc_2030,3)," [95%CI:", round(SQ_HCV_inc_2030_CI(1),3),"-",round(SQ_HCV_inc_2030_CI(2),3),"]"));
SQ_HCV_prev_2022_withCI=join(horzcat(round(SQ_HCV_prev_2022,3)," [95%CI:", round(SQ_HCV_prev_2022_CI(1),3),"-",round(SQ_HCV_prev_2022_CI(2),3),"]"));
SQ_HCV_prev_2030_withCI=join(horzcat(round(SQ_HCV_prev_2030,3)," [95%CI:", round(SQ_HCV_prev_2030_CI(1),3),"-",round(SQ_HCV_prev_2030_CI(2),3),"]"));
SQ_perc_HCV_red_withCI=join(horzcat(round(perc_HCV_red_SQ,3)," [95%CI:", round(perc_HCV_red_SQ_CI(1),3),"-",round(perc_HCV_red_SQ_CI(2),3),"]"));
SQ_ART_2022_withCI=join(horzcat(round(SQscenario_ART_2022,3)," [95%CI:", round(SQscenario_ART_2022_CI(1),3),"-",round(SQscenario_ART_2022_CI(2),3),"]"));
SQ_ART_2030_withCI=join(horzcat(round(SQscenario_ART_2030,3)," [95%CI:", round(SQscenario_ART_2030_CI(1),3),"-",round(SQscenario_ART_2030_CI(2),3),"]"));
SQ_OST_2022_withCI=join(horzcat(round(SQscenario_OST_2022,3)," [95%CI:", round(SQscenario_OST_2022_CI(1),3),"-",round(SQscenario_OST_2022_CI(2),3),"]"));
SQ_OST_2030_withCI=join(horzcat(round(SQscenario_OST_2030,3)," [95%CI:", round(SQscenario_OST_2030_CI(1),3),"-",round(SQscenario_OST_2030_CI(2),3),"]"));

prop_hcvnew_averted_cumsum_SQ_CI_final=" 0[95%CI:0-0]";


HCV_AB_prevalence_com_2022_SQscenario_withCI=join(horzcat(round(HCV_AB_prevalence_com_2022_SQscenario,3)," [95%CI:", round(HCV_AB_prevalence_com_2022_SQscenario_CI(1),3),"-",round(HCV_AB_prevalence_com_2022_SQscenario_CI(2),3),"]"));
HCV_AB_prevalence_com_2030_SQscenario_withCI=join(horzcat(round(HCV_AB_prevalence_com_2022_SQscenario,3)," [95%CI:", round(HCV_AB_prevalence_com_2022_SQscenario_CI(1),3),"-",round(HCV_AB_prevalence_com_2022_SQscenario_CI(2),3),"]"));


Variables_names2={'HCV Ab prevalence com  2022' ; 'HCV Ab prevalence com  2030' ;'HCV incidence  2022' ;'HCV incidence  2030' ;'HCV prevalence  2022';'HCV prevalence  2030';'percentage HCV reduction';'ART Coverage in 2022' ;'ART Coverage in 2030';'OST Coverage in 2022' ;'OST Coverage in 2030';'HCV infection averted'};
SQ_scenario_withCI=[HCV_AB_prevalence_com_2022_SQscenario_withCI ;HCV_AB_prevalence_com_2030_SQscenario_withCI; SQ_HCV_inc_2022_withCI ;SQ_HCV_inc_2030_withCI ;SQ_HCV_prev_2022_withCI;SQ_HCV_prev_2030_withCI;SQ_perc_HCV_red_withCI;SQ_ART_2022_withCI;SQ_ART_2030_withCI;SQ_OST_2022_withCI;SQ_OST_2030_withCI;prop_hcvnew_averted_cumsum_SQ_CI_final];

T10SQ = table(Variables_names2,SQ_scenario_withCI);
Filename2 = [outputfolder,'/1b.summarytable2.HCV_SQ_', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T10SQ,Filename2)









%%%%%%% ART TABLE   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ART_HCV_inc_2022_withCI=join(horzcat(round(ART_HCV_inc_2022,3)," [95%CI:", round(ART_HCV_inc_2022_CI(1),3),"-",round(ART_HCV_inc_2022_CI(2),3),"]"));
ART_HCV_inc_2030_withCI=join(horzcat(round(ART_HCV_inc_2030,3)," [95%CI:", round(ART_HCV_inc_2030_CI(1),3),"-",round(ART_HCV_inc_2030_CI(2),3),"]"));
ART_HCV_prev_2022_withCI=join(horzcat(round(ART_HCV_prev_2022,3)," [95%CI:", round(ART_HCV_prev_2022_CI(1),3),"-",round(ART_HCV_prev_2022_CI(2),3),"]"));
ART_HCV_prev_2030_withCI=join(horzcat(round(ART_HCV_prev_2030,3)," [95%CI:", round(ART_HCV_prev_2030_CI(1),3),"-",round(ART_HCV_prev_2030_CI(2),3),"]"));
ART_perc_HCV_red_withCI=join(horzcat(round(perc_HCV_red_ART,3)," [95%CI:", round(perc_HCV_red_ART_CI(1),3),"-",round(perc_HCV_red_ART_CI(2),3),"]"));
ART_ART_2022_withCI=join(horzcat(round(ARTscenario_ART_2022,3)," [95%CI:", round(ARTscenario_ART_2022_CI(1),3),"-",round(ARTscenario_ART_2022_CI(2),3),"]"));
ART_ART_2030_withCI=join(horzcat(round(ARTscenario_ART_2030,3)," [95%CI:", round(ARTscenario_ART_2030_CI(1),3),"-",round(ARTscenario_ART_2030_CI(2),3),"]"));
ART_OST_2022_withCI=join(horzcat(round(ARTscenario_OST_2022,3)," [95%CI:", round(ARTscenario_OST_2022_CI(1),3),"-",round(ARTscenario_OST_2022_CI(2),3),"]"));
ART_OST_2030_withCI=join(horzcat(round(ARTscenario_OST_2030,3)," [95%CI:", round(ARTscenario_OST_2030_CI(1),3),"-",round(ARTscenario_OST_2030_CI(2),3),"]"));

prop_hcvnew_averted_cumsum_ART_CI_final=join(horzcat(100*round(prop_hcvnew_averted_cumsum_ART,3)," [95%CI:", 100*round(prop_hcvnew_averted_cumsum_ART_CI(1),3),"-",100*round(prop_hcvnew_averted_cumsum_ART_CI(2),3),"]"));

HCV_AB_prevalence_com_2022_ART_withCI=join(horzcat(round(HCV_AB_prevalence_com_2022_ART,3)," [95%CI:", round(HCV_AB_prevalence_com_2022_ART_CI(1),3),"-",round(HCV_AB_prevalence_com_2022_ART_CI(2),3),"]"));
HCV_AB_prevalence_com_2030_ART_withCI=join(horzcat(round(HCV_AB_prevalence_com_2022_ART,3)," [95%CI:", round(HCV_AB_prevalence_com_2022_ART_CI(1),3),"-",round(HCV_AB_prevalence_com_2022_ART_CI(2),3),"]"));



Variables_names2={'HCV Ab prevalence com  2022' ; 'HCV Ab prevalence com  2030' ; 'HCV incidence  2022' ;'HCV incidence  2030' ;'HCV prevalence  2022';'HCV prevalence  2030';'percentage HCV reduction';'ART Coverage in 2022' ;'ART Coverage in 2030';'OST Coverage in 2022' ;'OST Coverage in 2030';'HCV infection averted'};
ART_scenario_withCI=[HCV_AB_prevalence_com_2022_ART_withCI ;HCV_AB_prevalence_com_2030_ART_withCI; ART_HCV_inc_2022_withCI ;ART_HCV_inc_2030_withCI ;ART_HCV_prev_2022_withCI;ART_HCV_prev_2030_withCI;ART_perc_HCV_red_withCI;ART_ART_2022_withCI;ART_ART_2030_withCI;ART_OST_2022_withCI;ART_OST_2030_withCI;prop_hcvnew_averted_cumsum_ART_CI_final];

T10ART = table(Variables_names2,ART_scenario_withCI);
Filename2 = [outputfolder,'/1b.summarytable2.HCV_ART_', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T10ART,Filename2)




%%%%%%% OST TABLE   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

OST_HCV_inc_2022_withCI=join(horzcat(round(OST_HCV_inc_2022,3)," [95%CI:", round(OST_HCV_inc_2022_CI(1),3),"-",round(OST_HCV_inc_2022_CI(2),3),"]"));
OST_HCV_inc_2030_withCI=join(horzcat(round(OST_HCV_inc_2030,3)," [95%CI:", round(OST_HCV_inc_2030_CI(1),3),"-",round(OST_HCV_inc_2030_CI(2),3),"]"));
OST_HCV_prev_2022_withCI=join(horzcat(round(OST_HCV_prev_2022,3)," [95%CI:", round(OST_HCV_prev_2022_CI(1),3),"-",round(OST_HCV_prev_2022_CI(2),3),"]"));
OST_HCV_prev_2030_withCI=join(horzcat(round(OST_HCV_prev_2030,3)," [95%CI:", round(OST_HCV_prev_2030_CI(1),3),"-",round(OST_HCV_prev_2030_CI(2),3),"]"));
OST_perc_HCV_red_withCI=join(horzcat(round(perc_HCV_red_OST,3)," [95%CI:", round(perc_HCV_red_OST_CI(1),3),"-",round(perc_HCV_red_OST_CI(2),3),"]"));
OST_ART_2022_withCI=join(horzcat(round(OSTscenario_ART_2022,3)," [95%CI:", round(OSTscenario_ART_2022_CI(1),3),"-",round(OSTscenario_ART_2022_CI(2),3),"]"));
OST_ART_2030_withCI=join(horzcat(round(OSTscenario_ART_2030,3)," [95%CI:", round(OSTscenario_ART_2030_CI(1),3),"-",round(OSTscenario_ART_2030_CI(2),3),"]"));
OST_OST_2022_withCI=join(horzcat(round(OSTscenario_OST_2022,3)," [95%CI:", round(OSTscenario_OST_2022_CI(1),3),"-",round(OSTscenario_OST_2022_CI(2),3),"]"));
OST_OST_2030_withCI=join(horzcat(round(OSTscenario_OST_2030,3)," [95%CI:", round(OSTscenario_OST_2030_CI(1),3),"-",round(OSTscenario_OST_2030_CI(2),3),"]"));

prop_hcvnew_averted_cumsum_OST_CI_final=join(horzcat(100*round(prop_hcvnew_averted_cumsum_OST,3)," [95%CI:", 100*round(prop_hcvnew_averted_cumsum_OST_CI(1),3),"-",100*round(prop_hcvnew_averted_cumsum_OST_CI(2),3),"]"));

HCV_AB_prevalence_com_2022_OST_withCI=join(horzcat(round(HCV_AB_prevalence_com_2022_OST,3)," [95%CI:", round(HCV_AB_prevalence_com_2022_OST_CI(1),3),"-",round(HCV_AB_prevalence_com_2022_OST_CI(2),3),"]"));
HCV_AB_prevalence_com_2030_OST_withCI=join(horzcat(round(HCV_AB_prevalence_com_2022_OST,3)," [95%CI:", round(HCV_AB_prevalence_com_2022_OST_CI(1),3),"-",round(HCV_AB_prevalence_com_2022_OST_CI(2),3),"]"));


Variables_names2={'HCV Ab prevalence com  2022' ; 'HCV Ab prevalence com  2030' ; 'HCV incidence  2022' ;'HCV incidence  2030' ;'HCV prevalence  2022';'HCV prevalence  2030';'percentage HCV reduction';'ART Coverage in 2022' ;'ART Coverage in 2030';'OST Coverage in 2022' ;'OST Coverage in 2030';'HCV infection averted'};
OST_scenario_withCI=[HCV_AB_prevalence_com_2022_OST_withCI ;HCV_AB_prevalence_com_2030_OST_withCI;OST_HCV_inc_2022_withCI ;OST_HCV_inc_2030_withCI ;OST_HCV_prev_2022_withCI;OST_HCV_prev_2030_withCI;OST_perc_HCV_red_withCI;OST_ART_2022_withCI;OST_ART_2030_withCI;OST_OST_2022_withCI;OST_OST_2030_withCI;prop_hcvnew_averted_cumsum_OST_CI_final];

T10OST = table(Variables_names2,OST_scenario_withCI);
Filename2 = [outputfolder,'/1b.summarytable2.HCV_OST_', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T10OST,Filename2)


%%%%%%% NSP TABLE   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NSP_HCV_inc_2022_withCI=join(horzcat(round(NSP_HCV_inc_2022,3)," [95%CI:", round(NSP_HCV_inc_2022_CI(1),3),"-",round(NSP_HCV_inc_2022_CI(2),3),"]"));
NSP_HCV_inc_2030_withCI=join(horzcat(round(NSP_HCV_inc_2030,3)," [95%CI:", round(NSP_HCV_inc_2030_CI(1),3),"-",round(NSP_HCV_inc_2030_CI(2),3),"]"));
NSP_HCV_prev_2022_withCI=join(horzcat(round(NSP_HCV_prev_2022,3)," [95%CI:", round(NSP_HCV_prev_2022_CI(1),3),"-",round(NSP_HCV_prev_2022_CI(2),3),"]"));
NSP_HCV_prev_2030_withCI=join(horzcat(round(NSP_HCV_prev_2030,3)," [95%CI:", round(NSP_HCV_prev_2030_CI(1),3),"-",round(NSP_HCV_prev_2030_CI(2),3),"]"));
NSP_perc_HCV_red_withCI=join(horzcat(round(perc_HCV_red_NSP,3)," [95%CI:", round(perc_HCV_red_NSP_CI(1),3),"-",round(perc_HCV_red_NSP_CI(2),3),"]"));
NSP_ART_2022_withCI=join(horzcat(round(NSPscenario_ART_2022,3)," [95%CI:", round(NSPscenario_ART_2022_CI(1),3),"-",round(NSPscenario_ART_2022_CI(2),3),"]"));
NSP_ART_2030_withCI=join(horzcat(round(NSPscenario_ART_2030,3)," [95%CI:", round(NSPscenario_ART_2030_CI(1),3),"-",round(NSPscenario_ART_2030_CI(2),3),"]"));
NSP_OST_2022_withCI=join(horzcat(round(NSPscenario_OST_2022,3)," [95%CI:", round(NSPscenario_OST_2022_CI(1),3),"-",round(NSPscenario_OST_2022_CI(2),3),"]"));
NSP_OST_2030_withCI=join(horzcat(round(NSPscenario_OST_2030,3)," [95%CI:", round(NSPscenario_OST_2030_CI(1),3),"-",round(NSPscenario_OST_2030_CI(2),3),"]"));

prop_hcvnew_averted_cumsum_NSP_CI_final=join(horzcat(100*round(prop_hcvnew_averted_cumsum_NSP,3)," [95%CI:", 100*round(prop_hcvnew_averted_cumsum_NSP_CI(1),3),"-",100*round(prop_hcvnew_averted_cumsum_NSP_CI(2),3),"]"));

HCV_AB_prevalence_com_2022_NSP_withCI=join(horzcat(round(HCV_AB_prevalence_com_2022_NSP,3)," [95%CI:", round(HCV_AB_prevalence_com_2022_NSP_CI(1),3),"-",round(HCV_AB_prevalence_com_2022_NSP_CI(2),3),"]"));
HCV_AB_prevalence_com_2030_NSP_withCI=join(horzcat(round(HCV_AB_prevalence_com_2022_NSP,3)," [95%CI:", round(HCV_AB_prevalence_com_2022_NSP_CI(1),3),"-",round(HCV_AB_prevalence_com_2022_NSP_CI(2),3),"]"));


Variables_names2={'HCV Ab prevalence com  2022' ; 'HCV Ab prevalence com  2030' ; 'HCV incidence  2022' ;'HCV incidence  2030' ;'HCV prevalence  2022';'HCV prevalence  2030';'percentage HCV reduction';'ART Coverage in 2022' ;'ART Coverage in 2030';'OST Coverage in 2022' ;'OST Coverage in 2030';'HCV infection averted'};
NSP_scenario_withCI=[HCV_AB_prevalence_com_2022_NSP_withCI ;HCV_AB_prevalence_com_2030_NSP_withCI;NSP_HCV_inc_2022_withCI ;NSP_HCV_inc_2030_withCI ;NSP_HCV_prev_2022_withCI;NSP_HCV_prev_2030_withCI;NSP_perc_HCV_red_withCI;NSP_ART_2022_withCI;NSP_ART_2030_withCI;NSP_OST_2022_withCI;NSP_OST_2030_withCI;prop_hcvnew_averted_cumsum_NSP_CI_final];

T10NSP = table(Variables_names2,NSP_scenario_withCI);
Filename2 = [outputfolder,'/1b.summarytable2.HCV_NSP_', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T10NSP,Filename2)




%%%%%%% ARTOST TABLE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ARTOST_HCV_inc_2022_withCI=join(horzcat(round(ARTOST_HCV_inc_2022,3)," [95%CI:", round(ARTOST_HCV_inc_2022_CI(1),3),"-",round(ARTOST_HCV_inc_2022_CI(2),3),"]"));
ARTOST_HCV_inc_2030_withCI=join(horzcat(round(ARTOST_HCV_inc_2030,3)," [95%CI:", round(ARTOST_HCV_inc_2030_CI(1),3),"-",round(ARTOST_HCV_inc_2030_CI(2),3),"]"));
ARTOST_HCV_prev_2022_withCI=join(horzcat(round(ARTOST_HCV_prev_2022,3)," [95%CI:", round(ARTOST_HCV_prev_2022_CI(1),3),"-",round(ARTOST_HCV_prev_2022_CI(2),3),"]"));
ARTOST_HCV_prev_2030_withCI=join(horzcat(round(ARTOST_HCV_prev_2030,3)," [95%CI:", round(ARTOST_HCV_prev_2030_CI(1),3),"-",round(ARTOST_HCV_prev_2030_CI(2),3),"]"));
ARTOST_perc_HCV_red_withCI=join(horzcat(round(perc_HCV_red_ARTOST,3)," [95%CI:", round(perc_HCV_red_ARTOST_CI(1),3),"-",round(perc_HCV_red_ARTOST_CI(2),3),"]"));
ARTOST_ART_2022_withCI=join(horzcat(round(ARTOSTscenario_ART_2022,3)," [95%CI:", round(ARTOSTscenario_ART_2022_CI(1),3),"-",round(ARTOSTscenario_ART_2022_CI(2),3),"]"));
ARTOST_ART_2030_withCI=join(horzcat(round(ARTOSTscenario_ART_2030,3)," [95%CI:", round(ARTOSTscenario_ART_2030_CI(1),3),"-",round(ARTOSTscenario_ART_2030_CI(2),3),"]"));
ARTOST_OST_2022_withCI=join(horzcat(round(ARTOSTscenario_OST_2022,3)," [95%CI:", round(ARTOSTscenario_OST_2022_CI(1),3),"-",round(ARTOSTscenario_OST_2022_CI(2),3),"]"));
ARTOST_OST_2030_withCI=join(horzcat(round(ARTOSTscenario_OST_2030,3)," [95%CI:", round(ARTOSTscenario_OST_2030_CI(1),3),"-",round(ARTOSTscenario_OST_2030_CI(2),3),"]"));

prop_hcvnew_averted_cumsum_ARTOST_CI_final=join(horzcat(100*round(prop_hcvnew_averted_cumsum_ARTOST,3)," [95%CI:", 100*round(prop_hcvnew_averted_cumsum_ARTOST_CI(1),3),"-",100*round(prop_hcvnew_averted_cumsum_ARTOST_CI(2),3),"]"));

HCV_AB_prevalence_com_2022_ARTOST_withCI=join(horzcat(round(HCV_AB_prevalence_com_2022_ARTOST,3)," [95%CI:", round(HCV_AB_prevalence_com_2022_ARTOST_CI(1),3),"-",round(HCV_AB_prevalence_com_2022_ARTOST_CI(2),3),"]"));
HCV_AB_prevalence_com_2030_ARTOST_withCI=join(horzcat(round(HCV_AB_prevalence_com_2022_ARTOST,3)," [95%CI:", round(HCV_AB_prevalence_com_2022_ARTOST_CI(1),3),"-",round(HCV_AB_prevalence_com_2022_ARTOST_CI(2),3),"]"));

Variables_names2={'HCV Ab prevalence com  2022' ; 'HCV Ab prevalence com  2030' ; 'HCV incidence  2022' ;'HCV incidence  2030' ;'HCV prevalence  2022';'HCV prevalence  2030';'percentage HCV reduction';'ART Coverage in 2022' ;'ART Coverage in 2030';'OST Coverage in 2022' ;'OST Coverage in 2030';'HCV infection averted'};
ARTOST_scenario_withCI=[HCV_AB_prevalence_com_2022_ARTOST_withCI ;HCV_AB_prevalence_com_2030_ARTOST_withCI;ARTOST_HCV_inc_2022_withCI ;ARTOST_HCV_inc_2030_withCI ;ARTOST_HCV_prev_2022_withCI;ARTOST_HCV_prev_2030_withCI;ARTOST_perc_HCV_red_withCI;ARTOST_ART_2022_withCI;ARTOST_ART_2030_withCI;ARTOST_OST_2022_withCI;ARTOST_OST_2030_withCI;prop_hcvnew_averted_cumsum_ARTOST_CI_final];

T10ARTOST = table(Variables_names2,ARTOST_scenario_withCI);
Filename2 = [outputfolder,'/1b.summarytable2.HCV_ARTOST_', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T10ARTOST,Filename2)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%% NSPART TABLE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NSPART_HCV_inc_2022_withCI=join(horzcat(round(NSPART_HCV_inc_2022,3)," [95%CI:", round(NSPART_HCV_inc_2022_CI(1),3),"-",round(NSPART_HCV_inc_2022_CI(2),3),"]"));
NSPART_HCV_inc_2030_withCI=join(horzcat(round(NSPART_HCV_inc_2030,3)," [95%CI:", round(NSPART_HCV_inc_2030_CI(1),3),"-",round(NSPART_HCV_inc_2030_CI(2),3),"]"));
NSPART_HCV_prev_2022_withCI=join(horzcat(round(NSPART_HCV_prev_2022,3)," [95%CI:", round(NSPART_HCV_prev_2022_CI(1),3),"-",round(NSPART_HCV_prev_2022_CI(2),3),"]"));
NSPART_HCV_prev_2030_withCI=join(horzcat(round(NSPART_HCV_prev_2030,3)," [95%CI:", round(NSPART_HCV_prev_2030_CI(1),3),"-",round(NSPART_HCV_prev_2030_CI(2),3),"]"));
NSPART_perc_HCV_red_withCI=join(horzcat(round(perc_HCV_red_NSPART,3)," [95%CI:", round(perc_HCV_red_NSPART_CI(1),3),"-",round(perc_HCV_red_NSPART_CI(2),3),"]"));
NSPART_ART_2022_withCI=join(horzcat(round(NSPARTscenario_ART_2022,3)," [95%CI:", round(NSPARTscenario_ART_2022_CI(1),3),"-",round(NSPARTscenario_ART_2022_CI(2),3),"]"));
NSPART_ART_2030_withCI=join(horzcat(round(NSPARTscenario_ART_2030,3)," [95%CI:", round(NSPARTscenario_ART_2030_CI(1),3),"-",round(NSPARTscenario_ART_2030_CI(2),3),"]"));
NSPART_OST_2022_withCI=join(horzcat(round(NSPARTscenario_OST_2022,3)," [95%CI:", round(NSPARTscenario_OST_2022_CI(1),3),"-",round(NSPARTscenario_OST_2022_CI(2),3),"]"));
NSPART_OST_2030_withCI=join(horzcat(round(NSPARTscenario_OST_2030,3)," [95%CI:", round(NSPARTscenario_OST_2030_CI(1),3),"-",round(NSPARTscenario_OST_2030_CI(2),3),"]"));

prop_hcvnew_averted_cumsum_NSPART_CI_final=join(horzcat(100*round(prop_hcvnew_averted_cumsum_NSPART,3)," [95%CI:", 100*round(prop_hcvnew_averted_cumsum_NSPART_CI(1),3),"-",100*round(prop_hcvnew_averted_cumsum_NSPART_CI(2),3),"]"));

HCV_AB_prevalence_com_2022_NSPART_withCI=join(horzcat(round(HCV_AB_prevalence_com_2022_NSPART,3)," [95%CI:", round(HCV_AB_prevalence_com_2022_NSPART_CI(1),3),"-",round(HCV_AB_prevalence_com_2022_NSPART_CI(2),3),"]"));
HCV_AB_prevalence_com_2030_NSPART_withCI=join(horzcat(round(HCV_AB_prevalence_com_2022_NSPART,3)," [95%CI:", round(HCV_AB_prevalence_com_2022_NSPART_CI(1),3),"-",round(HCV_AB_prevalence_com_2022_NSPART_CI(2),3),"]"));


Variables_names2={'HCV Ab prevalence com  2022' ; 'HCV Ab prevalence com  2030' ; 'HCV incidence  2022' ;'HCV incidence  2030' ;'HCV prevalence  2022';'HCV prevalence  2030';'percentage HCV reduction';'ART Coverage in 2022' ;'ART Coverage in 2030';'OST Coverage in 2022' ;'OST Coverage in 2030';'HCV infection averted'};
NSPART_scenario_withCI=[HCV_AB_prevalence_com_2022_NSPART_withCI;HCV_AB_prevalence_com_2030_NSPART_withCI; NSPART_HCV_inc_2022_withCI ;NSPART_HCV_inc_2030_withCI ;NSPART_HCV_prev_2022_withCI;NSPART_HCV_prev_2030_withCI;NSPART_perc_HCV_red_withCI;NSPART_ART_2022_withCI;NSPART_ART_2030_withCI;NSPART_OST_2022_withCI;NSPART_OST_2030_withCI;prop_hcvnew_averted_cumsum_NSPART_CI_final];

T10NSPART = table(Variables_names2,NSPART_scenario_withCI);
Filename2 = [outputfolder,'/1b.summarytable2.HCV_NSPART_', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T10NSPART,Filename2)



%%%%%%% NSPOST TABLE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NSPOST_HCV_inc_2022_withCI=join(horzcat(round(NSPOST_HCV_inc_2022,3)," [95%CI:", round(NSPOST_HCV_inc_2022_CI(1),3),"-",round(NSPOST_HCV_inc_2022_CI(2),3),"]"));
NSPOST_HCV_inc_2030_withCI=join(horzcat(round(NSPOST_HCV_inc_2030,3)," [95%CI:", round(NSPOST_HCV_inc_2030_CI(1),3),"-",round(NSPOST_HCV_inc_2030_CI(2),3),"]"));
NSPOST_HCV_prev_2022_withCI=join(horzcat(round(NSPOST_HCV_prev_2022,3)," [95%CI:", round(NSPOST_HCV_prev_2022_CI(1),3),"-",round(NSPOST_HCV_prev_2022_CI(2),3),"]"));
NSPOST_HCV_prev_2030_withCI=join(horzcat(round(NSPOST_HCV_prev_2030,3)," [95%CI:", round(NSPOST_HCV_prev_2030_CI(1),3),"-",round(NSPOST_HCV_prev_2030_CI(2),3),"]"));
NSPOST_perc_HCV_red_withCI=join(horzcat(round(perc_HCV_red_NSPOST,3)," [95%CI:", round(perc_HCV_red_NSPOST_CI(1),3),"-",round(perc_HCV_red_NSPOST_CI(2),3),"]"));
NSPOST_ART_2022_withCI=join(horzcat(round(NSPOSTscenario_ART_2022,3)," [95%CI:", round(NSPOSTscenario_ART_2022_CI(1),3),"-",round(NSPOSTscenario_ART_2022_CI(2),3),"]"));
NSPOST_ART_2030_withCI=join(horzcat(round(NSPOSTscenario_ART_2030,3)," [95%CI:", round(NSPOSTscenario_ART_2030_CI(1),3),"-",round(NSPOSTscenario_ART_2030_CI(2),3),"]"));
NSPOST_OST_2022_withCI=join(horzcat(round(NSPOSTscenario_OST_2022,3)," [95%CI:", round(NSPOSTscenario_OST_2022_CI(1),3),"-",round(NSPOSTscenario_OST_2022_CI(2),3),"]"));
NSPOST_OST_2030_withCI=join(horzcat(round(NSPOSTscenario_OST_2030,3)," [95%CI:", round(NSPOSTscenario_OST_2030_CI(1),3),"-",round(NSPOSTscenario_OST_2030_CI(2),3),"]"));

prop_hcvnew_averted_cumsum_NSPOST_CI_final=join(horzcat(100*round(prop_hcvnew_averted_cumsum_NSPOST,3)," [95%CI:", 100*round(prop_hcvnew_averted_cumsum_NSPOST_CI(1),3),"-",100*round(prop_hcvnew_averted_cumsum_NSPOST_CI(2),3),"]"));

HCV_AB_prevalence_com_2022_NSPOST_withCI=join(horzcat(round(HCV_AB_prevalence_com_2022_NSPOST,3)," [95%CI:", round(HCV_AB_prevalence_com_2022_NSPOST_CI(1),3),"-",round(HCV_AB_prevalence_com_2022_NSPOST_CI(2),3),"]"));
HCV_AB_prevalence_com_2030_NSPOST_withCI=join(horzcat(round(HCV_AB_prevalence_com_2022_NSPOST,3)," [95%CI:", round(HCV_AB_prevalence_com_2022_NSPOST_CI(1),3),"-",round(HCV_AB_prevalence_com_2022_NSPOST_CI(2),3),"]"));


Variables_names2={'HCV Ab prevalence com  2022' ; 'HCV Ab prevalence com  2030' ; 'HCV incidence  2022' ;'HCV incidence  2030' ;'HCV prevalence  2022';'HCV prevalence  2030';'percentage HCV reduction';'ART Coverage in 2022' ;'ART Coverage in 2030';'OST Coverage in 2022' ;'OST Coverage in 2030';'HCV infection averted'};
NSPOST_scenario_withCI=[HCV_AB_prevalence_com_2022_NSPOST_withCI;HCV_AB_prevalence_com_2030_NSPOST_withCI; NSPOST_HCV_inc_2022_withCI ;NSPOST_HCV_inc_2030_withCI ;NSPOST_HCV_prev_2022_withCI;NSPOST_HCV_prev_2030_withCI;NSPOST_perc_HCV_red_withCI;NSPOST_ART_2022_withCI;NSPOST_ART_2030_withCI;NSPOST_OST_2022_withCI;NSPOST_OST_2030_withCI;prop_hcvnew_averted_cumsum_NSPOST_CI_final];

T10NSPOST = table(Variables_names2,NSPOST_scenario_withCI);
Filename2 = [outputfolder,'/1.summarytable2_NSPOST_', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T10NSPOST,Filename2)



%%%%%%% NSPARTOST TABLE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NSPARTOST_HCV_inc_2022_withCI=join(horzcat(round(NSPARTOST_HCV_inc_2022,3)," [95%CI:", round(NSPARTOST_HCV_inc_2022_CI(1),3),"-",round(NSPARTOST_HCV_inc_2022_CI(2),3),"]"));
NSPARTOST_HCV_inc_2030_withCI=join(horzcat(round(NSPARTOST_HCV_inc_2030,3)," [95%CI:", round(NSPARTOST_HCV_inc_2030_CI(1),3),"-",round(NSPARTOST_HCV_inc_2030_CI(2),3),"]"));
NSPARTOST_HCV_prev_2022_withCI=join(horzcat(round(NSPARTOST_HCV_prev_2022,3)," [95%CI:", round(NSPARTOST_HCV_prev_2022_CI(1),3),"-",round(NSPARTOST_HCV_prev_2022_CI(2),3),"]"));
NSPARTOST_HCV_prev_2030_withCI=join(horzcat(round(NSPARTOST_HCV_prev_2030,3)," [95%CI:", round(NSPARTOST_HCV_prev_2030_CI(1),3),"-",round(NSPARTOST_HCV_prev_2030_CI(2),3),"]"));
NSPARTOST_perc_HCV_red_withCI=join(horzcat(round(perc_HCV_red_NSPARTOST,3)," [95%CI:", round(perc_HCV_red_NSPARTOST_CI(1),3),"-",round(perc_HCV_red_NSPARTOST_CI(2),3),"]"));
NSPARTOST_ART_2022_withCI=join(horzcat(round(NSPARTOSTscenario_ART_2022,3)," [95%CI:", round(NSPARTOSTscenario_ART_2022_CI(1),3),"-",round(NSPARTOSTscenario_ART_2022_CI(2),3),"]"));
NSPARTOST_ART_2030_withCI=join(horzcat(round(NSPARTOSTscenario_ART_2030,3)," [95%CI:", round(NSPARTOSTscenario_ART_2030_CI(1),3),"-",round(NSPARTOSTscenario_ART_2030_CI(2),3),"]"));
NSPARTOST_OST_2022_withCI=join(horzcat(round(NSPARTOSTscenario_OST_2022,3)," [95%CI:", round(NSPARTOSTscenario_OST_2022_CI(1),3),"-",round(NSPARTOSTscenario_OST_2022_CI(2),3),"]"));
NSPARTOST_OST_2030_withCI=join(horzcat(round(NSPARTOSTscenario_OST_2030,3)," [95%CI:", round(NSPARTOSTscenario_OST_2030_CI(1),3),"-",round(NSPARTOSTscenario_OST_2030_CI(2),3),"]"));

prop_hcvnew_averted_cumsum_NSPARTOST_CI_final=join(horzcat(100*round(prop_hcvnew_averted_cumsum_NSPARTOST,3)," [95%CI:", 100*round(prop_hcvnew_averted_cumsum_NSPARTOST_CI(1),3),"-",100*round(prop_hcvnew_averted_cumsum_NSPARTOST_CI(2),3),"]"));

HCV_AB_prevalence_com_2022_NSPARTOST_withCI=join(horzcat(round(HCV_AB_prevalence_com_2022_NSPARTOST,3)," [95%CI:", round(HCV_AB_prevalence_com_2022_NSPARTOST_CI(1),3),"-",round(HCV_AB_prevalence_com_2022_NSPARTOST_CI(2),3),"]"));
HCV_AB_prevalence_com_2030_NSPARTOST_withCI=join(horzcat(round(HCV_AB_prevalence_com_2022_NSPARTOST,3)," [95%CI:", round(HCV_AB_prevalence_com_2022_NSPARTOST_CI(1),3),"-",round(HCV_AB_prevalence_com_2022_NSPARTOST_CI(2),3),"]"));

Variables_names2={'HCV Ab prevalence com  2022' ; 'HCV Ab prevalence com  2030' ; 'HCV incidence  2022' ;'HCV incidence  2030' ;'HCV prevalence  2022';'HCV prevalence  2030';'percentage HCV reduction';'ART Coverage in 2022' ;'ART Coverage in 2030';'OST Coverage in 2022' ;'OST Coverage in 2030';'HCV infection averted'};
NSPARTOST_scenario_withCI=[HCV_AB_prevalence_com_2022_NSPARTOST_withCI; HCV_AB_prevalence_com_2030_NSPARTOST_withCI; NSPARTOST_HCV_inc_2022_withCI ;NSPARTOST_HCV_inc_2030_withCI ;NSPARTOST_HCV_prev_2022_withCI;NSPARTOST_HCV_prev_2030_withCI;NSPARTOST_perc_HCV_red_withCI;NSPARTOST_ART_2022_withCI;NSPARTOST_ART_2030_withCI;NSPARTOST_OST_2022_withCI;NSPARTOST_OST_2030_withCI;prop_hcvnew_averted_cumsum_NSPARTOST_CI_final];

T10NSPARTOST = table(Variables_names2,NSPARTOST_scenario_withCI);
Filename2 = [outputfolder,'/1.summarytable2_NSPARTOST_', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T10NSPARTOST,Filename2)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% INFECTION AVERTED TABLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


prop_hcvnew_averted_cumsum_OST_CI_final=join(horzcat(100*round(prop_hcvnew_averted_cumsum_OST,3)," [95%CI:", 100*round(prop_hcvnew_averted_cumsum_OST_CI(1),3),"-",100*round(prop_hcvnew_averted_cumsum_OST_CI(2),3),"]"));
prop_hcvnew_averted_auc_OST_CI_final=join(horzcat(100*round(prop_hcvnew_averted_auc_OST,3)," [95%CI:", 100*round(prop_hcvnew_averted_auc_OST_CI(1),3),"-",100*round(prop_hcvnew_averted_auc_OST_CI(2),3),"]"));

prop_hcvnew_averted_cumsum_ART_CI_final=join(horzcat(100*round(prop_hcvnew_averted_cumsum_ART,3)," [95%CI:", 100*round(prop_hcvnew_averted_cumsum_ART_CI(1),3),"-",100*round(prop_hcvnew_averted_cumsum_ART_CI(2),3),"]"));
prop_hcvnew_averted_auc_ART_CI_final=join(horzcat(100*round(prop_hcvnew_averted_auc_ART,3)," [95%CI:", 100*round(prop_hcvnew_averted_auc_ART_CI(1),3),"-",100*round(prop_hcvnew_averted_auc_ART_CI(2),3),"]"));

prop_hcvnew_averted_cumsum_ARTOST_CI_final=join(horzcat(100*round(prop_hcvnew_averted_cumsum_ARTOST,3)," [95%CI:", 100*round(prop_hcvnew_averted_cumsum_ARTOST_CI(1),3),"-",100*round(prop_hcvnew_averted_cumsum_ARTOST_CI(2),3),"]"));
prop_hcvnew_averted_auc_ARTOST_CI_final=join(horzcat(100*round(prop_hcvnew_averted_auc_ARTOST,3)," [95%CI:", 100*round(prop_hcvnew_averted_auc_ARTOST_CI(1),3),"-",100*round(prop_hcvnew_averted_auc_ARTOST_CI(2),3),"]"));


prop_hcvnew_averted_cumsum_NSP_CI_final=join(horzcat(100*round(prop_hcvnew_averted_cumsum_NSP,3)," [95%CI:", 100*round(prop_hcvnew_averted_cumsum_NSP_CI(1),3),"-",100*round(prop_hcvnew_averted_cumsum_NSP_CI(2),3),"]"));
prop_hcvnew_averted_auc_NSP_CI_final=join(horzcat(100*round(prop_hcvnew_averted_auc_NSP,3)," [95%CI:", 100*round(prop_hcvnew_averted_auc_NSP_CI(1),3),"-",100*round(prop_hcvnew_averted_auc_NSP_CI(2),3),"]"));

prop_hcvnew_averted_cumsum_NSPART_CI_final=join(horzcat(100*round(prop_hcvnew_averted_cumsum_NSPART,3)," [95%CI:", 100*round(prop_hcvnew_averted_cumsum_NSPART_CI(1),3),"-",100*round(prop_hcvnew_averted_cumsum_NSPART_CI(2),3),"]"));
prop_hcvnew_averted_auc_NSPART_CI_final=join(horzcat(100*round(prop_hcvnew_averted_auc_NSPART,3)," [95%CI:", 100*round(prop_hcvnew_averted_auc_NSPART_CI(1),3),"-",100*round(prop_hcvnew_averted_auc_NSPART_CI(2),3),"]"));

prop_hcvnew_averted_cumsum_NSPOST_CI_final=join(horzcat(100*round(prop_hcvnew_averted_cumsum_NSPOST,3)," [95%CI:", 100*round(prop_hcvnew_averted_cumsum_NSPOST_CI(1),3),"-",100*round(prop_hcvnew_averted_cumsum_NSPOST_CI(2),3),"]"));
prop_hcvnew_averted_auc_NSPOST_CI_final=join(horzcat(100*round(prop_hcvnew_averted_auc_NSPOST,3)," [95%CI:", 100*round(prop_hcvnew_averted_auc_NSPOST_CI(1),3),"-",100*round(prop_hcvnew_averted_auc_NSPOST_CI(2),3),"]"));

prop_hcvnew_averted_cumsum_NSPARTOST_CI_final=join(horzcat(100*round(prop_hcvnew_averted_cumsum_NSPARTOST,3)," [95%CI:", 100*round(prop_hcvnew_averted_cumsum_NSPARTOST_CI(1),3),"-",100*round(prop_hcvnew_averted_cumsum_NSPARTOST_CI(2),3),"]"));
prop_hcvnew_averted_auc_NSPARTOST_CI_final=join(horzcat(100*round(prop_hcvnew_averted_auc_NSPARTOST,3)," [95%CI:", 100*round(prop_hcvnew_averted_auc_NSPARTOST_CI(1),3),"-",100*round(prop_hcvnew_averted_auc_NSPARTOST_CI(2),3),"]"));



Variables_names3={'Percentage of HCV infections averted 2022-2030 (auc)';'Percentage of HCV infections averted 2022-2030 (cumsum)'};
ART_scenario_withCI=[prop_hcvnew_averted_auc_ART_CI_final;prop_hcvnew_averted_cumsum_ART_CI_final];
OST_scenario_withCI=[prop_hcvnew_averted_auc_OST_CI_final;prop_hcvnew_averted_cumsum_OST_CI_final];
ARTOST_scenario_withCI=[prop_hcvnew_averted_auc_ARTOST_CI_final;prop_hcvnew_averted_cumsum_ARTOST_CI_final];
NSP_scenario_withCI=[prop_hcvnew_averted_auc_NSP_CI_final;prop_hcvnew_averted_cumsum_NSP_CI_final];
NSPART_scenario_withCI=[prop_hcvnew_averted_auc_NSPART_CI_final;prop_hcvnew_averted_cumsum_NSPART_CI_final];
NSPOST_scenario_withCI=[prop_hcvnew_averted_auc_NSPOST_CI_final;prop_hcvnew_averted_cumsum_NSPOST_CI_final];
NSPARTOST_scenario_withCI=[prop_hcvnew_averted_auc_NSPARTOST_CI_final;prop_hcvnew_averted_cumsum_NSPARTOST_CI_final];


T2B = table(Variables_names3,ART_scenario_withCI,OST_scenario_withCI,ARTOST_scenario_withCI,NSP_scenario_withCI,NSPART_scenario_withCI,NSPOST_scenario_withCI,NSPARTOST_scenario_withCI);
Filename2 = [outputfolder,'/1.summarytable3_infectionavered_', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T2B,Filename2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% T3 = table(HCV_inc_2022_ART_vector,HCV_inc_2030_ART_vector,HCV_prev_2022_ART_vector,HCV_prev_2030_ART_vector,HCV_ART_coverage_2022_vector,HCV_ART_coverage_2030_vector);
% Filename3 = [outputfolder,'/1.ART.output_vector_', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T3,Filename3)
% 
% T4 = table(HCV_inc_2022_OST_vector,HCV_inc_2030_OST_vector,HCV_prev_2022_OST_vector,HCV_prev_2030_OST_vector,HCV_OST_coverage_2022_vector,HCV_OST_coverage_2030_vector);
% Filename4 = [outputfolder,'/1.OST.output_vector_', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T4,Filename4)
% 
% T5 = table(HCV_prev_2022_ARTOST_vector,HCV_prev_2030_ARTOST_vector);
% Filename5 = [outputfolder,'/1.OST.output_vector_', datestr(now, 'yyyy-mm-dd'),'.csv'];
% writetable(T5,Filename5)




%%

scale_OST_cat = nan(N,1);
scale_ART_cat = nan(N,1);
for i=1:N
    load([dir,'/scale_OST_50_2030_',num2str(i)])
    load([dir,'/scale_ART_50_2030_',num2str(i)])
    scale_OST_cat(i) = scale_OST_50_2030;
    scale_ART_cat(i) = scale_ART_50_2030;
end
figure
fig1=figure; set(fig1,'visible','off');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 6])
histogram(scale_OST_cat)
title('OST scale-up factor')
Filename1 = [outputfolder,'/1.HCV.OST_ScaleUp_', datestr(now, 'yyyy-mm-dd'),'.png'];
saveas(gcf,Filename1)

figure
fig2=figure; set(fig2,'visible','off');

histogram(scale_ART_cat)
title('ART scale-up factor')
Filename2 = [outputfolder,'/2.HCV.ART_ScaleUp_', datestr(now, 'yyyy-mm-dd'),'.png'];
saveas(gcf,Filename2)


close all

end
% find(isnan(scale_OST_cat))
