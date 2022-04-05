function scale = get_scale_OST(params,SS)

time_start = params.seed_date;
time_end = 2022; %2022
TIME= [time_start,time_end];

[~,y] = ode23(@(t,y)Ukraine_model(t,y,params,'Calibration',0),TIME,SS);
SS = y(end,:);

scale = nan;
% options = optimoptions('lsqnonlin','OptimalityTolerance', 100); 
[tmp,resnorm,~,~,~,~,~] = lsqnonlin(@(x)difference(params,SS,x), 1.9, 0, 20);
% [tmp,resnorm,~,~,~,~,~] = lsqnonlin(@(x)difference(params,SS,x), 0.04, 0, 5, options);
% if resnorm<0.001
% if resnorm<100
    scale=tmp;
% end

end
function diff = difference(params,SS,x)
params.scale_OST_50_2030=x;
TIME= [2022,2030];

        
[~,y] = ode23(@(t,y)Ukraine_model(t,y,params,'Calibration',1),TIME,SS);
y_out = reshape(y(end,1:1*2*2*4*3*4*8),[1,2,2,4,3,4,8]);
OST_cov = sum(y_out(1,:,:,:,:,[2,3],:),'all')./...
    sum(y_out(1,:,:,:,:,:,:),'all')*100;

diff = OST_cov-40; % 40
end

% lsqnonlin troubleshooting
% https://www.mathworks.com/help/optim/ug/when-the-solver-might-have-succeeded.html#br44i8w
% https://www.mathworks.com/help/optim/ug/lsqnonlin.html#buuhch7-options
% https://www.mathworks.com/help/optim/ug/first-order-optimality-measure.html