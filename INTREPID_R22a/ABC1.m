function ABC_output = ABC1(priors,N,stoping_criteria,alpha,sigma_scale,seed,Tol_length,ISO,num)
tic
%Filename1 = sprintf('ABC_%s', datestr(now,'mm-dd-yyyy HH-MM'));
Filename1 = sprintf('ABC_%s', datestr(now,'mm-dd-yyyy HH-MM-SS'));

% res = getenv('WORK');
% Filename2 = '/Ukraine_Fitting/';
% Folder = append(res,Filename2);    
Folder0 = 'ABC_outputs/';
Folder=append(Folder0,ISO,'/');
if not(isfolder(Folder))
    mkdir(Folder)
end
Filename = append(Folder,Filename1,'_',ISO,'_',num2str(N));
    
rng(seed,'twister')

%function sigma = find_sigma(score, tolerance, samp, weights)
%         check_tmp = score<tolerance;
%         pert_ind = find(min(check_tmp,[],2)==1);
%
%         samp_hat = samp(pert_ind,:);
%         w = weights;
%         w_hat = weights(pert_ind);
%         w_hat = w_hat./sum(w_hat);
%
%         sigma=zeros(param_length,param_length);
%
%
%         for i1=1:N
%             for k = 1:length(pert_ind)
%                 sigma=sigma + w(i1)*w_hat(k)*(samp_hat(k,:)-samp(i1,:)).*(samp_hat(k,:)-samp(i1,:))';
%             end
%         end
%
%     end



%% Function for steps t>=2
    function [samp_fin,score_fin] = ABC_it(Tolerance,samp_old,weights,sigma)
        close all
 %       ABC_plot3(num)
        samp_size=0;
        s = size(samp_old,2);
        samp_fin=nan(N,s);
        score_fin = nan(N,Tol_length);
        itt=1;
%        f=waitbar(0,sprintf('%4.0f',0));
        while samp_size<N
            
            n = N-samp_size;
 %           waitbar((N-n)/N,f,sprintf('%4.2f',100-n/N*100))
            %formatSpec = 'Iteration: %4.0f; Progress: %4.2f%%; Time: %s \n';
            
            %fprintf(formatSpec,itt,100-n/N*100,datestr(now,'HH:MM:SS.FFF'))
            % sample from previous generation using weights
            samp_tmp = samp_old(discretesample(weights,n),:);
            
            % Perturb sampled parameters
            
            samp_tmp1 = samp_tmp + unifrnd(repmat(-sigma,[n,1]),repmat(sigma,[n,1]));
            
            
            % Check if in support
            support_check=nan(n,s);
            
            fields = fieldnames(priors);
            
            for tmp_i = 1:numel(fields)
                support_check(:,tmp_i) = pdf(priors.(fields{tmp_i}),samp_tmp1(:,tmp_i));
            end
            
            support_ind = find(min(support_check,[],2)>0);
            %length(support_ind)./n*100
            samp_tmp2 = samp_tmp1(support_ind,:);
            
            
            
            % Compute Scores
            
            score=nan(n,Tol_length);
            
            parfor r=1:size(samp_tmp2,1)
                
                    score(r,:) = Distance(samp_tmp2(r,:),ISO,t,itt,r,Tolerance,num);
                
            end
            % Check if scores are within tolerances
            
            score_check = score<=Tolerance;
            score_ind = find(min(score_check,[],2));
            samp_tmp3=samp_tmp2(score_ind,:);
            score_tmp = score(score_ind,:);
            
            % Add to samp_fin and score_fin
            samp_fin(samp_size+1:samp_size+ size(samp_tmp3,1),:) = samp_tmp3;
            score_fin(samp_size+1:samp_size+ size(samp_tmp3,1),:) = score_tmp;
            
            
            samp_size = samp_size + size(samp_tmp3,1);
            itt=itt+1;
        end
        
    end

%%
% initialise
t = 1;
stop =0;

% sample from prior distributions
fields = fieldnames(priors);
param_length = numel(fields);
samp_new = nan(N,param_length);

for j = 1:param_length
   % j
    samp_new(:,j) = random(priors.(fields{j}),[N,1]);
end


tmp = lhsdesign(N,param_length);
for j = 1:param_length
    
    samp_new(:,j) = icdf(priors.(fields{j}),tmp(:,j));
end


Score=nan(N,Tol_length);
% calculate distances


parfor m=1:N
%     try
    Score(m,:) = Distance(samp_new(m,:),ISO,t,1,m,inf,num);
%     catch
%         Score(m,:) = Inf*ones(1,Tol_length);
%         m
%     end
end

% determine first tolerance
Tolerance = quantile(Score,alpha)
tmp = Tolerance==inf
Tolerance(tmp)=10000000;
% calculate  weights
Weights = (1./N).*ones(N,1);

% calculate perturbation kernel sigma
sigma = sigma_scale*(max(samp_new)-min(samp_new));

% save generation 1

ABC = {'iteration',t,'Params',samp_new,'Score',Score,'Weights',Weights,'sigma',sigma,'Tolerance',Tolerance,'Elapsed_time',toc};
save(Filename,'ABC')
%%
%H = waitbar(0,num2str(0))
while stop ~=1
t=t+1;    
    
    Samp_old = ABC{t-1,4};
    Weights_old = ABC{t-1,8};
    Sigma_old = ABC{t-1,10};
    Tolerance_old = ABC{t-1,12};
    
   toc
   formatSpec = 'Generation: %4.2f; Tolerances: %4.2f %4.2f; Time: %s';
  % formatSpec = 'Generation: %4.2f; Tolerances: %4.2f; Time: %s';

   fprintf([formatSpec ,'\n'],t,Tolerance_old,datestr(now,'mm-dd-yyyy HH-MM'));
   %fprintf(filename_variable, '\n');
   %fclose(filename_variable);
  

    [Samp_new,Score] = ABC_it(Tolerance_old,Samp_old,Weights_old,Sigma_old);
    
    
    % Determine Tolerance
    Tolerance_new = quantile(Score,alpha);
    Tolerance_new;
    % update weights
    Weights_num = nan(N,param_length);
    
    
    for i = 1:param_length
        Weights_num(:,i) = pdf(priors.(fields{i}),Samp_old(:,i));
    end
    
    Weights_denom = nan(N,N);
    for l=1:N
        for K =1:N
            Weights_denom(l,K) = Weights_old(K)*prod(Samp_new(l,:)>=Samp_old(K,:)-Sigma_old & Samp_new(l,:)<=Samp_old(K,:)+Sigma_old);
        end
    end
    
    
    Weights_new = prod(Weights_num,2)./sum(Weights_denom,2);
    
    
    % Update perturbation Kernel sigma
    %Sigma_new = sigma_scale*(max(samp_new)-min(samp_new));
    Sigma_new = sigma;
    
    % save
    ABC(t,:) = {'iteration',t,'Params',Samp_new,'Score',Score,'Weights',Weights_new,'sigma',Sigma_new,'Tolerance',Tolerance_new,'elapsed_time',toc};    
    ABC_lastGen = ABC(t,:);
   % save([Filename,'_',num2str(t),'.mat'],'ABC')
    save(Filename,'ABC')
    Filename_lg = append(Filename,'_lastGen');
   save(Filename_lg,'ABC_lastGen');
    
    % Check stopping criteria
    
%     if t==stoping_criteria %Tolerance_new/Tolerance_old>stoping_criteria
    if toc > 48*60*60
        stop=1;
    end
fdel = append(Folder,'ABC_outputs',num2str(num),'/Output',num2str(t-1),'*');
delete(fdel)    
end
ABC_output= ABC;
end
