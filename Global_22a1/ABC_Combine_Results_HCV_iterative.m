function ABC_Combine_Results_HCV_iterative(ISO,numrun,pp)

if pp==1
    %% create a local cluster object (john's addition)
    pc = parcluster('local');
    % explicitly set the JobStorageLocation to the temp directory that was created in your sbatch script
    pc.JobStorageLocation = strcat('.matlab/local_cluster_jobs/R2019b','/', getenv('SLURM_JOB_ID'));
    parpool(pc,24);
end

  
currentFolder = pwd;

ABC_filename=[currentFolder,'/ABC_outputs_combined/',ISO,'/ABC.',num2str(numrun),'.mat'];
load(ABC_filename);
   % [m,~] = size(ABC);
 par = vertcat(newABC{:,4});
    
%% 
N = size(par,1);
tmp = [];
tmp2 = [];
Get_Disability_Weights_ISO(N,ISO);

%subdir1 = datestr(now,'mm-dd-yyyy_HH-MM');
%subdir1 = datestr(now,'mm-dd-yyyy_HH');
subdir1 = datestr(now,'mm-dd-yyyy');
%subdir1 ='02-04-2022';

subdir = append(subdir1,'/',ISO,'/RUNS',num2str(numrun),'/');




dir = ['Results/',subdir];

if not(isfolder(dir))
    mkdir(dir)
end

ABC_Get_HCV_reduction_combined_CI(ISO,N,dir,numrun);


