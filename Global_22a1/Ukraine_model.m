function ydot2 = Ukraine_model(t,y_tmp,params,model,scenario)

mydate=2022;   
%#codegen
%% Indexes
%{
Index 1 - Injecting status
    1 - current PWID
    2 - ex- PWID

Index 2 Gender
    1 - male
    2 - female

Index 3 - age
    1 - <25 years old
    2 - >=25 years old

Index 4 Incarceration
    1 - never incarcerated
    2 - currently incarcerated
    3 - recently released in last 12 months
    4 - ever incarcerated but not in last 12 months

Index 5 - Homelessness status
    1 - not homeless
    2 - homeless

Index 6 - OST
    1 - not on OST
    2 - currently on OST - < 1 year
    3 - currently on OST - >= 1 year
    4 - ever on OST

Index 7 - HIV infection status and ART status
    1 - Susceptible
    2 - Acute infection
    3 - chronic/latent infection - not on ART
    4 - chronic/latent infection - on ART
    5 - pre-AIDS - not on ART
    6 - pre-AIDS - on ART
    7 - AIDS - not on ART
    8 - AIDS - on ART

Index 8 - HCV infection status
    1 - Susceptible
    2 - previously exposed - (AB+ve, rna-ve)
    3 - chronic infection - (AB+ve, rna+ve)

Index 9 - HCV disease status
    1 - F0
    2 - F1
    3 - F2
    4 - F3
    5 - F4
    6 - Decompensated chirrosis
    7 - Hepatocellular carcinoma
%}
%% Set-up y and ydot
ydot = zeros(2,2,2,4,3,4,8,3,7);
switch model
    case 'Initialisation'
        % add zeros to compartments not included (ex-PWID, Homeless, OST, HIV, HCV infection & HCV disease stages)
        y = zeros(2,2,2,4,3,4,8,3,7);
        y_tmp = y_tmp(1:1*2*2*4*2*1*1*3*1);
        y_tmp = reshape(y_tmp,[1,2,2,4,2,1,1,3,1]);
        y(1,:,:,:,[1,2],1,1,:,1) = y_tmp;
    case 'Calibration'
        % add zeroes to compartments not included (ex-PWID & HCV disease stages)
        y = zeros(2,2,2,4,3,4,8,3,7);
        y_tmp = y_tmp(1:1*2*2*4*3*4*8*3*1);
        y_tmp = reshape(y_tmp,[1,2,2,4,3,4,8,3,1]);
        y(1,:,:,:,:,:,:,:,1) = y_tmp;
    case 'Projections'
        y = y_tmp(1:2*2*2*4*3*4*8*3*7);
        y = reshape(y,[2,2,2,4,3,4,8,3,7]);
    otherwise
        y = nan([2,2,2,4,3,4,8,3,7]);
        
end

HIV_Inf_sex = 0;
HIV_Inf_inj = 0;
HIV_Inf_tot = 0;
HIV_Incidence_PWID = 0;
HCV_Inf_tot = 0;
HCV_Incidence_PWID = 0;
HIV_Incidence_NGO = 0;
HIV_Incidence_non_NGO = 0;
HCV_Incidence_NGO = 0;
HCV_Incidence_non_NGO = 0;
ART_initiations_NGO=0;

%% Parameters




if t<params.OST_start_date
    params.OST_start_com = 0;
else
    params.OST_start_com = min(t-params.OST_start_date,params.OST_cal_date-params.OST_start_date)/(params.OST_cal_date-params.OST_start_date)*params.OST_start_com;
end

if t>params.OST_end_date
    params.OST_start_com = 0;
end

if t<params.ART_start_date
    params.ART_start = 0;
else
    params.ART_start =  min(t-params.ART_start_date,params.ART_cal_date-params.ART_start_date)/(params.ART_cal_date-params.ART_start_date)*params.ART_start;
end

if t>params.ART_end_date
    params.ART_start = 0;
end


% NSP edits from Antoine %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if t<params.NSP_start_date
%     params.NSP_start_com = 0;
% else
%     params.NSP_start_com =  min(t-params.NSP_start_date,params.NSP_cal_date-params.NSP_start_date)/(params.NSP_cal_date-params.NSP_start_date)*params.NSP_start_com;
% end
% 
% if t>params.NSP_end_date
%     params.NSP_start_com = 0;
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




switch scenario
    case 0 % default scenario for calibration
    
    case 1
        if t>=mydate
            params.OST_start_com = params.scale_OST_50_2030;
        end
    case 2
        if t>=mydate
            params.ART_start = params.scale_ART_50_2030;
        end
%%%% ART and OST scenario? %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    case 3
        if t>=mydate
            params.ART_start = params.scale_ART_50_2030;
            params.OST_start_com = params.scale_OST_50_2030;
        end
%%%%  NSP only%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    case 4
        if t>=mydate
%             params.ART_start = params.scale_ART_50_2030;
%             params.OST_start_com = params.scale_OST_50_2030;
        end
%%%%  NSP ART only%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    case 5
        if t>=mydate
             params.ART_start = params.scale_ART_50_2030;
%             params.OST_start_com = params.scale_OST_50_2030;
        end
%%%%  NSP OST only%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    case 6
        if t>=mydate
%              params.ART_start = params.scale_ART_50_2030;
             params.OST_start_com = params.scale_OST_50_2030;
        end
%%%%  NSP ART and OST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    case 7
        if t>=mydate
             params.ART_start = params.scale_ART_50_2030;
             params.OST_start_com = params.scale_OST_50_2030;
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

   
    otherwise
        y = nan([2,2,2,4,3,4,8,3,7]);
end

params.ART_recruit_matrix = params.ART_start*params.ART_recruit_matrix;
%% Background mortality + cessation
% excludes HIV disease related mortality and increased mortality in the
% first 4 weeks of starting or leaving OST

% params.mu_death_PWID = non_disease related death_rate among PWID

% params.RR_death_OST = relative risk of mortality if on OST vs off OST

% params.mu_death_ex = non_disease related death_rate among ex-PWID

% params.mu_cess = rate of injecting cessation

% mortality among PWID - not on OST
ydot(1,:,:,:,:,[1,4],:,:,:) = ydot(1,:,:,:,:,[1,4],:,:,:) - params.mu_death_PWID*y(1,:,:,:,:,[1,4],:,:,:);
% mortality among PWID - on OST
ydot(1,:,:,:,:,[2,3],:,:,:) = ydot(1,:,:,:,:,[2,3],:,:,:) - params.RR_death_OST.*params.mu_death_PWID*y(1,:,:,:,:,[2,3],:,:,:);

% mortality among ex-PWID
ydot(2,:,:,:,:,:,:,:,:) = ydot(2,:,:,:,:,:,:,:,:) - params.mu_death_ex*y(2,:,:,:,:,:,:,:,:);

% injecting cessation
ydot(1,:,:,:,:,:,:,:,:) = ydot(1,:,:,:,:,:,:,:,:) - params.mu_cess*y(1,:,:,:,:,:,:,:,:);
% add all ceasing pwid to never incarcerated, off OST and not in contact

%%%     edits
% with NGO and old should not be all  ceasing pwid to never incarcerated, off OST and not homeless and old
ydot(2,:,2,1,1,1,:,:,:) = ydot(2,:,2,1,1,1,:,:,:) + sum(sum(sum(sum(params.mu_cess*y(1,:,:,:,:,:,:,:,:),3),4),5),6);
%% Inflow into the model

% params.Initial_pop_size = starting population size

% params.entrants_matrix = a matrix of the proportions of new PWID that enter into
% each combination of compartments

% calculate expected number of exits in the absence of OST
exits = (params.mu_cess + params.mu_death_PWID)*params.PWID_initial_pop_size;


% calculate the number of new PWID entering with HIV
% entrants_matrix_temp = ones(size(params.entrants_matrix));
switch model
    case {'Initialisation'}
        params.entrants_matrix(:,:,:,:,:,:,2:8,:,:) = 0;
    case {'Calibration','Projections'}
        if t<params.seed_date
            params.entrants_matrix(:,:,:,:,:,:,2:8,:,:) = 0;
        else
            % assume no new PWID on ART and that infections are distributed evenly
            % among HIV disease stages (2,3,5,7)
            params.entrants_matrix(:,:,:,:,:,:,[4,6,8],:,:) = 0;
            params.entrants_matrix(:,1,1,:,:,:,[2,3,5,7],:,:) = min(t-params.seed_date, mydate-params.seed_date) / (mydate-params.seed_date) * params.prop_new_PWID_hiv_young_m * params.entrants_matrix(:,1,1,:,:,:,[2,3,5,7],:,:) / 4;
            params.entrants_matrix(:,1,1,:,:,:,1,:,:) = (1 - min(t-params.seed_date, mydate-params.seed_date) / (mydate-params.seed_date) * params.prop_new_PWID_hiv_young_m) * params.entrants_matrix(:,1,1,:,:,:,1,:,:);
            params.entrants_matrix(:,1,2,:,:,:,[2,3,5,7],:,:) = min(t-params.seed_date,mydate-params.seed_date)/(mydate-params.seed_date)*params.prop_new_PWID_hiv_old_m*params.entrants_matrix(:,1,2,:,:,:,[2,3,5,7],:,:)/4;
            params.entrants_matrix(:,1,2,:,:,:,1,:,:) = (1 - min(t-params.seed_date,mydate-params.seed_date)/(mydate-params.seed_date)*params.prop_new_PWID_hiv_old_m)*params.entrants_matrix(:,1,2,:,:,:,1,:,:);
            params.entrants_matrix(:,2,1,:,:,:,[2,3,5,7],:,:) = min(t-params.seed_date,mydate-params.seed_date)/(mydate-params.seed_date)*params.prop_new_PWID_hiv_young_f*params.entrants_matrix(:,2,1,:,:,:,[2,3,5,7],:,:)/4;
            params.entrants_matrix(:,2,1,:,:,:,1,:,:) = (1 - min(t-params.seed_date,mydate-params.seed_date)/(mydate-params.seed_date)*params.prop_new_PWID_hiv_young_f)*params.entrants_matrix(:,2,1,:,:,:,1,:,:);
            params.entrants_matrix(:,2,2,:,:,:,[2,3,5,7],:,:) = min(t-params.seed_date,mydate-params.seed_date)/(mydate-params.seed_date)*params.prop_new_PWID_hiv_old_f*params.entrants_matrix(:,2,2,:,:,:,[2,3,5,7],:,:)/4;
            params.entrants_matrix(:,2,2,:,:,:,1,:,:) = (1 - min(t-params.seed_date,mydate-params.seed_date)/(mydate-params.seed_date)*params.prop_new_PWID_hiv_old_f)*params.entrants_matrix(:,2,2,:,:,:,1,:,:);
        end
end

% add new PWID to the model
% ydot = ydot + params.factor_reduction_initiation*params.entrants_matrix*exits;
ydot = ydot + params.entrants_matrix*exits;
%% Ageing
% ageing_male = rate of ageing from young group to old group - same for
% males and females

% males
ydot(:,1,1,:,:,:,:,:,:) = ydot(:,1,1,:,:,:,:,:,:) - params.ageing_rate*y(:,1,1,:,:,:,:,:,:);
ydot(:,1,2,:,:,:,:,:,:) = ydot(:,1,2,:,:,:,:,:,:) + params.ageing_rate*y(:,1,1,:,:,:,:,:,:);
% females
ydot(:,2,1,:,:,:,:,:,:) = ydot(:,2,1,:,:,:,:,:,:) - params.ageing_rate*y(:,2,1,:,:,:,:,:,:);
ydot(:,2,2,:,:,:,:,:,:) = ydot(:,2,2,:,:,:,:,:,:) + params.ageing_rate*y(:,2,1,:,:,:,:,:,:);
%% Movement between incarceration states
% params.Inc_matrix = matrix of incarceration rates for each stratifcation (0 for
% ex-pwid and those already in prison)

% params.RR_death_params.OST_leave = relative increase in mortality in first 4 weeks of leaving
% OST

% remove those incarcerated from each incarceration compartment
ydot = ydot - params.Inc_matrix.*y;

% Add those incarcerated to the prison compartment. homeless move to non-homeless
% CASE 1: those not on OST or ART
ydot(:,:,:,2,1,1,[1,2,3,5,7],:,:) = ydot(:,:,:,2,1,1,[1,2,3,5,7],:,:) + sum(sum(params.Inc_matrix(:,:,:,:,:,1,[1,2,3,5,7],:,:).*y(:,:,:,:,:,1,[1,2,3,5,7],:,:),4),5);

if params.OST_prison==1 && params.ART_prison==1
    % CASE 2a: on OST, not on ART
    % no interruption of coverage
    ydot(:,:,:,2,1,[2,3,4],[1,2,3,5,7],:,:) = ydot(:,:,:,2,1,[2,3,4],[1,2,3,5,7],:,:) + sum(sum(params.Inc_matrix(:,:,:,:,:,[2,3,4],[1,2,3,5,7],:,:).*y(:,:,:,:,:,[2,3,4],[1,2,3,5,7],:,:),4),5);

    % CASE 3a: on ART (OST doesn't matter)
    % no interruption of coverage
    ydot(:,:,:,2,1,:,[4,6,8],:,:) = ydot(:,:,:,2,1,:,[4,6,8],:,:) + sum(sum(params.Inc_matrix(:,:,:,:,:,:,[4,6,8],:,:).*y(:,:,:,:,:,:,[4,6,8],:,:),4),5);

elseif params.OST_prison==1 && params.ART_prison==0
    % CASE 2b: on OST, not on ART
    % no interruption of coverage
    ydot(:,:,:,2,1,[2,3,4],[1,2,3,5,7],:,:) = ydot(:,:,:,2,1,[2,3,4],[1,2,3,5,7],:,:) + sum(sum(params.Inc_matrix(:,:,:,:,:,[2,3,4],[1,2,3,5,7],:,:).*y(:,:,:,:,:,[2,3,4],[1,2,3,5,7],:,:),4),5);
    
    % CASE 3b: on ART (OST doesn't matter)
    % Move those on ART off ART
    ydot(:,:,:,2,1,:,[3,5,7],:,:) = ydot(:,:,:,2,1,:,[3,5,7],:,:) + sum(sum(params.Inc_matrix(:,:,:,:,:,:,[4,6,8],:,:).*y(:,:,:,:,:,:,[4,6,8],:,:),4),5);

elseif params.OST_prison==0 && params.ART_prison==1
    % CASE 2c: on ART, not on OST
    % no interruption of coverage
    ydot(:,:,:,2,1,1,[4,6,8],:,:) = ydot(:,:,:,2,1,1,[4,6,8],:,:) + sum(sum(params.Inc_matrix(:,:,:,:,:,1,[4,6,8],:,:).*y(:,:,:,:,:,1,[4,6,8],:,:),4),5);
    
    % CASE 3c: on OST (ART doesn't matter)
    % Move those on OST to the ever OST compartment (ever OST not incarcerated move to ever OST currently incarcerated)
    ydot(:,:,:,2,1,4,:,:,:) = ydot(:,:,:,2,1,4,:,:,:) + sum(sum(sum(params.Inc_matrix(:,:,:,:,:,[2,3,4],:,:,:).*y(:,:,:,:,:,[2,3,4],:,:,:),4),5),6);
    % remove deaths due to increase in mortality in the first 4 weeks of leaving OST
    ydot(:,:,:,2,1,4,:,:,:) = ydot(:,:,:,2,1,4,:,:,:) -...
        (params.RR_death_OST_leave-1).*params.mu_death_PWID*4/52*(1-params.OST_retain_inc)*sum(sum(sum(params.Inc_matrix(:,:,:,:,:,[2,3],:,:,:).*y(:,:,:,:,:,[2,3],:,:,:),4),5),6);
    
elseif params.OST_prison==0 && params.ART_prison==0
    % CASE 2d: on OST, not on ART
    % Move those on OST to the ever OST compartment (ever OST not incarcerated move to ever OST currently incarcerated)
    ydot(:,:,:,2,1,4,[1,2,3,5,7],:,:) = ydot(:,:,:,2,1,4,[1,2,3,5,7],:,:) + sum(sum(sum(params.Inc_matrix(:,:,:,:,:,[2,3,4],[1,2,3,5,7],:,:).*y(:,:,:,:,:,[2,3,4],[1,2,3,5,7],:,:),4),5),6);
    % remove deaths due to increase in mortality in the first 4 weeks of leaving OST
    ydot(:,:,:,2,1,4,[1,2,3,5,7],:,:) = ydot(:,:,:,2,1,4,[1,2,3,5,7],:,:) -...
        (params.RR_death_OST_leave-1).*params.mu_death_PWID*4/52*(1-params.OST_retain_inc)*sum(sum(sum(params.Inc_matrix(:,:,:,:,:,[2,3],[1,2,3,5,7],:,:).*y(:,:,:,:,:,[2,3],[1,2,3,5,7],:,:),4),5),6);
    
    % CASE 3d: on ART, not on OST
    % Move those on ART off ART
    ydot(:,:,:,2,1,1,[3,5,7],:,:) = ydot(:,:,:,2,1,1,[3,5,7],:,:) + sum(sum(params.Inc_matrix(:,:,:,:,:,1,[4,6,8],:,:).*y(:,:,:,:,:,1,[4,6,8],:,:),4),5);
    
    % CASE 4d: on OST and ART
    % Move those on OST to the ever OST compartment, and move those on ART off ART
    ydot(:,:,:,2,1,4,[3,5,7],:,:) = ydot(:,:,:,2,1,4,[3,5,7],:,:) + sum(sum(sum(params.Inc_matrix(:,:,:,:,:,[2,3,4],[4,6,8],:,:).*y(:,:,:,:,:,[2,3,4],[4,6,8],:,:),4),5),6);
    % remove deaths due to increase in mortality in the first 4 weeks of leaving OST
    ydot(:,:,:,2,1,4,[3,5,7],:,:) = ydot(:,:,:,2,1,4,[3,5,7],:,:) -...
        (params.RR_death_OST_leave-1).*params.mu_death_PWID*4/52*(1-params.OST_retain_inc)*sum(sum(sum(params.Inc_matrix(:,:,:,:,:,[2,3],[3,5,7],:,:).*y(:,:,:,:,:,[2,3],[3,5,7],:,:),4),5),6);
end

% release (all prisoners)
ydot(:,:,:,2,:,:,:,:,:) = ydot(:,:,:,2,:,:,:,:,:) - params.prison_release.*y(:,:,:,2,:,:,:,:,:);
ydot(:,:,:,3,:,:,:,:,:) = ydot(:,:,:,3,:,:,:,:,:) + params.prison_release.*y(:,:,:,2,:,:,:,:,:);

% transition between recent incarceration and ever incarcerated but not
% recently incarcerated
ydot(:,:,:,3,:,:,:,:,:) = ydot(:,:,:,3,:,:,:,:,:) - params.transition_post_release_risk.*y(:,:,:,3,:,:,:,:,:);
ydot(:,:,:,4,:,:,:,:,:) = ydot(:,:,:,4,:,:,:,:,:) + params.transition_post_release_risk.*y(:,:,:,3,:,:,:,:,:);
%%


%%% EDITS  ANTOINE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NSP_prison=1;








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% I DO NOT CHANGE THE INITIALISATION FOR HCV
switch model
    case {'Initialisation'}
        HCV_inj_params.lambda_com = params.lambda_HCV_inj*sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_num(:,:,:,[1,3,4],:,:,:,:,:).*y(:,:,:,[1,3,4],:,:,:,:,:))))))))))./...
            sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_denom(:,:,:,[1,3,4],:,:,:,:,:).*y(:,:,:,[1,3,4],:,:,:,:,:))))))))));
        HCV_inj_params.lambda_com_young = params.lambda_HCV_inj*sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_num(:,:,1,[1,3,4],:,:,:,:,:).*y(:,:,1,[1,3,4],:,:,:,:,:))))))))))./...
            sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_denom(:,:,1,[1,3,4],:,:,:,:,:).*y(:,:,1,[1,3,4],:,:,:,:,:))))))))));
        HCV_inj_params.lambda_com_old = params.lambda_HCV_inj*sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_num(:,:,2,[1,3,4],:,:,:,:,:).*y(:,:,2,[1,3,4],:,:,:,:,:))))))))))./...
            sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_denom(:,:,2,[1,3,4],:,:,:,:,:).*y(:,:,2,[1,3,4],:,:,:,:,:))))))))));
        HCV_inj_params.lambda_pris = params.lambda_HCV_inj*sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_num(:,:,:,2,:,:,:,:,:).*y(:,:,:,2,:,:,:,:,:))))))))))./...
            sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_denom(:,:,:,2,:,:,:,:,:).*y(:,:,:,2,:,:,:,:,:))))))))));
        
        
        % HCV transmission in the community - HIV negatives
        ydot(:,:,:,[1,3,4],:,:,1,1,:) = ydot(:,:,:,[1,3,4],:,:,1,1,:) - (1-params.assortative)*HCV_inj_params.lambda_com*params.HCV_inj_matrix_denom(:,:,:,[1,3,4],:,:,1,1,:).*y(:,:,:,[1,3,4],:,:,1,1,:);
        ydot(:,:,:,[1,3,4],:,:,1,2,:) = ydot(:,:,:,[1,3,4],:,:,1,2,:) + (1-params.assortative)*params.alpha_HIV_neg*HCV_inj_params.lambda_com*params.HCV_inj_matrix_denom(:,:,:,[1,3,4],:,:,1,1,:).*y(:,:,:,[1,3,4],:,:,1,1,:) ...
            - (1-params.assortative)*(1-params.alpha_HIV_neg)*HCV_inj_params.lambda_com*params.HCV_inj_matrix_denom(:,:,:,[1,3,4],:,:,1,2,:).*y(:,:,:,[1,3,4],:,:,1,2,:);
        ydot(:,:,:,[1,3,4],:,:,1,3,:) = ydot(:,:,:,[1,3,4],:,:,1,3,:) + (1-params.assortative)*(1-params.alpha_HIV_neg)*sum(HCV_inj_params.lambda_com*params.HCV_inj_matrix_denom(:,:,:,[1,3,4],:,:,1,1:2,:).*y(:,:,:,[1,3,4],:,:,1,1:2,:),8);
        
        ydot(:,:,1,[1,3,4],:,:,1,1,:) = ydot(:,:,1,[1,3,4],:,:,1,1,:) - (params.assortative)*HCV_inj_params.lambda_com_young*params.HCV_inj_matrix_denom(:,:,1,[1,3,4],:,:,1,1,:).*y(:,:,1,[1,3,4],:,:,1,1,:);
        ydot(:,:,1,[1,3,4],:,:,1,2,:) = ydot(:,:,1,[1,3,4],:,:,1,2,:) + (params.assortative)*params.alpha_HIV_neg*HCV_inj_params.lambda_com_young*params.HCV_inj_matrix_denom(:,:,1,[1,3,4],:,:,1,1,:).*y(:,:,1,[1,3,4],:,:,1,1,:) ...
            - (params.assortative)*(1-params.alpha_HIV_neg)*HCV_inj_params.lambda_com_young*params.HCV_inj_matrix_denom(:,:,1,[1,3,4],:,:,1,2,:).*y(:,:,1,[1,3,4],:,:,1,2,:);
        ydot(:,:,1,[1,3,4],:,:,1,3,:) = ydot(:,:,1,[1,3,4],:,:,1,3,:) + (params.assortative)*(1-params.alpha_HIV_neg)*sum(HCV_inj_params.lambda_com_young*params.HCV_inj_matrix_denom(:,:,1,[1,3,4],:,:,1,1:2,:).*y(:,:,1,[1,3,4],:,:,1,1:2,:),8);
        
        ydot(:,:,2,[1,3,4],:,:,1,1,:) = ydot(:,:,2,[1,3,4],:,:,1,1,:) - (params.assortative)*HCV_inj_params.lambda_com_old*params.HCV_inj_matrix_denom(:,:,2,[1,3,4],:,:,1,1,:).*y(:,:,2,[1,3,4],:,:,1,1,:);
        ydot(:,:,2,[1,3,4],:,:,1,2,:) = ydot(:,:,2,[1,3,4],:,:,1,2,:) + (params.assortative)*params.alpha_HIV_neg*HCV_inj_params.lambda_com_old*params.HCV_inj_matrix_denom(:,:,2,[1,3,4],:,:,1,1,:).*y(:,:,2,[1,3,4],:,:,1,1,:) ...
            - (params.assortative)*(1-params.alpha_HIV_neg)*HCV_inj_params.lambda_com_old*params.HCV_inj_matrix_denom(:,:,2,[1,3,4],:,:,1,2,:).*y(:,:,2,[1,3,4],:,:,1,2,:);
        ydot(:,:,2,[1,3,4],:,:,1,3,:) = ydot(:,:,2,[1,3,4],:,:,1,3,:) + (params.assortative)*(1-params.alpha_HIV_neg)*sum(HCV_inj_params.lambda_com_old*params.HCV_inj_matrix_denom(:,:,2,[1,3,4],:,:,1,1:2,:).*y(:,:,2,[1,3,4],:,:,1,1:2,:),8);
        
        
        ydot(:,:,:,2,:,:,1,1,:) = ydot(:,:,:,2,:,:,1,1,:) - HCV_inj_params.lambda_pris*params.HCV_inj_matrix_denom(:,:,:,2,:,:,1,1,:).*y(:,:,:,2,:,:,1,1,:);
        ydot(:,:,:,2,:,:,1,2,:) = ydot(:,:,:,2,:,:,1,2,:) + params.alpha_HIV_neg*HCV_inj_params.lambda_pris*params.HCV_inj_matrix_denom(:,:,:,2,:,:,1,1,:).*y(:,:,:,2,:,:,1,1,:) ...
            - (1-params.alpha_HIV_neg)*HCV_inj_params.lambda_pris*params.HCV_inj_matrix_denom(:,:,:,2,:,:,1,2,:).*y(:,:,:,2,:,:,1,2,:);
        ydot(:,:,:,2,:,:,1,3,:) = ydot(:,:,:,2,:,:,1,3,:) + (1-params.alpha_HIV_neg)*sum(HCV_inj_params.lambda_pris*params.HCV_inj_matrix_denom(:,:,:,2,:,:,1,1:2,:).*y(:,:,:,2,:,:,1,1:2,:),8);
    case {'Calibration','Projections'}
        %% Movement on/off OST
        
        % RR_OST_start_NGO = relative increase in OST recruitment if in contact
        % with NGO
        
        % params.RR_death_OST_start = relative increase in mortality in first 4 weeks of starting
        % OST
        
        % params.RR_death_params.OST_leave = relative increase in mortality in first 4 weeks of leaving
        % OST
        
        % params.OST_start_matrix - array of incarceration rates for each group;
        
        
        params.OST_start_matrix(:,:,:,[1,3,4],:,:,:,:,:) = params.OST_start_com*params.OST_start_matrix(:,:,:,[1,3,4],:,:,:,:,:);
        
        
        % Start OST
        ydot(:,:,:,:,:,[1,4],:,:,:) = ydot(:,:,:,:,:,[1,4],:,:,:) - params.OST_start_matrix(:,:,:,:,:,[1,4],:,:,:).*y(:,:,:,:,:,[1,4],:,:,:);
        ydot(:,:,:,:,:,2,:,:,:) = ydot(:,:,:,:,:,2,:,:,:) + sum(params.OST_start_matrix(:,:,:,:,:,[1,4],:,:,:).*y(:,:,:,:,:,[1,4],:,:,:),6);
        % take off deaths due to increase in mortality in first 4 weeks of OST
        ydot(:,:,:,:,:,2,:,:,:) = ydot(:,:,:,:,:,2,:,:,:) - (params.RR_death_OST_start-1)*params.RR_death_OST*params.mu_death_PWID*4/52*sum(params.OST_start_matrix(:,:,:,:,:,[1,4],:,:,:).*y(:,:,:,:,:,[1,4],:,:,:),6);
        
        % OST - stay for 1 year
        ydot(:,:,:,:,:,2,:,:,:) = ydot(:,:,:,:,:,2,:,:,:) - y(:,:,:,:,:,2,:,:,:);
        ydot(:,:,:,:,:,3,:,:,:) = ydot(:,:,:,:,:,3,:,:,:) + y(:,:,:,:,:,2,:,:,:);
        
        % OST cessation
        ydot(:,:,:,:,:,2,:,:,:) = ydot(:,:,:,:,:,2,:,:,:) - params.OST_leave1*y(:,:,:,:,:,2,:,:,:);
        ydot(:,:,:,:,:,3,:,:,:) = ydot(:,:,:,:,:,3,:,:,:) - params.OST_leave2*y(:,:,:,:,:,3,:,:,:);
        ydot(:,:,:,:,:,4,:,:,:) = ydot(:,:,:,:,:,4,:,:,:) + params.OST_leave1*y(:,:,:,:,:,2,:,:,:) + params.OST_leave2*y(:,:,:,:,:,3,:,:,:);
        % take off deaths due to increase in mortality in first 4 weeks after leaving OST
        ydot(:,:,:,:,:,4,:,:,:) = ydot(:,:,:,:,:,4,:,:,:) - (params.RR_death_OST_leave-1).*params.mu_death_PWID*4/52*params.OST_leave1*y(:,:,:,:,:,2,:,:,:) ...
            -(params.RR_death_OST_leave-1).*params.mu_death_PWID*4/52*params.OST_leave2*y(:,:,:,:,:,3,:,:,:);
        %% Movement between homeless states
        
      % params.homeless_start_matrix = matrix of rates of starting
        % homelessness
        
        % params.homeless_leave = rates of becoming housed
        
        % start homelessness
        ydot(:,:,:,:,1,:,:,:,:) = ydot(:,:,:,:,1,:,:,:,:) - params.homeless_start_matrix(:,:,:,:,1,:,:,:,:).*y(:,:,:,:,1,:,:,:,:);
        ydot(:,:,:,:,2,:,:,:,:) = ydot(:,:,:,:,2,:,:,:,:) + params.homeless_start_matrix(:,:,:,:,1,:,:,:,:).*y(:,:,:,:,1,:,:,:,:);
        
        % transition between NGO contact durations
%         ydot(:,:,:,:,2,:,:,:,:) = ydot(:,:,:,:,2,:,:,:,:) - params.transition_NGO_duration*y(:,:,:,:,2,:,:,:,:);
%         ydot(:,:,:,:,3,:,:,:,:) = ydot(:,:,:,:,3,:,:,:,:) + params.transition_NGO_duration*y(:,:,:,:,2,:,:,:,:);
        
        % end homelessness
        ydot(:,:,:,:,2,:,:,:,:) = ydot(:,:,:,:,2,:,:,:,:) - params.homeless_leave*y(:,:,:,:,2,:,:,:,:);
        ydot(:,:,:,:,1,:,:,:,:) = ydot(:,:,:,:,1,:,:,:,:) + params.homeless_leave*y(:,:,:,:,2,:,:,:,:);
        %% HIV force of infection through sexual transmission
        
        % params.Prop_sex_active_matrix = matrix of proportions who are sexually active
        
        % params.Number_Contacts_matrix = matrix of contacts
        
        % params.HIV_sex_transmission_m = Prob HIV transmission for males
        
        % params.HIV_sex_transmission_f = Prob HIV transmission for females
        
        % params.Prop_male_partners_PWID = Proportion of male PWID's partners who are PWID
        
        % params.condom_efficacy = per-act effectiveness of condoms
        
        % params.Condom_use_matrix = Matrix of probabilities of using a condom
        
        mixing_matrix_f = params.Female_FOI_term2.*y(1,2,:,:,:,:,:,:,:)./...
            sum(params.Female_FOI_term2.*y(1,2,:,:,:,:,:,:,:),'all');% Stratified matrix. Represents proportion of sexual contacts of females by female group. Each entry is the number of sexual contacts of females in a particular group (contacts per person times group size) divided by total number of sexual contacts of females. Consists of params.Female_FOI_term2 multiplied by y, normalized. See above.
        
        mixing_matrix_f2 = mixing_matrix_f./y(1,2,:,:,:,:,:,:,:);
        mixing_matrix_f2(isnan(mixing_matrix_f2))=0;
        
        
        
%         Prev_f1 = reshape(mixing_matrix_f(1,1,:,:,:,:,:,:,:).*params.weighted_prev(1,2,:,:,:,:,:,:,:),[1*1*2*4*3*4*8*3*7,1]);
%         Prev_m1 = reshape(params.Male_FOT_term2.*y(1,1,:,:,:,:,:,:,:).*params.weighted_prev(1,1,:,:,:,:,:,:,:),[1*1*2*4*3*4*8*3*7,1]);
%         
%         sex_FOI(1,1,:,[1,3,4],:,:,1,:,:) = params.Male_FOI_term.*repmat(reshape(params.Condom_mf*Prev_f1,[1,1,2,3,3,4,1,1,1]),[1,1,1,1,1,1,1,3,7]);
%         sex_FOI(1,2,:,[1,3,4],:,:,1,:,:) = params.Female_FOI_term1.*repmat(reshape(params.Condom_fm*Prev_m1,[1,1,2,3,3,4,1,1,1]),[1,1,1,1,1,1,1,3,7]).*mixing_matrix_f2(1,1,:,[1,3,4],:,:,1,:,:);
%         
        sex_FOI = zeros(2,2,2,4,3,4,8,3,7);
       sex_FOI_internal = zeros(2,2,2,4,3,4,8,3,7);
        
        Prev_f1 = reshape(mixing_matrix_f(1,1,:,:,:,:,:,:,:).*params.weighted_prev(1,2,:,:,:,:,:,:,:),[1*1*2*4*3*4*8*3*7,1]); %Column vector. Represents the proportional sexual activity levels of HIV+ female subgroups, also includes relative transmissibility of HIV stages on/off ART. Consists of mixing_matrix_f and params.weighted_prev, multiplied and re-shaped into column vector. 
        Prev_m1 = reshape(params.Male_FOT_term2.*y(1,1,:,:,:,:,:,:,:).*params.weighted_prev(1,1,:,:,:,:,:,:,:,:,:),[1*1*2*4*3*4*8*3*7,1]); %Column vector containing number of sexual contacts of each male PWID HIV+ group (absolute, not per PWID), adjusted by transmissibility modifiers. Consists of params.Male_FOT_term2, params.weighted_prev, and the state vector, multiplied element-wise and reshaped into a column vector.
        
        sex_FOI_internal(1,1,:,[1,3,4],:,:,1,:,:) = params.Male_FOI_term.*repmat(reshape(params.Condom_mf*Prev_f1,[1,1,2,3,3,4,1,1,1]),[1,1,1,1,1,1,1,3,7]);
       %Stratified matrix. Sexual FOI term, nonzero for unincarcerated HIV-susceptibles. The male portion consists of params.Male_FOI_term, which describes male sexual activity, params.Condom_mf to incorporate condom usage, and Prev_f1, which represents the relative sexual activity levels and HIV transmissibility of female groups. params.Condom_mf is a matrix whose rows correspond to susceptible male groups, and whose columns correspond to female groups. Each entry is the probability a condom will be used in that partnership. Prev_f1 is a column vector corresponding to female groups, so params.Condom_mf*Prev_f1 (matrix multiplication) is a column vector representing average sexual risk for each male group.
         sex_FOI_internal(1,2,:,[1,3,4],:,:,1,:,:) = params.Female_FOI_term1.*repmat(reshape(params.Condom_fm*Prev_m1,[1,1,2,3,3,4,1,1,1]),[1,1,1,1,1,1,1,3,7]).*mixing_matrix_f2(1,1,:,[1,3,4],:,:,1,:,:);
      
         %external sex FOIs
         sex_FOI_external = zeros(2,2,2,4,3,4,8,3,7);
         
 if t<2017
 hiv_prev_young_f= ((t-params.seed_date)/(2017-params.seed_date))*params.prop_new_PWID_hiv_young_f;
 hiv_prev_young_m= ((t-params.seed_date)/(2017-params.seed_date))*params.prop_new_PWID_hiv_young_m;
 else
    hiv_prev_young_f=params.prop_new_PWID_hiv_young_f;
    hiv_prev_young_m=params.prop_new_PWID_hiv_young_m;
 end
 
 if t<params.ART_start_date
     propARTGenPop=0;
 elseif t>params.ART_start_date && t<2017
     propARTGenPop=((t-params.ART_start_date)/(2017-params.ART_start_date))*0.5;
 elseif t>2017
     propARTGenPop=0.5;
 end

 %%%%%%%%%%% EDITS FROM ANTOINE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  PWID_prop_NSP_com.time_pt =params.NSP_cal_date ;%2015;
 PWID_prop_NSP_com.estimate= params.NSP_cal_Est; % 0.394;
% PWID_prop_NSP_com.estimate
% params.NSP_start_date=2014;
%params.NSP_start_date=2004;
 if t<params.NSP_start_date
     propNSP=0;
     
 elseif t>=params.NSP_start_date && t< PWID_prop_NSP_com.time_pt 
     propNSP=((t-params.NSP_start_date)/(PWID_prop_NSP_com.time_pt -params.NSP_start_date))*PWID_prop_NSP_com.estimate ;
 elseif t>=PWID_prop_NSP_com.time_pt && t< 2022
     propNSP=PWID_prop_NSP_com.estimate ;
  elseif t>=2022
      if scenario==4
        propNSP=1 ;
      elseif scenario==5
        propNSP=1 ;
      elseif scenario==6
        propNSP=1 ;
      elseif scenario==7
        propNSP=1 ;
      else
         propNSP=PWID_prop_NSP_com.estimate ;
      end
 end
 
% relative risk of hiv transmission through idu if on NSP

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
        Prev_f1_external = reshape(mixing_matrix_f(1,1,:,:,:,:,:,:,:).*hiv_prev_young_f.*(1-propARTGenPop),[1*1*2*4*3*4*8*3*7,1]); %Column vector. Represents the proportional sexual activity levels of HIV+ female subgroups, also includes relative transmissibility of HIV stages on/off ART. Consists of mixing_matrix_f and params.weighted_prev, multiplied and re-shaped into column vector. 
        Prev_m1_external = reshape(params.Male_FOT_term2.*y(1,1,:,:,:,:,:,:,:).*hiv_prev_young_m.*(1-propARTGenPop),[1*1*2*4*3*4*8*3*7,1]); %Column vector containing number of sexual contacts of each male PWID HIV+ group (absolute, not per PWID), adjusted by transmissibility modifiers. Consists of params.Male_FOT_term2, params.weighted_prev, and the state vector, multiplied element-wise and reshaped into a column vector.
       
        sex_FOI_external(1,1,:,[1,3,4],:,:,1,:,:) = params.Male_FOI_termA.*repmat(reshape(params.Condom_mf*Prev_f1_external,[1,1,2,3,3,4,1,1,1]),[1,1,1,1,1,1,1,1,1]);
        sex_FOI_external(1,2,:,[1,3,4],:,:,1,:,:) = 0;% assume no female nonPWID partners. params.Female_FOI_term1A.*repmat(reshape(params.Condom_fm*Prev_m1_external,[1,1,2,3,3,4,1]),[1,1,1,1,1,1,1]).*mixing_matrix_f2(1,1,:,[1,3,4],:,:,1);
       
        sex_FOI=sex_FOI_internal+sex_FOI_external;
         
         
         %In the above equation, params.Condom_fm*Prev_m1 is a column vector. Each entry corresponds to a female group: the sum of male HIV+ PWID, weighted by sexual risks (condom use) corresponding to the female group. Multiplication with mixing_matrix_f2 yields the weighted sum of male HIV+ PWID that mix with each female group, on a per-female basis.


        ydot(1,:,:,:,:,:,1,:,:) = ydot(1,:,:,:,:,:,1,:,:) - sex_FOI(1,:,:,:,:,:,1,:,:).*y(1,:,:,:,:,:,1,:,:);
        ydot(1,:,:,:,:,:,2,:,:) = ydot(1,:,:,:,:,:,2,:,:) + sex_FOI(1,:,:,:,:,:,1,:,:).*y(1,:,:,:,:,:,1,:,:);
        
        if strcmp(model,'Projections')
            ydot(2,:,:,:,:,:,1,:,:) = ydot(2,:,:,:,:,:,1,:,:) - sex_FOI(1,:,:,:,:,:,1,:,:).*y(2,:,:,:,:,:,1,:,:)*params.ex_PWID_sex_trans_factor;
            ydot(2,:,:,:,:,:,2,:,:) = ydot(2,:,:,:,:,:,2,:,:) + sex_FOI(1,:,:,:,:,:,2,:,:).*y(2,:,:,:,:,:,1,:,:)*params.ex_PWID_sex_trans_factor;
        end
        %% HIV force of infection through Injecting transmission
%%%%%%%% EDITS FROM ANTOINE TO GET PROPER PROPORTION NSP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        HIV_inj_params.lambda_com = (1-(propNSP*(1-params.RR_HIV_NSP)))*params.lambda_HIV_inj*sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HIV_inj_matrix_num(:,:,:,[1,3,4],:,:,:,:,:).*y(:,:,:,[1,3,4],:,:,:,:,:))))))))))./...
            sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HIV_inj_matrix_denom(:,:,:,[1,3,4],:,:,:,:,:).*y(:,:,:,[1,3,4],:,:,:,:,:))))))))));
        HIV_inj_params.lambda_pris = (1-(NSP_prison*propNSP*(1-params.RR_HIV_NSP)))*params.lambda_HIV_inj*sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HIV_inj_matrix_num(:,:,:,2,:,:,:,:,:).*y(:,:,:,2,:,:,:,:,:))))))))))./...
            sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HIV_inj_matrix_denom(:,:,:,2,:,:,:,:,:).*y(:,:,:,2,:,:,:,:,:))))))))));
        
        HIV_inj_params.lambda_com_young = (1-(propNSP*(1-params.RR_HIV_NSP)))*params.lambda_HIV_inj*sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HIV_inj_matrix_num(:,:,1,[1,3,4],:,:,:,:,:).*y(:,:,1,[1,3,4],:,:,:,:,:))))))))))./...
            sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HIV_inj_matrix_denom(:,:,1,[1,3,4],:,:,:,:,:).*y(:,:,1,[1,3,4],:,:,:,:,:))))))))));
        HIV_inj_params.lambda_com_old = (1-(propNSP*(1-params.RR_HIV_NSP)))*params.lambda_HIV_inj*sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HIV_inj_matrix_num(:,:,2,[1,3,4],:,:,:,:,:).*y(:,:,2,[1,3,4],:,:,:,:,:))))))))))./...
            sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HIV_inj_matrix_denom(:,:,2,[1,3,4],:,:,:,:,:).*y(:,:,2,[1,3,4],:,:,:,:,:))))))))));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % HIV transmission in the community
        ydot(:,:,:,[1,3,4],:,:,1,:,:) = ydot(:,:,:,[1,3,4],:,:,1,:,:) - (1-params.assortative)*HIV_inj_params.lambda_com*params.HIV_inj_matrix_denom(:,:,:,[1,3,4],:,:,1,:,:).*y(:,:,:,[1,3,4],:,:,1,:,:);
        ydot(:,:,:,[1,3,4],:,:,2,:,:) = ydot(:,:,:,[1,3,4],:,:,2,:,:) + (1-params.assortative)*HIV_inj_params.lambda_com*params.HIV_inj_matrix_denom(:,:,:,[1,3,4],:,:,1,:,:).*y(:,:,:,[1,3,4],:,:,1,:,:);
        
        ydot(:,:,1,[1,3,4],:,:,1,:,:) = ydot(:,:,1,[1,3,4],:,:,1,:,:) - (params.assortative)*HIV_inj_params.lambda_com_young*params.HIV_inj_matrix_denom(:,:,1,[1,3,4],:,:,1,:,:).*y(:,:,1,[1,3,4],:,:,1,:,:);
        ydot(:,:,1,[1,3,4],:,:,2,:,:) = ydot(:,:,1,[1,3,4],:,:,2,:,:) + (params.assortative)*HIV_inj_params.lambda_com_young*params.HIV_inj_matrix_denom(:,:,1,[1,3,4],:,:,1,:,:).*y(:,:,1,[1,3,4],:,:,1,:,:);
        ydot(:,:,2,[1,3,4],:,:,1,:,:) = ydot(:,:,2,[1,3,4],:,:,1,:,:) - (params.assortative)*HIV_inj_params.lambda_com_old*params.HIV_inj_matrix_denom(:,:,2,[1,3,4],:,:,1,:,:).*y(:,:,2,[1,3,4],:,:,1,:,:);
        ydot(:,:,2,[1,3,4],:,:,2,:,:) = ydot(:,:,2,[1,3,4],:,:,2,:,:) + (params.assortative)*HIV_inj_params.lambda_com_old*params.HIV_inj_matrix_denom(:,:,2,[1,3,4],:,:,1,:,:).*y(:,:,2,[1,3,4],:,:,1,:,:);
        
        
        % HIV transmission in prison
        ydot(:,:,:,2,:,:,1,:,:) = ydot(:,:,:,2,:,:,1,:,:) - HIV_inj_params.lambda_pris*params.HIV_inj_matrix_denom(:,:,:,2,:,:,1,:,:).*y(:,:,:,2,:,:,1,:,:);
        ydot(:,:,:,2,:,:,2,:,:) = ydot(:,:,:,2,:,:,2,:,:) + HIV_inj_params.lambda_pris*params.HIV_inj_matrix_denom(:,:,:,2,:,:,1,:,:).*y(:,:,:,2,:,:,1,:,:);
        %% HIV Disease progression
        
        % params.tau_acute = rate of leaving the acute stage of HIV infection
        
        % params.tau_chronic = rate of leaving the acute stage of HIV infection
        
        % params.tau_preaids = rate of leaving the acute stage of HIV infection
        
        % params.tau_aids = mortality rate with aids
        
        % params.RR_HIVprog_ART = reduction in hiv progression and mortality if on art
        
        % acute to chronic/latent
        ydot(:,:,:,:,:,:,2,:,:) = ydot(:,:,:,:,:,:,2,:,:) - params.tau_acute*y(:,:,:,:,:,:,2,:,:);
        ydot(:,:,:,:,:,:,3,:,:) = ydot(:,:,:,:,:,:,3,:,:) + params.tau_acute*y(:,:,:,:,:,:,2,:,:);
        
        % latent to pre-aids; not on art
        ydot(:,:,:,:,:,:,3,:,:) = ydot(:,:,:,:,:,:,3,:,:) - params.tau_chronic*y(:,:,:,:,:,:,3,:,:);
        ydot(:,:,:,:,:,:,5,:,:) = ydot(:,:,:,:,:,:,5,:,:) + params.tau_chronic*y(:,:,:,:,:,:,3,:,:);
        
        % latent to pre-aids; on art
        ydot(:,:,:,:,:,:,4,:,:) = ydot(:,:,:,:,:,:,4,:,:) - params.RR_HIVprog_ART*params.tau_chronic*y(:,:,:,:,:,:,4,:,:);
        ydot(:,:,:,:,:,:,6,:,:) = ydot(:,:,:,:,:,:,6,:,:) + params.RR_HIVprog_ART*params.tau_chronic*y(:,:,:,:,:,:,4,:,:);
        
        % pre-aids to aids ; not on art
        ydot(:,:,:,:,:,:,5,:,:) = ydot(:,:,:,:,:,:,5,:,:) - params.tau_preAIDS*y(:,:,:,:,:,:,5,:,:);
        ydot(:,:,:,:,:,:,7,:,:) = ydot(:,:,:,:,:,:,7,:,:) + params.tau_preAIDS*y(:,:,:,:,:,:,5,:,:);
        
        % pre-aids to aids ; on art
        ydot(:,:,:,:,:,:,6,:,:) = ydot(:,:,:,:,:,:,6,:,:) - params.RR_HIVprog_ART*params.tau_preAIDS*y(:,:,:,:,:,:,6,:,:);
        ydot(:,:,:,:,:,:,8,:,:) = ydot(:,:,:,:,:,:,8,:,:) + params.RR_HIVprog_ART*params.tau_preAIDS*y(:,:,:,:,:,:,6,:,:);
        
        % HIV deaths
        ydot(:,:,:,:,:,:,7,:,:) = ydot(:,:,:,:,:,:,7,:,:) - params.tau_AIDS*y(:,:,:,:,:,:,7,:,:);
        ydot(:,:,:,:,:,:,8,:,:) = ydot(:,:,:,:,:,:,8,:,:) - params.RR_HIVprog_ART*params.tau_AIDS*y(:,:,:,:,:,:,8,:,:);
        %% ART recruitment and loss to care
        
        ydot(:,:,:,:,:,:,[3,5,7],:,:) = ydot(:,:,:,:,:,:,[3,5,7],:,:) - params.ART_recruit_matrix(:,:,:,:,:,:,[3,5,7],:,:).*y(:,:,:,:,:,:,[3,5,7],:,:);
        ydot(:,:,:,:,:,:,[4,6,8],:,:) = ydot(:,:,:,:,:,:,[4,6,8],:,:) + params.ART_recruit_matrix(:,:,:,:,:,:,[3,5,7],:,:).*y(:,:,:,:,:,:,[3,5,7],:,:);
        
        ydot(:,:,:,:,:,:,[4,6,8],:,:) = ydot(:,:,:,:,:,:,[4,6,8],:,:) - params.ART_leave_matrix(:,:,:,:,:,:,[4,6,8],:,:).*y(:,:,:,:,:,:,[4,6,8],:,:);
        ydot(:,:,:,:,:,:,[3,5,7],:,:) = ydot(:,:,:,:,:,:,[3,5,7],:,:) + params.ART_leave_matrix(:,:,:,:,:,:,[4,6,8],:,:).*y(:,:,:,:,:,:,[4,6,8],:,:);
        
        if strcmp(model,'Projections')
            ART_initiations_NGO = sum(params.ART_recruit_matrix(:,:,:,:,[2,3],:,[3,5,7],:,:).*y(:,:,:,:,[2,3],:,[3,5,7],:,:),'all');
        end
        %% HCV force of infection
        
%         HCV_inj_params.lambda_com = params.lambda_HCV_inj*sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_num(:,:,:,[1,3,4],:,:,:,:,:).*y(:,:,:,[1,3,4],:,:,:,:,:))))))))))./...
%             sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_denom(:,:,:,[1,3,4],:,:,:,:,:).*y(:,:,:,[1,3,4],:,:,:,:,:))))))))));
%         HCV_inj_params.lambda_com_young = params.lambda_HCV_inj*sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_num(:,:,1,[1,3,4],:,:,:,:,:).*y(:,:,1,[1,3,4],:,:,:,:,:))))))))))./...
%             sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_denom(:,:,1,[1,3,4],:,:,:,:,:).*y(:,:,1,[1,3,4],:,:,:,:,:))))))))));
%         HCV_inj_params.lambda_com_old = params.lambda_HCV_inj*sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_num(:,:,2,[1,3,4],:,:,:,:,:).*y(:,:,2,[1,3,4],:,:,:,:,:))))))))))./...
%             sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_denom(:,:,2,[1,3,4],:,:,:,:,:).*y(:,:,2,[1,3,4],:,:,:,:,:))))))))));
%         HCV_inj_params.lambda_pris = params.lambda_HCV_inj*sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_num(:,:,:,2,:,:,:,:,:).*y(:,:,:,2,:,:,:,:,:))))))))))./...
%             sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_denom(:,:,:,2,:,:,:,:,:).*y(:,:,:,2,:,:,:,:,:))))))))));
%         %%%%%%% NEW HCV FOI ADJUSTED FOR NSP
         HCV_inj_params.lambda_com = (1-(propNSP*(1-params.RR_HCV_NSP)))*params.lambda_HCV_inj*sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_num(:,:,:,[1,3,4],:,:,:,:,:).*y(:,:,:,[1,3,4],:,:,:,:,:))))))))))./...
            sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_denom(:,:,:,[1,3,4],:,:,:,:,:).*y(:,:,:,[1,3,4],:,:,:,:,:))))))))));
         HCV_inj_params.lambda_pris = (1-(NSP_prison*propNSP*(1-params.RR_HCV_NSP)))*params.lambda_HCV_inj*sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_num(:,:,:,2,:,:,:,:,:).*y(:,:,:,2,:,:,:,:,:))))))))))./...
            sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_denom(:,:,:,2,:,:,:,:,:).*y(:,:,:,2,:,:,:,:,:))))))))));
 
        HCV_inj_params.lambda_com_young = (1-(propNSP*(1-params.RR_HCV_NSP)))*params.lambda_HCV_inj*sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_num(:,:,1,[1,3,4],:,:,:,:,:).*y(:,:,1,[1,3,4],:,:,:,:,:))))))))))./...
            sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_denom(:,:,1,[1,3,4],:,:,:,:,:).*y(:,:,1,[1,3,4],:,:,:,:,:))))))))));
        HCV_inj_params.lambda_com_old = (1-(propNSP*(1-params.RR_HCV_NSP)))*params.lambda_HCV_inj*sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_num(:,:,2,[1,3,4],:,:,:,:,:).*y(:,:,2,[1,3,4],:,:,:,:,:))))))))))./...
            sum(sum(sum(sum(sum(sum(sum(sum(sum(params.HCV_inj_matrix_denom(:,:,2,[1,3,4],:,:,:,:,:).*y(:,:,2,[1,3,4],:,:,:,:,:))))))))));
              
        % HCV transmission in the community - HIV negatives
        ydot(:,:,:,[1,3,4],:,:,1,1,:) = ydot(:,:,:,[1,3,4],:,:,1,1,:) - (1-params.assortative)*HCV_inj_params.lambda_com*params.HCV_inj_matrix_denom(:,:,:,[1,3,4],:,:,1,1,:).*y(:,:,:,[1,3,4],:,:,1,1,:);
        ydot(:,:,:,[1,3,4],:,:,1,2,:) = ydot(:,:,:,[1,3,4],:,:,1,2,:) + (1-params.assortative)*params.alpha_HIV_neg*HCV_inj_params.lambda_com*params.HCV_inj_matrix_denom(:,:,:,[1,3,4],:,:,1,1,:).*y(:,:,:,[1,3,4],:,:,1,1,:) ...
            - (1-params.assortative)*(1-params.alpha_HIV_neg)*HCV_inj_params.lambda_com*params.HCV_inj_matrix_denom(:,:,:,[1,3,4],:,:,1,2,:).*y(:,:,:,[1,3,4],:,:,1,2,:);
        ydot(:,:,:,[1,3,4],:,:,1,3,:) = ydot(:,:,:,[1,3,4],:,:,1,3,:) + (1-params.assortative)*(1-params.alpha_HIV_neg)*sum(HCV_inj_params.lambda_com*params.HCV_inj_matrix_denom(:,:,:,[1,3,4],:,:,1,1:2,:).*y(:,:,:,[1,3,4],:,:,1,1:2,:),8);
        
        ydot(:,:,1,[1,3,4],:,:,1,1,:) = ydot(:,:,1,[1,3,4],:,:,1,1,:) - (params.assortative)*HCV_inj_params.lambda_com_young*params.HCV_inj_matrix_denom(:,:,1,[1,3,4],:,:,1,1,:).*y(:,:,1,[1,3,4],:,:,1,1,:);
        ydot(:,:,1,[1,3,4],:,:,1,2,:) = ydot(:,:,1,[1,3,4],:,:,1,2,:) + (params.assortative)*params.alpha_HIV_neg*HCV_inj_params.lambda_com_young*params.HCV_inj_matrix_denom(:,:,1,[1,3,4],:,:,1,1,:).*y(:,:,1,[1,3,4],:,:,1,1,:) ...
            - (params.assortative)*(1-params.alpha_HIV_neg)*HCV_inj_params.lambda_com_young*params.HCV_inj_matrix_denom(:,:,1,[1,3,4],:,:,1,2,:).*y(:,:,1,[1,3,4],:,:,1,2,:);
        ydot(:,:,1,[1,3,4],:,:,1,3,:) = ydot(:,:,1,[1,3,4],:,:,1,3,:) + (params.assortative)*(1-params.alpha_HIV_neg)*sum(HCV_inj_params.lambda_com_young*params.HCV_inj_matrix_denom(:,:,1,[1,3,4],:,:,1,1:2,:).*y(:,:,1,[1,3,4],:,:,1,1:2,:),8);
        
        ydot(:,:,2,[1,3,4],:,:,1,1,:) = ydot(:,:,2,[1,3,4],:,:,1,1,:) - (params.assortative)*HCV_inj_params.lambda_com_old*params.HCV_inj_matrix_denom(:,:,2,[1,3,4],:,:,1,1,:).*y(:,:,2,[1,3,4],:,:,1,1,:);
        ydot(:,:,2,[1,3,4],:,:,1,2,:) = ydot(:,:,2,[1,3,4],:,:,1,2,:) + (params.assortative)*params.alpha_HIV_neg*HCV_inj_params.lambda_com_old*params.HCV_inj_matrix_denom(:,:,2,[1,3,4],:,:,1,1,:).*y(:,:,2,[1,3,4],:,:,1,1,:) ...
            - (params.assortative)*(1-params.alpha_HIV_neg)*HCV_inj_params.lambda_com_old*params.HCV_inj_matrix_denom(:,:,2,[1,3,4],:,:,1,2,:).*y(:,:,2,[1,3,4],:,:,1,2,:);
        ydot(:,:,2,[1,3,4],:,:,1,3,:) = ydot(:,:,2,[1,3,4],:,:,1,3,:) + (params.assortative)*(1-params.alpha_HIV_neg)*sum(HCV_inj_params.lambda_com_old*params.HCV_inj_matrix_denom(:,:,2,[1,3,4],:,:,1,1:2,:).*y(:,:,2,[1,3,4],:,:,1,1:2,:),8);
        
        % HCV transmission in the community - HIV positives
        ydot(:,:,:,[1,3,4],:,:,2:8,1,:) = ydot(:,:,:,[1,3,4],:,:,2:8,1,:) - (1-params.assortative)*HCV_inj_params.lambda_com*params.HCV_inj_matrix_denom(:,:,:,[1,3,4],:,:,2:8,1,:).*y(:,:,:,[1,3,4],:,:,2:8,1,:);
        ydot(:,:,:,[1,3,4],:,:,2:8,2,:) = ydot(:,:,:,[1,3,4],:,:,2:8,2,:) + (1-params.assortative)*params.alpha_HIV_pos*HCV_inj_params.lambda_com*params.HCV_inj_matrix_denom(:,:,:,[1,3,4],:,:,2:8,1,:).*y(:,:,:,[1,3,4],:,:,2:8,1,:) ...
            - (1-params.assortative)*(1-params.alpha_HIV_pos)*HCV_inj_params.lambda_com*params.HCV_inj_matrix_denom(:,:,:,[1,3,4],:,:,2:8,2,:).*y(:,:,:,[1,3,4],:,:,2:8,2,:);
        ydot(:,:,:,[1,3,4],:,:,2:8,3,:) = ydot(:,:,:,[1,3,4],:,:,2:8,3,:) + (1-params.assortative)*(1-params.alpha_HIV_pos)*sum(HCV_inj_params.lambda_com*params.HCV_inj_matrix_denom(:,:,:,[1,3,4],:,:,2:8,1:2,:).*y(:,:,:,[1,3,4],:,:,2:8,1:2,:),8);
        
        ydot(:,:,1,[1,3,4],:,:,2:8,1,:) = ydot(:,:,1,[1,3,4],:,:,2:8,1,:) - (params.assortative)*HCV_inj_params.lambda_com_young*params.HCV_inj_matrix_denom(:,:,1,[1,3,4],:,:,2:8,1,:).*y(:,:,1,[1,3,4],:,:,2:8,1,:);
        ydot(:,:,1,[1,3,4],:,:,2:8,2,:) = ydot(:,:,1,[1,3,4],:,:,2:8,2,:) + (params.assortative)*params.alpha_HIV_pos*HCV_inj_params.lambda_com_young*params.HCV_inj_matrix_denom(:,:,1,[1,3,4],:,:,2:8,1,:).*y(:,:,1,[1,3,4],:,:,2:8,1,:) ...
            - (params.assortative)*(1-params.alpha_HIV_pos)*HCV_inj_params.lambda_com_young*params.HCV_inj_matrix_denom(:,:,1,[1,3,4],:,:,2:8,2,:).*y(:,:,1,[1,3,4],:,:,2:8,2,:);
        ydot(:,:,1,[1,3,4],:,:,2:8,3,:) = ydot(:,:,1,[1,3,4],:,:,2:8,3,:) + (params.assortative)*(1-params.alpha_HIV_pos)*sum(HCV_inj_params.lambda_com_young*params.HCV_inj_matrix_denom(:,:,1,[1,3,4],:,:,2:8,1:2,:).*y(:,:,1,[1,3,4],:,:,2:8,1:2,:),8);
        
        ydot(:,:,2,[1,3,4],:,:,2:8,1,:) = ydot(:,:,2,[1,3,4],:,:,2:8,1,:) - (params.assortative)*HCV_inj_params.lambda_com_old*params.HCV_inj_matrix_denom(:,:,2,[1,3,4],:,:,2:8,1,:).*y(:,:,2,[1,3,4],:,:,2:8,1,:);
        ydot(:,:,2,[1,3,4],:,:,2:8,2,:) = ydot(:,:,2,[1,3,4],:,:,2:8,2,:) + (params.assortative)*params.alpha_HIV_pos*HCV_inj_params.lambda_com_old*params.HCV_inj_matrix_denom(:,:,2,[1,3,4],:,:,2:8,1,:).*y(:,:,2,[1,3,4],:,:,2:8,1,:) ...
            - (params.assortative)*(1-params.alpha_HIV_pos)*HCV_inj_params.lambda_com_old*params.HCV_inj_matrix_denom(:,:,2,[1,3,4],:,:,2:8,2,:).*y(:,:,2,[1,3,4],:,:,2:8,2,:);
        ydot(:,:,2,[1,3,4],:,:,2:8,3,:) = ydot(:,:,2,[1,3,4],:,:,2:8,3,:) + (params.assortative)*(1-params.alpha_HIV_pos)*sum(HCV_inj_params.lambda_com_old*params.HCV_inj_matrix_denom(:,:,2,[1,3,4],:,:,2:8,1:2,:).*y(:,:,2,[1,3,4],:,:,2:8,1:2,:),8);
        
        
        % HCV transmission in prison - HIV negatives
        ydot(:,:,:,2,:,:,1,1,:) = ydot(:,:,:,2,:,:,1,1,:) - HCV_inj_params.lambda_pris*params.HCV_inj_matrix_denom(:,:,:,2,:,:,1,1,:).*y(:,:,:,2,:,:,1,1,:);
        ydot(:,:,:,2,:,:,1,2,:) = ydot(:,:,:,2,:,:,1,2,:) + params.alpha_HIV_neg*HCV_inj_params.lambda_pris*params.HCV_inj_matrix_denom(:,:,:,2,:,:,1,1,:).*y(:,:,:,2,:,:,1,1,:) ...
            - (1-params.alpha_HIV_neg)*HCV_inj_params.lambda_pris*params.HCV_inj_matrix_denom(:,:,:,2,:,:,1,2,:).*y(:,:,:,2,:,:,1,2,:);
        ydot(:,:,:,2,:,:,1,3,:) = ydot(:,:,:,2,:,:,1,3,:) + (1-params.alpha_HIV_neg)*sum(HCV_inj_params.lambda_pris*params.HCV_inj_matrix_denom(:,:,:,2,:,:,1,1:2,:).*y(:,:,:,2,:,:,1,1:2,:),8);
        
        % HCV transmission in prison - HIV positives
        ydot(:,:,:,2,:,:,2:8,1,:) = ydot(:,:,:,2,:,:,2:8,1,:) - HCV_inj_params.lambda_pris*params.HCV_inj_matrix_denom(:,:,:,2,:,:,2:8,1,:).*y(:,:,:,2,:,:,2:8,1,:);
        ydot(:,:,:,2,:,:,2:8,2,:) = ydot(:,:,:,2,:,:,2:8,2,:) + params.alpha_HIV_pos*HCV_inj_params.lambda_pris*params.HCV_inj_matrix_denom(:,:,:,2,:,:,2:8,1,:).*y(:,:,:,2,:,:,2:8,1,:) ...
            - (1-params.alpha_HIV_pos)*HCV_inj_params.lambda_pris*params.HCV_inj_matrix_denom(:,:,:,2,:,:,2:8,2,:).*y(:,:,:,2,:,:,2:8,2,:);
        ydot(:,:,:,2,:,:,2:8,3,:) = ydot(:,:,:,2,:,:,2:8,3,:) + (1-params.alpha_HIV_pos)*sum(HCV_inj_params.lambda_pris*params.HCV_inj_matrix_denom(:,:,:,2,:,:,2:8,1:2,:).*y(:,:,:,2,:,:,2:8,1:2,:),8);
        %% HCV treatment
        
        %% Outputs
        switch model
            case 'Calibration'
                HIV_Inf_sex = sex_FOI(1,:,:,:,:,:,1,:,:).*y(1,:,:,:,:,:,1,:,:);
                
                HIV_Inf_inj = zeros(size(HIV_Inf_sex));
                HIV_Inf_inj(1,:,:,2,:,:,1,:,:) = HIV_Inf_inj(1,:,:,2,:,:,1,:,:) + HIV_inj_params.lambda_pris*params.HIV_inj_matrix_denom(1,:,:,2,:,:,1,:,:).*y(1,:,:,2,:,:,1,:,:);
                HIV_Inf_inj(1,:,1,[1,3,4],:,:,1,:,:) = HIV_Inf_inj(1,:,1,[1,3,4],:,:,1,:,:) + (params.assortative)*HIV_inj_params.lambda_com_young*params.HIV_inj_matrix_denom(1,:,1,[1,3,4],:,:,1,:,:).*y(1,:,1,[1,3,4],:,:,1,:,:);
                HIV_Inf_inj(1,:,2,[1,3,4],:,:,1,:,:) = HIV_Inf_inj(1,:,2,[1,3,4],:,:,1,:,:) + (params.assortative)*HIV_inj_params.lambda_com_old*params.HIV_inj_matrix_denom(1,:,2,[1,3,4],:,:,1,:,:).*y(1,:,2,[1,3,4],:,:,1,:,:);
                HIV_Inf_inj(1,:,:,[1,3,4],:,:,1,:,:) = HIV_Inf_inj(1,:,:,[1,3,4],:,:,1,:,:) + (1-params.assortative)*HIV_inj_params.lambda_com*params.HIV_inj_matrix_denom(1,:,:,[1,3,4],:,:,1,:,:).*y(1,:,:,[1,3,4],:,:,1,:,:);
                
                HIV_Inf_tot = HIV_Inf_inj+HIV_Inf_sex;
                
                HIV_Incidence_PWID = sum(HIV_Inf_tot,'all')./sum(y(1,:,:,:,:,:,1,:,:),'all')*100;
               
                PWID_prop_HIV_sexual = sum(HIV_Inf_sex,'all')/(sum(HIV_Inf_sex,'all') + sum(HIV_Inf_inj,'all'))*100;

                RR_HIV_Incidence_rec_inc = (sum(HIV_Inf_tot(1,:,:,3,:,:,1,:,:),'all')/sum(y(1,:,:,3,:,:,1,:,:),'all'))/...
                                           (sum(HIV_Inf_tot(1,:,:,1,:,:,1,:,:),'all')/sum(y(1,:,:,1,:,:,1,:,:),'all'));
                
                RR_HIV_Incidence_nonrec_inc = (sum(HIV_Inf_tot(1,:,:,4,:,:,1,:,:),'all')/sum(y(1,:,:,4,:,:,1,:,:),'all'))/...
                                           (sum(HIV_Inf_tot(1,:,:,1,:,:,1,:,:),'all')/sum(y(1,:,:,1,:,:,1,:,:),'all'));
                                       
                RR_HIV_Incidence_homeless = (sum(HIV_Inf_tot(1,:,:,[1,3,4],2,:,1,:,:),'all')/sum(y(1,:,:,[1,3,4],2,:,1,:,:),'all')*100)/...
                                            (sum(HIV_Inf_tot(1,:,:,[1,3,4],1,:,1,:,:),'all')/sum(y(1,:,:,[1,3,4],1,:,1,:,:),'all')*100);
                                       
                HCV_Inf_chronic = zeros(2,2,2,4,3,4,8,3,7);
                HCV_Inf_chronic(:,:,:,2,:,:,1,:,:) = HCV_Inf_chronic(:,:,:,2,:,:,1,:,:) + (1-params.alpha_HIV_neg)*sum(HCV_inj_params.lambda_pris*params.HCV_inj_matrix_denom(:,:,:,2,:,:,1,1:2,:).*y(:,:,:,2,:,:,1,1:2,:),8);
                HCV_Inf_chronic(:,:,:,2,:,:,2:8,:,:) = HCV_Inf_chronic(:,:,:,2,:,:,2:8,:,:) + (1-params.alpha_HIV_pos)*sum(HCV_inj_params.lambda_pris*params.HCV_inj_matrix_denom(:,:,:,2,:,:,2:8,1:2,:).*y(:,:,:,2,:,:,2:8,1:2,:),8);
                HCV_Inf_chronic(:,:,:,[1,3,4],:,:,1,:,:) = HCV_Inf_chronic(:,:,:,[1,3,4],:,:,1,:,:) + (1-params.assortative)*(1-params.alpha_HIV_neg)*sum(HCV_inj_params.lambda_com*params.HCV_inj_matrix_denom(:,:,:,[1,3,4],:,:,1,1:2,:).*y(:,:,:,[1,3,4],:,:,1,1:2,:),8);
                HCV_Inf_chronic(:,:,1,[1,3,4],:,:,1,:,:) = HCV_Inf_chronic(:,:,1,[1,3,4],:,:,1,:,:) + (params.assortative)*(1-params.alpha_HIV_neg)*sum(HCV_inj_params.lambda_com_young*params.HCV_inj_matrix_denom(:,:,1,[1,3,4],:,:,1,1:2,:).*y(:,:,1,[1,3,4],:,:,1,1:2,:),8);
                HCV_Inf_chronic(:,:,2,[1,3,4],:,:,1,:,:) = HCV_Inf_chronic(:,:,2,[1,3,4],:,:,1,:,:) + (params.assortative)*(1-params.alpha_HIV_neg)*sum(HCV_inj_params.lambda_com_old*params.HCV_inj_matrix_denom(:,:,2,[1,3,4],:,:,1,1:2,:).*y(:,:,2,[1,3,4],:,:,1,1:2,:),8);
                HCV_Inf_chronic(:,:,:,[1,3,4],:,:,2:8,:,:) = HCV_Inf_chronic(:,:,:,[1,3,4],:,:,2:8,:,:) + (1-params.assortative)*(1-params.alpha_HIV_pos)*sum(HCV_inj_params.lambda_com*params.HCV_inj_matrix_denom(:,:,:,[1,3,4],:,:,2:8,1:2,:).*y(:,:,:,[1,3,4],:,:,2:8,1:2,:),8);
                HCV_Inf_chronic(:,:,1,[1,3,4],:,:,2:8,:,:) = HCV_Inf_chronic(:,:,1,[1,3,4],:,:,2:8,:,:) + (params.assortative)*(1-params.alpha_HIV_pos)*sum(HCV_inj_params.lambda_com_young*params.HCV_inj_matrix_denom(:,:,1,[1,3,4],:,:,2:8,1:2,:).*y(:,:,1,[1,3,4],:,:,2:8,1:2,:),8);
                HCV_Inf_chronic(:,:,2,[1,3,4],:,:,2:8,:,:) = HCV_Inf_chronic(:,:,2,[1,3,4],:,:,2:8,:,:) + (params.assortative)*(1-params.alpha_HIV_pos)*sum(HCV_inj_params.lambda_com_old*params.HCV_inj_matrix_denom(:,:,2,[1,3,4],:,:,2:8,1:2,:).*y(:,:,2,[1,3,4],:,:,2:8,1:2,:),8);

                RR_HCV_Incidence_rec_inc = (sum(HCV_Inf_chronic(1,:,:,3,:,:,:,:,:),'all')/sum(y(1,:,:,3,:,:,:,[2,3],:),'all'))/...
                                           (sum(HCV_Inf_chronic(1,:,:,1,:,:,:,:,:),'all')/sum(y(1,:,:,1,:,:,:,[2,3],:),'all'));
                
                RR_HCV_Incidence_nonrec_inc = (sum(HCV_Inf_chronic(1,:,:,4,:,:,:,:,:),'all')/sum(y(1,:,:,4,:,:,:,[2,3],:),'all'))/...
                                           (sum(HCV_Inf_chronic(1,:,:,1,:,:,:,:,:),'all')/sum(y(1,:,:,1,:,:,:,[2,3],:),'all'));
                                       
                RR_HCV_Incidence_homeless = (sum(HCV_Inf_chronic(1,:,:,[1,3,4],2,:,:,[1,2],:),'all')/sum(y(1,:,:,[1,3,4],2,:,:,[1,2],:),'all'))/...
                                            (sum(HCV_Inf_chronic(1,:,:,[1,3,4],1,:,:,[1,2],:),'all')/sum(y(1,:,:,[1,3,4],1,:,:,[1,2],:),'all'));
           
            case 'Projections'
                HIV_Inf_sex = sex_FOI(1,:,:,:,:,:,1,:,:).*y(1,:,:,:,:,:,1,:,:);
                
                HIV_Inf_inj = zeros(size(HIV_Inf_sex));
                HIV_Inf_inj(1,:,:,2,:,:,1,:,:) = HIV_Inf_inj(1,:,:,2,:,:,1,:,:) + HIV_inj_params.lambda_pris*params.HIV_inj_matrix_denom(1,:,:,2,:,:,1,:,:).*y(1,:,:,2,:,:,1,:,:);
                HIV_Inf_inj(1,:,1,[1,3,4],:,:,1,:,:) = HIV_Inf_inj(1,:,1,[1,3,4],:,:,1,:,:) + (params.assortative)*HIV_inj_params.lambda_com_young*params.HIV_inj_matrix_denom(1,:,1,[1,3,4],:,:,1,:,:).*y(1,:,1,[1,3,4],:,:,1,:,:);
                HIV_Inf_inj(1,:,2,[1,3,4],:,:,1,:,:) = HIV_Inf_inj(1,:,2,[1,3,4],:,:,1,:,:) + (params.assortative)*HIV_inj_params.lambda_com_old*params.HIV_inj_matrix_denom(1,:,2,[1,3,4],:,:,1,:,:).*y(1,:,2,[1,3,4],:,:,1,:,:);
                HIV_Inf_inj(1,:,:,[1,3,4],:,:,1,:,:) = HIV_Inf_inj(1,:,:,[1,3,4],:,:,1,:,:) + (1-params.assortative)*HIV_inj_params.lambda_com*params.HIV_inj_matrix_denom(1,:,:,[1,3,4],:,:,1,:,:).*y(1,:,:,[1,3,4],:,:,1,:,:);
                
                HIV_Inf_tot = HIV_Inf_inj+HIV_Inf_sex;
                
                %%%%%%% EDITS FROM ANTOINE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                PWID_prop_HIV_sexual = sum(HIV_Inf_sex,'all')/(sum(HIV_Inf_sex,'all') + sum(HIV_Inf_inj,'all'))*100;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                HIV_Incidence_PWID = sum(HIV_Inf_tot,'all')./sum(y(1,:,:,:,:,:,1,:,:),'all')*100;
                
                RR_HIV_Incidence_rec_inc = (sum(HIV_Inf_tot(1,:,:,3,:,:,1,:,:),'all')/sum(y(1,:,:,3,:,:,1,:,:),'all'))/...
                                           (sum(HIV_Inf_tot(1,:,:,1,:,:,1,:,:),'all')/sum(y(1,:,:,1,:,:,1,:,:),'all'));
                
                RR_HIV_Incidence_nonrec_inc = (sum(HIV_Inf_tot(1,:,:,4,:,:,1,:,:),'all')/sum(y(1,:,:,4,:,:,1,:,:),'all'))/...
                                           (sum(HIV_Inf_tot(1,:,:,1,:,:,1,:,:),'all')/sum(y(1,:,:,1,:,:,1,:,:),'all'));
                
                RR_HIV_Incidence_homeless = (sum(HIV_Inf_tot(1,:,:,[1,3,4],2,:,1,:,:),'all')/sum(y(1,:,:,[1,3,4],2,:,1,:,:),'all')*100)/...
                                            (sum(HIV_Inf_tot(1,:,:,[1,3,4],1,:,1,:,:),'all')/sum(y(1,:,:,[1,3,4],1,:,1,:,:),'all')*100);
                                       
                HCV_Inf_tot = sum(HCV_inj_params.lambda_pris*params.HCV_inj_matrix_denom(:,:,:,2,:,:,:,[1,2],:).*y(:,:,:,2,:,:,:,[1,2],:),'all')+...
                    sum((params.assortative)*HCV_inj_params.lambda_com_young*params.HCV_inj_matrix_denom(:,:,1,[1,3,4],:,:,:,[1,2],:).*y(:,:,1,[1,3,4],:,:,:,[1,2],:),'all')+...
                    sum((params.assortative)*HCV_inj_params.lambda_com_old*params.HCV_inj_matrix_denom(:,:,2,[1,3,4],:,:,:,[1,2],:).*y(:,:,2,[1,3,4],:,:,:,[1,2],:),'all')+...
                    sum((1-params.assortative)*HCV_inj_params.lambda_com*params.HCV_inj_matrix_denom(:,:,:,[1,3,4],:,:,:,[1,2],:).*y(:,:,:,[1,3,4],:,:,:,[1,2],:),'all');

                HCV_Incidence_PWID = HCV_Inf_tot./sum(y(1,:,:,:,:,:,:,[1,2],:),'all')*100;
                
                HCV_Inf_chronic = zeros(2,2,2,4,3,4,8,3,7);
                HCV_Inf_chronic(:,:,:,2,:,:,1,:,:) = HCV_Inf_chronic(:,:,:,2,:,:,1,:,:) + (1-params.alpha_HIV_neg)*sum(HCV_inj_params.lambda_pris*params.HCV_inj_matrix_denom(:,:,:,2,:,:,1,1:2,:).*y(:,:,:,2,:,:,1,1:2,:),8);
                HCV_Inf_chronic(:,:,:,2,:,:,2:8,:,:) = HCV_Inf_chronic(:,:,:,2,:,:,2:8,:,:) + (1-params.alpha_HIV_pos)*sum(HCV_inj_params.lambda_pris*params.HCV_inj_matrix_denom(:,:,:,2,:,:,2:8,1:2,:).*y(:,:,:,2,:,:,2:8,1:2,:),8);
                HCV_Inf_chronic(:,:,:,[1,3,4],:,:,1,:,:) = HCV_Inf_chronic(:,:,:,[1,3,4],:,:,1,:,:) + (1-params.assortative)*(1-params.alpha_HIV_neg)*sum(HCV_inj_params.lambda_com*params.HCV_inj_matrix_denom(:,:,:,[1,3,4],:,:,1,1:2,:).*y(:,:,:,[1,3,4],:,:,1,1:2,:),8);
                HCV_Inf_chronic(:,:,1,[1,3,4],:,:,1,:,:) = HCV_Inf_chronic(:,:,1,[1,3,4],:,:,1,:,:) + (params.assortative)*(1-params.alpha_HIV_neg)*sum(HCV_inj_params.lambda_com_young*params.HCV_inj_matrix_denom(:,:,1,[1,3,4],:,:,1,1:2,:).*y(:,:,1,[1,3,4],:,:,1,1:2,:),8);
                HCV_Inf_chronic(:,:,2,[1,3,4],:,:,1,:,:) = HCV_Inf_chronic(:,:,2,[1,3,4],:,:,1,:,:) + (params.assortative)*(1-params.alpha_HIV_neg)*sum(HCV_inj_params.lambda_com_old*params.HCV_inj_matrix_denom(:,:,2,[1,3,4],:,:,1,1:2,:).*y(:,:,2,[1,3,4],:,:,1,1:2,:),8);
                HCV_Inf_chronic(:,:,:,[1,3,4],:,:,2:8,:,:) = HCV_Inf_chronic(:,:,:,[1,3,4],:,:,2:8,:,:) + (1-params.assortative)*(1-params.alpha_HIV_pos)*sum(HCV_inj_params.lambda_com*params.HCV_inj_matrix_denom(:,:,:,[1,3,4],:,:,2:8,1:2,:).*y(:,:,:,[1,3,4],:,:,2:8,1:2,:),8);
                HCV_Inf_chronic(:,:,1,[1,3,4],:,:,2:8,:,:) = HCV_Inf_chronic(:,:,1,[1,3,4],:,:,2:8,:,:) + (params.assortative)*(1-params.alpha_HIV_pos)*sum(HCV_inj_params.lambda_com_young*params.HCV_inj_matrix_denom(:,:,1,[1,3,4],:,:,2:8,1:2,:).*y(:,:,1,[1,3,4],:,:,2:8,1:2,:),8);
                HCV_Inf_chronic(:,:,2,[1,3,4],:,:,2:8,:,:) = HCV_Inf_chronic(:,:,2,[1,3,4],:,:,2:8,:,:) + (params.assortative)*(1-params.alpha_HIV_pos)*sum(HCV_inj_params.lambda_com_old*params.HCV_inj_matrix_denom(:,:,2,[1,3,4],:,:,2:8,1:2,:).*y(:,:,2,[1,3,4],:,:,2:8,1:2,:),8);

                RR_HCV_Incidence_rec_inc = (sum(HCV_Inf_chronic(1,:,:,3,:,:,:,:,:),'all')/sum(y(1,:,:,3,:,:,:,[2,3],:),'all'))/...
                                           (sum(HCV_Inf_chronic(1,:,:,1,:,:,:,:,:),'all')/sum(y(1,:,:,1,:,:,:,[2,3],:),'all'));
                
                RR_HCV_Incidence_nonrec_inc = (sum(HCV_Inf_chronic(1,:,:,4,:,:,:,:,:),'all')/sum(y(1,:,:,4,:,:,:,[2,3],:),'all'))/...
                                           (sum(HCV_Inf_chronic(1,:,:,1,:,:,:,:,:),'all')/sum(y(1,:,:,1,:,:,:,[2,3],:),'all'));
                
                RR_HCV_Incidence_homeless = (sum(HCV_Inf_chronic(1,:,:,[1,3,4],2,:,:,[1,2],:),'all')/sum(y(1,:,:,[1,3,4],2,:,:,[1,2],:),'all'))/...
                                            (sum(HCV_Inf_chronic(1,:,:,[1,3,4],1,:,:,[1,2],:),'all')/sum(y(1,:,:,[1,3,4],1,:,:,[1,2],:),'all'));
                                       
                HIV_infs_NGO = sum(sex_FOI(1,:,:,:,[2,3],:,1,:,:).*y(1,:,:,:,[2,3],:,1,:,:),'all') + ...
                    sum(HIV_inj_params.lambda_pris*params.HIV_inj_matrix_denom(:,:,:,2,[2,3],:,1,:,:).*y(:,:,:,2,[2,3],:,1,:,:),'all') + ...
                    sum((params.assortative)*HIV_inj_params.lambda_com_young*params.HIV_inj_matrix_denom(:,:,1,[1,3,4],[2,3],:,1,:,:).*y(:,:,1,[1,3,4],[2,3],:,1,:,:),'all')+...
                    sum((params.assortative)*HIV_inj_params.lambda_com_old*params.HIV_inj_matrix_denom(:,:,2,[1,3,4],[2,3],:,1,:,:).*y(:,:,2,[1,3,4],[2,3],:,1,:,:),'all')+...
                    sum((1-params.assortative)*HIV_inj_params.lambda_com*params.HIV_inj_matrix_denom(:,:,:,[1,3,4],[2,3],:,1,:,:).*y(:,:,:,[1,3,4],[2,3],:,1,:,:),'all');
                
                HIV_infs_non_NGO = sum(sex_FOI(1,:,:,:,[1],:,1,:,:).*y(1,:,:,:,[1],:,1,:,:),'all') + ...
                    sum(HIV_inj_params.lambda_pris*params.HIV_inj_matrix_denom(:,:,:,2,[1],:,1,:,:).*y(:,:,:,2,[1],:,1,:,:),'all') + ...
                    sum((params.assortative)*HIV_inj_params.lambda_com_young*params.HIV_inj_matrix_denom(:,:,1,[1,3,4],[1],:,1,:,:).*y(:,:,1,[1,3,4],[1],:,1,:,:),'all')+...
                    sum((params.assortative)*HIV_inj_params.lambda_com_old*params.HIV_inj_matrix_denom(:,:,2,[1,3,4],[1],:,1,:,:).*y(:,:,2,[1,3,4],[1],:,1,:,:),'all')+...
                    sum((1-params.assortative)*HIV_inj_params.lambda_com*params.HIV_inj_matrix_denom(:,:,:,[1,3,4],[1],:,1,:,:).*y(:,:,:,[1,3,4],[1],:,1,:,:),'all');
                
                HCV_infs_NGO = sum(HCV_inj_params.lambda_pris*params.HCV_inj_matrix_denom(:,:,:,2,[2,3],:,:,[1,2],:).*y(:,:,:,2,[2,3],:,:,[1,2],:),'all')+...
                    sum((params.assortative)*HCV_inj_params.lambda_com_young*params.HCV_inj_matrix_denom(:,:,1,[1,3,4],[2,3],:,:,[1,2],:).*y(:,:,1,[1,3,4],[2,3],:,:,[1,2],:),'all')+...
                    sum((params.assortative)*HCV_inj_params.lambda_com_old*params.HCV_inj_matrix_denom(:,:,2,[1,3,4],[2,3],:,:,[1,2],:).*y(:,:,2,[1,3,4],[2,3],:,:,[1,2],:),'all')+...
                    sum((1-params.assortative)*HCV_inj_params.lambda_com*params.HCV_inj_matrix_denom(:,:,:,[1,3,4],[2,3],:,:,[1,2],:).*y(:,:,:,[1,3,4],[2,3],:,:,[1,2],:),'all');
                
                HCV_infs_non_NGO = sum(HCV_inj_params.lambda_pris*params.HCV_inj_matrix_denom(:,:,:,2,[1],:,:,[1,2],:).*y(:,:,:,2,[1],:,:,[1,2],:),'all')+...
                    sum((params.assortative)*HCV_inj_params.lambda_com_young*params.HCV_inj_matrix_denom(:,:,1,[1,3,4],1,:,:,[1,2],:).*y(:,:,1,[1,3,4],[1],:,:,[1,2],:),'all')+...
                    sum((params.assortative)*HCV_inj_params.lambda_com_old*params.HCV_inj_matrix_denom(:,:,2,[1,3,4],[1],:,:,[1,2],:).*y(:,:,2,[1,3,4],[1],:,:,[1,2],:),'all')+...
                    sum((1-params.assortative)*HCV_inj_params.lambda_com*params.HCV_inj_matrix_denom(:,:,:,[1,3,4],[1],:,:,[1,2],:).*y(:,:,:,[1,3,4],[1],:,:,[1,2],:),'all');
                
                if sum(y(1,:,:,:,[2,3],:,:,:,:),'all')>0
                    HIV_Incidence_NGO = 100*HIV_infs_NGO./sum(y(1,:,:,:,[2,3],:,1,:,:),'all');
                    HCV_Incidence_NGO = 100*HCV_infs_NGO./sum(y(1,:,:,:,[2,3],:,:,[1,2],:),'all');
                end
                HIV_Incidence_non_NGO = 100*HIV_infs_non_NGO./sum(y(1,:,:,:,1,:,1,:,:),'all');
                HCV_Incidence_non_NGO = 100*HCV_infs_non_NGO./sum(y(1,:,:,:,1,:,:,[1,2],:),'all');
                switch scenario
                    case {3,8}
                        HIV_Incidence_NGO = 0;
                        HCV_Incidence_NGO = 0;
                        ART_initiations_NGO=0;
                end
        end
        
end
switch model
    case {'Projections'}
        %% HCV Disease progression
        % allow slower rates for those who are rna-ve
        % allow degrading of fibrosis if rna-ve
        
        % params.omega_F0_F1 = progression from F0 to F1 in HIV negative
        
        % params.omega_F1_F2 = progression from F1 to F2 in HIV negative
        
        %params.omega_F2_F3 = progression from F2 to F3 in HIV negative
        
        %params.omega_F3_F4 = progression from F3 to F4 in HIV negative
        
        % params.omega_F_HIV = acceleration in progression to cirrhosis if HIV positive
        
        %params.omega_F_ART = acceleration in progression to cirrhosis if on ART vs HIV negative
        
        %params.omega_F4_DC = progression to decompensated cirrhosis from F4
        
        %params.omega_F4_HCC = progression to HCC from F4 / progression to HCC from DC
        
        %params.mu_DC = Death rate from decompensated cirrhosis if HIV negative
        
        %Factor_params.mu_DC_HIV = Relative death rate from decompensated cirrhosis if HIV positive vs negative
        
        %params.mu_HCC = Death rate from HCC
        
        % Progression from f0 to f1 among RNA positives
        ydot(:,:,:,:,:,:,1,3,1) = ydot(:,:,:,:,:,:,1,3,1) - params.omega_F0_F1*y(:,:,:,:,:,:,1,3,1);
        ydot(:,:,:,:,:,:,1,3,2) = ydot(:,:,:,:,:,:,1,3,2) + params.omega_F0_F1*y(:,:,:,:,:,:,1,3,1);
        ydot(:,:,:,:,:,:,[2,3,5,7],3,1) = ydot(:,:,:,:,:,:,[2,3,5,7],3,1) - params.omega_F_HIV*params.omega_F0_F1*y(:,:,:,:,:,:,[2,3,5,7],3,1);
        ydot(:,:,:,:,:,:,[2,3,5,7],3,2) = ydot(:,:,:,:,:,:,[2,3,5,7],3,2) + params.omega_F_HIV*params.omega_F0_F1*y(:,:,:,:,:,:,[2,3,5,7],3,1);
        ydot(:,:,:,:,:,:,[4,6,8],3,1) = ydot(:,:,:,:,:,:,[4,6,8],3,1) - params.omega_F_ART*params.omega_F_HIV*params.omega_F0_F1*y(:,:,:,:,:,:,[4,6,8],3,1);
        ydot(:,:,:,:,:,:,[4,6,8],3,2) = ydot(:,:,:,:,:,:,[4,6,8],3,2) + params.omega_F_ART*params.omega_F_HIV*params.omega_F0_F1*y(:,:,:,:,:,:,[4,6,8],3,1);
        
        % Progression from f1 to f2 among RNA positives
        ydot(:,:,:,:,:,:,1,3,2) = ydot(:,:,:,:,:,:,1,3,2) - params.omega_F1_F2*y(:,:,:,:,:,:,1,3,2);
        ydot(:,:,:,:,:,:,1,3,3) = ydot(:,:,:,:,:,:,1,3,3) + params.omega_F1_F2*y(:,:,:,:,:,:,1,3,2);
        ydot(:,:,:,:,:,:,[2,3,5,7],3,2) = ydot(:,:,:,:,:,:,[2,3,5,7],3,2) - params.omega_F_HIV*params.omega_F1_F2*y(:,:,:,:,:,:,[2,3,5,7],3,2);
        ydot(:,:,:,:,:,:,[2,3,5,7],3,3) = ydot(:,:,:,:,:,:,[2,3,5,7],3,3) + params.omega_F_HIV*params.omega_F1_F2*y(:,:,:,:,:,:,[2,3,5,7],3,2);
        ydot(:,:,:,:,:,:,[4,6,8],3,2) = ydot(:,:,:,:,:,:,[4,6,8],3,2) - params.omega_F_ART*params.omega_F_HIV*params.omega_F1_F2*y(:,:,:,:,:,:,[4,6,8],3,2);
        ydot(:,:,:,:,:,:,[4,6,8],3,3) = ydot(:,:,:,:,:,:,[4,6,8],3,3) + params.omega_F_ART*params.omega_F_HIV*params.omega_F1_F2*y(:,:,:,:,:,:,[4,6,8],3,2);
        
        % Progression from f2 to f3 among RNA positives
        ydot(:,:,:,:,:,:,1,3,3) = ydot(:,:,:,:,:,:,1,3,3) - params.omega_F2_F3*y(:,:,:,:,:,:,1,3,3);
        ydot(:,:,:,:,:,:,1,3,4) = ydot(:,:,:,:,:,:,1,3,4) + params.omega_F2_F3*y(:,:,:,:,:,:,1,3,3);
        ydot(:,:,:,:,:,:,[2,3,5,7],3,3) = ydot(:,:,:,:,:,:,[2,3,5,7],3,3) - params.omega_F_HIV*params.omega_F2_F3*y(:,:,:,:,:,:,[2,3,5,7],3,3);
        ydot(:,:,:,:,:,:,[2,3,5,7],3,4) = ydot(:,:,:,:,:,:,[2,3,5,7],3,4) + params.omega_F_HIV*params.omega_F2_F3*y(:,:,:,:,:,:,[2,3,5,7],3,3);
        ydot(:,:,:,:,:,:,[4,6,8],3,3) = ydot(:,:,:,:,:,:,[4,6,8],3,3) - params.omega_F_ART*params.omega_F_HIV*params.omega_F2_F3*y(:,:,:,:,:,:,[4,6,8],3,3);
        ydot(:,:,:,:,:,:,[4,6,8],3,4) = ydot(:,:,:,:,:,:,[4,6,8],3,4) + params.omega_F_ART*params.omega_F_HIV*params.omega_F2_F3*y(:,:,:,:,:,:,[4,6,8],3,3);
        
        % Progression from f3 to f4 among RNA positives
        ydot(:,:,:,:,:,:,1,3,4) = ydot(:,:,:,:,:,:,1,3,4) - params.omega_F3_F4*y(:,:,:,:,:,:,1,3,4);
        ydot(:,:,:,:,:,:,1,3,5) = ydot(:,:,:,:,:,:,1,3,5) + params.omega_F3_F4*y(:,:,:,:,:,:,1,3,4);
        ydot(:,:,:,:,:,:,[2,3,5,7],3,4) = ydot(:,:,:,:,:,:,[2,3,5,7],3,4) - params.omega_F_HIV*params.omega_F3_F4*y(:,:,:,:,:,:,[2,3,5,7],3,4);
        ydot(:,:,:,:,:,:,[2,3,5,7],3,5) = ydot(:,:,:,:,:,:,[2,3,5,7],3,5) + params.omega_F_HIV*params.omega_F3_F4*y(:,:,:,:,:,:,[2,3,5,7],3,4);
        ydot(:,:,:,:,:,:,[4,6,8],3,4) = ydot(:,:,:,:,:,:,[4,6,8],3,4) - params.omega_F_ART*params.omega_F_HIV*params.omega_F3_F4*y(:,:,:,:,:,:,[4,6,8],3,4);
        ydot(:,:,:,:,:,:,[4,6,8],3,5) = ydot(:,:,:,:,:,:,[4,6,8],3,5) + params.omega_F_ART*params.omega_F_HIV*params.omega_F3_F4*y(:,:,:,:,:,:,[4,6,8],3,4);
        
        % Progression from f4 to DC among RNA positives
        ydot(:,:,:,:,:,:,:,3,5) = ydot(:,:,:,:,:,:,:,3,5) - params.omega_F4_DC*y(:,:,:,:,:,:,:,3,5);
        ydot(:,:,:,:,:,:,:,3,6) = ydot(:,:,:,:,:,:,:,3,6) + params.omega_F4_DC*y(:,:,:,:,:,:,:,3,5);
        
        % Progression from f4 to HCC among RNA positives
        ydot(:,:,:,:,:,:,:,3,5) = ydot(:,:,:,:,:,:,:,3,5) - params.omega_F4_HCC*y(:,:,:,:,:,:,:,3,5);
        ydot(:,:,:,:,:,:,:,3,7) = ydot(:,:,:,:,:,:,:,3,7) + params.omega_F4_HCC*y(:,:,:,:,:,:,:,3,5);
        
        % Progression from DC to HCC among RNA positives
        ydot(:,:,:,:,:,:,:,3,6) = ydot(:,:,:,:,:,:,:,3,6) - params.omega_F4_HCC*y(:,:,:,:,:,:,:,3,6);
        ydot(:,:,:,:,:,:,:,3,7) = ydot(:,:,:,:,:,:,:,3,7) + params.omega_F4_HCC*y(:,:,:,:,:,:,:,3,6);
        
        % assume no progression or regression in fribrosis following svr but slower
        % progression to DC and HCC following SVR
        
        % Progression from f4 to DC among AB positive RNA negatives
        ydot(:,:,:,:,:,:,:,2,5) = ydot(:,:,:,:,:,:,:,2,5) - params.RR_DC_SVR*params.omega_F4_DC*y(:,:,:,:,:,:,:,2,5);
        ydot(:,:,:,:,:,:,:,2,6) = ydot(:,:,:,:,:,:,:,2,6) + params.RR_DC_SVR*params.omega_F4_DC*y(:,:,:,:,:,:,:,2,5);
        
        % Progression from f4 to HCC among AB positive RNA negatives
        ydot(:,:,:,:,:,:,:,2,5) = ydot(:,:,:,:,:,:,:,2,5) - params.RR_HCC_SVR*params.omega_F4_HCC*y(:,:,:,:,:,:,:,2,5);
        ydot(:,:,:,:,:,:,:,2,7) = ydot(:,:,:,:,:,:,:,2,7) + params.RR_HCC_SVR*params.omega_F4_HCC*y(:,:,:,:,:,:,:,2,5);
        
        % Progression from DC to HCC among AB positive RNA negatives
        ydot(:,:,:,:,:,:,:,2,6) = ydot(:,:,:,:,:,:,:,2,6) - params.RR_HCC_SVR*params.omega_F4_HCC*y(:,:,:,:,:,:,:,2,6);
        ydot(:,:,:,:,:,:,:,2,7) = ydot(:,:,:,:,:,:,:,2,7) + params.RR_HCC_SVR*params.omega_F4_HCC*y(:,:,:,:,:,:,:,2,6);
        
        % death from DC
        ydot(:,:,:,:,:,:,1,:,6) = ydot(:,:,:,:,:,:,1,:,6) - params.mu_DC*y(:,:,:,:,:,:,1,:,6);
        ydot(:,:,:,:,:,:,2:8,:,6) = ydot(:,:,:,:,:,:,2:8,:,6) - params.Factor_mu_DC_HIV*params.mu_DC*y(:,:,:,:,:,:,2:8,:,6);
        
        % death from HCC
        ydot(:,:,:,:,:,:,:,:,7) = ydot(:,:,:,:,:,:,:,:,7) - params.mu_HCC*y(:,:,:,:,:,:,:,:,7);
end

%% Outputs

switch model
    case 'Initialisation'
        % add zeros to compartments not included (ex-PWID, NGO, OST, HIV, HCV infection & HCV disease stages)
        ydot = sum(sum(sum(ydot(1,:,:,:,[1,2],:,:,:,:),6),7),9);
        ydot2 = reshape(ydot,[1*2*2*4*2*1*1*3*1,1]);
    case 'Calibration'
        ydot = sum(ydot(1,:,:,:,:,:,:,:,:),9);
        ydot2 = reshape(ydot,[1*2*2*4*3*4*8*3*1,1]);
        ydot2 = [ydot2;...
            PWID_prop_HIV_sexual;...   %%% EDITS FROM ANTOINE PUTTING BACK PROP HIV SEXUAL
            RR_HIV_Incidence_rec_inc;...
            RR_HIV_Incidence_nonrec_inc;...
            RR_HCV_Incidence_rec_inc;...
            RR_HCV_Incidence_nonrec_inc;...
            RR_HIV_Incidence_homeless;...
            RR_HCV_Incidence_homeless];
    case 'Projections'
        ydot2 = reshape(ydot,[2*2*2*4*3*4*8*3*7,1]);
        ydot2 = [ydot2;...
            sum(HIV_Inf_sex,'all');...
            sum(HIV_Inf_inj,'all');...
            sum(HIV_Inf_tot,'all');...
            PWID_prop_HIV_sexual;...  %%% EDITS FROM ANTOINE PUTTING BACK PROP HIV SEXUAL
            HIV_Incidence_PWID;...
            HCV_Inf_tot;...
            HCV_Incidence_PWID;...
            HIV_Incidence_NGO;...
            HIV_Incidence_non_NGO;...
            HCV_Incidence_NGO;...
            HCV_Incidence_non_NGO;...
            ART_initiations_NGO;...
            RR_HIV_Incidence_rec_inc;...
            RR_HIV_Incidence_nonrec_inc;...
            RR_HCV_Incidence_rec_inc;...
            RR_HCV_Incidence_nonrec_inc;...
            RR_HIV_Incidence_homeless;...
            RR_HCV_Incidence_homeless];
    otherwise
        ydot2 = nan([2*2*2*4*3*4*8*3*7,1]);
end
end


