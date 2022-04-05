function [ART_start_date, OST_start_date, NSP_start_date] = Get_start_dates(ISO)

% ART
filename = 'Data_Files/Parameter_Data/ART_start_dates_com.csv';
opts = detectImportOptions(filename);
opts = setvartype(opts,'Date','single');
dataTable = readtable(filename,opts);
data = dataTable(strcmp(dataTable.ISO,ISO),:);
ART_start_date = data.Date;

% OST
filename = 'Data_Files/Parameter_Data/OST_start_dates_com.csv';
opts = detectImportOptions(filename);
opts = setvartype(opts,'Date','single');
dataTable = readtable(filename,opts);
data = dataTable(strcmp(dataTable.ISO,ISO),:);
OST_start_date = data.Date;

% NSP
filename = 'Data_Files/Parameter_Data/NSP_start_dates_com.csv';
opts = detectImportOptions(filename);
opts = setvartype(opts,'Date','single');
dataTable = readtable(filename,opts);
data = dataTable(strcmp(dataTable.ISO,ISO),:);
NSP_start_date = data.Date;

end