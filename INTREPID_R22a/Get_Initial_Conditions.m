function IC = Get_Initial_Conditions(params,model)
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

Index 5 - homelessness status 
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

%run gender, incarceration and age model to steady state
SS = ones([1,1*2*2*4*2*1*1]);
SS = SS./sum(sum(sum(sum(sum(sum(sum(SS)))))))*params.PWID_initial_pop_size;
%options1 = odeset('NonNegative',1:(1*2*2*4*1*1*1*1*1),'AbsTol',1e-5,'RelTol',1e-5);
[t,y] = ode23(@(t,y)Ukraine_model(t,y,params,'Initialisation',0),[0,150],SS);
SS = y(end,:);
SS = reshape(SS,[1,2,2,4,2,1,1]);
switch model 
    case 'Calibration'
    IC = zeros(1,2,2,4,3,4,8);
    length_IC = 1*2*2*4*3*4*8;
    length_other_outputs = 4;
    case 'Projections'
    IC = zeros(2,2,2,4,3,4,8);
    length_IC = 2*2*2*4*3*4*8;
    length_other_outputs = 11;
end

% Fill in steady state gender, incarceration and age    
    IC(1,:,:,:,[1,2],1,1) =  SS;
% Seed HIV
    IC(:,:,:,:,:,:,2) = IC(:,:,:,:,:,:,1)*params.HIV_seed;
    IC(:,:,:,:,:,:,1) = IC(:,:,:,:,:,:,1)*(1-params.HIV_seed);
% Seed HCV
    %IC(:,:,:,:,:,:,:,3,:) = IC(:,:,:,:,:,:,:,1,:)*params.HCV_seed;
    %IC(:,:,:,:,:,:,:,1,:) = IC(:,:,:,:,:,:,:,1,:)*(1-params.HCV_seed);
% reshape IC
    IC = reshape(IC,[length_IC,1]);
% add other outputs - e.g. incidence, infections
    IC = [IC;zeros(length_other_outputs,1)];
end
