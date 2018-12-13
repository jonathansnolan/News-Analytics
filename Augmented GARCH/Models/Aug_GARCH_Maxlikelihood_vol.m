% Aug_GARCH_Maxlikelihood_vol.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code: Aug_GARCH_Maxlikelihood_vol.m          %
% Student Name: Jonathan Nolan                 %
% Student Number: 16071514                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-------------------------------------------------

function j = Aug_GARCH_Maxlikelihood_vol ...
(returns, trad_vol, Params)

%-------------------------------------------------
% The parameters ininitial values:

parameter_one=Params(1);

parameter_two=Params(2);

parameter_three=Params(3);

parameter_four=Params(4);


%-------------------------------------------------
% the datasets length
num=length(returns);

if ((parameter_one<0) || (parameter_two<0) || (parameter_three<0) || (parameter_four<0))

j=intmax;
% Code returns the maximum integer 

return;
end


variance_t(1,1)=nanvar(returns);

j = -log(variance_t(1))-(returns(1)^2/variance_t(1));

for count=2:num

variance_t(count,1)=parameter_one+parameter_two*(returns(count-1))^2+ ...
parameter_three*variance_t(count-1)+parameter_four*trad_vol(count);

j=j-log(variance_t(count))-...
((returns(count))^2/variance_t(count));

end

% the final value of likelihood function
j=-(1/2)*(j-log(2*pi));

end