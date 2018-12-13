% GARCH_1_1_simulation.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code: GARCH_1_1_simulation.m                 %
% Student Name: Jonathan Nolan                 %
% Student Number: 16071514                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% given parameters of GARCH model and values of log returns
% it returns the array of values of variance
function vola = GARCH_1_1_simulation ( smp, T, params)

%-------------------------------------------------
% The parameters ininitial values
parameter1_ = params (1); 
parameter2_ = params (2); 
parameter3_ = params (3);

%-------------------------------------------------
% Volatility when t = 1
volatility(1)=sqrt(var(smp));

for i=2:T
    
%-------------------------------------------------
% Volatility for the other values of t, t = 2:T

volatility(i) = sqrt(parameter1_ + parameter2_ *smp(i-1)^2+ parameter3_ *volatility(i-1)^2);

end

vola=volatility;

end