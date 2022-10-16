function dist = make_uniform_dist(varargin)
if length(varargin)==2
    ISO = varargin{1};
    parameter_name = varargin{2};
    filename = ['Data_Files/Parameter_Data/',parameter_name,'_data.csv'];
    opts = detectImportOptions(filename);
    opts = setvartype(opts,{'LI','UI'},'double');
    dataTable = readtable(filename,opts);
    data = dataTable(strcmp(dataTable.ISO,ISO),:);
    ci_low = data.LI;
    ci_up = data.UI;
else
    specs = varargin{1};
    ci_low = specs(1);
    ci_up = specs(2);
end

dist = makedist('uniform',ci_low,ci_up);
end