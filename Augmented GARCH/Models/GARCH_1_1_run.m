% GARCH_1_1_run.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code: GARCH_1_1_run.m                        %
% Student Name: Jonathan Nolan                 %
% Student Number: 16071514                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-----------------------------------------------
% Clear all work spaces and previous code

clc
clear

%-----------------------------------------------
% Load your data sets - Choose from 5 companies:

% 1. ASTRAZENECA
%COMP = xlsread('astraftseN.xlsx',1, 'A:G','basic');

% 2. BP
%COMP = xlsread('bpftseN.xlsx',1, 'A:G','basic');

% 3. GLAXOSMITHKLINE
%COMP = xlsread('glaxoftseN.xlsx',1, 'A:G','basic');

% 4. TESCO
%COMP = xlsread('tescoftseN.xlsx',1, 'A:G','basic');

% 5. VODAFONE
COMP = xlsread('vodaftseN.xlsx',1, 'A:G','basic');

%-----------------------------------------------
% Calculate the log returns:
ret = diff(log(COMP(:,3)));
ret(isnan(ret))=0;
ret(~isfinite(ret))=0;


%-----------------------------------------------
% Initial Parameters
% NOTE: These will be used to find initial points of the search
Initial_1 = 9;
Initial_2 = 5;

%-----------------------------------------------
% Calculates opitmal params for function below
Params = GARCH_1_1_runALL(Initial_1,Initial_2, ret);

%-----------------------------------------------
% Log Likelihood Function
LLF = -GARCH_1_1_Maxlikelihood(ret, Params);
