% Aug_GARCH_1_1_calibration_vol.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code: Aug_GARCH_1_1_calibration_vol.m        %
% Student Name: Jonathan Nolan                 %
% Student Number: 16071514                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function params = Aug_GARCH_1_1_calibration_vol ...
(ret, trad_vol, start_Parameters)

function j = mns_aux(Parameters)

j = Aug_GARCH_Maxlikelihood_vol(ret, trad_vol, Parameters);

end

params = fminsearch(@mns_aux, start_Parameters);

end