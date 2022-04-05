%%% This function takes xxx

function [deathdata] =   Death_calculator2(ISO)

%function [prop_new_PWID_young, age_initiation_young, age_initiation_old_LI] = Death_calculator(ISO)


filename = 'Data_Files/Parameter_Data/death_params.csv';
opts = detectImportOptions(filename);
opts = setvartype(opts,{'Year','Value','LI','UI'},'double');
deathdataTable = readtable(filename,opts);
deathdata = deathdataTable(strcmp(deathdataTable.ISO,ISO),:);

% A = agedata.Value;
% B = agedata.LI;
% C = agedata.UI;
% D= agedata.Gender;
% 
% deathrate=A;
% agelowerbound=B;
% ageupperbound=C;


end

