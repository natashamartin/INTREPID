load('priors_city1.mat')
fieldnames = fields(priors);

numsamples = 12;
numgens = 14;
numparams = 57;

R6_gens = nan(numgens,numsamples,numparams);
R7b_gens = nan(numgens,numsamples,numparams);
for i=1:numgens
    R6_gens(i,:,:) = ABC_R6{i,4};
    R7b_gens(i,:,:) = ABC_R7b{i,4};
end

gens = 1:numgens;

% PWID_initial_pop_size_R6 = R6_gens(:,:,55);
% PWID_initial_pop_size_R7b = R7b_gens(:,:,55);

parfor i=1:numparams
    var1 = R6_gens(:,:,i);
    var2 = R7b_gens(:,:,i);
    var3 = abs(var1 - var2)./var1*100;
    
    fig1=figure; set(fig1,'visible','off');
    function_plot_intervals(gens,var1,'b')
    function_plot_intervals(gens,var2,'r')
    title(char(fieldnames(i)),'Interpreter','none')
    legend('R6','','','R7b','','')
    xlabel('generation')
    ylabel(char(fieldnames(i)),'Interpreter','none')
    filename = ['Outputs/param_plots/',char(fieldnames(i)),'.png'];
    saveas(fig1,filename)
    
    fig2=figure; set(fig2,'visible','off');
    plot(gens,median(var3,2),'b','linewidth',1.5);
    title(char(fieldnames(i)),'Interpreter','none')
    xlabel('generation')
    ylabel('% diff','Interpreter','none')
    filename = ['Outputs/param_plots_diff/',char(fieldnames(i)),'.png'];
    saveas(fig2,filename)
end

function [] = function_plot_intervals(tSpan,y,color)
hold on
plot(tSpan,median(y,2),color,'linewidth',1.5);
plot(tSpan,prctile(y,2.5,2),[color,'-.'],'linewidth',0.5);
plot(tSpan,prctile(y,97.5,2),[color,'-.'],'linewidth',0.5);
end