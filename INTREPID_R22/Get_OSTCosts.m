function OSTUnitCost = Get_OSTCosts(ISO)
filename = 'Data_Files/Parameter_Data/OST_costs.csv';
dataTable = readtable(filename);
data = dataTable(strcmp(dataTable.ISO,ISO),:);
OSTUnitCost = data.Est;
end