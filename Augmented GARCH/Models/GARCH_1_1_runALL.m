% GARCH_1_1_runALL.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code: GARCH_1_1_runALL.m                     %
% Student Name: Jonathan Nolan                 %
% Student Number: 16071514                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function d = GARCH_1_1_runALL (Initial_1,Initial_2, ret)

%-----------------------------------------------
% Initial Values
Minimum_Value=0;
x = 9;
z = 0;

%-----------------------------------------------
for a=x:Initial_1

for b=z:(Initial_2 - 1)

for c=z:(Initial_2 - b - 1)

    
%-------------------------------------------------
% The parameters initial values:

%Omega
parameter_1=10^(-a);

%Alpha
parameter_2=b/Initial_2+0.0001;

%Beta
parameter_3=c/Initial_2+0.0001;


%-------------------------------------------------
% Put these in to a dataset
startParams = [parameter_1 parameter_2 parameter_3];

Parameters = GARCH_1_1_calibration ...
(ret, startParams);

G_val = GARCH_1_1_Maxlikelihood ...
(ret, Parameters);

if (G_val < Minimum_Value)
Minimum_Value=G_val;
d = Parameters;

end;

end;

end;

end;