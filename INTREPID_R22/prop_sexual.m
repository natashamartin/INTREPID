% this function calculates the estimated proportion of HIV transmission due
% to sex vs injection
% source: "Is the HCV?HIV co-infection prevalence amongst injecting drug users a marker
% for the level of sexual and injection related HIV transmission?" (Vickerman et al 2013)

function [median_tmp,LI_tmp,UI_tmp] = prop_sexual(HIV_prev_tmp, HCV_prev_tmp, HCV_HIV_prev_tmp)
% calculate prevalence ratio
prev_ratio_tmp = HIV_prev_tmp/HCV_prev_tmp;

% construct HCV_HIV_prev bins
HCV_HIV_prev = [repmat({'Less than 60%'},1,5), repmat({'60-70%'},1,5), repmat({'70-80%'},1,5), repmat({'80-90%'},1,5), repmat({'90-100%'},1,5)]';

% construct prev_ratio bins
prev_ratio = repmat({'Less than 0.25', '0.25-0.5', '0.5-0.75','0.75-1.0', 'Greater than 1.0'},1,5)';

% construct median bins
median = [0.77 0.76 0.86 0.85 0.88,...
          0.62 0.69 0.75 0.83 0.95,...
          0.42 0.65 0.70 0.80 0.74,...
          0.27 0.38 0.55 0.67 0.79,...
          0.18 0.17 0.17 0.19 nan]';
  
% construct LI bins
LI = 1-[0.39 0.39 0.41 0.30 0.27,...
      0.58 0.57 0.42 0.37 0.15,...
      0.85 0.69 0.52 0.40 0.33 ,...
      0.95 0.90 0.69 0.60 0.49,...
      0.98 0.98 0.98 0.98 nan]';
  
% construct UI bins
UI = 1-[0.20 0.10 0.07 0.09 0.06,...
      0.22 0.12 0.09 0.07 0.05,...
      0.30 0.15 0.11 0.09 0.07,...
      0.40 0.22 0.17 0.09 0.06,...
      0.42 0.37 0.38 0.37 nan]';

% assign column names and create table
colNames = {'HCV_HIV_prev','prev_ratio','median','LI','UI'};
lookup_table = table(HCV_HIV_prev, prev_ratio, median, LI, UI, 'VariableNames', colNames);

% look up HCV_HIV_prev bin
tol = 1e-7;
if prev_ratio_tmp<0.25-tol
    prev_ratio_tmp = 'Less than 0.25';
elseif prev_ratio_tmp>=0.25 && prev_ratio_tmp<0.5-tol
    prev_ratio_tmp = '0.25-0.5';
elseif prev_ratio_tmp>=0.5 && prev_ratio_tmp<0.75-tol
    prev_ratio_tmp = '0.5-0.75';
elseif prev_ratio_tmp>=0.75 && prev_ratio_tmp<1.0-tol
    prev_ratio_tmp = '0.75-1.0';
elseif prev_ratio_tmp>=1.0
    prev_ratio_tmp = 'Greater than 1.0';
end

% look up prev_ratio bin
if HCV_HIV_prev_tmp<0.6-tol
    HCV_HIV_prev_tmp = 'Less than 60%';
elseif HCV_HIV_prev_tmp>=0.6 && HCV_HIV_prev_tmp<0.7-tol
    HCV_HIV_prev_tmp = '60-70%';
elseif HCV_HIV_prev_tmp>=0.7 && HCV_HIV_prev_tmp<0.8-tol
    HCV_HIV_prev_tmp = '70-80%';
elseif HCV_HIV_prev_tmp>=0.8 && HCV_HIV_prev_tmp<0.9-tol
    HCV_HIV_prev_tmp = '80-90%';
elseif HCV_HIV_prev_tmp>=0.9 && HCV_HIV_prev_tmp<=1.0-tol
    HCV_HIV_prev_tmp = '90-100%';
end

% find the correct row number
row = intersect(find(strcmp(HCV_HIV_prev,HCV_HIV_prev_tmp)), find(strcmp(prev_ratio,prev_ratio_tmp)));

median_tmp = median(row);
LI_tmp = LI(row);
UI_tmp = UI(row);

end