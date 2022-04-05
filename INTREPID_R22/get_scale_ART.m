function scale = get_scale_ART(params,SS)

time_start = params.seed_date;
time_end = 2022; %2022
TIME= [time_start,time_end];

[~,y] = ode23(@(t,y)Ukraine_model(t,y,params,'Calibration',0),TIME,SS);
SS = y(end,:);

scale = nan;
% options = optimoptions('lsqnonlin','OptimalityTolerance', 100); 
[tmp,resnorm,~,~,~,~,~] = lsqnonlin(@(x)difference(params,SS,x), 0.6, 0, 5);
% [tmp,resnorm,~,~,~,~,~] = lsqnonlin(@(x)difference(params,SS,x), 0.6, 0, 5, options);
% if resnorm<0.001
% if resnorm<100
    scale=tmp;
% end

end
function diff = difference(params,SS,x)
params.scale_ART_50_2030=x;
TIME= [2022,2030];

        
[~,y] = ode23(@(t,y)Ukraine_model(t,y,params,'Calibration',2),TIME,SS);
y_out = reshape(y(end,1:1*2*2*4*3*4*8),[1,2,2,4,3,4,8]);
ART_cov = sum(y_out(1,:,:,:,:,:,[4,6,8]),'all')./...
    sum(y_out(1,:,:,:,:,:,2:8),'all')*100;

diff = ART_cov-81; % 81
end

