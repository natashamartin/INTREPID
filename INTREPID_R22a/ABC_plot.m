function ABC_plot(samp_params,city)
%% Load data for city
filename = ['city',num2str(city),'_Data.mat'];
city_names = {'National'};
city_name = city_names(city);
tmp = load(filename);
Data = tmp.Data;
clear tmp
%% Setup variables
HCV_params = load('HCV_params.mat');
Np= size(samp_params,1);

HCV_tmp = HCV_params.HCV_params(1,:);
params = Get_Parameters(samp_params(1,:),1,HCV_tmp);
TIME = params.seed_date:1:2018;
Nt = size(TIME,2);

y_out = nan(Np,Nt,1*2*2*4*3*4*8*3*1);
%% Parfor loop. evaluating model and calculating outputs to be plotted
parfor i=1:size(samp_params,1)
    params = Get_Parameters(samp_params(i,:),1,HCV_tmp);
    
    SS = Get_Initial_Conditions2(params,'Calibration');
    %options1 = odeset('NonNegative',1:(1*2*2*4*3*3*8*3*1),'AbsTol',1e-6,'RelTol',1e-6);
    [~,y_out(i,:,:)] = ode23(@(t,y)Ukraine_model_mex(t,y,params,'Calibration'),TIME,SS);
end
    y_out = reshape(y_out,[Np,Nt,1,2,2,4,3,4,8,3,1]);
    clear samp_params
    %% PWID Population Size
    PWID_pop_size = sum(y_out(:,:,1,:,:,:,:,:,:,:,:),4:11);
    %% prop female
    PWID_prop_female_com = sum(y_out(:,:,1,2,:,[1,3,4],:,:,:,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],:,:,:,:,:),3:11)*100;
    %% prop young
    PWID_prop_male_com_young = sum(y_out(:,:,1,1,1,[1,3,4],:,:,:,:,:),3:11)./...
        sum(y_out(:,:,1,1,:,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_female_com_young = sum(y_out(:,:,1,2,1,[1,3,4],:,:,:,:,:),3:11)./...
        sum(y_out(:,:,1,2,:,[1,3,4],:,:,:,:,:),3:11)*100;
    %% prop with incarceration history
    % ever incarcerated
    PWID_prop_ever_incarcerated_young_male = sum(y_out(:,:,1,1,1,[3,4],:,:,:,:,:),3:11)./...
        sum(y_out(:,:,1,1,1,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_ever_incarcerated_old_male = sum(y_out(:,:,1,1,2,[3,4],:,:,:,:,:),3:11)./...
        sum(y_out(:,:,1,1,2,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_ever_incarcerated_young_female = sum(y_out(:,:,1,2,1,[3,4],:,:,:,:,:),3:11)./...
        sum(y_out(:,:,1,2,1,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_ever_incarcerated_old_female = sum(y_out(:,:,1,2,2,[3,4],:,:,:,:,:),3:11)./...
        sum(y_out(:,:,1,2,2,[1,3,4],:,:,:,:,:),3:11)*100;
    % recently incarcerated
    PWID_prop_recently_incarcerated_young_male = sum(y_out(:,:,1,1,1,3,:,:,:,:,:),3:11)./...
        sum(y_out(:,:,1,1,1,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_recently_incarcerated_old_male = sum(y_out(:,:,1,1,2,3,:,:,:,:,:),3:11)./...
        sum(y_out(:,:,1,1,2,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_recently_incarcerated_young_female = sum(y_out(:,:,1,2,1,3,:,:,:,:,:),3:11)./...
        sum(y_out(:,:,1,2,1,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_recently_incarcerated_old_female = sum(y_out(:,:,1,2,2,3,:,:,:,:,:),3:11)./...
        sum(y_out(:,:,1,2,2,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_recently_incarcerated_NGO = sum(y_out(:,:,1,:,:,3,[2,3],:,:,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],[2,3],:,:,:,:),3:11)*100;
    PWID_prop_recently_incarcerated_non_NGO = sum(y_out(:,:,1,:,:,3,1,:,:,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],1,:,:,:,:),3:11)*100;
    %% Prop who are NGO clients
    PWID_prop_NGO = sum(y_out(:,:,1,:,:,[1,3,4],[2,3],:,:,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_NGO_young_male = sum(y_out(:,:,1,1,1,[1,3,4],[2,3],:,:,:,:),3:11)./...
        sum(y_out(:,:,1,1,1,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_NGO_old_male = sum(y_out(:,:,1,1,2,[1,3,4],[2,3],:,:,:,:),3:11)./...
        sum(y_out(:,:,1,1,2,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_NGO_young_female = sum(y_out(:,:,1,2,1,[1,3,4],[2,3],:,:,:,:),3:11)./...
        sum(y_out(:,:,1,2,1,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_NGO_old_female = sum(y_out(:,:,1,2,2,[1,3,4],[2,3],:,:,:,:),3:11)./...
        sum(y_out(:,:,1,2,2,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_NGO_ever_inc = sum(y_out(:,:,1,:,:,[3,4],[2,3],:,:,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_NGO_never_inc = sum(y_out(:,:,1,:,:,1,[2,3],:,:,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,1,:,:,:,:,:),3:11)*100;
    PWID_prop_NGO_HIV_pos = sum(y_out(:,:,1,:,:,[1,3,4],[2,3],:,2:8,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],:,:,2:8,:,:),3:11)*100;
    PWID_prop_NGO_HIV_neg = sum(y_out(:,:,1,:,:,[1,3,4],[2,3],:,1,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],:,:,1,:,:),3:11)*100;
    PWID_prop_NGO_HCV_pos = sum(y_out(:,:,1,:,:,[1,3,4],[2,3],:,:,2:3,:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],:,:,:,2:3,:),3:11)*100;
    PWID_prop_NGO_HCV_neg = sum(y_out(:,:,1,:,:,[1,3,4],[2,3],:,:,1,:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],:,:,:,1,:),3:11)*100;
    %% Proportion of NGO clients that have been clienbts for < 2 years
    PWID_prop_short_NGO = sum(y_out(:,:,1,:,:,:,2,:,:,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,:,[2,3],:,:,:,:),3:11)*100;
    %% HIV prevalence among community PWID
    % overall
    PWID_HIV_prevalence_com = sum(y_out(:,:,1,:,:,[1,3,4],:,:,2:8,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],:,:,1:8,:,:),3:11)*100;
    %by gender
    PWID_HIV_prevalence_com_ym = sum(y_out(:,:,1,1,1,[1,3,4],:,:,2:8,:,:),3:11)./...
        sum(y_out(:,:,1,1,1,[1,3,4],:,:,1:8,:,:),3:11)*100;
    PWID_HIV_prevalence_com_om = sum(y_out(:,:,1,1,2,[1,3,4],:,:,2:8,:,:),3:11)./...
        sum(y_out(:,:,1,1,2,[1,3,4],:,:,1:8,:,:),3:11)*100;
    PWID_HIV_prevalence_com_yf = sum(y_out(:,:,1,2,1,[1,3,4],:,:,2:8,:,:),3:11)./...
        sum(y_out(:,:,1,2,1,[1,3,4],:,:,1:8,:,:),3:11)*100;
    PWID_HIV_prevalence_com_of = sum(y_out(:,:,1,2,2,[1,3,4],:,:,2:8,:,:),3:11)./...
        sum(y_out(:,:,1,2,2,[1,3,4],:,:,1:8,:,:),3:11)*100;
    % by inc status
    PWID_HIV_prevalence_never_inc =  sum(y_out(:,:,1,:,:,1,:,:,2:8,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,1,:,:,1:8,:,:),3:11)*100;
    PWID_HIV_prevalence_ever_inc =  sum(y_out(:,:,1,:,:,[3,4],:,:,2:8,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[3,4],:,:,1:8,:,:),3:11)*100;
    % by ngo status
    PWID_HIV_prevalence_com_client =  sum(y_out(:,:,1,:,:,[1,3,4],[2,3],:,2:8,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],[2,3],:,1:8,:,:),3:11)*100;
    PWID_HIV_prevalence_com_non_client =  sum(y_out(:,:,1,:,:,[1,3,4],1,:,2:8,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],1,:,1:8,:,:),3:11)*100;
    % by HCV AB status
    PWID_HIV_prevalence_com_HCV_neg = sum(y_out(:,:,1,:,:,[1,3,4],:,:,2:8,1,:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],:,:,1:8,1,:),3:11)*100;
    PWID_HIV_prevalence_com_HCV_pos = sum(y_out(:,:,1,:,:,[1,3,4],:,:,2:8,[2,3],:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],:,:,1:8,[2,3],:),3:11)*100;
    %% HIV prevalence among prisoners
    % overall
    PWID_HIV_prevalence_pris = sum(y_out(:,:,1,:,:,2,:,:,2:8,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,2,:,:,1:8,:,:),3:11)*100;
    %by gender
    PWID_HIV_prevalence_pris_ym = sum(y_out(:,:,1,1,1,2,:,:,2:8,:,:),3:11)./...
        sum(y_out(:,:,1,1,1,2,:,:,1:8,:,:),3:11)*100;
    PWID_HIV_prevalence_pris_om = sum(y_out(:,:,1,1,2,2,:,:,2:8,:,:),3:11)./...
        sum(y_out(:,:,1,1,2,2,:,:,1:8,:,:),3:11)*100;
    PWID_HIV_prevalence_pris_yf = sum(y_out(:,:,1,2,1,2,:,:,2:8,:,:),3:11)./...
        sum(y_out(:,:,1,2,1,2,:,:,1:8,:,:),3:11)*100;
    PWID_HIV_prevalence_pris_of = sum(y_out(:,:,1,2,2,2,:,:,2:8,:,:),3:11)./...
        sum(y_out(:,:,1,2,2,2,:,:,1:8,:,:),3:11)*100;
    %% HCV AB prevalence among community PWID
    % overall
    PWID_HCV_AB_prevalence_com = sum(y_out(:,:,1,:,:,[1,3,4],:,:,:,[2,3],:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],:,:,:,:,:),3:11)*100;
    %by gender
    PWID_HCV_AB_prevalence_com_ym = sum(y_out(:,:,1,1,1,[1,3,4],:,:,:,[2,3],:),3:11)./...
        sum(y_out(:,:,1,1,1,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_HCV_AB_prevalence_com_om = sum(y_out(:,:,1,1,2,[1,3,4],:,:,:,[2,3],:),3:11)./...
        sum(y_out(:,:,1,1,2,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_HCV_AB_prevalence_com_yf = sum(y_out(:,:,1,2,1,[1,3,4],:,:,:,[2,3],:),3:11)./...
        sum(y_out(:,:,1,2,1,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_HCV_AB_prevalence_com_of = sum(y_out(:,:,1,2,2,[1,3,4],:,:,:,[2,3],:),3:11)./...
        sum(y_out(:,:,1,2,2,[1,3,4],:,:,:,:,:),3:11)*100;
    % by inc status
    PWID_HCV_AB_prevalence_never_inc =  sum(y_out(:,:,1,:,:,1,:,:,:,[2,3],:),3:11)./...
        sum(y_out(:,:,1,:,:,1,:,:,:,:,:),3:11)*100;
    PWID_HCV_AB_prevalence_ever_inc =  sum(y_out(:,:,1,:,:,[3,4],:,:,:,[2,3],:),3:11)./...
        sum(y_out(:,:,1,:,:,[3,4],:,:,:,:,:),3:11)*100;
    % by ngo status
    PWID_HCV_AB_prevalence_com_client =  sum(y_out(:,:,1,:,:,[1,3,4],[2,3],:,:,[2,3],:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],[2,3],:,:,:,:),3:11)*100;
    PWID_HCV_AB_prevalence_com_non_client =  sum(y_out(:,:,1,:,:,[1,3,4],1,:,:,[2,3],:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],1,:,:,:,:),3:11)*100;
    % by HIV status
    PWID_HCV_AB_prevalence_com_HIV_neg = sum(y_out(:,:,1,:,:,[1,3,4],:,:,1,[2,3],:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],:,:,1,:,:),3:11)*100;
    PWID_HCV_AB_prevalence_com_HIV_pos = sum(y_out(:,:,1,:,:,[1,3,4],:,:,2:8,[2,3],:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],:,:,2:8,:,:),3:11)*100;
    %% HCV_AB prevalence among prisoners
    % overall
    PWID_HCV_AB_prevalence_pris = sum(y_out(:,:,1,:,:,2,:,:,:,[2,3],:),3:11)./...
        sum(y_out(:,:,1,:,:,2,:,:,:,:,:),3:11)*100;
    %by gender
    PWID_HCV_AB_prevalence_pris_ym = sum(y_out(:,:,1,1,1,2,:,:,:,[2,3],:),3:11)./...
        sum(y_out(:,:,1,1,1,2,:,:,:,:,:),3:11)*100;
    PWID_HCV_AB_prevalence_pris_om = sum(y_out(:,:,1,1,2,2,:,:,:,[2,3],:),3:11)./...
        sum(y_out(:,:,1,1,2,2,:,:,:,:,:),3:11)*100;
    PWID_HCV_AB_prevalence_pris_yf = sum(y_out(:,:,1,2,1,2,:,:,:,[2,3],:),3:11)./...
        sum(y_out(:,:,1,2,1,2,:,:,:,:,:),3:11)*100;
    PWID_HCV_AB_prevalence_pris_of = sum(y_out(:,:,1,2,2,2,:,:,:,[2,3],:),3:11)./...
        sum(y_out(:,:,1,2,2,2,:,:,:,:,:),3:11)*100;
    %% Prop on OST
    PWID_prop_current_OST_com = sum(y_out(:,:,1,:,:,[1,3,4],:,[2,3],:,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_current_OST_com_ym = sum(y_out(:,:,1,1,1,[1,3,4],:,[2,3],:,:,:),3:11)./...
        sum(y_out(:,:,1,1,1,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_current_OST_com_om = sum(y_out(:,:,1,1,2,[1,3,4],:,[2,3],:,:,:),3:11)./...
        sum(y_out(:,:,1,1,2,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_current_OST_com_yf = sum(y_out(:,:,1,2,1,[1,3,4],:,[2,3],:,:,:),3:11)./...
        sum(y_out(:,:,1,2,1,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_current_OST_com_of = sum(y_out(:,:,1,2,2,[1,3,4],:,[2,3],:,:,:),3:11)./...
        sum(y_out(:,:,1,2,2,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_current_OST_com_client = sum(y_out(:,:,1,:,:,[1,3,4],[2,3],[2,3],:,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],[2,3],:,:,:,:),3:11)*100;
    PWID_prop_current_OST_com_non_client = sum(y_out(:,:,1,:,:,[1,3,4],1,[2,3],:,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],1,:,:,:,:),3:11)*100;
    PWID_prop_current_OST_com_never_inc = sum(y_out(:,:,1,:,:,1,:,[2,3],:,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,1,:,:,:,:,:),3:11)*100;
    PWID_prop_current_OST_com_ever_inc = sum(y_out(:,:,1,:,:,[3,4],:,[2,3],:,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_current_OST_com_recent_inc = sum(y_out(:,:,1,:,:,3,:,[2,3],:,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,3,:,:,:,:,:),3:11)*100;
    PWID_prop_current_OST_com_non_recent_inc = sum(y_out(:,:,1,:,:,4,:,[2,3],:,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,4,:,:,:,:,:),3:11)*100;
    %% Prop ever on OST
    PWID_prop_ever_OST_com = sum(y_out(:,:,1,:,:,[1,3,4],:,[2,3,4],:,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_ever_OST_com_ym = sum(y_out(:,:,1,1,1,[1,3,4],:,[2,3,4],:,:,:),3:11)./...
        sum(y_out(:,:,1,1,1,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_ever_OST_com_om = sum(y_out(:,:,1,1,2,[1,3,4],:,[2,3,4],:,:,:),3:11)./...
        sum(y_out(:,:,1,1,2,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_ever_OST_com_yf = sum(y_out(:,:,1,2,1,[1,3,4],:,[2,3,4],:,:,:),3:11)./...
        sum(y_out(:,:,1,2,1,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_ever_OST_com_of = sum(y_out(:,:,1,2,2,[1,3,4],:,[2,3,4],:,:,:),3:11)./...
        sum(y_out(:,:,1,2,2,[1,3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_ever_OST_com_client = sum(y_out(:,:,1,:,:,[1,3,4],[2,3],[2,3,4],:,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],[2,3],:,:,:,:),3:11)*100;
    PWID_prop_ever_OST_com_non_client = sum(y_out(:,:,1,:,:,[1,3,4],1,[2,3,4],:,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],1,:,:,:,:),3:11)*100;
    PWID_prop_ever_OST_com_never_inc = sum(y_out(:,:,1,:,:,1,:,[2,3,4],:,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,1,:,:,:,:,:),3:11)*100;
    PWID_prop_ever_OST_com_ever_inc = sum(y_out(:,:,1,:,:,[3,4],:,[2,3,4],:,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[3,4],:,:,:,:,:),3:11)*100;
    PWID_prop_ever_OST_com_recent_inc = sum(y_out(:,:,1,:,:,3,:,[2,3,4],:,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,3,:,:,:,:,:),3:11)*100;
    PWID_prop_ever_OST_com_non_recent_inc = sum(y_out(:,:,1,:,:,4,:,[2,3,4],:,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,4,:,:,:,:,:),3:11)*100;
    PWID_prop_ever_OST_pris = sum(y_out(:,:,1,:,:,2,:,[2,3,4],:,:,:),3:11)./...
        sum(y_out(:,:,1,:,:,2,:,:,:,:,:),3:11)*100;
    %% Prop on ART
    PWID_prop_current_ART_com = sum(y_out(:,:,1,:,:,[1,3,4],:,:,[4,6,8],:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],:,:,2:8,:,:),3:11)*100;
    PWID_prop_current_ART_com_ym = sum(y_out(:,:,1,1,1,[1,3,4],:,:,[4,6,8],:,:),3:11)./...
        sum(y_out(:,:,1,1,1,[1,3,4],:,:,2:8,:,:),3:11)*100;
    PWID_prop_current_ART_com_om = sum(y_out(:,:,1,1,2,[1,3,4],:,:,[4,6,8],:,:),3:11)./...
        sum(y_out(:,:,1,1,2,[1,3,4],:,:,2:8,:,:),3:11)*100;
    PWID_prop_current_ART_com_yf = sum(y_out(:,:,1,2,1,[1,3,4],:,:,[4,6,8],:,:),3:11)./...
        sum(y_out(:,:,1,2,1,[1,3,4],:,:,2:8,:,:),3:11)*100;
    PWID_prop_current_ART_com_of = sum(y_out(:,:,1,2,2,[1,3,4],:,:,[4,6,8],:,:),3:11)./...
        sum(y_out(:,:,1,2,2,[1,3,4],:,:,2:8,:,:),3:11)*100;
    PWID_prop_current_ART_com_ever_inc = sum(y_out(:,:,1,:,:,[3,4],:,:,[4,6,8],:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[3,4],:,:,2:8,:,:),3:11)*100;
    PWID_prop_current_ART_com_never_inc = sum(y_out(:,:,1,:,:,1,:,:,[4,6,8],:,:),3:11)./...
        sum(y_out(:,:,1,:,:,1,:,:,2:8,:,:),3:11)*100;
    PWID_prop_current_ART_com_recent_inc = sum(y_out(:,:,1,:,:,3,:,:,[4,6,8],:,:),3:11)./...
        sum(y_out(:,:,1,:,:,3,:,:,2:8,:,:),3:11)*100;
    PWID_prop_current_ART_com_non_recent_inc = sum(y_out(:,:,1,:,:,4,:,:,[4,6,8],:,:),3:11)./...
        sum(y_out(:,:,1,:,:,4,:,:,2:8,:,:),3:11)*100;
    PWID_prop_current_ART_com_client = sum(y_out(:,:,1,:,:,[1,3,4],[2,3],:,[4,6,8],:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],[2,3],:,2:8,:,:),3:11)*100;
    PWID_prop_current_ART_com_non_client = sum(y_out(:,:,1,:,:,[1,3,4],1,:,[4,6,8],:,:),3:11)./...
        sum(y_out(:,:,1,:,:,[1,3,4],1,:,2:8,:,:),3:11)*100;
    PWID_prop_current_ART_pris = sum(y_out(:,:,1,:,:,2,:,:,[4,6,8],:,:),3:11)./...
        sum(y_out(:,:,1,:,:,2,:,:,2:8,:,:),3:11)*100;

PWID_prop_recently_incarcerated_NGO(isnan(PWID_prop_recently_incarcerated_NGO))=0;
PWID_prop_short_NGO(isnan(PWID_prop_short_NGO))=0;
PWID_prop_current_OST_com_client(isnan(PWID_prop_current_OST_com_client))=0;
PWID_prop_current_ART_com_client(isnan(PWID_prop_current_ART_com_client))=0;
PWID_prop_ever_OST_com_client(isnan(PWID_prop_ever_OST_com_client))=0;
%% FIGURES %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PWID population size
data_field = 'Pop_size';
figure;
fig = tiledlayout('flow');
fig.Padding = 'compact';
fig.TileSpacing = 'compact';
sgtitle('% PWID population size')
nexttile
function_plot_intervals(TIME,PWID_pop_size)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
xlabel('Time')
ylabel('Number of PWID')
xlim([1985,2020])
filename = [char(city_name),'_PWID_pop_size_.png'];
saveas(gcf,filename)
%% Proportion female
data_field = 'prop_female';
figure;
fig = tiledlayout('flow');
fig.Padding = 'compact';
fig.TileSpacing = 'compact';
sgtitle('% PWID who are female')
nexttile
function_plot_intervals(TIME,PWID_prop_female_com)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
xlabel('Time')
ylabel('% female')
xlim([1985,2020])
filename = [char(city_name),'_prop_female.png'];
saveas(gcf,filename)
%% <25
figure;
fig = tiledlayout('flow');
fig.Padding = 'compact';
fig.TileSpacing = 'compact';
sgtitle('% <25 years old')

f1=nexttile;
data_field = 'PWID_prop_male_com_young';
function_plot_intervals(TIME,PWID_prop_male_com_young)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Males')
xlabel('Time')
ylabel('% Young')


f2=nexttile;
data_field = 'PWID_prop_female_com_young';
function_plot_intervals(TIME,PWID_prop_female_com_young)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Females')
xlabel('Time')
ylabel('% Young')

linkaxes([f1,f2]);
xlim([1985,2020])
filename = [char(city_name),'_prop_young.png'];
saveas(gcf,filename)
%% Ever incarcerated
figure;
fig = tiledlayout('flow');
fig.Padding = 'compact';
fig.TileSpacing = 'compact';
sgtitle('% Ever Incarcerated')

f1 = nexttile;
data_field = 'prop_ever_inc_young_male';
function_plot_intervals(TIME,PWID_prop_ever_incarcerated_young_male)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Males <25y.o')
xlabel('Time')
ylabel('% ever incarcerated')


f2=nexttile;
data_field = 'prop_ever_inc_old_male';
function_plot_intervals(TIME,PWID_prop_ever_incarcerated_old_male)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Males >=25y.o')
xlabel('Time')
ylabel('% ever incarcerated')


f3=nexttile;
data_field = 'prop_ever_inc_young_female';
function_plot_intervals(TIME,PWID_prop_ever_incarcerated_young_female)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('females <25y.o')
xlabel('Time')
ylabel('% ever incarcerated')


f4=nexttile;
data_field = 'prop_ever_inc_old_female';
function_plot_intervals(TIME,PWID_prop_ever_incarcerated_old_female)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('females >=25y.o')
xlabel('Time')
ylabel('% ever incarcerated')


linkaxes([f1,f2,f3,f4]);
xlim([1985,2020])
filename = [char(city_name),'_ever_inc.png'];
saveas(gcf,filename)
%% Recently incarcerated
figure;
fig = tiledlayout('flow');
fig.Padding = 'compact';
fig.TileSpacing = 'compact';
sgtitle('% recently Incarcerated')

f1 = nexttile;
data_field = 'prop_rec_inc_young_male';
function_plot_intervals(TIME,PWID_prop_recently_incarcerated_young_male)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Males <25y.o')
xlabel('Time')
ylabel('% recently incarcerated')


f2=nexttile;
data_field = 'prop_rec_inc_old_male';
function_plot_intervals(TIME,PWID_prop_recently_incarcerated_old_male)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Males >=25y.o')
xlabel('Time')
ylabel('% recently incarcerated')


f3=nexttile;
data_field = 'prop_rec_inc_young_female';
function_plot_intervals(TIME,PWID_prop_recently_incarcerated_young_female)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('females <25y.o')
xlabel('Time')
ylabel('% recently incarcerated')


f4=nexttile;
data_field = 'prop_rec_inc_old_female';
function_plot_intervals(TIME,PWID_prop_recently_incarcerated_old_female)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('females >=25y.o')
xlabel('Time')
ylabel('% recently incarcerated')


f5=nexttile;
data_field = 'prop_rec_inc_NGO';
function_plot_intervals(TIME,PWID_prop_recently_incarcerated_NGO)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('NGO clients')
xlabel('Time')
ylabel('% recently incarcerated')


f6=nexttile;
data_field = 'prop_rec_inc_non_NGO';
function_plot_intervals(TIME,PWID_prop_recently_incarcerated_non_NGO)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('non_NGO clients')
xlabel('Time')
ylabel('% recently incarcerated')
linkaxes([f1,f2,f3,f4,f5,f6]);
xlim([1985,2020])
filename = [char(city_name),'_rec_inc.png'];
saveas(gcf,filename)
%% NGO coverage
figure;
fig = tiledlayout('flow');
fig.Padding = 'compact';
fig.TileSpacing = 'compact';
sgtitle('% who are NGO clients')

f1 = nexttile;
data_field = 'PWID_prop_NGO';
function_plot_intervals(TIME,PWID_prop_NGO)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Overall')
xlabel('Time')
ylabel('% NGO clients')

f2 = nexttile;
data_field = 'PWID_prop_NGO_young_male';
function_plot_intervals(TIME,PWID_prop_NGO_young_male)

if isempty(Data.(char(data_field)).time_pt) ==0
    for i=1:length(Data.(char(data_field)).time_pt)
        plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Males <25')
xlabel('Time')
ylabel('% NGO clients')

f3 = nexttile;
data_field = 'PWID_prop_NGO_old_male';
function_plot_intervals(TIME,PWID_prop_NGO_old_male)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Males >=25')
xlabel('Time')
ylabel('% NGO clients')

f4 = nexttile;
data_field = 'PWID_prop_NGO_young_female';
function_plot_intervals(TIME,PWID_prop_NGO_young_female)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Females <25')
xlabel('Time')
ylabel('% NGO clients')

f5 = nexttile;
data_field = 'PWID_prop_NGO_old_female';
function_plot_intervals(TIME,PWID_prop_NGO_old_female)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Females >=25')
xlabel('Time')
ylabel('% NGO clients')

f6 = nexttile;
data_field = 'PWID_prop_NGO_ever_inc';
function_plot_intervals(TIME,PWID_prop_NGO_ever_inc)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Ever incarcerated')
xlabel('Time')
ylabel('% NGO clients')

f7 = nexttile;
data_field = 'PWID_prop_NGO_never_inc';
function_plot_intervals(TIME,PWID_prop_NGO_never_inc)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Never incarcerated')
xlabel('Time')
ylabel('% NGO clients')

f8 = nexttile;
data_field = 'PWID_prop_NGO_HIV_pos';
function_plot_intervals(TIME,PWID_prop_NGO_HIV_pos)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('HIV positive')
xlabel('Time')
ylabel('% NGO clients')

f9 = nexttile;
data_field = 'PWID_prop_NGO_HIV_neg';
function_plot_intervals(TIME,PWID_prop_NGO_HIV_neg)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('HIV negative')
xlabel('Time')
ylabel('% NGO clients')

f10 = nexttile;
data_field = 'PWID_prop_NGO_HCV_pos';
function_plot_intervals(TIME,PWID_prop_NGO_HCV_pos)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('HCV positive')
xlabel('Time')
ylabel('% NGO clients')

f11 = nexttile;
data_field = 'PWID_prop_NGO_HCV_neg';
function_plot_intervals(TIME,PWID_prop_NGO_HCV_neg)

if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('HCV negative')
xlabel('Time')
ylabel('% NGO clients')
linkaxes([f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11]);
xlim([1985,2020])
filename = [char(city_name),'_NGO_coverage.png'];
saveas(gcf,filename)
%% Proportion of clients who have been clients for more than 2 years
figure;
fig = tiledlayout('flow');
fig.Padding = 'compact';
fig.TileSpacing = 'compact';
sgtitle('% NGO clients that are short term (<2 years)')

nexttile
data_field = 'PWID_prop_short_NGO';
function_plot_intervals(TIME,PWID_prop_short_NGO)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
xlabel('Time')
ylabel('% NGO clients')
filename = [char(city_name),'_NGO_short_term.png'];
saveas(gcf,filename)
%% HIV prevalence community
figure;
fig = tiledlayout('flow');
fig.Padding = 'compact';
fig.TileSpacing = 'compact';
sgtitle('HIV prevalence - community')

f1 = nexttile;
data_field = 'PWID_HIV_prevalence_com';
function_plot_intervals(TIME,PWID_HIV_prevalence_com)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Overall')
xlabel('Time')
ylabel('HIV prevalence (%)')

f2 = nexttile;
data_field = 'PWID_HIV_prevalence_com_ym';
function_plot_intervals(TIME,PWID_HIV_prevalence_com_ym)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Males <25')
xlabel('Time')
ylabel('HIV prevalence (%)')

f3 = nexttile;
data_field = 'PWID_HIV_prevalence_com_om';
function_plot_intervals(TIME,PWID_HIV_prevalence_com_om)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Males >=25')
xlabel('Time')
ylabel('HIV prevalence (%)')

f4 = nexttile;
data_field = 'PWID_HIV_prevalence_com_yf';
function_plot_intervals(TIME,PWID_HIV_prevalence_com_yf)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Females <25')
xlabel('Time')
ylabel('HIV prevalence (%)')

f5 = nexttile;
data_field = 'PWID_HIV_prevalence_com_of';
function_plot_intervals(TIME,PWID_HIV_prevalence_com_of)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Females >=25')
xlabel('Time')
ylabel('HIV prevalence (%)')

f6 = nexttile;
data_field = 'PWID_HIV_prevalence_never_inc';
function_plot_intervals(TIME,PWID_HIV_prevalence_never_inc)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Never incarcerated')
xlabel('Time')
ylabel('HIV prevalence (%)')

f7 = nexttile;
data_field = 'PWID_HIV_prevalence_ever_inc';
function_plot_intervals(TIME,PWID_HIV_prevalence_ever_inc)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Ever incarcerated')
xlabel('Time')
ylabel('HIV prevalence (%)')


f8 = nexttile;
data_field = 'PWID_HIV_prevalence_com_HCV_neg';
function_plot_intervals(TIME,PWID_HIV_prevalence_com_HCV_neg)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('HCV AB-ve')
xlabel('Time')
ylabel('HIV prevalence (%)')

f9 = nexttile;
data_field = 'PWID_HIV_prevalence_com_HCV_pos';
function_plot_intervals(TIME,PWID_HIV_prevalence_com_HCV_pos)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('HCV AB+ve')
xlabel('Time')
ylabel('HIV prevalence (%)')

f10 = nexttile;
data_field = 'PWID_HIV_prevalence_com_non_client';
function_plot_intervals(TIME,PWID_HIV_prevalence_com_non_client)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Non NGO clients')
xlabel('Time')
ylabel('HIV prevalence (%)')

f11 = nexttile;
data_field = 'PWID_HIV_prevalence_com_client';
function_plot_intervals(TIME,PWID_HIV_prevalence_com_client)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('NGO clients')
xlabel('Time')
ylabel('HIV prevalence (%)')
linkaxes([f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11]);
xlim([1985,2020])
filename = [char(city_name),'_HIV_prevalence_com.png'];
saveas(gcf,filename)
%% HIV prevalence prisons
figure;
fig = tiledlayout('flow');
fig.Padding = 'compact';
fig.TileSpacing = 'compact';
sgtitle('HIV prevalence - prisons')

f1 = nexttile;
data_field = 'PWID_HIV_prevalence_pris';
function_plot_intervals(TIME,PWID_HIV_prevalence_pris)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Overall')
xlabel('Time')
ylabel('HIV prevalence (%)')

f2 = nexttile;
data_field = 'PWID_HIV_prevalence_pris_ym';
function_plot_intervals(TIME,PWID_HIV_prevalence_pris_ym)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Males <25')
xlabel('Time')
ylabel('HIV prevalence (%)')

f3 = nexttile;
data_field = 'PWID_HIV_prevalence_pris_om';
function_plot_intervals(TIME,PWID_HIV_prevalence_pris_om)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Males >=25')
xlabel('Time')
ylabel('HIV prevalence (%)')

f4 = nexttile;
data_field = 'PWID_HIV_prevalence_pris_yf';
function_plot_intervals(TIME,PWID_HIV_prevalence_pris_yf)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Females <25')
xlabel('Time')
ylabel('HIV prevalence (%)')

f5 = nexttile;
data_field = 'PWID_HIV_prevalence_pris_of';
function_plot_intervals(TIME,PWID_HIV_prevalence_pris_of)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Females <25')
xlabel('Time')
ylabel('HIV prevalence (%)')
linkaxes([f1,f2,f3,f4,f5]);
xlim([1985,2020])
filename = [char(city_name),'_HIV_prevalence_pris.png'];
saveas(gcf,filename)
%% HCV_AB prevalence community
figure;
fig = tiledlayout('flow');
fig.Padding = 'compact';
fig.TileSpacing = 'compact';
sgtitle('HCV AB prevalence - community')

f1 = nexttile;
data_field = 'PWID_HCV_AB_prevalence_com';
function_plot_intervals(TIME,PWID_HCV_AB_prevalence_com)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Overall')
xlabel('Time')
ylabel('HCV AB prevalence (%)')

f2 = nexttile;
data_field = 'PWID_HCV_AB_prevalence_com_ym';
function_plot_intervals(TIME,PWID_HCV_AB_prevalence_com_ym)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Males <25')
xlabel('Time')
ylabel('HCV AB prevalence (%)')

f3 = nexttile;
data_field = 'PWID_HCV_AB_prevalence_com_om';
function_plot_intervals(TIME,PWID_HCV_AB_prevalence_com_om)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Males >=25')
xlabel('Time')
ylabel('HCV AB prevalence (%)')

f4 = nexttile;
data_field = 'PWID_HCV_AB_prevalence_com_yf';
function_plot_intervals(TIME,PWID_HCV_AB_prevalence_com_yf)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Females <25')
xlabel('Time')
ylabel('HCV AB prevalence (%)')

f5 = nexttile;
data_field = 'PWID_HCV_AB_prevalence_com_of';
function_plot_intervals(TIME,PWID_HCV_AB_prevalence_com_of)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Females >=25')
xlabel('Time')
ylabel('HCV AB prevalence (%)')

f6 = nexttile;
data_field = 'PWID_HCV_AB_prevalence_never_inc';
function_plot_intervals(TIME,PWID_HCV_AB_prevalence_never_inc)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Never incarcerated')
xlabel('Time')
ylabel('HCV AB prevalence (%)')

f7 = nexttile;
data_field = 'PWID_HCV_AB_prevalence_ever_inc';
function_plot_intervals(TIME,PWID_HCV_AB_prevalence_ever_inc)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Ever incarcerated')
xlabel('Time')
ylabel('HCV AB prevalence (%)')


f8 = nexttile;
data_field = 'PWID_HCV_AB_prevalence_com_HIV_neg';
function_plot_intervals(TIME,PWID_HCV_AB_prevalence_com_HIV_neg)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('HIV -ve')
xlabel('Time')
ylabel('HCV AB prevalence (%)')

f9 = nexttile;
data_field = 'PWID_HCV_AB_prevalence_com_HIV_pos';
function_plot_intervals(TIME,PWID_HCV_AB_prevalence_com_HIV_pos)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('HIV +ve')
xlabel('Time')
ylabel('HCV AB prevalence (%)')

f10 = nexttile;
data_field = 'PWID_HCV_AB_prevalence_com_non_client';
function_plot_intervals(TIME,PWID_HCV_AB_prevalence_com_non_client)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Non NGO clients')
xlabel('Time')
ylabel('HCV AB prevalence (%)')

f11 = nexttile;
data_field = 'PWID_HCV_AB_prevalence_com_client';
function_plot_intervals(TIME,PWID_HCV_AB_prevalence_com_client)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('NGO clients')
xlabel('Time')
ylabel('HCV AB prevalence (%)')
linkaxes([f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11]);
xlim([1985,2020])
filename = [char(city_name),'_HCV_AB_prevalence_com.png'];
saveas(gcf,filename)
%% HCV_AB prevalence prisons
figure;
fig = tiledlayout('flow');
fig.Padding = 'compact';
fig.TileSpacing = 'compact';
sgtitle('HCV AB prevalence - prisons')

f1 = nexttile;
data_field = 'PWID_HCV_AB_prevalence_pris';
function_plot_intervals(TIME,PWID_HCV_AB_prevalence_pris)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Overall')
xlabel('Time')
ylabel('HCV AB prevalence (%)')

f2 = nexttile;
data_field = 'PWID_HCV_AB_prevalence_pris_ym';
function_plot_intervals(TIME,PWID_HCV_AB_prevalence_pris_ym)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Males <25')
xlabel('Time')
ylabel('HCV AB prevalence (%)')

f3 = nexttile;
data_field = 'PWID_HCV_AB_prevalence_pris_om';
function_plot_intervals(TIME,PWID_HCV_AB_prevalence_pris_om)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Males >=25')
xlabel('Time')
ylabel('HCV AB prevalence (%)')

f4 = nexttile;
data_field = 'PWID_HCV_AB_prevalence_pris_yf';
function_plot_intervals(TIME,PWID_HCV_AB_prevalence_pris_yf)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Females <25')
xlabel('Time')
ylabel('HCV AB prevalence (%)')

f5 = nexttile;
data_field = 'PWID_HCV_AB_prevalence_pris_of';
function_plot_intervals(TIME,PWID_HCV_AB_prevalence_pris_of)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Females <25')
xlabel('Time')
ylabel('HCV AB prevalence (%)')
linkaxes([f1,f2,f3,f4,f5]);
xlim([1985,2020])
filename = [char(city_name),'_HCV_AB_prevalence_pris.png'];
saveas(gcf,filename)
%% ART coverage
figure;
fig = tiledlayout('flow');
fig.Padding = 'compact';
fig.TileSpacing = 'compact';
sgtitle('ART coverage - Community (except ***)')

f1 = nexttile;
data_field = 'PWID_prop_current_ART_com';
function_plot_intervals(TIME,PWID_prop_current_ART_com)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Overall')
xlabel('Time')
ylabel('ART coverage (%)')

f2 = nexttile;
data_field = 'PWID_prop_current_ART_com_ym';
function_plot_intervals(TIME,PWID_prop_current_ART_com_ym)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Males <25')
xlabel('Time')
ylabel('ART coverage (%)')

f3 = nexttile;
data_field = 'PWID_prop_current_ART_com_om';
function_plot_intervals(TIME,PWID_prop_current_ART_com_om)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Males >=25')
xlabel('Time')
ylabel('ART coverage (%)')

f4 = nexttile;
data_field = 'PWID_prop_current_ART_com_yf';
function_plot_intervals(TIME,PWID_prop_current_ART_com_yf)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Females <25')
xlabel('Time')
ylabel('ART coverage (%)')

f5 = nexttile;
data_field = 'PWID_prop_current_ART_com_of';
function_plot_intervals(TIME,PWID_prop_current_ART_com_of)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Females >=25')
xlabel('Time')
ylabel('ART coverage (%)')

f6 = nexttile;
data_field = 'PWID_prop_current_ART_com_non_client';
function_plot_intervals(TIME,PWID_prop_current_ART_com_non_client)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Non NGO clients')
xlabel('Time')
ylabel('ART coverage (%)')

f7 = nexttile;
data_field = 'PWID_prop_current_ART_com_client';
function_plot_intervals(TIME,PWID_prop_current_ART_com_client)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('NGO clients')
xlabel('Time')
ylabel('ART coverage (%)')

f8 = nexttile;
data_field = 'PWID_prop_current_ART_com_never_inc';
function_plot_intervals(TIME,PWID_prop_current_ART_com_never_inc)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Never incarcerated')
xlabel('Time')
ylabel('ART coverage (%)')

f9 = nexttile;
data_field = 'PWID_prop_current_ART_com_ever_inc';
function_plot_intervals(TIME,PWID_prop_current_ART_com_ever_inc)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Ever incarcerated (recent + non-recent)')
xlabel('Time')
ylabel('ART coverage (%)')

f10 = nexttile;
data_field = 'PWID_prop_current_ART_com_recent_inc';
function_plot_intervals(TIME,PWID_prop_current_ART_com_recent_inc)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Recent incarcerated')
xlabel('Time')
ylabel('ART coverage (%)')

f11 = nexttile;
data_field = 'PWID_prop_current_ART_com_non_recent_inc';
function_plot_intervals(TIME,PWID_prop_current_ART_com_non_recent_inc)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Ever incarcerated - non recent')
xlabel('Time')
ylabel('ART coverage (%)')

f12 = nexttile;
data_field = 'PWID_prop_current_ART_pris';
function_plot_intervals(TIME,PWID_prop_current_ART_pris)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('***Currently incarcerated***')
xlabel('Time')
ylabel('ART coverage (%)')

linkaxes([f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12]);
xlim([2000,2020])
filename = [char(city_name),'_ART_coverage.png'];
saveas(gcf,filename)
%% OST Coverage - current
figure;
fig = tiledlayout('flow');
fig.Padding = 'compact';
fig.TileSpacing = 'compact';
sgtitle('OST coverage - Community')

f1 = nexttile;
data_field = 'PWID_prop_current_OST_com';
function_plot_intervals(TIME,PWID_prop_current_OST_com)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Overall')
xlabel('Time')
ylabel('OST coverage (%)')

f2 = nexttile;
data_field = 'PWID_prop_current_OST_com_ym';
function_plot_intervals(TIME,PWID_prop_current_OST_com_ym)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Males <25')
xlabel('Time')
ylabel('OST coverage (%)')

f3 = nexttile;
data_field = 'PWID_prop_current_OST_com_om';
function_plot_intervals(TIME,PWID_prop_current_OST_com_om)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Males >=25')
xlabel('Time')
ylabel('OST coverage (%)')

f4 = nexttile;
data_field = 'PWID_prop_current_OST_com_yf';
function_plot_intervals(TIME,PWID_prop_current_OST_com_yf)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Females <25')
xlabel('Time')
ylabel('OST coverage (%)')

f5 = nexttile;
data_field = 'PWID_prop_current_OST_com_of';
function_plot_intervals(TIME,PWID_prop_current_OST_com_of)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Females >=25')
xlabel('Time')
ylabel('OST coverage (%)')

f6 = nexttile;
data_field = 'PWID_prop_current_OST_com_non_client';
function_plot_intervals(TIME,PWID_prop_current_OST_com_non_client)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Non NGO clients')
xlabel('Time')
ylabel('OST coverage (%)')

f7 = nexttile;
data_field = 'PWID_prop_current_OST_com_client';
function_plot_intervals(TIME,PWID_prop_current_OST_com_client)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('NGO clients')
xlabel('Time')
ylabel('OST coverage (%)')

f8 = nexttile;
data_field = 'PWID_prop_current_OST_com_never_inc';
function_plot_intervals(TIME,PWID_prop_current_OST_com_never_inc)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Never incarcerated')
xlabel('Time')
ylabel('OST coverage (%)')

f9 = nexttile;
data_field = 'PWID_prop_current_OST_com_ever_inc';
function_plot_intervals(TIME,PWID_prop_current_OST_com_ever_inc)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Ever incarcerated (recent + non-recent)')
xlabel('Time')
ylabel('OST coverage (%)')

f10 = nexttile;
data_field = 'PWID_prop_current_OST_com_recent_inc';
function_plot_intervals(TIME,PWID_prop_current_OST_com_recent_inc)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Recent incarcerated')
xlabel('Time')
ylabel('OST coverage (%)')

f11 = nexttile;
data_field = 'PWID_prop_current_OST_com_non_recent_inc';
function_plot_intervals(TIME,PWID_prop_current_OST_com_non_recent_inc)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Ever incarcerated - non recent')
xlabel('Time')
ylabel('OST coverage (%)')


linkaxes([f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11]);
xlim([2000,2020])
filename = [char(city_name),'_OST_coverage_com.png'];
saveas(gcf,filename)
%% OST Coverage - ever
figure;
fig = tiledlayout('flow');
fig.Padding = 'compact';
fig.TileSpacing = 'compact';
sgtitle('% ever OST - Community (except ***)')

f1 = nexttile;
data_field = 'PWID_prop_ever_OST_com';
function_plot_intervals(TIME,PWID_prop_ever_OST_com)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Overall')
xlabel('Time')
ylabel('% ever OST')

f2 = nexttile;
data_field = 'PWID_prop_ever_OST_com_ym';
function_plot_intervals(TIME,PWID_prop_ever_OST_com_ym)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Males <25')
xlabel('Time')
ylabel('% ever OST')

f3 = nexttile;
data_field = 'PWID_prop_ever_OST_com_om';
function_plot_intervals(TIME,PWID_prop_ever_OST_com_om)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Males >=25')
xlabel('Time')
ylabel('% ever OST')

f4 = nexttile;
data_field = 'PWID_prop_ever_OST_com_yf';
function_plot_intervals(TIME,PWID_prop_ever_OST_com_yf)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Females <25')
xlabel('Time')
ylabel('% ever OST')

f5 = nexttile;
data_field = 'PWID_prop_ever_OST_com_of';
function_plot_intervals(TIME,PWID_prop_ever_OST_com_of)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Females >=25')
xlabel('Time')
ylabel('% ever OST')

f6 = nexttile;
data_field = 'PWID_prop_ever_OST_com_non_client';
function_plot_intervals(TIME,PWID_prop_ever_OST_com_non_client)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Non NGO clients')
xlabel('Time')
ylabel('% ever OST')

f7 = nexttile;
data_field = 'PWID_prop_ever_OST_com_client';
function_plot_intervals(TIME,PWID_prop_ever_OST_com_client)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('NGO clients')
xlabel('Time')
ylabel('% ever OST')

f8 = nexttile;
data_field = 'PWID_prop_ever_OST_com_never_inc';
function_plot_intervals(TIME,PWID_prop_ever_OST_com_never_inc)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Never incarcerated')
xlabel('Time')
ylabel('% ever OST')

f9 = nexttile;
data_field = 'PWID_prop_ever_OST_com_ever_inc';
function_plot_intervals(TIME,PWID_prop_ever_OST_com_ever_inc)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Ever incarcerated (recent + non-recent)')
xlabel('Time')
ylabel('% ever OST')

f10 = nexttile;
data_field = 'PWID_prop_ever_OST_com_recent_inc';
function_plot_intervals(TIME,PWID_prop_ever_OST_com_recent_inc)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Recent incarcerated')
xlabel('Time')
ylabel('% ever OST')

f11 = nexttile;
data_field = 'PWID_prop_ever_OST_com_non_recent_inc';
function_plot_intervals(TIME,PWID_prop_ever_OST_com_non_recent_inc)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('Ever incarcerated - non recent')
xlabel('Time')
ylabel('% ever OST')

f12 = nexttile;
data_field = 'PWID_prop_ever_OST_pris';
function_plot_intervals(TIME,PWID_prop_ever_OST_pris)
if isempty(Data.(char(data_field)).time_pt) ==0
    plot(Data.(char(data_field)).time_pt,Data.(char(data_field)).estimate,'d','color','black','markerfacecolor','black','markersize',5)
    for i=1:length(Data.(char(data_field)).time_pt)
        plot([Data.(char(data_field)).time_pt(i),Data.(char(data_field)).time_pt(i)],[Data.(char(data_field)).lower(i),Data.(char(data_field)).upper(i)],'color','black','linewidth',3)
    end
end
title('***Currently incarcerated***')
xlabel('Time')
ylabel('% ever OST')


linkaxes([f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12]);
xlim([2000,2020])
filename = [char(city_name),'_ever_OST.png'];
saveas(gcf,filename)
end


function [] = function_plot_intervals(tSpan,y)

%%%%%% Injectors
hold on
%plot(tSpan,y,'color',[0.8 0.8 0.8]);
plot(tSpan,median(y,1),'k','linewidth',1.5);
%plot(tSpan,prctile(y,[0,100],1),'k-.','linewidth',1);
%plot(tSpan,prctile(y,[2.5,97.5],1),'k-.','linewidth'1);
%plot(tSpan,prctile(y,[25,75],1),'k--','linewidth',0.5);
%plot(tSpan,prctile(y,[2.5,97.5],1),'k-.','linewidth',0.5);
ciplot(prctile(y,2.5,1),prctile(y,97.5,1),tSpan,[0.5,0.5,0.5],0.3,1);
end