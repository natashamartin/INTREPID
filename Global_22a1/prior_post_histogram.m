function prior_post_histogram(N, posteriors, priors, ISO, scenario)
close all

fields = fieldnames(priors);
param_length = numel(fields);

tmp = lhsdesign(N,param_length);

fig_multi1 = figure; set(fig_multi1,'visible','off');
% ax = gca;
% ax.FontSize = 2;
fig_multi2 = figure; set(fig_multi2,'visible','off');
% ax = gca;
% ax.FontSize = 2;

for j = 1:param_length
    % individual figs
    samp_new = icdf(priors.(fields{j}),tmp(:,j));
    
%     close all

    fig=figure; set(fig,'visible','off');
    histogram(samp_new,10,'FaceColor','b');
    hold on
    histogram(posteriors(:,j),10,'FaceColor','r');
    hold off
    
    title(fields(j),'Interpreter','none');
    legend('prior','posterior');
    
    filename = ['Outputs/scenario_',num2str(scenario),'/Histograms/',ISO,'_',char(fields(j)),'.png'];
    saveas(fig,filename)
    
    % tiled fig
    if j<=50
        set(0, 'CurrentFigure', fig_multi1)
        subplot(5,10,j)
        histogram(samp_new,10,'FaceColor','b');
        hold on
        histogram(posteriors(:,j),10,'FaceColor','r');
        title(fields(j),'Interpreter','none');
        ax = gca;
        ax.FontSize = 3;
    else
        set(0, 'CurrentFigure', fig_multi2)
        subplot(5,10,j-50)
        histogram(samp_new,10,'FaceColor','b');
        hold on
        histogram(posteriors(:,j),10,'FaceColor','r');
        title(fields(j),'Interpreter','none');
        ax = gca;
        ax.FontSize = 3;
    end
end


filename = ['Outputs/scenario_',num2str(scenario),'/Histograms/',ISO,'_multi1.png'];
saveas(fig_multi1,filename)

filename = ['Outputs/scenario_',num2str(scenario),'/Histograms/',ISO,'_multi2.png'];
saveas(fig_multi2,filename)

end