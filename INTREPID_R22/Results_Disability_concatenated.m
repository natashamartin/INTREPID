function [] = Results_Disability_concatenated(k,ABC_filename,ISO,dir)
% tmp1 = getenv('WORK');


fname1 = [dir,'/Status_quo_',num2str(k),'.mat'];
fname2 = [dir,'/OST_50_2030_',num2str(k),'.mat'];
fname3 = [dir,'/ART_50_2030_',num2str(k),'.mat'];


% if isfile(fname1)==0 || isfile(fname2)==0 || isfile(fname3)==0 || isfile(fname4)==0 || isfile(fname5)==0  ...
%         || isfile(fname6)==0 || isfile(fname7)==0 || isfile(fname8)==0 || isfile(fname9)==0 ...
%         || isfile(fname10)==0 || isfile(fname11)==0 || isfile(fname12)==0 || isfile(fname13)==0
if isfile(fname1)==0 || isfile(fname2)==0 || isfile(fname3)==0
%     Get_Disability_Weights(k)
filename_out = append('Disability_weights_',ISO,'.mat');
    load(filename_out,'Disability_weights','Disability_weights_PWID','Disability_weights_HIV')
%     DW_out = Get_Disability_Weights(k); % john's revision
%     load('params.mat','params')
%     ABC_filename = 'ABC_outputs/ABC_07-05-2021 16-47_1.mat';
    load(ABC_filename);
   % [m,~] = size(ABC);
    params = vertcat(newABC{:,4});
    params = Get_Parameters(params(k,:),ISO,'Projections');
    
    SS_calib = Get_Initial_Conditions(params,'Calibration');
    SS = Get_Initial_Conditions(params,'Projections');
    Disability_weights = Disability_weights(k,:,:);
    Disability_weights_PWID = Disability_weights_PWID(k,:,:,:,:);
    Disability_weights_HIV = Disability_weights_HIV(k,:);
%     Disability_weights = DW_out.Disability_weights(k,:,:); % john's revisions
%     Disability_weights_PWID = DW_out.Disability_weights_PWID(k,:,:,:,:);
%     Disability_weights_HIV = DW_out.Disability_weights_HIV(k,:);
%     Disability_weights_HCV = DW_out.Disability_weights_HCV(k,:);
    
    %% Get scale-up factors
    
    % OST scale-up
    tmp_name = [dir,'/scale_OST_50_2030_',num2str(k),'.mat'];
    if isfile(tmp_name)==0
        scale_OST_50_2030 = get_scale_OST(params,SS_calib);
        save(tmp_name,'scale_OST_50_2030')
    end
    tmp = load(tmp_name);
    params.scale_OST_50_2030 = tmp.scale_OST_50_2030;
    
    % ART scale-up
    tmp_name = [dir,'/scale_ART_50_2030_',num2str(k),'.mat'];
    if isfile(tmp_name)==0
        scale_ART_50_2030 = get_scale_ART(params,SS_calib);
        save(tmp_name,'scale_ART_50_2030')
    end
    tmp = load(tmp_name);
    params.scale_ART_50_2030 = tmp.scale_ART_50_2030;

%     tmp_name = [dir,'/scale_NGO_rec_',num2str(k),'.mat'];
%     if isfile(tmp_name)==0
%         scale_NGO_rec = get_scale_NGO_rec(params,SS_calib);
%         save(tmp_name,'scale_NGO_rec')
%     end
%     tmp = load(tmp_name);
%     params.scale_NGO_rec = tmp.scale_NGO_rec;
%     
%     tmp_name = [dir,'/scale_NGO_OST_ART_rec_',num2str(k),'.mat'];
%     
%     if isfile(tmp_name)==0
%         tmp1 = get_scale_OST_ART_rec(params,SS_calib);
%         scale_OST_rec = tmp1(1);
%         scale_ART_rec = tmp1(2);
%         save(tmp_name,'scale_OST_rec','scale_ART_rec')
%     end
%     tmp = load(tmp_name);
%     params.scale_OST_rec1 = tmp.scale_OST_rec;
%     params.scale_ART_rec1 = tmp.scale_ART_rec;
%     
%     
%     tmp_name = [dir,'/scale_OST_ART_rec_',num2str(k),'.mat'];
%     if isfile(tmp_name)==0
%         tmp1 = get_scale_OST_ART_rec2(params,SS_calib);
%         scale_OST_rec = tmp1(1);
%         scale_ART_rec = tmp1(2);
%         save(tmp_name,'scale_OST_rec','scale_ART_rec')
%     end
%     tmp = load(tmp_name);
%     params.scale_OST_rec2 = tmp.scale_OST_rec;
%     params.scale_ART_rec2 = tmp.scale_ART_rec;
    
    %% Run Scenarios
    
    % STATUS QUO
    filename = [dir,'/Status_quo_',num2str(k),'.mat'];
    if isfile(filename)==0
        Status_quo = model_proj(params,SS,0,Disability_weights,Disability_weights_PWID,Disability_weights_HIV);
        save(filename,'Status_quo')
    end
    
    % Scale-up OST to 50% 2030 target
    filename = [dir,'/OST_50_2030_',num2str(k),'.mat'];
    if isfile(filename)==0
        OST_50_2030 = model_proj(params,SS,1,Disability_weights,Disability_weights_PWID,Disability_weights_HIV);
        save(filename,'OST_50_2030')
    end
    
    % Scale-up ART to 50% 2030 target
    filename = [dir,'/ART_50_2030_',num2str(k),'.mat'];
    if isfile(filename)==0
        ART_50_2030 = model_proj(params,SS,2,Disability_weights,Disability_weights_PWID,Disability_weights_HIV);
        save(filename,'ART_50_2030')
    end
    
    %% Turn off NGO ever
%     filename = [dir,'/No_NGO_Ever_',num2str(k),'.mat'];
%     if isfile(filename)==0
%         No_NGO_Ever = model_proj(params,SS,1,Disability_weights,Disability_weights_PWID,Disability_weights_HIV,Disability_weights_HCV);
%         save(filename,'No_NGO_Ever')
%     end
    
    %% Turn off NGO 2020-2040
%     filename = [dir,'/No_NGO_2020_2040_',num2str(k),'.mat'];
%     if isfile(filename)==0
%         No_NGO_2020_2040 = model_proj(params,SS,2,Disability_weights,Disability_weights_PWID,Disability_weights_HIV,Disability_weights_HCV);
%         save(filename,'No_NGO_2020_2040')
%     end
    
    
    %% Turn off NGO 2020-2025
%     filename = [dir,'/No_NGO_2020_2025_',num2str(k),'.mat'];
%     if isfile(filename)==0
%         No_NGO_2020_2025 = model_proj(params,SS,3,Disability_weights,Disability_weights_PWID,Disability_weights_HIV,Disability_weights_HCV);
%         save(filename,'No_NGO_2020_2025')
%     end
    
    %% Scale-up NGO 2020-2040
%     filename = [dir,'/NGO_60_coverage_',num2str(k),'.mat'];
%     if isfile(filename)==0
%         NGO_60_coverage = model_proj(params,SS,4,Disability_weights,Disability_weights_PWID,Disability_weights_HIV,Disability_weights_HCV);
%         save(filename,'NGO_60_coverage')
%     end
    
    %% Scale-up NGO/OAT/ART 2020-2040
%     filename = [dir,'/Scale_NGO_OAT_ART_',num2str(k),'.mat'];
%     if isfile(filename)==0
%         Scale_NGO_OAT_ART = model_proj(params,SS,5,Disability_weights,Disability_weights_PWID,Disability_weights_HIV,Disability_weights_HCV);
%         save(filename,'Scale_NGO_OAT_ART')
%     end
    %% Scale-up OAT/ART 2020-2040 no NGOs
%     filename = [dir,'/Scale_OAT_ART_no_NGO_',num2str(k),'.mat'];
%     if isfile(filename)==0
%         Scale_OAT_ART_no_NGO = model_proj(params,SS,6,Disability_weights,Disability_weights_PWID,Disability_weights_HIV,Disability_weights_HCV);
%         save(filename,'Scale_OAT_ART_no_NGO')
%     end
end
%% Scale-up OAT/ART 2020-2040
% filename = [dir,'/Scale_OAT_ART_',num2str(k),'.mat'];
% if isfile(filename)==0
%     Scale_OAT_ART = model_proj(params,SS,7,Disability_weights,Disability_weights_PWID,Disability_weights_HIV,Disability_weights_HCV);
%     save(filename,'Scale_OAT_ART')
% end
% 
% %% NO_NGOS 2020-2025 with Scale-up OAT/ART 2020-2040
% filename = [dir,'/NO_NGO_2020_2025_Scale_OAT_ART_',num2str(k),'.mat'];
% if isfile(filename)==0
%     try
%     NO_NGO_2020_2025_Scale_OAT_ART = model_proj(params,SS,8,Disability_weights,Disability_weights_PWID,Disability_weights_HIV,Disability_weights_HCV);
%     save(filename,'NO_NGO_2020_2025_Scale_OAT_ART')
%     end
% end
% %% REMOVE EFFECTS IN TURN from 2020
% filename = [dir,'/Remove_effect_ART_',num2str(k),'.mat'];
% if isfile(filename)==0
%     Remove_effect_ART = model_proj(params,SS,9,Disability_weights,Disability_weights_PWID,Disability_weights_HIV,Disability_weights_HCV);
% save(filename,'Remove_effect_ART')
% end
% filename = [dir,'/Remove_effect_condoms_',num2str(k),'.mat'];
% if isfile(filename)==0
%     Remove_effect_condoms = model_proj(params,SS,10,Disability_weights,Disability_weights_PWID,Disability_weights_HIV,Disability_weights_HCV);
% save(filename,'Remove_effect_condoms')
% end
% filename = [dir,'/Remove_effect_inj_risk_',num2str(k),'.mat'];
% if isfile(filename)==0
%     Remove_effect_inj_risk = model_proj(params,SS,11,Disability_weights,Disability_weights_PWID,Disability_weights_HIV,Disability_weights_HCV);
% save(filename,'Remove_effect_inj_risk')
% end
% filename = [dir,'/Remove_effect_OST_',num2str(k),'.mat'];
% if isfile(filename)==0
%     Remove_effect_OST = model_proj(params,SS,12,Disability_weights,Disability_weights_PWID,Disability_weights_HIV,Disability_weights_HCV);
% save(filename,'Remove_effect_OST')
% end

end
