% Aug_GARCH_1_1_runALL_vol.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code: Aug_GARCH_1_1_runALL_vol.m        %
% Student Name: Jonathan Nolan                 %
% Student Number: 16071514                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function j = Aug_GARCH_1_1_runALL_vol (Initial_1,Initial_2,Initial_3, ret, Trad_vol)


%-----------------------------------------------
% Initial Values
Minimum_Value=0;
x = 9;
z = 0;
y = 4;


for a=x:Initial_1
for b=z:(Initial_2-1)
for c=z:(Initial_2-b-1)
for d=y:Initial_3

    
%-------------------------------------------------
% The parameters ininitial values:

parameter_1=10^(-a);

parameter_2=b/Initial_2+0.0001;

parameter_3=c/Initial_2+0.0001;

parameter_4=10^(-d); 

%-------------------------------------------------
% Put these in to a dataset
startParams = [parameter_1 parameter_2 parameter_3 parameter_4];

Parameters = Aug_GARCH_1_1_calibration_vol ...
(ret, Trad_vol, startParams);

G_val = Aug_GARCH_Maxlikelihood_vol ...
(ret, Trad_vol, Parameters);

if (G_val<Minimum_Value)
Minimum_Value=G_val;
j = Parameters;

end;
end;
end;
end;
end;