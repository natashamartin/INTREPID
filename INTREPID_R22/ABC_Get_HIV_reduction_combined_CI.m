%%% run this code to calculate % reduction in HIV incidence from 2022 to
%%% 2030 under OST scale-up and ART scale-up scenarios (each scenario
%%% scales OST or ART to 50% coverage by 2030)

% dir='/Users/antoinechaillon/Dropbox/intrepid/matlab/Global2_R19_HIVonly/Outputs/';
% N=5000;
function [] = ABC_Get_HIV_reduction_combined_CI(ISO,N,dir,numrun)


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
% HIV Incidence (all PWID)
tmp = Status_quo.HIV_Incidence_PWID;
tmp2 = Status_quo.PWID_HIV_prevalence;
tmp3 = Status_quo.PWID_pop_size;

newinfections_SQ_auc= trapz(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
newinfections_SQ_auc_final=mean(newinfections_SQ_auc,1);
%   4.0986e+06

newinfections_SQ_cumsum=cumsum(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
newinfections_SQ_cumsum_final=mean(newinfections_SQ_cumsum(:,size(newinfections_SQ_cumsum,2)),1);
%   4.1500e+06


load([dir,'/ART_50_2030.mat']);
% HIV Incidence (all PWID)
tmp = ART_50_2030.HIV_Incidence_PWID;
tmp2 = ART_50_2030.PWID_HIV_prevalence;
tmp3 = ART_50_2030.PWID_pop_size;


HIV_inc_2022 = mean(tmp(:,ind2022),1);
HIV_inc_2022_CI=prctile(tmp(:,ind2022),[2.5  97.5]);


HIV_inc_2030 = mean(tmp(:,ind2030),1);
HIV_inc_2030_CI=prctile(tmp(:,ind2030),[2.5  97.5]);

HIV_inc_2022_ART_vector=tmp(:,ind2022);
HIV_inc_2030_ART_vector=tmp(:,ind2030);



%mytable = table(HIV_inc_2022_ART_vector,HIV_inc_2030_ART_vector);

%X.Properties.VariableNames = {'incidence2022_ART','incidence2030_ART'};
perc_HIV_red_ART = (HIV_inc_2022 - HIV_inc_2030)/HIV_inc_2022*100;
perc_HIV_red_ART_CI=prctile((tmp(:,ind2022) - tmp(:,ind2030))./tmp(:,ind2022).*100,[2.5  97.5]);


% HIV prevalence (all PWID)
HIV_prev_2022_ART = mean(tmp2(:,ind2022),1);
HIV_prev_2022_ART_CI=prctile(tmp2(:,ind2022),[2.5  97.5]);

HIV_prev_2030_ART = mean(tmp2(:,ind2030),1);
HIV_prev_2030_ART_CI=prctile(tmp2(:,ind2030),[2.5  97.5]);

HIV_prev_2022_ART_vector=tmp2(:,ind2022);
HIV_prev_2030_ART_vector=tmp2(:,ind2030);



% new HIV infection with ART scenario
% Num Susceptible = Num PWID* (1-Prevalence) = tmp3.*(1-tmp2/100)
% New infections= incidence rate* num susceptible  = tmp.*tmp3.*(1-tmp2/100)

newinfections_ART_auc= trapz(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
newinfections_ART_auc_final=mean(newinfections_ART_auc,1);
%   2.4700e+06

newinfections_ART_cumsum=cumsum(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
newinfections_ART_cumsum_final=mean(newinfections_ART_cumsum(:,size(newinfections_ART_cumsum,2)),1);
%   2.5090e+06


prop_hivnew_averted_auc_ART=(newinfections_SQ_auc_final-newinfections_ART_auc_final)/newinfections_SQ_auc_final;
prop_hivnew_averted_auc_ART_CI=prctile((newinfections_SQ_auc-newinfections_ART_auc)./newinfections_SQ_auc,[2.5  97.5]);
%0.3973 [0.3429    0.4555]
prop_hivnew_averted_cumsum_ART=(newinfections_SQ_cumsum_final-newinfections_ART_cumsum_final)/newinfections_SQ_cumsum_final;
prop_hivnew_averted_cumsum_ART_CI=prctile((newinfections_SQ_cumsum(:,size(newinfections_SQ_cumsum,2))-newinfections_ART_cumsum(:,size(newinfections_ART_cumsum,2)))./newinfections_SQ_cumsum(:,size(newinfections_SQ_cumsum,2)),[2.5  97.5]);

% 0.3954 [0.3413    0.4533]




clear tmp
clear tmp2
clear tmp3

% ART coverage (all PWID)
tmp = ART_50_2030.PWID_prop_current_ART_all;
ART_2022 = mean(tmp(:,ind2022),1);
ART_2022_CI=prctile(tmp(:,ind2022),[2.5  97.5]);

ART_2030 = mean(tmp(:,ind2030),1);
ART_2030_CI=prctile(tmp(:,ind2030),[2.5  97.5]);

HIV_ART_coverage_2022_vector=tmp(:,ind2022);
HIV_ART_coverage_2030_vector=tmp(:,ind2030);


clear tmp



%% OST
load([dir,'/OST_50_2030.mat']);
% HIV Incidence (all PWID)
tmp = OST_50_2030.HIV_Incidence_PWID;
tmp2 = OST_50_2030.PWID_HIV_prevalence;
tmp3 = OST_50_2030.PWID_pop_size;


HIV_inc_2022_2 = mean(tmp(:,ind2022),1);
HIV_inc_2022_2_CI=prctile(tmp(:,ind2022),[2.5  97.5]);

HIV_inc_2030_2 = mean(tmp(:,ind2030),1);
HIV_inc_2030_2_CI=prctile(tmp(:,ind2030),[2.5  97.5]);

HIV_inc_2022_OST_vector=tmp(:,ind2022);
HIV_inc_2030_OST_vector=tmp(:,ind2030);


perc_HIV_red_OST = (HIV_inc_2022_2 - HIV_inc_2030_2)/HIV_inc_2022_2*100;
perc_HIV_red_OST_CI=prctile((tmp(:,ind2022) - tmp(:,ind2030))./tmp(:,ind2022).*100,[2.5  97.5]);


% HIV prevalence (all PWID)
HIV_prev_2022_OST = mean(tmp2(:,ind2022),1);
HIV_prev_2022_OST_CI=prctile(tmp2(:,ind2022),[2.5  97.5]);

HIV_prev_2030_OST = mean(tmp2(:,ind2030),1);
HIV_prev_2030_OST_CI=prctile(tmp2(:,ind2030),[2.5  97.5]);

HIV_prev_2022_OST_vector=tmp2(:,ind2022);
HIV_prev_2030_OST_vector=tmp2(:,ind2030);

% new HIV infection with OST scenario
% Num Susceptible = Num PWID* (1-Prevalence) = tmp3.*(1-tmp2/100)
% New infections= incidence rate* num susceptible  = tmp.*tmp3.*(1-tmp2/100)

newinfections_OST_auc= trapz(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
newinfections_OST_auc_final=mean(newinfections_OST_auc,1);
%   2.9676e+06

newinfections_OST_cumsum=cumsum(tmp(:,ind2022:ind2030).*tmp3(:,ind2022:ind2030).*(1-tmp2(:,ind2022:ind2030)/100),2);
newinfections_OST_cumsum_final=mean(newinfections_OST_cumsum(:,size(newinfections_OST_cumsum,2)),1);
%   3.0088e+06


prop_hivnew_averted_auc_OST=(newinfections_SQ_auc_final-newinfections_OST_auc_final)/newinfections_SQ_auc_final;
prop_hivnew_averted_auc_OST_CI=prctile((newinfections_SQ_auc-newinfections_OST_auc)./newinfections_SQ_auc,[2.5  97.5]);

%0.2790 [0.2450    0.3043]
prop_hivnew_averted_cumsum_OST=(newinfections_SQ_cumsum_final-newinfections_OST_cumsum_final)/newinfections_SQ_cumsum_final;
prop_hivnew_averted_cumsum_OST_CI=prctile((newinfections_SQ_cumsum(:,size(newinfections_SQ_cumsum,2))-newinfections_OST_cumsum(:,size(newinfections_OST_cumsum,2)))./newinfections_SQ_cumsum(:,size(newinfections_SQ_cumsum,2)),[2.5  97.5]);
% 0.2750 [0.2442    0.3032]




clear tmp
clear tmp2
clear tmp3

% OST coverage (all PWID)
tmp = OST_50_2030.PWID_prop_current_OST_all;
OST_2022 = mean(tmp(:,ind2022),1);
OST_2022_CI=prctile(tmp(:,ind2022),[2.5  97.5]);

OST_2030 = mean(tmp(:,ind2030),1);
OST_2030_CI=prctile(tmp(:,ind2030),[2.5  97.5]);

HIV_OST_coverage_2022_vector=tmp(:,ind2022);
HIV_OST_coverage_2030_vector=tmp(:,ind2030);



clear tmp


%X.Properties.VariableNames = {'incidence2022_ART','incidence2030_ART'};
% prop_infection_averted_HIV_ART = (HIV_new_2022_2030_SQ - HIV_new_2022_2030_ART)/HIV_new_2022_2030_SQ*100;
% prop_infection_averted_HIV_ART_CI=((HIV_new_2030_SQ_vector.-HIV_new_2022_SQ_vector).-(HIV_new_2030_ART_vector.-HIV_new_2022_ART_vector))./(HIV_new_2030_SQ_vector.-HIV_new_2022_SQ_vector);
% 


clear tmp1
clear tmp2
clear tmp3

% colnames = {'HIV_inc_2022';'HIV_inc_2030';'Li';'perc_HIV_red_OST';'HIV_prev_2022_ART';'HIV_prev_2030_ART';'perc_HIV_red_ART';'ART_2022';'ART_2030';...
%     'HIV_prev_2022_OST';'HIV_prev_2030_OST';'perc_HIV_red_OST';'OST_2022';'OST_2030'};
% 
% colnames = {'HIV_inc_2022';'HIV_inc_2030';'Li';'perc_HIV_red_OST';'HIV_prev_2022_ART';'HIV_prev_2030_ART';'perc_HIV_red_ART';'ART_2022';'ART_2030';...
%     'HIV_prev_2022_OST';'HIV_prev_2030_OST';'perc_HIV_red_OST';'OST_2022';'OST_2030'};
% 

Variables_names={'HIV incidence  2022' ;'HIV incidence  2030' ;'HIV prevalence  2022';'HIV prevalence  2030';'percentage HIV reduction';'Coverage in 2022' ;'Coverage in 2030'};
ART_scenario=[HIV_inc_2022 ;HIV_inc_2030 ;HIV_prev_2022_ART;HIV_prev_2030_ART;perc_HIV_red_ART;ART_2022;ART_2030];
OST_scenario=[HIV_inc_2022_2 ;HIV_inc_2030_2 ;HIV_prev_2022_OST;HIV_prev_2030_OST;perc_HIV_red_OST;OST_2022;OST_2030];

T = table(Variables_names,ART_scenario,OST_scenario);
Filename = [outputfolder,'/1.summarytable_', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T,Filename)


HIV_inc_2022_withCI=join(horzcat(round(HIV_inc_2022,3)," [95%CI:", round(HIV_inc_2022_CI(1),3),"-",round(HIV_inc_2022_CI(2),3),"]"));
HIV_inc_2030_withCI=join(horzcat(round(HIV_inc_2030,3)," [95%CI:", round(HIV_inc_2030_CI(1),3),"-",round(HIV_inc_2030_CI(2),3),"]"));
HIV_prev_2022_ART_withCI=join(horzcat(round(HIV_prev_2022_ART,3)," [95%CI:", round(HIV_prev_2022_ART_CI(1),3),"-",round(HIV_prev_2022_ART_CI(2),3),"]"));
HIV_prev_2030_ART_withCI=join(horzcat(round(HIV_prev_2030_ART,3)," [95%CI:", round(HIV_prev_2030_ART_CI(1),3),"-",round(HIV_prev_2030_ART_CI(2),3),"]"));
perc_HIV_red_ART_withCI=join(horzcat(round(perc_HIV_red_ART,3)," [95%CI:", round(perc_HIV_red_ART_CI(1),3),"-",round(perc_HIV_red_ART_CI(2),3),"]"));
ART_2022_withCI=join(horzcat(round(ART_2022,3)," [95%CI:", round(ART_2022_CI(1),3),"-",round(ART_2022_CI(2),3),"]"));
ART_2030_withCI=join(horzcat(round(ART_2030,3)," [95%CI:", round(ART_2030_CI(1),3),"-",round(ART_2030_CI(2),3),"]"));
HIV_inc_2022_2_withCI=join(horzcat(round(HIV_inc_2022_2,3)," [95%CI:", round(HIV_inc_2022_2_CI(1),3),"-",round(HIV_inc_2022_2_CI(2),3),"]"));
HIV_inc_2030_2_withCI=join(horzcat(round(HIV_inc_2030_2,3)," [95%CI:", round(HIV_inc_2030_2_CI(1),3),"-",round(HIV_inc_2030_2_CI(2),3),"]"));
HIV_prev_2022_OST_withCI=join(horzcat(round(HIV_prev_2022_OST,3)," [95%CI:", round(HIV_prev_2022_OST_CI(1),3),"-",round(HIV_prev_2022_OST_CI(2),3),"]"));
HIV_prev_2030_OST_withCI=join(horzcat(round(HIV_prev_2030_OST,3)," [95%CI:", round(HIV_prev_2030_OST_CI(1),3),"-",round(HIV_prev_2030_OST_CI(2),3),"]"));
perc_HIV_red_OST_withCI=join(horzcat(round(perc_HIV_red_OST,3)," [95%CI:", round(perc_HIV_red_OST_CI(1),3),"-",round(perc_HIV_red_OST_CI(2),3),"]"));
OST_2022_withCI=join(horzcat(round(OST_2022,3)," [95%CI:", round(OST_2022_CI(1),3),"-",round(OST_2022_CI(2),3),"]"));
OST_2030_withCI=join(horzcat(round(OST_2030,3)," [95%CI:", round(OST_2030_CI(1),3),"-",round(OST_2030_CI(2),3),"]"));



Variables_names2={'HIV incidence  2022' ;'HIV incidence  2030' ;'HIV prevalence  2022';'HIV prevalence  2030';'percentage HIV reduction';'Coverage in 2022' ;'Coverage in 2030'};
ART_scenario_withCI=[HIV_inc_2022_withCI ;HIV_inc_2030_withCI ;HIV_prev_2022_ART_withCI;HIV_prev_2030_ART_withCI;perc_HIV_red_ART_withCI;ART_2022_withCI;ART_2030_withCI];
OST_scenario_withCI=[HIV_inc_2022_2_withCI ;HIV_inc_2030_2_withCI ;HIV_prev_2022_OST_withCI;HIV_prev_2030_OST_withCI;perc_HIV_red_OST_withCI;OST_2022_withCI;OST_2030_withCI];

T2 = table(Variables_names2,ART_scenario_withCI,OST_scenario_withCI);
Filename2 = [outputfolder,'/1.summarytable2_', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T2,Filename2)



HIV_inc_2022_withCI=join(horzcat(round(HIV_inc_2022,3)," [95%CI:", round(HIV_inc_2022_CI(1),3),"-",round(HIV_inc_2022_CI(2),3),"]"));
HIV_inc_2030_withCI=join(horzcat(round(HIV_inc_2030,3)," [95%CI:", round(HIV_inc_2030_CI(1),3),"-",round(HIV_inc_2030_CI(2),3),"]"));
HIV_prev_2022_ART_withCI=join(horzcat(round(HIV_prev_2022_ART,3)," [95%CI:", round(HIV_prev_2022_ART_CI(1),3),"-",round(HIV_prev_2022_ART_CI(2),3),"]"));
HIV_prev_2030_ART_withCI=join(horzcat(round(HIV_prev_2030_ART,3)," [95%CI:", round(HIV_prev_2030_ART_CI(1),3),"-",round(HIV_prev_2030_ART_CI(2),3),"]"));
perc_HIV_red_ART_withCI=join(horzcat(round(perc_HIV_red_ART,3)," [95%CI:", round(perc_HIV_red_ART_CI(1),3),"-",round(perc_HIV_red_ART_CI(2),3),"]"));
ART_2022_withCI=join(horzcat(round(ART_2022,3)," [95%CI:", round(ART_2022_CI(1),3),"-",round(ART_2022_CI(2),3),"]"));
ART_2030_withCI=join(horzcat(round(ART_2030,3)," [95%CI:", round(ART_2030_CI(1),3),"-",round(ART_2030_CI(2),3),"]"));
HIV_inc_2022_2_withCI=join(horzcat(round(HIV_inc_2022_2,3)," [95%CI:", round(HIV_inc_2022_2_CI(1),3),"-",round(HIV_inc_2022_2_CI(2),3),"]"));
HIV_inc_2030_2_withCI=join(horzcat(round(HIV_inc_2030_2,3)," [95%CI:", round(HIV_inc_2030_2_CI(1),3),"-",round(HIV_inc_2030_2_CI(2),3),"]"));
HIV_prev_2022_OST_withCI=join(horzcat(round(HIV_prev_2022_OST,3)," [95%CI:", round(HIV_prev_2022_OST_CI(1),3),"-",round(HIV_prev_2022_OST_CI(2),3),"]"));
HIV_prev_2030_OST_withCI=join(horzcat(round(HIV_prev_2030_OST,3)," [95%CI:", round(HIV_prev_2030_OST_CI(1),3),"-",round(HIV_prev_2030_OST_CI(2),3),"]"));
perc_HIV_red_OST_withCI=join(horzcat(round(perc_HIV_red_OST,3)," [95%CI:", round(perc_HIV_red_OST_CI(1),3),"-",round(perc_HIV_red_OST_CI(2),3),"]"));
OST_2022_withCI=join(horzcat(round(OST_2022,3)," [95%CI:", round(OST_2022_CI(1),3),"-",round(OST_2022_CI(2),3),"]"));
OST_2030_withCI=join(horzcat(round(OST_2030,3)," [95%CI:", round(OST_2030_CI(1),3),"-",round(OST_2030_CI(2),3),"]"));

prop_hivnew_averted_cumsum_OST_CI_final=join(horzcat(100*round(prop_hivnew_averted_cumsum_OST,3)," [95%CI:", 100*round(prop_hivnew_averted_cumsum_OST_CI(1),3),"-",100*round(prop_hivnew_averted_cumsum_OST_CI(2),3),"]"));
prop_hivnew_averted_cumsum_ART_CI_final=join(horzcat(100*round(prop_hivnew_averted_cumsum_ART,3)," [95%CI:", 100*round(prop_hivnew_averted_cumsum_ART_CI(1),3),"-",100*round(prop_hivnew_averted_cumsum_ART_CI(2),3),"]"));

prop_hivnew_averted_auc_OST_CI_final=join(horzcat(100*round(prop_hivnew_averted_auc_OST,3)," [95%CI:", 100*round(prop_hivnew_averted_auc_OST_CI(1),3),"-",100*round(prop_hivnew_averted_auc_OST_CI(2),3),"]"));
prop_hivnew_averted_auc_ART_CI_final=join(horzcat(100*round(prop_hivnew_averted_auc_ART,3)," [95%CI:", 100*round(prop_hivnew_averted_auc_ART_CI(1),3),"-",100*round(prop_hivnew_averted_auc_ART_CI(2),3),"]"));



Variables_names3={'HIV incidence  2022' ;'HIV incidence  2030' ;'HIV prevalence  2022';'HIV prevalence  2030';'percentage HIV reduction';'Coverage in 2022' ;'Coverage in 2030';'Percentage of HIV infections averted 2022-2030 (auc)';'Percentage of HIV infections averted 2022-2030 (cumsum)'};
ART_scenario_withCI=[HIV_inc_2022_withCI ;HIV_inc_2030_withCI ;HIV_prev_2022_ART_withCI;HIV_prev_2030_ART_withCI;perc_HIV_red_ART_withCI;ART_2022_withCI;ART_2030_withCI;prop_hivnew_averted_auc_ART_CI_final;prop_hivnew_averted_cumsum_ART_CI_final];
OST_scenario_withCI=[HIV_inc_2022_2_withCI ;HIV_inc_2030_2_withCI ;HIV_prev_2022_OST_withCI;HIV_prev_2030_OST_withCI;perc_HIV_red_OST_withCI;OST_2022_withCI;OST_2030_withCI;prop_hivnew_averted_auc_OST_CI_final;prop_hivnew_averted_cumsum_OST_CI_final];

T2B = table(Variables_names3,ART_scenario_withCI,OST_scenario_withCI);
Filename2 = [outputfolder,'/1.summarytable3_', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T2B,Filename2)


T3 = table(HIV_inc_2022_ART_vector,HIV_inc_2030_ART_vector,HIV_prev_2022_ART_vector,HIV_prev_2030_ART_vector,HIV_ART_coverage_2022_vector,HIV_ART_coverage_2030_vector);
Filename3 = [outputfolder,'/1.ART.output_vector_', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T3,Filename3)

T4 = table(HIV_inc_2022_OST_vector,HIV_inc_2030_OST_vector,HIV_prev_2022_OST_vector,HIV_prev_2030_OST_vector,HIV_OST_coverage_2022_vector,HIV_OST_coverage_2030_vector);
Filename4 = [outputfolder,'/1.OST.output_vector_', datestr(now, 'yyyy-mm-dd'),'.csv'];
writetable(T4,Filename4)




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
Filename1 = [outputfolder,'/1.OST_ScaleUp_', datestr(now, 'yyyy-mm-dd'),'.png'];
saveas(gcf,Filename1)

figure
fig2=figure; set(fig2,'visible','off');

histogram(scale_ART_cat)
title('ART scale-up factor')
Filename2 = [outputfolder,'/2.ART_ScaleUp_', datestr(now, 'yyyy-mm-dd'),'.png'];
saveas(gcf,Filename2)


close all

end
% find(isnan(scale_OST_cat))
