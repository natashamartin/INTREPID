function NSPUnitCost = Get_NSPCosts(ISO)
filename = 'Data_Files/Parameter_Data/NSP_costs.csv';
dataTable = readtable(filename);
data = dataTable(strcmp(dataTable.ISO,ISO),:);
NSPUnitCost = data.Est;
end