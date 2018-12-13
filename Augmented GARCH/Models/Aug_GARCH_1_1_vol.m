% Aug_GARCH_1_1_vol.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code: Aug_GARCH_1_1_vol.m                    %
% Student Name: Jonathan Nolan                 %
% Student Number: 16071514                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-----------------------------------------------
% Clear all work spaces and previous code

clc
clear

%-----------------------------------------------
% Initial Parameters
% NOTE: These will be used to find initial points of the search

Initial_1=9;
Initial_2=5;
Initial_3=5;

%-----------------------------------------------
% Load your data sets - Choose from 5 companies:

% 1. ASTRAZENECA
COMP = xlsread('astraftseN.xlsx',1, 'A:G','basic');

% 2. BP
%COMP = xlsread('bpftseN.xlsx',1, 'A:G','basic');

% 3. GLAXOSMITHKLINE
%COMP = xlsread('glaxoftseN.xlsx',1, 'A:G','basic');

% 4. TESCO
%COMP = xlsread('tescoftseN.xlsx',1, 'A:G','basic');

% 5. VODAFONE
%COMP = xlsread('vodaftseN.xlsx',1, 'A:G','basic');

%-----------------------------------------------
% Calculate the log returns:
ret = diff(log(COMP(:,3)));
ret(isnan(ret))=0;
ret(~isfinite(ret))=0;


%-----------------------------------------------
ftse_rets = diff(log(COMP(:,6)));
ftse_rets(isnan(ftse_rets))=0;
ftse_rets(~isfinite(ftse_rets))=0;


%-----------------------------------------------
% load the volume of news published per day
T = length(COMP);

%VOLUME
vol = COMP(2:T,4);
volume = vol/(max(vol));


Parameters = Aug_GARCH_1_1_runALL_vol(Initial_1,Initial_2,Initial_3,ret,volume);


LLF = -Aug_GARCH_Maxlikelihood_vol(ret, volume, Parameters);