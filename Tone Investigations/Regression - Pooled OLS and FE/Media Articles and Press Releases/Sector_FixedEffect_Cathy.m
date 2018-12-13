


clear all;
clc;
tic

conn = database('TextSentiment', 'sa','nuclear97','com.microsoft.sqlserver.jdbc.SQLServerDriver','jdbc:sqlserver://localhost:1433;database=TextSentiment');

%設定基本參數
% Sector = '''Consumer Discretionary''';
% Sector = '''Consumer Staples''';
% Sector = '''Energy''';
Sector = '''Financials''';
% Sector = '''Health Care''';
% Sector = '''Industrials''';
% Sector = '''Information Technology''';
% Sector = '''Materials''';
% Sector = '''Consumer Discretionary''';
SQLCmdLead = 'with SymbolView as ( SELECT ROW_NUMBER() OVER (ORDER BY symbol) AS SymbolID, symbol FROM (SELECT DISTINCT dbo.SymbolData.symbol FROM dbo.[1204_relevantdata_nd5_tl1] INNER JOIN dbo.SymbolData ON dbo.[1204_relevantdata_nd5_tl1].symbol = dbo.SymbolData.symbol WHERE (dbo.[1204_relevantdata_nd5_tl1].GICS_sector = ';
SQLCmdTail = ')) AS TBL) SELECT date, SymbolID, GICS_sector,debtratio_seg,indicnews,BL_pos_prop,BL_neg_prop, BL_agreeindex,LM_pos_prop,LM_neg_prop, LM_agreeindex, MPQA_pos_prop, MPQA_neg_prop, MPQA_agreeindex,  MPQA_strongpos_prop,MPQA_strongneg_prop, MPQA_strongagreeindex, sp500_log_returns_tl1*0.01, vix_close_tl1*0.01, h_gk_tl1, log_returns_tl1, log_volume_tl1, log_volume_linear_trend_tl1, log_volume_linear_residual_tl1, log_volume_expected_tl1, log_volume_unexpected_tl1, h_gk, log_returns, log_volume, log_volume_linear_trend, log_volume_linear_residual, log_volume_expected, log_volume_unexpected FROM    [1204_relevantdata_nd5_tl1] INNER JOIN SymbolView ON [1204_relevantdata_nd5_tl1].symbol = SymbolView.symbol';
SQLCmd = strcat(SQLCmdLead, Sector, SQLCmdTail);


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
sid=cell2num(Data(:,2));

%%%%%%%%%%% loghgk   %%%%%%%%%%%%%%%
%%%%%%%%   BL    %%%%%%%%

% Neg+Pos
% y= cData(:,[24 2 3 4 15 16 17 18 22]);

%%%%%%%%   LM    %%%%%%%%
% y= cData(:,[24 2 6 7 15 16 17 18 21]);
% result1 = ppooled(y);


%%%%%%%%   MPQA    %%%%%%%%

y= cData(:,[24 2 9 10 15 16 17 18 21]);   % hgk
result1 = pfixed(y,sid);
 y= cData(:,[28 2 9 10 15 16 17 18]);       % log volume
 result2 = pfixed(y,sid);
  y= cData(:,[25 2 9 10 15 16 17 18]);     % return
  result3 = pfixed(y,sid);

%%%%%%%%%%%  log_volume_linear_residual (Detrend volume) %%%%%%%%%%%%%%%
%%%%%%%%   BL    %%%%%%%%

% y= cData(:,[28 2 3 4 15 16 17 18]);


%%%%%%%%   LM    %%%%%%%%

% y= cData(:,[28 2 6 7 15 16 17 18]);


%%%%%%%%   MPQA    %%%%%%%%
% y= cData(:,[28 2 9 10 15 16 17 18]);



%%%%%%%%%%%  log_return  %%%%%%%%%%%%%%%
%%%%%%%%   BL    %%%%%%%%

% y= cData(:,[25 2 3 4 15 16 17 18]);

%%%%%%%%   LM    %%%%%%%%

% y= cData(:,[25 2 6 7 15 16 17 18]);


%%%%%%%%   MPQA    %%%%%%%%
% y= cData(:,[25 2 9 10 15 16 17 18]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%    PCA   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% POS= cData(:,[ 3 6 9]);
% NEG= cData(:,[ 4 7 10]);
% [Pvector,Pscore,Pvalue] = princomp(POS) ;
% POSfactor=POS*Pvector;
% [Nvector,Nscore,Nvalue] = princomp(NEG) ;
% NEGfactor=NEG*Nvector;
% PCA_Pos=POSfactor(:,1);
% PCA_Neg=NEGfactor(:,1);
% 
%  y= [cData(:,[24 2 15 16 17 18 21]) PCA_Pos PCA_Neg];







