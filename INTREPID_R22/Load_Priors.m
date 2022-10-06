function Load_Priors(ISO)
    
%% Injecting risk
% difference in injecting risk if homeless vs not
priors.RR_inject_homeless = makedist('uniform',1,10);

% difference in injecting risk if in post release vs rest of time in
% community
priors.RR_inject_post_release = makedist('uniform',1,5);

priors.RR_inject_ever_inc = makedist('uniform',1,10);

% difference in injecting risk if female vs male
priors.RR_inject_female = makedist('triangular',1.079659*1.3164,1.25219*1.542618,1.452292*1.807711);

% relative risk of hiv transmission through idu if on OST
priors.RR_HIV_OST = make_lognormal_dist([0.46,0.32,0.67]);

% relative risk of hiv transmission through idu if on NSP
priors.RR_HIV_NSP = make_lognormal_dist([0.66,0.43,1.01]);

%% To Update

% rate of loss to care from ART
priors.ART_leave = makedist('uniform',10.9/100,15.8/100);

% rate of loss to care from OST
priors.OST_leave1 = make_uniform_dist(ISO,'OST_leave1');
priors.OST_leave2 = make_uniform_dist(ISO,'OST_leave2');

% Proportion of PWID on ART who are virally supressed
priors.prop_VS = make_lognormal_dist([0.69,0.49,0.77]);

%Average log viral Load if not on ART
priors.viral_load_off_ART = makedist('Triangular',4.11,4.79,5.27);

% Average reduction in log viral Load if on ART and not virally suppressed
priors.viral_load_reduction_non_vs = makedist('Triangular',0.0,0.81,2.27);
%% Proportion Sexually active
% Baseline_prop_sex_active
priors.Baseline_prop_sex_active = make_lognormal_dist([0.804, 0.579, 0.996]);
% increase if female
priors.RR_sex_active_female = makedist('uniform',0.5,2.0);
% decrease if old
priors.RR_sex_active_old = makedist('uniform',0.5,2.0);
%% Number of sexual contacts
priors.IRR_contacts_old = make_lognormal_dist([.8246855, .7826485,   .8689803]);
priors.contacts = make_lognormal_dist([28.94722, 26.30572,31.85397]);
%% Proportion of male PWID's parnters who are pwid
priors.Prop_male_partners_PWID = makedist('Triangular',0.1143,0.1269,0.1402);
%% Condom use
 priors.condom_efficacy = makedist('Triangular',0.66,0.8,0.94);
priors.Baseline_prop_condom = make_lognormal_dist([0.431, 0.193, 0.678]);
 priors.RR_condom_homeless = makedist('uniform',0,1);
 
%% HIV natural history
% HIV transmissability if in acute stage of infection
priors.transmissabilitty_acute = make_lognormal_dist([276,131,509]);

% HIV transmissability if in latent stage
priors.transmissabilitty_chronic = make_lognormal_dist([10.6,7.61,13.3]);

% HIV transmissability if in pre-aids stage
priors.transmissabilitty_preaids = make_lognormal_dist([76.0,41.3,128.0]);

% average duration of acute stage of hiv infection
priors.average_duration_acute_months = makedist('triangular',1.23,2.90,6.00);

% average duration from infection to aids
priors.median_years_to_death = makedist('uniform',10.8,16.7);%Todd J, Glynn JR, Marston M, et al. Time from HIV seroconversion to death: a collaborative analysis of eight studies in six low and middle-income countries before highly active antiretroviral therapy. AIDS 2007; 21 Suppl 6: S55-63.

% average duration of preaids stage of hiv infection
priors.average_duration_preAIDS_months = makedist('triangular',4.81,9.0,14.0);

% average time til death from aids (not on art)
priors.average_months_until_death_from_AIDS = make_lognormal_dist([10,6.79,12.7]);

% reduction in HIV disease progression/mortality if on ART
priors.RR_HIVprog_ART = make_lognormal_dist([0.34,0.26,0.44]);

% increase in vs if on OST
priors.OR_VS_OST = make_lognormal_dist([1.45,1.21,1.73]);

% Factor difference in HIV transmission risk for each log increment PVL	
priors.HIV_increase_per_VL = make_lognormal_dist([2.45,1.85,3.26]);


%% Mortality and cessation

% Average duration of injecting years
priors.average_dur_inj = make_uniform_dist(ISO,'average_dur_inj');

% RR of mortality if on OST
priors.RR_death_OST = make_lognormal_dist([0.33,0.28,0.39]); % degenhardt lancet 2019

% RR of mortality in first 4 weeks after starting OST vs rest of time on ost - 
priors.RR_death_OST_start = make_lognormal_dist([1.97,0.94,4.10]); % sordo

% RR of mortality in first 4 weeks after leaving OST
priors.RR_death_OST_leave = make_lognormal_dist([2.38,1.51,3.74]); % sordo

% non_disease related death_rate among PWID
priors.mu_death_PWID = make_lognormal_dist(ISO,'mu_death_PWID'); % Vanguard SOC for HIV negative partners.

%% Incarceration rates & average duration
% Average length of time spent in incarceration
priors.average_prison_length_months = makedist('uniform',5,15);

% primary incarceration rate
priors.inc_rate = makedist('uniform',0,0.3);

% re-incarceration rate
priors.reinc_rate = makedist('uniform',0,0.5);

% relative risk of incarceration if on OST
priors.RR_inc_OST = makedist('uniform',0.58,0.90);
%% HIV/HCV transmission rates
% HIV transmission rate through IDU
priors.lambda_HIV_inj = makedist('uniform',0,0.15);

% HIV sexual transmission rate for males
priors.HIV_sex_transmission_m = makedist('uniform',0.01/100,0.14/100);
priors.HIV_sex_transmission_fm = makedist('uniform',1,3);

% difference in injecting risk if in prison vs in community
priors.RR_inject_prison = makedist('uniform',0,5);
%% ART recruitment and ltfu
% increase in ART recruitment rate if young
priors.RR_ART_rec_young = makedist('uniform',0,1);

% Art recruitment rate
priors.ART_start = makedist('uniform',0,0.5);

% increase in art recruitment rate if on OST
priors.RR_ART_rec_OST = make_lognormal_dist([1.87,1.50,2.33]);

% reduction in ART loss to care if on OST
priors.RR_ART_leave_OST = make_lognormal_dist([0.77,0.63,0.95]);
%% OST recruitment and ltfu
% OST recruitment rate
priors.OST_start_com = makedist('uniform',0,0.1);

%% Homelessness

% rate of starting homelessness
priors.homeless_start = makedist('uniform',0,1);


%% New injector dempgraphics


% proportion of new PWID that are male

priors.prop_new_PWID_male = make_uniform_dist(ISO,'prop_new_PWID_male');

% age of new PWID under 25
[~,priors.age_initiation_young,~] = Age_calculator(ISO);
 
% proportion of new pwid that have never been incarcerated
priors.prop_new_PWID_never_inc = makedist('uniform',0.82,1.0);

% homeless
priors.prop_new_PWID_homeless = make_lognormal_dist(ISO,'prop_new_PWID_homeless');

% proportion of new pwid who are hiv+
priors.prop_new_PWID_hiv_young_m = make_lognormal_dist(ISO,'prop_new_PWID_hiv_young_m');
priors.prop_new_PWID_hiv_old_m = make_lognormal_dist(ISO,'prop_new_PWID_hiv_old_m');
priors.prop_new_PWID_hiv_young_f = make_lognormal_dist(ISO,'prop_new_PWID_hiv_young_f');
priors.prop_new_PWID_hiv_old_f = make_lognormal_dist(ISO,'prop_new_PWID_hiv_old_f');


% PWID_pop_size = make_uniform_dist(ISO,'PWID_initial_pop_size');
filename = 'Data_Files/Calibration_Data/PWID_pop_size_data.csv';
opts = detectImportOptions(filename);
opts = setvartype(opts,{'Est','LI','UI'},'double');
dataTable = readtable(filename,opts);
data = dataTable(strcmp(dataTable.ISO,ISO),:);
ci_low = min(data.LI);
ci_up = max(data.UI);
priors.PWID_initial_pop_size = makedist('uniform', ci_low, 1.5*ci_up);

% seeds


if ISO=='BY'
    priors.HIV_seed = makedist('uniform',0.0001,0.0005);
else
    priors.HIV_seed = makedist('uniform',0.001/100,5/100);
end

    

priors.assortative = makedist('uniform',0,0.5);
%% Save priors

filename =['priors_',ISO,'.mat'];
save(filename,'priors');
