function [] = Results_Disability_concatenated5(k,ABC_filename,ISO,dir)
% tmp1 = getenv('WORK');
% dir = [tmp1,'/Ukraine_Projections_NGOs/Results'];
% dir = [tmp1,'Results'];

fname1 = [dir,'/Status_quo_',num2str(k),'.mat'];
fname2 = [dir,'/OST_50_2030_',num2str(k),'.mat'];
fname3 = [dir,'/ART_50_2030_',num2str(k),'.mat'];
fname4 = [dir,'/ARTOST_50_2030_',num2str(k),'.mat'];
fname5 = [dir,'/NSP_50_2030_',num2str(k),'.mat'];
fname6 = [dir,'/NSPART_50_2030_',num2str(k),'.mat'];
fname7 = [dir,'/NSPOST_50_2030_',num2str(k),'.mat'];
fname8 = [dir,'/NSPARTOST_50_2030_',num2str(k),'.mat'];


ARTUnitCost=Get_ARTCosts(ISO);
OSTUnitCost=Get_OSTCosts(ISO);
NSPUnitCost=Get_NSPCosts(ISO);


% if isfile(fname1)==0 || isfile(fname2)==0 || isfile(fname3)==0 || isfile(fname4)==0 || isfile(fname5)==0  ...
%         || isfile(fname6)==0 || isfile(fname7)==0 || isfile(fname8)==0 || isfile(fname9)==0 ...
%         || isfile(fname10)==0 || isfile(fname11)==0 || isfile(fname12)==0 || isfile(fname13)==0
if isfile(fname1)==0 || isfile(fname2)==0 || isfile(fname3)==0 || isfile(fname4)==0 || isfile(fname5)==0 || isfile(fname6)==0 || isfile(fname7)==0 || isfile(fname8)==0
 filename_out = append('Disability_weights_',ISO,'.mat');
    load(filename_out,'Disability_weights','Disability_weights_PWID','Disability_weights_HIV','Disability_weights_HCV')
%     DW_out = Get_Disability_Weights(k); % john's revision
%     load('params.mat','params')
%     ABC_filename = 'ABC_outputs/ABC_07-05-2021 16-47_1.mat';
    load(ABC_filename);
   %[m,~] = size(newABC);
   %params = newABC{m,4};
    params = vertcat(newABC{:,4});
    load('HCV_params.mat','HCV_params')
    params = Get_Parameters(params(k,:),ISO,HCV_params(k,:),'Projections');
    
    SS_calib = Get_Initial_Conditions(params,'Calibration');
    SS = Get_Initial_Conditions(params,'Projections');
    Disability_weights = Disability_weights(k,:,:);
    Disability_weights_PWID = Disability_weights_PWID(k,:,:,:,:);
    Disability_weights_HIV = Disability_weights_HIV(k,:);
    Disability_weights_HCV = Disability_weights_HCV(k,:);
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
%%%%%%%%%%%%%% EDITS TO GET COMBINED SCENARIO SCALE UP %%%%%%%%%%%%%%%%%%%%%

    % ART and OST scale-up
    tmp_name = [dir,'/scale_ARTOST_50_2030_',num2str(k),'.mat'];
    if isfile(tmp_name)==0
        scale_ART_50_2030 = get_scale_ART(params,SS_calib);
        scale_OST_50_2030 = get_scale_OST(params,SS_calib);

        save(tmp_name,'scale_ART_50_2030','scale_OST_50_2030')
    end
    tmp = load(tmp_name);
    params.scale_ART_50_2030 = tmp.scale_ART_50_2030;
    params.scale_OST_50_2030 = tmp.scale_OST_50_2030;
    
    clear tmp
    clear tmp_name
    
    tmp_name = [dir,'/scale_NSPART_50_2030_',num2str(k),'.mat'];
    if isfile(tmp_name)==0
        scale_ART_50_2030 = get_scale_ART(params,SS_calib);
        save(tmp_name,'scale_ART_50_2030')
    end
    tmp = load(tmp_name);
    params.scale_ART_50_2030 = tmp.scale_ART_50_2030;
    clear tmp
    clear tmp_name
    
    tmp_name = [dir,'/scale_NSPOST_50_2030_',num2str(k),'.mat'];
    if isfile(tmp_name)==0
        scale_OST_50_2030 = get_scale_OST(params,SS_calib);
        save(tmp_name,'scale_OST_50_2030')
    end
    tmp = load(tmp_name);
    params.scale_OST_50_2030 = tmp.scale_OST_50_2030;
    clear tmp
    clear tmp_name
    
    tmp_name = [dir,'/scale_NSPARTOST_50_2030_',num2str(k),'.mat'];
    if isfile(tmp_name)==0
        scale_ART_50_2030 = get_scale_ART(params,SS_calib);
        scale_OST_50_2030 = get_scale_OST(params,SS_calib);

        save(tmp_name,'scale_ART_50_2030','scale_OST_50_2030')
    end
    tmp = load(tmp_name);
    params.scale_ART_50_2030 = tmp.scale_ART_50_2030;
    params.scale_OST_50_2030 = tmp.scale_OST_50_2030;
    clear tmp
    clear tmp_name
  
    
    %% Run Scenarios
      
    
        % STATUS QUO
    filename = [dir,'/Status_quo_',num2str(k),'.mat'];
    if isfile(filename)==0
        Status_quo = model_proj5(params,SS,0,Disability_weights,Disability_weights_PWID,Disability_weights_HIV,Disability_weights_HCV,ARTUnitCost,OSTUnitCost,NSPUnitCost);
        save(filename,'Status_quo')
    end
    
    % Scale-up OST to 50% 2030 target
    filename = [dir,'/OST_50_2030_',num2str(k),'.mat'];
    if isfile(filename)==0
        OST_50_2030 = model_proj5(params,SS,1,Disability_weights,Disability_weights_PWID,Disability_weights_HIV,Disability_weights_HCV,ARTUnitCost,OSTUnitCost,NSPUnitCost);
        save(filename,'OST_50_2030')
    end
    
    % Scale-up ART to 50% 2030 target
    filename = [dir,'/ART_50_2030_',num2str(k),'.mat'];
    if isfile(filename)==0
        ART_50_2030 = model_proj5(params,SS,2,Disability_weights,Disability_weights_PWID,Disability_weights_HIV,Disability_weights_HCV,ARTUnitCost,OSTUnitCost,NSPUnitCost);
        save(filename,'ART_50_2030')
    end
    % Scale-up ART to 50% 2030 target
    filename = [dir,'/ARTOST_50_2030_',num2str(k),'.mat'];
    if isfile(filename)==0
        ARTOST_50_2030 = model_proj5(params,SS,3,Disability_weights,Disability_weights_PWID,Disability_weights_HIV,Disability_weights_HCV,ARTUnitCost,OSTUnitCost,NSPUnitCost);
        save(filename,'ARTOST_50_2030')
    end

     % Scale-up ART to 50% 2030 target
    filename = [dir,'/NSP_50_2030_',num2str(k),'.mat'];
    if isfile(filename)==0
        NSP_50_2030 = model_proj5(params,SS,4,Disability_weights,Disability_weights_PWID,Disability_weights_HIV,Disability_weights_HCV,ARTUnitCost,OSTUnitCost,NSPUnitCost);
        save(filename,'NSP_50_2030')
    end   
     % Scale-up ART to 50% 2030 target
    filename = [dir,'/NSPART_50_2030_',num2str(k),'.mat'];
    if isfile(filename)==0
        NSPART_50_2030 = model_proj5(params,SS,5,Disability_weights,Disability_weights_PWID,Disability_weights_HIV,Disability_weights_HCV,ARTUnitCost,OSTUnitCost,NSPUnitCost);
        save(filename,'NSPART_50_2030')
    end   
    
      % Scale-up ART to 50% 2030 target
    filename = [dir,'/NSPOST_50_2030_',num2str(k),'.mat'];
    if isfile(filename)==0
        NSPOST_50_2030 = model_proj5(params,SS,6,Disability_weights,Disability_weights_PWID,Disability_weights_HIV,Disability_weights_HCV,ARTUnitCost,OSTUnitCost,NSPUnitCost);
        save(filename,'NSPOST_50_2030')
    end
    
    % Scale-up ART to 50% 2030 target
    filename = [dir,'/NSPARTOST_50_2030_',num2str(k),'.mat'];
    if isfile(filename)==0
        NSPARTOST_50_2030 = model_proj5(params,SS,7,Disability_weights,Disability_weights_PWID,Disability_weights_HIV,Disability_weights_HCV,ARTUnitCost,OSTUnitCost,NSPUnitCost);
        save(filename,'NSPARTOST_50_2030')
    end   
   
     
    
    
end


end
