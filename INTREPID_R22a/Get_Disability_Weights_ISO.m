function [] = Get_Disability_Weights_ISO(N,ISO)
rng(1,'twister')
%HIV
%  1 - Susceptible
%     2 - Acute infection
%     3 - chronic/latent infection - not on ART
%     4 - chronic/latent infection - on ART
%     5 - pre-AIDS - not on ART
%     6 - pre-AIDS - on ART
%     7 - AIDS - not on ART
%     8 - AIDS - on ART
%
%HCV
% Index 9 - HCV disease status
%     1 - F0
%     2 - F1
%     3 - F2
%     4 - F3
%     5 - F4
%     6 - Decompensated chirrosis
%     7 - Hepatocellular carcinoma

HIV_wght = nan(N,8);

m=0.697; lower=0.510; upper=0.843;
tmp = makedist('Triangular',lower,m,upper);
PWID_wght = random(tmp,N,1);

m=0.335; lower=0.221; upper=0.473;
tmp = makedist('Triangular',lower,m,upper);
OAT_wght = random(tmp,N,1);

HIV_wght(:,1) = zeros(N,1);

% acute, chronic or on ART
m = 0.078;lower= 0.052;upper=0.111;
tmp = makedist('Triangular',lower,m,upper);
DW_ART = random(tmp,N,1);
HIV_wght(:,[2,3,4,6,8]) = DW_ART.*ones(1,5);

% Pre-aids not on ART
m = 0.274;lower= 0.184;upper=0.377;
tmp = makedist('Triangular',lower,m,upper);
DW_Pre_AIDs = random(tmp,N,1);
HIV_wght(:,5) = DW_Pre_AIDs;


m = 0.582; lower= 0.406;upper=0.743;
tmp = makedist('Triangular',lower,m,upper);
DW_AIDS = random(tmp,N,1);
HIV_wght(:,7) = DW_AIDS;

Disability_weights=nan(N,8,7);
for i=1:8
    for j=1:7
        Disability_weights(:,i,j)=1-(1-HIV_wght(:,i));
    end
end
Disability_weights_PWID = nan(N,2,4,8,7);
for i=1:8
    for j=1:7
        Disability_weights_PWID(:,2,1,i,j)=1-(1-HIV_wght(:,i));
        Disability_weights_PWID(:,2,2,i,j)=1-(1-HIV_wght(:,i));
        Disability_weights_PWID(:,2,3,i,j)=1-(1-HIV_wght(:,i));
        Disability_weights_PWID(:,2,4,i,j)=1-(1-HIV_wght(:,i));
        Disability_weights_PWID(:,1,1,i,j)=1-(1-PWID_wght).*(1-HIV_wght(:,i));
        Disability_weights_PWID(:,1,2,i,j)=1-(1-OAT_wght).*(1-HIV_wght(:,i));
        Disability_weights_PWID(:,1,3,i,j)=1-(1-OAT_wght).*(1-HIV_wght(:,i));
        Disability_weights_PWID(:,1,4,i,j)=1-(1-PWID_wght).*(1-HIV_wght(:,i));
    end
end

Disability_weights_HIV = HIV_wght;
% Disability_weights_HCV = HCV_wght;

% DW_out = struct('Disability_weights', Disability_weights,...
%                                 'Disability_weights_PWID', Disability_weights_PWID,...
%                                 'Disability_weights_HIV', Disability_weights_HIV,...
%                                 'Disability_weights_HCV', Disability_weights_HCV);
filename_out = append('Disability_weights_',ISO,'.mat');

save(filename_out,'Disability_weights','Disability_weights_PWID','Disability_weights_HIV')

end