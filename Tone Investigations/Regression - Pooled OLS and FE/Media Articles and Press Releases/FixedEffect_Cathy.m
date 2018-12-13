
%****************************************************************************************
% NOTE: Text sentiment research by implementing panel regression with
% company fixed effects. call pfixed.m , and see panel_d.m
%**************************************************************************




clear all;
clc;
tic

conn = database('TextSentiment', 'sa','nuclear97','com.microsoft.sqlserver.jdbc.SQLServerDriver','jdbc:sqlserver://localhost:1433;database=TextSentiment');

%設定基本參數
% Entire sample

SQLCmd = 'SELECT date, SymbolID, GICS_sector,debtratio_seg,indicnews,BL_pos_prop,BL_neg_prop, BL_agreeindex,LM_pos_prop,LM_neg_prop, LM_agreeindex, MPQA_pos_prop, MPQA_neg_prop, MPQA_agreeindex,  MPQA_strongpos_prop,MPQA_strongneg_prop, MPQA_strongagreeindex, sp500_log_returns_tl1*0.01, vix_close_tl1*0.01, h_gk_tl1, log_returns_tl1, log_volume_tl1, log_volume_linear_trend_tl1, log_volume_linear_residual_tl1, log_volume_expected_tl1, log_volume_unexpected_tl1, h_gk, log_returns, log_volume, log_volume_linear_trend, log_volume_linear_residual, log_volume_expected, log_volume_unexpected FROM    [1204_relevantdata_nd5_tl1] INNER JOIN  SymbolData ON [1204_relevantdata_nd5_tl1].symbol = SymbolData.symbol order by Date';

% SQLCmd = 'SELECT date, SymbolID, GICS_sector,debtratio_seg,indicnews,BL_pos_prop,BL_neg_prop, BL_agreeindex,LM_pos_prop,LM_neg_prop, LM_agreeindex, MPQA_pos_prop, MPQA_neg_prop, MPQA_agreeindex,  MPQA_strongpos_prop,MPQA_strongneg_prop, MPQA_strongagreeindex, sp500_log_returns_tl1*0.01, vix_close_tl1*0.01, h_gk_tl1, log_returns_tl1, log_volume_tl1, log_volume_linear_trend_tl1, log_volume_linear_residual_tl1, log_volume_expected_tl1, log_volume_unexpected_tl1, h_gk, log_returns, log_volume, log_volume_linear_trend, log_volume_linear_residual, log_volume_expected, log_volume_unexpected FROM    [1204_relevantdata_nd5_tl1] INNER JOIN  SymbolData ON [1204_relevantdata_nd5_tl1].symbol = SymbolData.symbol  WHERE indicnews=1 order by Date';


% SQLCmd = 'SELECT date, Convert(bigint, CONVERT(binary(5), symbol)) AS symbolID, GICS_sector,debtratio_seg,indicnews,BL_pos_prop,BL_neg_prop, BL_agreeindex,LM_pos_prop,LM_neg_prop, LM_agreeindex, MPQA_pos_prop, MPQA_neg_prop, MPQA_agreeindex,  MPQA_strongpos_prop,MPQA_strongneg_prop, MPQA_strongagreeindex, sp500_log_returns_tl1, vix_close_tl1, h_gk_tl1, log_returns_tl1, log_volume_tl1, log_volume_linear_trend_tl1, log_volume_linear_residual_tl1, log_volume_expected_tl1, log_volume_unexpected_tl1, h_gk, log_returns, log_volume, log_volume_linear_trend, log_volume_linear_residual, log_volume_expected, log_volume_unexpected FROM [TextSentiment].[dbo].[1204_relevantdata_nd5_tl1] ORDER BY symbolID, Date';
%





Data = fetch(conn, SQLCmd);


% PURPOSE: performs Pooled Least Squares for Panel Data(for balanced or
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
cData = cell2mat(Data(:,4:33));
correlation=corrcoef(cData);
sid=cell2num(Data(:,2));
% Sent= cData(:,[3 4 6 7 9 10]);


%%%%%%%%%%% loghgk   %%%%%%%%%%%%%%%
%%%%%%%%   BL    %%%%%%%%

% Neg+Pos
% y= cData(:,[24 2 3 4 15 16 17 18 22]);
% % results = ppooled(y);
% result1 = pfixed(y,sid);

% IndiNeg+Pos
% IndiBL=cData(:,2).*cData(:,4);
% y= [cData(:,[24 3 15 16 17 18 22]) IndiBL];
% result1 = pfixed(y,sid);

%%%%%%%%   LM    %%%%%%%%

% Neg+Pos
% y= cData(:,[24 2 6 7 15 16 17 18 21]);
% IndiLM=cData(:,2).*cData(:,7);
% y= [cData(:,[24 6 15 16 17 18 21]) IndiLM];   

%%%%%%%%   MPQA    %%%%%%%%

% y= cData(:,[24 2 9 10 15 16 17 18 21]);
% result1 = pfixed(y,sid);
% y= cData(:,[24 2 12 13 15 16 17 18 21]);
% result1 = pfixed(y,sid);

% IndiMPQA=cData(:,2).*cData(:,10);
% y= [cData(:,[24 9 15 16 17 18 21]) IndiMPQA];




%%%%%%%%%%%  log_volume_linear_residual (Detrend volume) %%%%%%%%%%%%%%%
%%%%%%%%   BL    %%%%%%%%

% y= cData(:,[28 2 3 4 15 16 17 18]);
% y= [cData(:,[28 3 15 16 17 18]) IndiBL];


%%%%%%%%   LM    %%%%%%%%

% y= cData(:,[28 2 6 7 15 16 17 18]);
% y= [cData(:,[28 6 15 16 17 18 ]) IndiLM];


%%%%%%%%   MPQA    %%%%%%%%
% y= cData(:,[28 2 9 10 15 16 17 18]);
% results = ppooled(y);
% y= cData(:,[28 2 12 13 15 16 17 18]);
% results = ppooled(y);

% y= [cData(:,[28 9 15 16 17 18]) IndiMPQA];



%%%%%%%%%%%  log_return  %%%%%%%%%%%%%%%
%%%%%%%%   BL    %%%%%%%%

% y= cData(:,[25 2 3 4 15 16 17 18]);
% y= [cData(:,[25 3 15 16 17 18]) IndiBL];

%%%%%%%%   LM    %%%%%%%%

% y= cData(:,[25 2 6 7 15 16 17 18]);
% y= [cData(:,[25 6 15 16 17 18]) IndiLM];


%%%%%%%%   MPQA    %%%%%%%%
% y= cData(:,[25 2 9 10 15 16 17 18]);
% results = ppooled(y);
% y= [cData(:,[25 9 15 16 17 18]) IndiMPQA];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%    PCA   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

POS= cData(:,[ 3 6 9]);
NEG= cData(:,[ 4 7 10]);
[Pvector,Pscore,Pvalue] = princomp(POS) ;
POSfactor=POS*Pvector;
[Nvector,Nscore,Nvalue] = princomp(NEG) ;
NEGfactor=NEG*Nvector;
PCA_Pos=POSfactor(:,1);
PCA_Neg=NEGfactor(:,1);
IndiNeg=cData(:,2).*PCA_Neg;
y= [cData(:,[24 2 15 16 17 18 22]) PCA_Pos PCA_Neg];
% y= [cData(:,[24 15 16 17 18 21]) PCA_Pos IndiNeg];
result1 = pfixed(y,sid);


% y= [cData(:,[28 2 15 16 17 18]) PCA_Pos PCA_Neg];
% y= [cData(:,[28 15 16 17 18]) PCA_Pos IndiNeg];

% y= [cData(:,[25 2 15 16 17 18]) PCA_Pos PCA_Neg];
% y= [cData(:,[25 15 16 17 18]) PCA_Pos IndiNeg];






% result1 = pfixed(y,sid);



%%%%%%%%%%%%%%%%   prints haussman test %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	  use for testing the specification of the fixed or random  effects model 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% y= cData(:,[24 2 4 15 16 17 18 21]);
% result1 = pfixed(y,sid);
% result2 = prandom(y,sid);
%  phaussman(result1, result2);

% phaussman(result1, result2);
% 
%  ***** Haussman Test ******* 
% 
%  Ho: Random Effects 
%  Ha: Fixed Effects  
%  Statistic      = -36670.9546 
% 
%  Probability	=       Inf 
% 
%  ***************************


% y= cData(:,[29 2 4 15 16 17 18 22]);
% result1 = pfixed(y,sid);
% result2 = prandom(y,sid);
% phaussman(result1, result2);
% 
%  ***** Haussman Test ******* 
% 
%  Ho: Random Effects 
%  Ha: Fixed Effects  
%  Statistic      =  948.0088 
% 
%  Probability	=    0.0000 
% 
%  ***************************
