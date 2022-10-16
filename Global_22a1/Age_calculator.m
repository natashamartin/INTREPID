%%% This function takes data for average age of onset of injecting from
%%% Hines (2020) and outputs average age of young PWID (<25) at onset of
%%% injecting, and proportion of new injectors younger than 25. To do this,
%%% we assume a triangular distribution constructed of the central estimate
%%% and upper/lower bounds.

function [prop_new_PWID_young, age_initiation_young, age_initiation_old_LI] = Age_calculator(ISO)
% A = support lower bound
% B = peak location
% C = support upper bound

filename = 'Data_Files/Parameter_Data/PWID_age_initiation_data.csv';
opts = detectImportOptions(filename);
opts = setvartype(opts,{'Est','LI','UI'},'double');
dataTable = readtable(filename,opts);
data = dataTable(strcmp(dataTable.ISO,ISO),:);
A = data.LI;
B = data.Est;
C = data.UI;

%% new edits for countries with Est=LI and/or UI
if A==B
    A=0.8*B;
else
    A=A;
end

if C==B
    C=1.2*B;
else
    C=C;
end
%%
dist = makedist('triangular',A,B,C);
% dist
% dist2=makedist('uniform',20,25);
% dist2
if A>=25
    prop_new_PWID_young = 0.001;
    age_initiation_young = makedist('uniform',20,25);
    age_initiation_old_LI = A;
    
elseif C<=25
    prop_new_PWID_young = 0.999;
    age_initiation_young = dist;
    age_initiation_old_LI = 25; % makedist('uniform',20,25);
else
    x=linspace(A,25,1000); % evenly spaced values from A to 25
    
    cdist = cdf(dist,x); % cumulative distribution function from A to 25, evaluated at x
    
    prop_new_PWID_young = cdist(end); % proportion <25 is the area under pdf from A to 25, AKA the max of cdist
    
    %     cdist_mid = 0.5*(cdist(end) - cdist(1)); % half-way point of cdf, AKA half of the area of the pdf
    %
    %     [~, ind] = min(abs(cdist-cdist_mid)); % find index of cdist nearest to midpoint
    %
    %     average_age_initiation_young = x(ind); % find corresponding age
    
    age_initiation_young = truncate(dist,A,25); % truncate age distribution at 25
    
    age_initiation_old_LI = 25;
end

end