function dist = make_triangular_dist(varargin)
if length(varargin)==2
    ISO = varargin{1};
    parameter_name = varargin{2};
    filename = ['Data_Files/Parameter_Data/',parameter_name,'_data.csv'];
    opts = detectImportOptions(filename);
    opts = setvartype(opts,{'Est','LI','UI'},'double');
    dataTable = readtable(filename,opts);
    data = dataTable(strcmp(dataTable.ISO,ISO),:);
    m = data.Est;
    ci_low = data.LI;
    ci_up = data.UI;
else
    specs = varargin{1};
    m = specs(1);
    ci_low = specs(2);
    ci_up = specs(3);
end

dist = makedist('triangular',ci_low,m,ci_up);
end