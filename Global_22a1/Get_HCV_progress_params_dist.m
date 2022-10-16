function [] = Get_HCV_progress_params_dist(N)

HCV_priors = struct();
%% HCV Params
%progression from F0 to F1 in HIV negative
HCV_priors.omega_F0_F1 = make_normal_dist([0.128,0.08,0.176]);

%progression from F1 to F2 in HIV negative
HCV_priors.omega_F1_F2 = make_normal_dist([0.059,0.035,0.082]);

%progression from F2 to F3 in HIV negative
HCV_priors.omega_F2_F3 = make_normal_dist([0.079,0.056,0.1]);

%progression from F3 to F4 in HIV negative
HCV_priors.omega_F3_F4 = make_normal_dist([0.116,0.07,0.161]);

%acceleration in progression to cirrhosis if HIV positive
HCV_priors.omega_F_HIV = make_lognormal_dist([2.489,1.811,3.42]);

%acceleration in progression to cirrhosis if on ART vs HIV negative
HCV_priors.omega_F_ART = makedist('uniform',0.27,0.70);

%progression to decompensated cirrhosis from F4
HCV_priors.omega_F4_DC = makedist('beta',14.6168,360.1732);

%progression to HCC from F4 / progression to HCC from DC
HCV_priors.omega_F4_HCC = makedist('beta',1.9326,136.1732);

%Death rate from decompensated cirrhosis if HIV negative
HCV_priors.mu_DC = makedist('beta',147.03,983.97);

%Relative death rate from decompensated cirrhosis if HIV positive vs negative
HCV_priors.Factor_mu_DC_HIV = make_lognormal_dist([2.26,1.51,3.38]);

%Death rate from HCC
HCV_priors.mu_HCC = makedist('beta',117.1033,155.23);

%reduction in progression from F4 to DC following SVR
HCV_priors.RR_DC_SVR = make_lognormal_dist([0.07,0.03,0.2]);

%reduction in progression from F4 to HCC following SVR
HCV_priors.RR_HCC_SVR = make_lognormal_dist([0.23,0.16,0.35]);
fields = fieldnames(HCV_priors);

tmp = lhsdesign(N,numel(fields));
for j = 1:numel(fields)
    HCV_params(:,j) = icdf(HCV_priors.(fields{j}),tmp(:,j));
end
save('HCV_params.mat','HCV_params')

save('HCV_priors.mat','HCV_priors')
end