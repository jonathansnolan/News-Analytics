
%****************************************************************************************
% NOTE: Text sentiment research by implementing panel regression with
% company fixed effects. call pfixed.m , and see panel_d.m
%**************************************************************************

%  PURPOSE: performs Pooled Least Squares for Panel Data(for balanced or
% unbalanced data)

% USAGE:  results = ppooled(y,x)
% where:    y     = a (nobs x neqs) matrix of all of the individual's observations 
%						 vertically concatenated. This matrix must include in the firt
%						 column the dependent variable, the independent variables must follow
%						 accordingly.	
%			    x    = optional matrix of exogenous variables, 
%						  dummy variables. 				
%						 (NOTE: constant vector automatically included)
%--------------------------------------------------------------------------
%--------------



clear all;
clc;
tic

conn = database('TextSentiment', 'sa','nuclear97','com.microsoft.sqlserver.jdbc.SQLServerDriver','jdbc:sqlserver://localhost:1433;database=TextSentiment');

%%
% %設定基本參數
% % Entire sample

SQLCmd = 'SELECT date, SymbolID, GICS_sector,debtratio_seg,indicnews,BL_pos_prop,BL_neg_prop, BL_agreeindex,LM_pos_prop,LM_neg_prop, LM_agreeindex, MPQA_pos_prop, MPQA_neg_prop, MPQA_agreeindex,  MPQA_strongpos_prop,MPQA_strongneg_prop, MPQA_strongagreeindex, sp500_log_returns_tl1*0.01, vix_close_tl1*0.01, h_gk_tl1, log_returns_tl1, log_volume_tl1, log_volume_linear_trend_tl1, log_volume_linear_residual_tl1, log_volume_expected_tl1, log_volume_unexpected_tl1, h_gk, log_returns, log_volume, log_volume_linear_trend, log_volume_linear_residual, log_volume_expected, log_volume_unexpected FROM    [1204_relevantdata_nd5_tl1] INNER JOIN  SymbolData ON [1204_relevantdata_nd5_tl1].symbol = SymbolData.symbol  WHERE indicnews=1 order by Date';

%%
Data = fetch(conn, SQLCmd);
cData = cell2mat(Data(:,4:33));
Sent= cData(:,[3 4 6 7 9 10]);
corSent=corrcoef(Sent);     %[BL_P, BL_N, LM_P, LM_N, MPQA_P, MPQA_N]
CS=chol(corSent);


%%
SQLCmd = 'SELECT date, SymbolID, GICS_sector,debtratio_seg,indicnews,BL_pos_prop,BL_neg_prop, BL_agreeindex,LM_pos_prop,LM_neg_prop, LM_agreeindex, MPQA_pos_prop, MPQA_neg_prop, MPQA_agreeindex,  MPQA_strongpos_prop,MPQA_strongneg_prop, MPQA_strongagreeindex, sp500_log_returns_tl1*0.01, vix_close_tl1*0.01, h_gk_tl1, log_returns_tl1, log_volume_tl1, log_volume_linear_trend_tl1, log_volume_linear_residual_tl1, log_volume_expected_tl1, log_volume_unexpected_tl1, h_gk, log_returns, log_volume, log_volume_linear_trend, log_volume_linear_residual, log_volume_expected, log_volume_unexpected FROM    [1204_relevantdata_nd5_tl1] INNER JOIN  SymbolData ON [1204_relevantdata_nd5_tl1].symbol = SymbolData.symbol order by date';



Data = fetch(conn, SQLCmd);
cData = cell2mat(Data(:,4:33));
sid=cell2num(Data(:,2));
n=length(unique(sid));
[numOfRows,numOfColumns] = size(Data);
beta=zeros(n,1);
lamda=zeros(n,1);
upperN=zeros(n,3);
upperP=zeros(n,3);
i=1;

%%
%%%%%%%%%%% loghgk   %%%%%%%%%%%%%%%

%%%%%%%%   BL    %%%%%%%%
y= cData(:,[24 2 3 4 15 16 17 18 21]);
result1 = pfixed(y,sid);
 %%%%%%%%   LM    %%%%%%%%
y= cData(:,[24 2 6 7 15 16 17 18 21]);
result2 = pfixed(y,sid);

%%%%%%%%   MPQA    %%%%%%%%
y= cData(:,[24 2 9 10 15 16 17 18 21]);
result3 = pfixed(y,sid);

% identical simulated variable
d1=100;
d2=1;
simSPreturn = random('gev',0.02,0.35,0.64,d1,d2)*0.01;  % assume gev(tail,sigma,mu) estimated from 2009/10~2014/10
simVIX=ones(d1,d2)*0.1889;
resid=rand(d1,d2)*0.001;



% Calculate beta and simulate for each symbol
SV1=zeros(n*d1,3); % save LM simulated Neg.pro(colume1), Pos.pro(colume2) and simulated volatility (colume3)
SV2=zeros(n*d1,3);  % save BL simulated Neg.pro(colume1), Pos.pro(colume2) and simulated volatility (colume3)
SV3=zeros(n*d1,3);  % save MPQA simulated Neg.pro(colume1), Pos.pro(colume2) and simulated volatility (colume3)

for rowIndex = 1:numOfRows
   while  i<=n
     index=find(sid==i);  
     singleCompanyData=cData(index,:);
     %simulate for each symbol by using the estimates from the panel fixed
     %effect, with individual attention ratio(lamda), and beta
     beta(i,:)=regress(singleCompanyData(:,18),singleCompanyData(:,15));
     lamda(i,:)=sum(singleCompanyData(:,2))/length(index);
     upperN(i,1)=max(singleCompanyData(:,7));  % upper bound of LM_Neg
     upperN(i,2)=max(singleCompanyData(:,4));  % upper bound of BL_Neg
     upperN(i,3)=max(singleCompanyData(:,10)); % upper bound of MPQA_Neg
     upperP(i,1)=max(singleCompanyData(:,6));  % upper bound of LM_Pos
     upperP(i,2)=max(singleCompanyData(:,3));  % upper bound of BL_Pos
     upperP(i,3)=max(singleCompanyData(:,9)); % upper bound of MPQA_Pos
     simI=binornd(1,lamda(i,1),d1,d2);
     simReturn=beta(i,1)*simSPreturn;
     % results.iintc  lists the individual intercept term (fixed effects)
     tmpN1=upperN(i,1)*rand(d1,d2).*simI;
     tmpP1=upperP(i,1)*rand(d1,d2).*simI;
     tmpN2=upperN(i,2)*rand(d1,d2).*simI;
     tmpP2=upperP(i,2)*rand(d1,d2).*simI;
     tmpN3=upperN(i,3)*rand(d1,d2).*simI;
     tmpP3=upperP(i,3)*rand(d1,d2).*simI;
     
     randNP=[tmpP1 tmpN1 tmpP2 tmpN2 tmpP3 tmpN3];  % independent sentiment varaibles
     corNP=abs(randNP*CS);                               % correlated sentiment varaibles
     
     
     %  BL simulation
     simh=result1.beta(1).*simI+result1.beta(2).*corNP(:,1)+result1.beta(3).*corNP(:,2)+result1.beta(4).*simSPreturn+result1.beta(5).*simVIX+result1.iintc(i,1)+resid;
     simEh=exp(simh);
     SV1(((i-1)*d1+1:i*d1),:)=[corNP(:,2) corNP(:,1) simEh];
     
     
     %  LM simulation
     simh=result2.beta(1).*simI+result2.beta(2).*corNP(:,3)+result2.beta(3).*corNP(:,4)+result2.beta(4).*simSPreturn+result2.beta(5).*simVIX+result2.iintc(i,1)+resid;
     simEh=exp(simh);
     SV2(((i-1)*d1+1:i*d1),:)=[corNP(:,4) corNP(:,3) simEh];
     
     
     %  MPQA simulation
     simh=result3.beta(1).*simI+result3.beta(2).*corNP(:,5)+result3.beta(3).*corNP(:,6)+result3.beta(4).*simSPreturn+result3.beta(5).*simVIX+result3.iintc(i,1)+resid;
     simEh=exp(simh);
     SV3(((i-1)*d1+1:i*d1),:)=[corNP(:,6) corNP(:,5) simEh];
         
     
     i=i+1;
   end
    
end






