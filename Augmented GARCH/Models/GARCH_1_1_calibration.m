% Aug_GARCH_1_1_calibration.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code: GARCH_1_1_calibration.m                %
% Student Name: Jonathan Nolan                 %
% Student Number: 16071514                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function op_params = GARCH_1_1_calibration ...
(ret, StartParameters)

function h = mns_aux(Parameters)
h = GARCH_1_1_Maxlikelihood(ret, Parameters);

end

% Calculates opitmal params
op_params = fminsearch(@mns_aux, StartParameters);

end