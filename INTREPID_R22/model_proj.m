function model = model_proj(params,Initial,Scenario,Disability_weights,Disability_weights_PWID,Disability_weights_HIV)
timestep = 0.1;
time_start = params.seed_date;
time_end = 2030;
TIME= time_start:timestep:time_end;
options1 = odeset('NonNegative',1:(2*2*2*4*3*4*8),'AbsTol',1e-6,'RelTol',1e-6);
[t,y] = ode23(@(t,y)Ukraine_model(t,y,params,'Projections',Scenario),TIME,Initial);
y_out = reshape(y(:,1:2*2*2*4*3*4*8),[length(t),2,2,2,4,3,4,8]);

add_outs = y(:,2*2*2*4*3*4*8+1:end);

Yearly_Disability_weighted_LYs = nan(time_end-time_start,1);
Yearly_Disability_weighted_LYs_PWID = nan(time_end-time_start,1);
Yearly_Disability_weighted_LYs_HIV = nan(time_end-time_start,1);
Yearly_Pyrs_ART = nan(time_end-time_start,1);
Yearly_Pyrs_OST = nan(time_end-time_start,1);
Yearly_Pyrs_NGO = nan(time_end-time_start,1);
Yearly_Pyrs_NGO_HIVpos = nan(time_end-time_start,1);
Yearly_Pyrs_NGO_HIVneg  = nan(time_end-time_start,1);
Yearly_life_years = nan(time_end-time_start,1);
Yearly_Pyrs_pre_Cirrhosis = nan(time_end-time_start,1);
Yearly_Pyrs_compensated = nan(time_end-time_start,1);
Yearly_Pyrs_Decompensated = nan(time_end-time_start,1);
Yearly_ART_initiations_NGO = nan(time_end-time_start,1);
YEAR = nan(time_end-time_start,1);

ART_initiations = [0;diff(add_outs(:,8))./timestep];

for j = 1:time_end-time_start
    Year = time_start+j-1;
    ind1 = find(TIME == Year);
    ind2 = find(TIME == Year+1);
    
YEAR(j) = Year;    
DW = nan(ind2-ind1+1,1);
DW_PWID = nan(ind2-ind1+1,1);
DW_HIV = nan(ind2-ind1+1,1);
k=1;

for x=ind1:ind2
    DW(k)=sum(squeeze(Disability_weights).*squeeze(sum(y_out(x,:,:,:,:,:,:,:),[1,2,3,4,5,6,7])),'all');
    DW_PWID(k)=sum(squeeze(Disability_weights_PWID).*squeeze(sum(y_out(x,:,:,:,:,:,:,:),[1,3,4,5,6])),'all');
    DW_HIV(k)=sum(squeeze(Disability_weights_HIV').*squeeze(sum(y_out(x,:,:,:,:,:,:,:),[1,2,3,4,5,6,7])),'all');
    
    k=k+1;
end

Yearly_Disability_weighted_LYs(j) = trapz(t(ind1:ind2),DW);
Yearly_Disability_weighted_LYs_PWID(j) = trapz(t(ind1:ind2),DW_PWID);
Yearly_Disability_weighted_LYs_HIV(j) = trapz(t(ind1:ind2),DW_HIV);
Yearly_Pyrs_ART(j) = trapz(t(ind1:ind2),sum(y_out(ind1:ind2,:,:,:,:,:,:,[4,6,8]),2:8));
Yearly_Pyrs_OST(j) = trapz(t(ind1:ind2),sum(y_out(ind1:ind2,1,:,:,:,:,[2,3],:),2:8));
Yearly_Pyrs_NGO(j) = trapz(t(ind1:ind2),sum(y_out(ind1:ind2,1,:,:,:,[2,3],:,:),2:8));
Yearly_Pyrs_NGO_HIVpos(j) = trapz(t(ind1:ind2),sum(y_out(ind1:ind2,1,:,:,:,[2,3],:,2:end),2:8));
Yearly_Pyrs_NGO_HIVneg(j) = trapz(t(ind1:ind2),sum(y_out(ind1:ind2,1,:,:,:,[2,3],:,1),2:8));
Yearly_life_years(j) = trapz(t(ind1:ind2),sum(y_out(ind1:ind2,:,:,:,:,:,:,:),2:8));
Yearly_Pyrs_pre_Cirrhosis(j) = trapz(t(ind1:ind2),sum(y_out(ind1:ind2,:,:,:,:,:,:,:),2:8));
Yearly_Pyrs_compensated(j) = trapz(t(ind1:ind2),sum(y_out(ind1:ind2,:,:,:,:,:,:,:),2:8));
Yearly_Pyrs_Decompensated(j) = trapz(t(ind1:ind2),sum(y_out(ind1:ind2,:,:,:,:,:,:,:),2:8));
Yearly_ART_initiations_NGO(j) = trapz(t(ind1:ind2),ART_initiations(ind1:ind2));
end

PWID_HIV_prevalence_com_y = sum(sum(sum(sum(sum(y_out(:,1,:,1,[1,3,4],:,:,2:8),3),5),6),7),8)./...
    sum(sum(sum(sum(sum(y_out(:,1,:,1,[1,3,4],:,:,1:8),3),5),6),7),8)*100;
PWID_HIV_prevalence_com_o = sum(sum(sum(sum(sum(y_out(:,1,:,2,[1,3,4],:,:,2:8),3),5),6),7),8)./...
    sum(sum(sum(sum(sum(y_out(:,1,:,2,[1,3,4],:,:,1:8),3),5),6),7),8)*100;
PWID_HIV_prevalence_never_inc =  sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,1,:,:,2:8),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,1,:,:,1:8),3),4),5),6),7),8)*100;
PWID_HIV_prevalence_ever_inc =  sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[3,4],:,:,2:8),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[3,4],:,:,1:8),3),4),5),6),7),8)*100;
PWID_HIV_prevalence_com_m = sum(sum(sum(sum(sum(y_out(:,1,1,:,[1,3,4],:,:,2:8),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(y_out(:,1,1,:,[1,3,4],:,:,1:8),4),5),6),7),8)*100;
PWID_HIV_prevalence_com_f = sum(sum(sum(sum(sum(y_out(:,1,2,:,[1,3,4],:,:,2:8),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(y_out(:,1,2,:,[1,3,4],:,:,1:8),4),5),6),7),8)*100;

PWID_prop_NGO_young = sum(y_out(:,1,:,1,[1,3,4],[2,3],:,:),2:8)./...
        sum(y_out(:,1,:,1,[1,3,4],:,:,:),2:8)*100;
PWID_prop_NGO_old = sum(y_out(:,1,:,2,[1,3,4],[2,3],:,:),2:8)./...
        sum(y_out(:,1,:,2,[1,3,4],:,:,:),2:8)*100;
PWID_prop_NGO_HIV_pos = sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],[2,3],:,2:8),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],:,:,2:8),3),4),5),6),7),8)*100;
PWID_prop_NGO_HIV_neg = sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],[2,3],:,1),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],:,:,1),3),4),5),6),7),8)*100;

PWID_prop_current_OST_com_client = sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],[2,3],[2,3],:),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],[2,3],:,:),3),4),5),6),7),8)*100;
PWID_prop_current_OST_com_non_client = sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],1,[2,3],:),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],1,:,:),3),4),5),6),7),8)*100;
PWID_prop_current_ART_com_client = sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],[2,3],:,[4,6,8]),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],[2,3],:,2:8),3),4),5),6),7),8)*100;
PWID_prop_current_ART_com_non_client = sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],1,:,[4,6,8]),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],1,:,2:8),3),4),5),6),7),8)*100;
PWID_prop_current_ART_com_young = sum(sum(sum(sum(sum(sum(y_out(:,1,:,1,[1,3,4],:,:,[4,6,8]),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,1,[1,3,4],:,:,2:8),3),4),5),6),7),8)*100;
PWID_prop_current_ART_com_old = sum(sum(sum(sum(sum(sum(y_out(:,1,:,2,[1,3,4],:,:,[4,6,8]),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,2,[1,3,4],:,:,2:8),3),4),5),6),7),8)*100;

model = struct('TIME',TIME,...
    'PWID_pop_size',sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,:,:,:,:),3),4),5),6),7),8),...
    'prop_female',sum(sum(sum(sum(sum(y_out(:,1,2,:,[1,3,4],:,:,:),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],:,:,:),3),4),5),6),7),8)*100,...
    'PWID_prop_young',sum(sum(sum(sum(sum(sum(y_out(:,1,:,1,[1,3,4],:,:,:),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],:,:,:),3),4),5),6),7),8)*100,...
    'PWID_prop_male_com_young',sum(sum(sum(sum(sum(y_out(:,1,1,1,[1,3,4],:,:,:),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,1,:,[1,3,4],:,:,:),3),4),5),6),7),8)*100,...
    'PWID_prop_female_com_young',sum(sum(sum(sum(sum(y_out(:,1,2,1,[1,3,4],:,:,:),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,2,:,[1,3,4],:,:,:),3),4),5),6),7),8)*100,...
    'PWID_prop_ever_inc',sum(y_out(:,1,:,:,[3,4],:,:,:),3:8)./...
    sum(y_out(:,1,:,:,[1,3,4],:,:,:),3:8)*100,...
    'prop_ever_inc_young_male',sum(sum(sum(sum(y_out(:,1,1,1,[3,4],:,:,:),5),6),7),8)./...
    sum(sum(sum(sum(y_out(:,1,1,1,[1,3,4],:,:,:),5),6),7),8)*100,...
    'prop_ever_inc_old_male',sum(sum(sum(sum(y_out(:,1,1,2,[3,4],:,:,:),5),6),7),8)./...
    sum(sum(sum(sum(y_out(:,1,1,2,[1,3,4],:,:,:),5),6),7),8)*100,...
    'prop_ever_inc_young_female' , sum(sum(sum(sum(y_out(:,1,2,1,[3,4],:,:,:),5),6),7),8)./...
    sum(sum(sum(sum(y_out(:,1,2,1,[1,3,4],:,:,:),5),6),7),8)*100,...
    'prop_ever_inc_old_female' , sum(sum(sum(sum(y_out(:,1,2,2,[3,4],:,:,:),5),6),7),8)./...
    sum(sum(sum(sum(y_out(:,1,2,2,[1,3,4],:,:,:),5),6),7),8)*100,...
    'prop_rec_inc_young_male' , sum(sum(sum(y_out(:,1,1,1,3,:,:,:),6),7),8)./...
    sum(sum(sum(sum(y_out(:,1,1,1,[1,3,4],:,:,:),5),6),7),8)*100,...
    'prop_rec_inc_old_male' , sum(sum(sum(y_out(:,1,1,2,3,:,:,:),6),7),8)./...
    sum(sum(sum(sum(y_out(:,1,1,2,[1,3,4],:,:,:),5),6),7),8)*100,...
    'prop_rec_inc_young_female' , sum(sum(sum(y_out(:,1,2,1,3,:,:,:),6),7),8)./...
    sum(sum(sum(sum(y_out(:,1,2,1,[1,3,4],:,:,:),5),6),7),8)*100,...
    'prop_rec_inc_old_female' , sum(sum(sum(y_out(:,1,2,2,3,:,:,:),6),7),8)./...
    sum(sum(sum(sum(y_out(:,1,2,2,[1,3,4],:,:,:),5),6),7),8)*100,...
    'prop_rec_inc_NGO' , sum(sum(sum(sum(sum(y_out(:,1,:,:,3,[2,3],:,:),3),4),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],[2,3],:,:),3),4),5),6),7),8)*100,...
    'prop_rec_inc_non_NGO',sum(sum(sum(sum(sum(y_out(:,1,:,:,3,1,:,:),3),4),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],1,:,:),3),4),5),6),7),8)*100,...
    'PWID_prop_NGO_HIV_pos' , sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],[2,3],:,2:8),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],:,:,2:8),3),4),5),6),7),8)*100,...
    'PWID_prop_NGO_HIV_neg' , sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],[2,3],:,1),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],:,:,1),3),4),5),6),7),8)*100,...
    'PWID_prop_short_NGO' , sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,:,2,:,:),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,:,[2,3],:,:),3),4),5),6),7),8)*100,...
    'PWID_prop_short_NGO_old' , sum(sum(sum(sum(sum(sum(y_out(:,1,:,2,:,2,:,:),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,2,:,[2,3],:,:),3),4),5),6),7),8)*100,...
    'PWID_prop_NGO',sum(y_out(:,1,:,:,[1,3,4],[2,3],:,:),2:8)./...
    sum(y_out(:,1,:,:,[1,3,4],:,:,:),2:8)*100,...
    'PWID_HIV_prevalence' , sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,:,:,:,2:8),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,:,:,:,1:8),3),4),5),6),7),8)*100,...
    'PWID_HIV_prevalence_com' , sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],:,:,2:8),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],:,:,1:8),3),4),5),6),7),8)*100,...
    'PWID_HIV_prevalence_com_m' , sum(sum(sum(sum(sum(y_out(:,1,1,:,[1,3,4],:,:,2:8),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(y_out(:,1,1,:,[1,3,4],:,:,1:8),4),5),6),7),8)*100,...
    'PWID_HIV_prevalence_com_f' , sum(sum(sum(sum(sum(y_out(:,1,2,:,[1,3,4],:,:,2:8),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(y_out(:,1,2,:,[1,3,4],:,:,1:8),4),5),6),7),8)*100,...
    'PWID_HIV_prevalence_com_y' , sum(sum(sum(sum(sum(y_out(:,1,:,1,[1,3,4],:,:,2:8),3),5),6),7),8)./...
    sum(sum(sum(sum(sum(y_out(:,1,:,1,[1,3,4],:,:,1:8),3),5),6),7),8)*100,...
    'PWID_HIV_prevalence_com_o' , sum(sum(sum(sum(sum(y_out(:,1,:,2,[1,3,4],:,:,2:8),3),5),6),7),8)./...
    sum(sum(sum(sum(sum(y_out(:,1,:,2,[1,3,4],:,:,1:8),3),5),6),7),8)*100,...
    'PWID_HIV_prevalence_com_ym' , sum(sum(sum(sum(sum(y_out(:,1,1,1,[1,3,4],:,:,2:8),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(y_out(:,1,1,1,[1,3,4],:,:,1:8),4),5),6),7),8)*100,...
    'PWID_HIV_prevalence_com_om' , sum(sum(sum(sum(sum(y_out(:,1,1,2,[1,3,4],:,:,2:8),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(y_out(:,1,1,2,[1,3,4],:,:,1:8),4),5),6),7),8)*100,...
    'PWID_HIV_prevalence_com_yf' , sum(sum(sum(sum(sum(y_out(:,1,2,1,[1,3,4],:,:,2:8),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(y_out(:,1,2,1,[1,3,4],:,:,1:8),4),5),6),7),8)*100,...
    'PWID_HIV_prevalence_com_of' , sum(sum(sum(sum(sum(y_out(:,1,2,2,[1,3,4],:,:,2:8),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(y_out(:,1,2,2,[1,3,4],:,:,1:8),4),5),6),7),8)*100,...
    'PWID_HIV_prevalence_never_inc' ,  sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,1,:,:,2:8),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,1,:,:,1:8),3),4),5),6),7),8)*100,...
    'PWID_HIV_prevalence_ever_inc' ,  sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[3,4],:,:,2:8),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[3,4],:,:,1:8),3),4),5),6),7),8)*100,...
    'PWID_prop_current_OST_com' , sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],:,[2,3],:),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],:,:,:),3),4),5),6),7),8)*100,...
    'PWID_prop_current_OST_com_client' , sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],[2,3],[2,3],:),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],[2,3],:,:),3),4),5),6),7),8)*100,...
    'PWID_prop_current_OST_com_non_client' , sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],1,[2,3],:),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],1,:,:),3),4),5),6),7),8)*100,...
    'PWID_prop_current_ART_com' , sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],:,:,[4,6,8]),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],:,:,2:8),3),4),5),6),7),8)*100,...
    'PWID_prop_current_ART_com_client' , sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],[2,3],:,[4,6,8]),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],[2,3],:,2:8),3),4),5),6),7),8)*100,...
    'PWID_prop_current_ART_com_non_client' , sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],1,:,[4,6,8]),3),4),5),6),7),8)./...
    sum(sum(sum(sum(sum(sum(y_out(:,1,:,:,[1,3,4],1,:,2:8),3),4),5),6),7),8)*100,...
    'OR_HIV_young' , make_OR(PWID_HIV_prevalence_com_y,PWID_HIV_prevalence_com_o),...
    'OR_HIV_female' , make_OR(PWID_HIV_prevalence_com_f,PWID_HIV_prevalence_com_m),...
    'RR_HIV_prev_female', make_RR(PWID_HIV_prevalence_com_f, PWID_HIV_prevalence_com_m),...
    'OR_HIV_ever_inc' , make_OR(PWID_HIV_prevalence_ever_inc,PWID_HIV_prevalence_never_inc),...
    'OR_NGO_young' , make_OR(PWID_prop_NGO_young,PWID_prop_NGO_old),...
    'OR_NGO_HIV' , make_OR(PWID_prop_NGO_HIV_pos,PWID_prop_NGO_HIV_neg),...
    'OR_OST_NGO' , make_OR(PWID_prop_current_OST_com_client,PWID_prop_current_OST_com_non_client),...
    'OR_ART_NGO' , make_OR(PWID_prop_current_ART_com_client,PWID_prop_current_ART_com_non_client),...
    'OR_ART_old', make_OR(PWID_prop_current_ART_com_old,PWID_prop_current_ART_com_young),...
    'PWID_prop_homeless',sum(y_out(:,1,:,:,[1,3,4],2,:,:),2:8)./...
    sum(y_out(:,1,:,:,[1,3,4],[1,2],:,:),2:8)*100,...
    'PWID_prop_NGO_all',sum(y_out(:,1,:,:,:,[2,3],:,:),2:8)./...
    sum(y_out(:,1,:,:,:,:,:,:),2:8)*100,...
    'PWID_prop_NGO_com',sum(y_out(:,1,:,:,[1,3,4],[2,3],:,:),2:8)./...
    sum(y_out(:,1,:,:,[1,3,4],:,:,:),2:8)*100,...
    'PWID_prop_NGO_young_male',sum(y_out(:,1,1,1,[1,3,4],[2,3],:,:),2:8)./...
    sum(y_out(:,1,1,1,[1,3,4],:,:,:),2:8)*100,...
    'PWID_prop_NGO_old_male',sum(y_out(:,1,1,2,[1,3,4],[2,3],:,:),2:8)./...
    sum(y_out(:,1,1,2,[1,3,4],:,:,:),2:8)*100,...
    'PWID_prop_NGO_young_female' , sum(y_out(:,1,2,1,[1,3,4],[2,3],:,:),2:8)./...
    sum(y_out(:,1,2,1,[1,3,4],:,:,:),2:8)*100,...
    'PWID_prop_NGO_old_female' , sum(y_out(:,1,2,2,[1,3,4],[2,3],:,:),2:8)./...
    sum(y_out(:,1,2,2,[1,3,4],:,:,:),2:8)*100, ...
    'PWID_prop_NGO_ever_inc' , sum(y_out(:,1,:,:,[3,4],[2,3],:,:),2:8)./...
    sum(y_out(:,1,:,:,[3,4],:,:,:),2:8)*100,...
    'PWID_prop_NGO_never_inc', sum(y_out(:,1,:,:,1,[2,3],:,:),2:8)./...
    sum(y_out(:,1,:,:,1,:,:,:),2:8)*100,...
    'PWID_HIV_prevalence_com_non_client', sum(y_out(:,1,:,:,[1,3,4],1,:,2:8),2:8)./...
    sum(y_out(:,1,:,:,[1,3,4],1,:,1:8),2:8)*100,...
    'PWID_HIV_prevalence_com_client', sum(y_out(:,1,:,:,[1,3,4],[2,3],:,2:8),2:8)./...
    sum(y_out(:,1,:,:,[1,3,4],[2,3],:,1:8),2:8)*100,...
    'PWID_HIV_prevalence_pris', sum(y_out(:,1,:,:,2,:,:,2:8),2:8)./...
    sum(y_out(:,1,:,:,2,:,:,1:8),2:8)*100,...
    'PWID_HIV_prevalence_pris_ym', sum(y_out(:,1,1,1,2,:,:,2:8),2:8)./...
    sum(y_out(:,1,1,1,2,:,:,1:8),2:8)*100,...
    'PWID_HIV_prevalence_pris_om', sum(y_out(:,1,1,2,2,:,:,2:8),2:8)./...
    sum(y_out(:,1,1,2,2,:,:,1:8),2:8)*100,...
    'PWID_HIV_prevalence_pris_yf', sum(y_out(:,1,2,1,2,:,:,2:8),2:8)./...
    sum(y_out(:,1,2,1,2,:,:,1:8),2:8)*100,...
    'PWID_HIV_prevalence_pris_of', sum(y_out(:,1,2,2,2,:,:,2:8),2:8)./...
    sum(y_out(:,1,2,2,2,:,:,1:8),2:8)*100,...
    'PWID_prop_current_ART_all', sum(y_out(:,1,:,:,:,:,:,[4,6,8]),2:8)./...
    sum(y_out(:,1,:,:,:,:,:,2:8),2:8)*100,...
    'PWID_prop_current_ART_com_ym', sum(y_out(:,1,1,1,[1,3,4],:,:,[4,6,8]),2:8)./...
    sum(y_out(:,1,1,1,[1,3,4],:,:,2:8),2:8)*100,...
    'PWID_prop_current_ART_com_om', sum(y_out(:,1,1,2,[1,3,4],:,:,[4,6,8]),2:8)./...
    sum(y_out(:,1,1,2,[1,3,4],:,:,2:8),2:8)*100,...
    'PWID_prop_current_ART_com_yf', sum(y_out(:,1,2,1,[1,3,4],:,:,[4,6,8]),2:8)./...
    sum(y_out(:,1,2,1,[1,3,4],:,:,2:8),2:8)*100,...
    'PWID_prop_current_ART_com_of', sum(y_out(:,1,2,2,[1,3,4],:,:,[4,6,8]),2:8)./...
    sum(y_out(:,1,2,2,[1,3,4],:,:,2:8),2:8)*100,...
    'PWID_prop_current_ART_com_never_inc', sum(y_out(:,1,:,:,1,:,:,[4,6,8]),2:8)./...
    sum(y_out(:,1,:,:,1,:,:,2:8),2:8)*100,...
    'PWID_prop_current_ART_com_ever_inc', sum(y_out(:,1,:,:,[3,4],:,:,[4,6,8]),2:8)./...
    sum(y_out(:,1,:,:,[3,4],:,:,2:8),2:8)*100,...
    'PWID_prop_current_ART_com_recent_inc', sum(y_out(:,1,:,:,3,:,:,[4,6,8]),2:8)./...
    sum(y_out(:,1,:,:,3,:,:,2:8),2:8)*100,...
    'PWID_prop_current_ART_com_non_recent_inc', sum(y_out(:,1,:,:,4,:,:,[4,6,8]),2:8)./...
    sum(y_out(:,1,:,:,4,:,:,2:8),2:8)*100,...
    'PWID_prop_current_ART_pris', sum(y_out(:,1,:,:,2,:,:,[4,6,8]),2:8)./...
    sum(y_out(:,1,:,:,2,:,:,2:8),2:8)*100,...
    'PWID_prop_current_OST_all', sum(y_out(:,1,:,:,:,:,[2,3],:),2:8)./...
    sum(y_out(:,1,:,:,:,:,:,:),2:8)*100,...
    'PWID_prop_current_OST_com_ym', sum(y_out(:,1,1,1,[1,3,4],:,[2,3],:),2:8)./...
    sum(y_out(:,1,1,1,[1,3,4],:,:,:),2:8)*100,...
    'PWID_prop_current_OST_com_om', sum(y_out(:,1,1,2,[1,3,4],:,[2,3],:),2:8)./...
    sum(y_out(:,1,1,2,[1,3,4],:,:,:),2:8)*100,...
    'PWID_prop_current_OST_com_yf', sum(y_out(:,1,2,1,[1,3,4],:,[2,3],:),2:8)./...
    sum(y_out(:,1,2,1,[1,3,4],:,:,:),2:8)*100,...
    'PWID_prop_current_OST_com_of', sum(y_out(:,1,2,2,[1,3,4],:,[2,3],:),2:8)./...
    sum(y_out(:,1,2,2,[1,3,4],:,:,:),2:8)*100,...
    'PWID_prop_current_OST_com_never_inc', sum(y_out(:,1,:,:,1,:,[2,3],:),2:8)./...
    sum(y_out(:,1,:,:,1,:,:,:),2:8)*100,...
    'PWID_prop_current_OST_com_ever_inc', sum(y_out(:,1,:,:,[3,4],:,[2,3],:),2:8)./...
    sum(y_out(:,1,:,:,[3,4],:,:,:),2:8)*100,...
    'PWID_prop_current_OST_com_recent_inc', sum(y_out(:,1,:,:,3,:,[2,3],:),2:8)./...
    sum(y_out(:,1,:,:,3,:,:,:),2:8)*100,...
    'PWID_prop_current_OST_com_non_recent_inc', sum(y_out(:,1,:,:,4,:,[2,3],:),2:8)./...
    sum(y_out(:,1,:,:,4,:,:,:),2:8)*100,...
    'HIV_Inf_sex', add_outs(:,1),...
    'HIV_Inf_inj', add_outs(:,2),...
    'HIV_Inf_tot', add_outs(:,3),...
    'HIV_Incidence_PWID',[0;diff(add_outs(:,5))]./timestep,...
    'PWID_prop_HIV_sexual', [0; diff(add_outs(:,4))]./timestep,...
    'RR_HIV_Incidence_rec_inc', [0; diff(add_outs(:,9))]./timestep,...
    'RR_HIV_Incidence_nonrec_inc', [0; diff(add_outs(:,10))]./timestep,...
    'RR_HIV_Incidence_homeless', [0; diff(add_outs(:,11))]./timestep,...
    'CE_YEAR',YEAR,...
    'CE_Yearly_Disability_weighted_LYs', Yearly_Disability_weighted_LYs,...
    'Yearly_Disability_weighted_LYs_PWID',Yearly_Disability_weighted_LYs_PWID,...
    'Yearly_Disability_weighted_LYs_HIV',Yearly_Disability_weighted_LYs_HIV,...
    'CE_Yearly_Pyrs_ART',Yearly_Pyrs_ART,...
    'CE_Yearly_Pyrs_OST',Yearly_Pyrs_OST,...
    'CE_Yearly_Pyrs_NGO',Yearly_Pyrs_NGO,...
    'CE_Yearly_Pyrs_NGO_HIVpos',Yearly_Pyrs_NGO_HIVpos,...
    'CE_Yearly_Pyrs_NGO_HIVneg',Yearly_Pyrs_NGO_HIVneg,...
    'CE_Yearly_life_years',Yearly_life_years,...
    'CE_Yearly_Pyrs_pre_Cirrhosis',Yearly_Pyrs_pre_Cirrhosis,...
    'CE_Yearly_Pyrs_compensated', Yearly_Pyrs_compensated,...
    'CE_Yearly_Pyrs_Decompensated', Yearly_Pyrs_Decompensated,...
    'Yearly_ART_initiations_NGO',Yearly_ART_initiations_NGO);

    function OR = make_OR(prev1,prev2)
        odds1 = prev1/100./(1-prev1/100);
        odds2 = prev2/100./(1-prev2/100);
        OR = odds1./odds2;
    end

    function RR = make_RR(prev1,prev2)
        RR = prev1./prev2;
    end
end