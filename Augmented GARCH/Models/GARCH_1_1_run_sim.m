%GARCH_1_1_run_sim.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code: GARCH_1_1_run_sim.m                    %
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
COMP = xlsread('bpftseN.xlsx',1, 'A:G','basic');

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

% input values of parameters of GARCH model 
% (Found from GARCH_run.m)

% 1. ASTRAZENECA
%Params = [4.11644881306226e-06,0.0522626795979556,0.932939174415168];

% 2. BP
Params = [4.53544649854822e-06,0.0766021081785507,0.906664348128872];

% 3. GLAXOSMITHKLINE
%Params = [1.97884621768647e-05,0.140517362068915,0.775619956707619];

% 4. TESCO
%Params = [1.11293440261326e-05,0.110805600526196,0.848028349708265];

% 5. VODAFONE
%Params = [2.10296069803219e-06,0.0542213254561133,0.941932256690579];



%------------------------------------------
% length of the input array (period of time)
T=length(ret);

%------------------------------------------
% simulation
Sim = GARCH_1_1_simulation(ret, T, Params);

%------------------------------------------
% plotting the simulated volatility
plot(Sim);