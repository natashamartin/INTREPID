function ARTUnitCost = Get_ARTCosts(ISO)
filename = 'Data_Files/Parameter_Data/ART_costs2.csv';
dataTable = readtable(filename);
data = dataTable(strcmp(dataTable.ISO,ISO),:);
ARTUnitCost = data.Y2019;
end