function [] = Tolerance_plots_combined(countrylist,mydir)
% countrylist={ 'DE' 'GB' 'GE'  }
% example: Tolerance_plots_together3(countrylist,'./ABC_outputs/')
outputfolder=append('./Outputs/');
if not(isfolder(outputfolder))
    mkdir(outputfolder)
end



fig1=figure; set(fig1,'visible','off');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 6])
 length(countrylist)

for i=1:length(countrylist)
   fname = dir( sprintf('./ABC_outputs/%s/*%s*1000.mat', char(countrylist(i)), char(countrylist(i)) ) );
  tmpData= load(append(mydir,'/',char(countrylist(i)),'/',fname.name));
  x{i}=cell2mat(tmpData.ABC(:,14))./3600;
  y{i}=cell2mat(tmpData.ABC(:,12));
  z{i}=tmpData.ABC{size(tmpData.ABC,1),14}/3600;
  zz{i}=size(tmpData.ABC,1);
end
clear tmpData;


figure
linecolor = parula(length(countrylist));
hold on
for i=1:length(countrylist)
  plot(x{i},log10(y{i}(:,1)),"-",'LineWidth',1,'color',linecolor(i,:));
  legendInfo{i}=['Country. ', char(countrylist(i)),' (',num2str(z{i}),' hrs,  ',num2str( zz{i}),' iterations)']; % or whatever is appropriate
  legend(legendInfo)
end

ylabel('Tolerance (log 10)')
xlabel('Time (hours)')
title(append(' Tolerance 1 (Popsize, Sex, HIV, Inc)'))
Plotname1 = [outputfolder,'/figure1a.tolerance1.', datestr(now, 'yyyy-mm-dd-HH-MM'),'.png'];
saveas(gcf,Plotname1)

figure
linecolor = parula(length(countrylist));
hold on
for i=1:length(countrylist)
  plot(x{i},log10(y{i}(:,2)),"-",'LineWidth',1,'color',linecolor(i,:));
  legendInfo2{i}=['Country. ', char(countrylist(i)),' (',num2str(z{i}),' hrs,  ',num2str( zz{i}),' iterations)']; % or whatever is appropriate
  legend(legendInfo2)
end

ylabel('Tolerance (log 10)')
xlabel('Time (hours)')
title(append(' Tolerance 2 (OST and ART)'))
Plotname2 = [outputfolder,'/figure1b.tolerance2.', datestr(now, 'yyyy-mm-dd-HH-MM'),'.png'];
saveas(gcf,Plotname2)

close all
% https://www.mathworks.com/matlabcentral/answers/153174-plotting-multiple-plots-in-a-for-loop

     
     



