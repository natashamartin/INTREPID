function [ART_end_date, OST_end_date, NSP_end_date] = Get_end_dates(ISO)
% ART
filename = 'Data_Files/Parameter_Data/ART_end_dates_com.csv';
opts = detectImportOptions(filename);
opts = setvartype(opts,'Date','single');
dataTable = readtable(filename,opts);
data = dataTable(strcmp(dataTable.ISO,ISO),:);
ART_end_date = data.Date;

% OST
filename = 'Data_Files/Parameter_Data/OST_end_dates_com.csv';
opts = detectImportOptions(filename);
opts = setvartype(opts,'Date','single');
dataTable = readtable(filename,opts);
data = dataTable(strcmp(dataTable.ISO,ISO),:);
OST_end_date = data.Date;

% NSP
filename = 'Data_Files/Parameter_Data/NSP_end_dates_com.csv';
opts = detectImportOptions(filename);
opts = setvartype(opts,'Date','single');
dataTable = readtable(filename,opts);
data = dataTable(strcmp(dataTable.ISO,ISO),:);
NSP_end_date = data.Date;

end