%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Jonathan Nolan                                                %
% Student Number: 16071514                                            %
% Module: Portfolio Risk Analysis (FI6012)                            %
% Assignment: Technical Assignment                                    %
%                                                                     %
% This code uses historical SPX_VIX_Ret to calculate the 10-day VaR   %
% and ES of an equity portfolio using 4 different approaches:         %
%   1st approach: 1-day Var/ES scaled to 10-day using sqrt(time)      %
%   2nd approach: Non-overlapping 10-day periods                      %
%   3rd approach: Overlapping adjusted returns                        %
%   4th approach: Overlapping 10 day periods and filtered historical  %
%                 simulation                                          %
%                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Clear workspace of past values before running code
clear


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Import equity portfolio data, calculate returns and dimensions needed 
% for initlising arrays.

%Initialise Parameters
alpha = 0.01; 									% significance level
H_1 = 1;                                        % 1-day risk horizon
H_2 = 10;                                       % 10-day risk horizon 
Scale_Factor = sqrt(H_2);                       % square root of time
value = 1;                                      % portfolio value

% Initialise Share Price Data:
% All data taken from Bloomberg on 01/03/2017
% Daily SPX VIX Index values from 03/01/1990 - 01/03/2017
% Import equity portfolio data, calculate returns and dimensions needed 
% for initlising arrays
SPX = xlsread('SPX_Historical_Last_Prices.xlsx',1, 'A:B','basic');

%calculates the daily returns from the prices
Returns = diff(log(SPX(:,2)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FURTHER DATA CLEAN UP

% NOTE: 
% Modulo Returns divdes the total number of Returns by 500, and shows the remainder.
% We will use this to get the number of returns from 6844, to 6500.

Mod_Returns = mod(length(Returns), 500);                %Modulo returns
% Mod_Returns = mod(length(Returns), 500)
% Mod_Returns = mod(6844, 500)
% Mod_Returns = 344

length_sample = length(Returns) - Mod_Returns + 9;      %Sample Length
% length_sample = length(Returns) - Mod_Returns + 9;
% length_sample = 6844 - 344 + 9;
% length_sample = 6509

Returns = Returns(end-length_sample+1 : end);           %Returns
%Returns = Returns(end-length_sample+1 : end);
%Returns = Returns(6844-6509+1 : 6844);
%Returns = Returns(336 : 6844);

Dates = SPX(end-length_sample+1:end, 1);                %Dates    
%Dates = SPX(end-length_sample+1:end, 1);
%Dates = SPX(6844-6509+1 : 6844, 1);
%Dates = SPX(336 : 6844, 1);

Number_of_Dates = x2mdate(Dates, 0);                    %Converts date number to matlab serial date

Sample_SPX = SPX(end-length_sample+1:end,2);            %sample size
%Sample_SPX = SPX(end-length_sample+1:end, 2);
%Sample_SPX = SPX(6844-6509+1 : 6844, 2);
%Sample_SPX = SPX(336 : 6844, 2)

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate the following:
% 10-day historical returns
% 10-day period daily volatilities

Ten_day_returns = zeros(length_sample-9, 1);
%Ten_day_returns = zeros(6509-9, 1);
%Ten_day_returns = zeros(6500, 1); 

Volatility = zeros(length_sample-9, 1);
%Volatility = zeros(6509-9, 1);
%Volatility = zeros(6500, 1);

for i = 1: length_sample-9
        Ten_day_returns(i,1) = sum(Returns(i:i+9));
        Volatility(i,1) = std(Returns(i:i+9));
end

%for i = 1: length_sample-9
%for i = 1: 6509-9
%for i = 1: 6500

        %Ten_day_returns(i,1) = sum(Returns(i:i+9));
        %Ten_day_returns(1:6500,1) = sum(Returns({1:6500}:{1:6500}+9)));
        % Example: i = 1
        %Ten_day_returns(1,1) = sum(Returns({1}:{1}+9));
        %Ten_day_returns(1,1) = sum(Returns(1:10));
        % Example: i = 2109
        %Ten_day_returns(2109,1) = sum(Returns(2109:2109+9));
        %Ten_day_returns(2109,1) = sum(Returns(2109:2118));
        
        %Volatility(i,1) = std(Returns(i:i+9));
        %Volatility(1:6500,1) = std(Returns({1:6500}:{1:6500}+9)));
        % Example: i = 1
        %Volatility(1,1) = std(Returns({1}:{1}+9));
        %Volatility(1,1) = std(Returns(1:10));
        % Example: i = 2109
        %Volatility(2109,1) = std(Returns({2109}:{2109}+9));
        %Volatility(2109,1) = std(Returns(2109:2118));    

Ten_day_date = Number_of_Dates(10:length_sample);
%Ten_day_date = Number_of_Dates(10:length_sample);
%Ten_day_date = Number_of_Dates(10:6509);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set Testing Window length
Test_Window = 2500;    

% Adjust Date Length
Dates = Number_of_Dates(length_sample-Test_Window-8: length_sample-9);         
%Dates = Number_of_Dates(length_sample-Test_Window-8 : length_sample-9);   
%Dates = Number_of_Dates(6509-2500-8 : 6509-9);   
%Dates = Number_of_Dates(4001 : 6500);   

%Historical Observations
Historical_OB = Ten_day_returns(end-Test_Window+1: end);
%Historical_OB = Ten_day_returns(end-Test_Window+1: end);
%Historical_OB = Ten_day_returns(6500-2500+1: 6500);
%Historical_OB = Ten_day_returns(4001: 6500);

%creates Daily VaR matrix
VaR_Daily = zeros(Test_Window, 1);
%VaR_Daily = zeros(Test_Window, 1);
%VaR_Daily = zeros(2500, 1);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Approaches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%3rd Approach: Overlapping 10-day VaR&ES with Garch(1, 1) adjusted returns

Approach_3_VaR = zeros(Test_Window, 5);
%Approach_3_VaR = zeros(Test_Window, 5);
%Approach_3_VaR = zeros(2500, 5);

Approach_3_ES = zeros(Test_Window, 5);        %   
%Approach_3_ES = zeros(Test_Window, 5);
%Approach_3_ES = zeros(2500, 5);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              
for l_length = 1:5
    Approach3_Est_Window = 500*l_length;%Estimation Window
    %Approach3_Est_Window = 500*l_length;%Estimation Window
    %Approach3_Est_Window = 500*(1:5);
    %Approach3_Est_Window = 500*[1, 2, 3, 4, 5];
    %Approach3_Est_Window = [500, 1000, 1500, 2000, 2500];
    
    T = Approach3_Est_Window+Test_Window;% Set Estimation Window length
    %T = Approach3_Est_Window+Test_Window;% Set Estimation Window length
    %T = [500, 1000, 1500, 2000, 2500] + 2500;
    %T = [3000, 3500, 4000, 4500, 5000];
    
    Sample_Returns3 = Returns(length_sample-T-9: length_sample);
    %Sample_Returns3 = Returns(length_sample-T-9: length_sample);
    %Sample_Returns3 = Returns({6509-[3000, 3500, 4000, 4500, 5000]-9}: 6509);
    %Sample_Returns3 = Returns([3500, 3000, 2500, 2000, 1500] : 6509);
    %Sample_Returns3 = Returns([{3500: 6509}, {3000: 6509}, {2500: 6509}, {2000: 6509}, {1500: 6509}];
    
    %-------------------------------------------------------------
    for j_n = 1 : Test_Window
        %j_n = 1 : Test_Window
        %j_n = 1 : 2500
        
        j_n_1 = Approach3_Est_Window+j_n;
        %j_n_1 = [500, 1000, 1500, 2000, 2500]+ (1 : 2500);
        %j_n_1 = [501:3000, 1001:3500, 1501:4000, 2001:4500, 2501:5000]
        
        j_n_2 = Approach3_Est_Window+j_n+9;
        %j_n_2 = [500, 1000, 1500, 2000, 2500]+ (1 : 2500) + 9;
        %j_n_2 = [510:3009, 1010:3509, 1510:4009, 2010:4509, 2510:5009]
        
        %-------------------------------------------------------------
        % Garch(1,1) fitting and calibration
        % Estimate conditional volatilities using MATLAB infer function
        
        Garchsample = Sample_Returns3(j_n: j_n+Approach3_Est_Window-1);
        %Garchsample = Sample_Returns3(j_n: j_n+Approach3_Est_Window-1);
        %Garchsample = Sample_Returns3([1 : 2500]: [1 : 2500] + [500, 1000, 1500, 2000, 2500]-1);
        %Garchsample = Sample_Returns3([1 : 2500]: [{500:2999}, {1000:3499}, {1500:3999}, {2000:4499}, {2500:4999}]);
        
        %example
        %Garchsample = Sample_Returns3([1] : [{500:2999}, {1000:3499}, {1500:3999}, {2000:4499}, {2500:4999}]);
        %Garchsample = Sample_Returns3([1:{500:2999}, 1:{1000:3499}, 1:{1500:3999}, 1:{2000:4499}, 1:{2500:4999}]);
        
        %example
        %Garchsample = Sample_Returns3([1:4] : [{5:9}, {10:14}, {15:19}, {20:24}, {25:29}]);
        %Garchsample = Sample_Returns3([1:4] : [{5:9}, {10:14}, {15:19}, {20:24}, {25:29}]);
        %([1,2,3,4] : [{5,6,7,8,9}, {10,11,12,13,14}, {15,16,17,18,19}, {20,21,22,23,24}, {25,26,27,28,29}]);
        
        % =
        % 1:5, 1:10, 1:15, 1:20, 1:25
        % 1:6, 1:11, 1:16, 1:21, 1:26
        % 1:7, 1:12, 1:17, 1:22, 1:27
        % 1:8, 1:13, 1:18, 1:23, 1:28
        % 1:9, 1:14, 1:19, 1:24, 1:29
        
        % =
        % [1, 2, 3, 4, 5]
        % [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        % [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
        % [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
        % [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
        % etc etc
        
        %NOTE: The last one will be:
        %Garchsample = Sample_Returns3([2500]: [4999]);
        
        Mdl = garch(1,1);
        % Specifies a GARCH(1,1) model, called Mdl with unknown
        % coefficients.
        
        EstMdl = estimate(Mdl, Garchsample, 'display', 'off');
        % Fits the GARCH(1,1) Model, called Mdl, to the series "Garchsample".
        % Now it is a GARCH model with known coefficients.
        
        Garch_vol = sqrt(infer(EstMdl,Garchsample,'E0', Garchsample(1)));
        % "infer(Mdl,Garchsample)" infers the conditional variances of the fully specified, 
        % univariate conditional variance model Mdl fit to the response data Y "
        
        Constant = EstMdl.Constant;
        
        if isempty(EstMdl.ARCH)==1
        % this function Determines whether array is empty
            Parameter1 = 0;
        % and if it is empty, put Parameter1 = 1
        else
            Parameter1 = cell2mat(EstMdl.ARCH);
        % and if it is NOT empty, put Parameter1 = 1
        % cell2mat function Converts cell array to ordinary array of the underlying data type
        % NOTE: 
        % Parameter 1 is our ALPHA
        end
        if isempty(EstMdl.GARCH)==1
        % this function Determines whether array is empty
           Parameter2 = 0;
        % and if it is empty, put Parameter2 = 1
        else
           Parameter2 = cell2mat(EstMdl.GARCH);
        % and if it is NOT empty, put Parameter2 = 1
        % cell2mat function Converts cell array to ordinary array of the underlying data type
        % NOTE: 
        % Parameter 2 is our BETA
        end;
        
        %Approach 3
        Adjust_returns = zeros(Approach3_Est_Window, 1);
        %Adjust_returns = zeros(Approach3_Est_Window, 1);
        %Adjust_returns = zeros([500, 1000, 1500, 2000, 2500],1);
        
            for p = 1 : Approach3_Est_Window
                %p = 1 : Approach3_Est_Window
                %p = 1 : [500, 1000, 1500, 2000, 2500]
                %p = [1:500, 1:1000, 1:1500, 1:2000, 1:2500]
                
                Adjust_returns(p, 1) = (Garch_vol(end)/Garch_vol(p,1))*Garchsample(p, 1);
                %Adjust_returns(p, 1) = (Garch_vol(end)/Garch_vol(p,1))*Garchsample(p, 1);
                %Adjust_returns([1:500, 1:1000, 1:1500, 1:2000, 1:2500], 1) = (Garch_vol(2500)/Garch_vol([1:500, 1:1000, 1:1500, 1:2000, 1:2500],1))*Garchsample([1:500, 1:1000, 1:1500, 1:2000, 1:2500], 1);
                
            end
        len = (Approach3_Est_Window/10)+9*(Approach3_Est_Window/10-1);
        %len = (Approach3_Est_Window/10)+9*(Approach3_Est_Window/10-1);
        %len = ([500, 1000, 1500, 2000, 2500]/10)+9*([500, 1000, 1500, 2000, 2500]/10-1);
        %len = ([50, 100, 150, 200, 250])+9*([50, 100, 150, 200, 250]-1);
        %len = ([50, 100, 150, 200, 250])+9*([49, 99, 149, 199, 249]);
        %len = ([50, 100, 150, 200, 250])+([441, 891, 1341, 1791, 2241]);
        %len = [491, 991, 1491, 1891, 2491];
        
        
        Approach3_Ret = zeros(len, 1);
        %Approach3_Ret = zeros(len, 1);
        %Approach3_Ret = zeros([491, 991, 1491, 1891, 2491], 1);
        
        g = 0;
        for n = 1 : 10
            for m = n+9 : 10 : Approach3_Est_Window 
                %m = n+9 : 10 : Approach3_Est_Window 
                %m = [1:10]+9 : 10 : [500, 1000, 1500, 2000, 2500] 
                %m = [10:19] : 10 : [500, 1000, 1500, 2000, 2500] 
            
                Approach3_Ret(g+1, 1) = sum(Adjust_returns(m-9:m)); 
                %Approach3_Ret(g+1, 1) = sum(Adjust_returns(m-9:m)); 
                %Approach3_Ret(0+1, 1) = sum(Adjust_returns(([10:19] : 10 : [500, 1000, 1500, 2000, 2500]-9):([10:19] : 10 : [500, 1000, 1500, 2000, 2500])));
                %Approach3_Ret(1, 1) = sum(Adjust_returns(([1:10] : 10 : [491, 991, 1491, 1991, 2491]):([10:19] : 10 : [500, 1000, 1500, 2000, 2500])));
          
            g = g + 1;
            end
        end
        length3 = length(Approach3_Ret);
        % length3 = 2491
        length3 = length3 - mod(length3, 10);
        %length3 = length3 - mod(length3, 10);
        %length3 = 2491 - mod(2491, 10);
        %length3 = 2491 - 1;
        %length3 = 2490;
        
        Sort_3 = sort(Approach3_Ret);
        %Sort_3 sorts the elements of Approach3_Ret in ascending order.
        
        Optimised_3 = floor(length3*alpha);
        %Optimised_3 = floor(length3*alpha);
        %Optimised_3 = floor(2490*0.01);
        %Optimised_3 = floor(24.90);
        %Optimised_3 = 24;
        % Floor() function rounds the elements of (length3*alpha) to the 
        % nearest integers less than or equal to (length3*alpha).
        
        if Optimised_3 == 0
           Optimised_3 = 1;
        end
        Approach_3_VaR(j_n, l_length) = -Sort_3(Optimised_3)*value;
        %Approach_3_VaR(j_n, l_length) = -Sort_3(Optimised_3)*value;
        %Approach_3_VaR(1 : 2500, 1:5) = -Sort_3(24)*1;
        %Approach_3_VaR(1 : 2500, 1:5) = -([-0.0409295914298172]);
        
        Approach_3_ES(j_n,l_length) = mean(Sort_3(1:Optimised_3))*value;
        %Approach_3_ES(j_n,l_length) = mean(Sort_3(1:Optimised_3))*value;
        %Approach_3_ES(j_n,l_length) = mean(Sort_3(1:Optimised_3))*value;
        %Approach_3_ES(j_n,l_length) = mean(Sort_3(1:Optimised_3))*value;
        
        
        
    end
end 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
