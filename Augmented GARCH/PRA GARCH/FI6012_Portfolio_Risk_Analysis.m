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

Mod_Returns = mod(length(Returns), 500);                %Modulo returns
length_sample = length(Returns) - Mod_Returns + 9;      %Sample Length
Returns = Returns(end-length_sample+1 : end);           %Returns
Dates = SPX(end-length_sample+1:end, 1);                %Dates    
Number_of_Dates = x2mdate(Dates, 0);                    %Converts date number to matlab serial date
Sample_SPX = SPX(end-length_sample+1:end,2);            %sample size

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Data Analysis and Pretesting
FirstTimeseries = fints(Number_of_Dates, Sample_SPX, {'Historical_SPX'}, 0, 'SPX_index' );
SecondTimeseries = fints(Number_of_Dates, Returns, {'SPX_returns'}, 0, 'SPX_returns' );

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Graphs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Comparison of Historical S&P 500 Returns with Index
figure(1)
subplot(2, 1, 2);
x = plot(FirstTimeseries);
set(x(1), 'color', 'blue');
xlabel('Date');ylabel('Historical S&P500 Index');
title('S&P 500 Index')
subplot(2,1,1);
plot(SecondTimeseries);
xlabel('Date');ylabel('Historical S&P500 Returns');
title('S&P 500 Returns');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create Histograms for Returns Data
% Plot histogram of daily Optimized Portfolio Daily Returns
figure (2)
histfit(Returns, 500)
title('Histogram of SPX Histroical Daily Returns')
xlabel('Historical Daily Returns')
ylabel('Frequency')
string_1 = {'Mean Return:' ,num2str(mean(Returns)),...
 'Excess Kurtosis:' ,num2str(kurtosis(Returns)-3),...
 'Skewness: ' ,num2str(skewness(Returns))};
annotation('textbox', [0.6,0.7,0.055,0.21],'String', string_1);
Histogram_Kurtosis = kurtosis(Returns);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%QQplot Comparison of Daily Returns versus Standard Normal
figure(3)
qqplot(Returns);
xlabel('Standard Normal Quantiles');
ylabel('Quantiles of SPX Daily Returns');
title('SPX Daily Returns VS Standard Normal')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Autocorrelation Test
figure(4)
subplot(1, 2, 2)
autocorr(Returns);
title('Daily Returns Autorrelation Test');
subplot(1, 2, 1)
autocorr(Returns.^2);
title('Squared Returns  Autorrelation Test');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate the following:
% 10-day historical returns
% 10-day period daily volatilities

Ten_day_returns = zeros(length_sample-9, 1);
Volatility = zeros(length_sample-9, 1);

for i = 1: length_sample-9
        Ten_day_returns(i,1) = sum(Returns(i:i+9));
        Volatility(i,1) = std(Returns(i:i+9));
end


Ten_day_date = Number_of_Dates(10:length_sample);
ThirdTimeseries = fints(Ten_day_date, Ten_day_returns,{'TenDayHistoricalReturns'},0,...
'TenDayReturns' );
FourthTimeseries = fints(Ten_day_date, Volatility, {'Volatility'},0, 'TenDayVolatilities' );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Graph of 10-Day Historical Returns Versus 10-da period Volatilities
figure(5)
subplot(2, 1, 2);
y = plot(ThirdTimeseries);
set(y(1), 'color', 'blue');
xlabel('Date');ylabel('10-Day Historical Returns');
title('10-Day Historical Returns')
subplot(2,1,1);
plot(FourthTimeseries);
xlabel('Date');ylabel('Volatility');
title('10-Day period Volatilities');   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Graph comparing the returns versus the 10-day returns
figure(6)
subplot(2, 1, 2);
y = plot(ThirdTimeseries);
set(y(1), 'color', 'blue');
xlabel('Date');ylabel('10-Day Historical Returns');
title('10-Day Historical Returns')
subplot(2,1,1);
plot(SecondTimeseries);
xlabel('Date');ylabel('Historical S&P500 Returns');
title('S&P 500 Returns');

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set Testing Window length
Test_Window = 2500;    

% Adjust Date Length
Dates = Number_of_Dates(length_sample-Test_Window-8: length_sample-9);         

%Historical Observations
Historical_OB = Ten_day_returns(end-Test_Window+1: end);

%creates Daily VaR matrix
VaR_Daily = zeros(Test_Window, 1);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Approaches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%1st Approach: 1-day Var/ES scaled to 10-day using sqrt(time)

%Creates matrix for values
Approach_1_VaR = zeros(Test_Window, 5);  
Approach_1_ES = zeros(Test_Window, 5);        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for l_length = 1:5
    
    %Estimation Window
    Approach1_Est_Window = 500*l_length;
    
    % Set Estimation Window length                                                           
    T = Approach1_Est_Window+Test_Window;
    
    % Length adjustment
    Sample_Returns = Returns(length_sample-T-9: length_sample);          
    
    for j_n = 1 : Test_Window  
        j_n_1 = Approach1_Est_Window+j_n;
        j_n_2 = Approach1_Est_Window+j_n+9;
        Approach1_Ret = Sample_Returns(j_n: j_n+Approach1_Est_Window-1);                   
        length1 = length(Approach1_Ret);
        Sort_1 = sort(Approach1_Ret);
        Optimised_1 = floor(length1*alpha); 
        Daily_VaR(j_n, l_length) = -Sort_1(Optimised_1)*value;
        Approach_1_VaR(j_n, l_length) = Scale_Factor*Daily_VaR(j_n, l_length);
        Approach_1_ES(j_n, l_length) = Scale_Factor*mean(Sort_1(1:Optimised_1))*value;
    end
end   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%2nd Approach: Non-overlapping 10-day periods  

%Creates matrix for values
Approach_2_VaR = zeros(Test_Window, 5);  
Approach_2_ES = zeros(Test_Window, 5); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
      
for l_length = 1:5  
    %Estimation Window
    Approach2_Est_Window = 500*l_length;
    % Set Estimation Window length                                                           
    T2 = Approach2_Est_Window + Test_Window;
    Sample_Returns2 = Returns(length_sample-T2-9: length_sample);
    for j_n = 1 : Test_Window  
        j_n_1 = Approach2_Est_Window+j_n;
        j_n_2 = Approach2_Est_Window+j_n+9;
        
        for Approach2_Ret = zeros(Approach2_Est_Window/10,1);
        c = 0;
        for u = j_n+9 : 10 : j_n+Approach2_Est_Window;                             
            Approach2_Ret(c+1) = sum(Sample_Returns2(u-9:u));
            c = c + 1;
        end
        
        length2 = length(Approach2_Ret);
        Sort_2 = sort(Approach2_Ret);
        Optimised_2 = floor(length2*alpha);
        
        if Optimised_2 == 0
            Optimised_2 = 1;
        end
        Approach_2_VaR(j_n, l_length) = -Sort_2(Optimised_2)*value;
        Approach_2_ES(j_n, l_length) = mean(Sort_2(1:Optimised_2))*value;
        end
    end;
end;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%3rd Approach: Overlapping 10-day VaR&ES with Garch(1, 1) adjusted returns

Approach_3_VaR = zeros(Test_Window, 5);
Approach_3_ES = zeros(Test_Window, 5);        %                            

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              
for l_length = 1:5
    Approach3_Est_Window = 500*l_length;%Estimation Window
    T = Approach3_Est_Window+Test_Window;% Set Estimation Window length
    Sample_Returns3 = Returns(length_sample-T-9: length_sample);
    
    for j_n = 1 : Test_Window  
        j_n_1 = Approach3_Est_Window+j_n;
        j_n_2 = Approach3_Est_Window+j_n+9;
                
        % Garch(1,1) fitting and calibration
        % Estimate conditional volatilities using MATLAB infer function
        Garchsample = Sample_Returns3(j_n: j_n+Approach3_Est_Window-1);
        Mdl = garch(1,1);
        EstMdl = estimate(Mdl, Garchsample, 'display', 'off');      
        Garch_vol = sqrt(infer(EstMdl,Garchsample,'E0', Garchsample(1)));
        Constant = EstMdl.Constant;
        if isempty(EstMdl.ARCH)==1
            Parameter1 = 0;
        else
            Parameter1 = cell2mat(EstMdl.ARCH);
        end
        if isempty(EstMdl.GARCH)==1
           Parameter2 = 0;
        else
           Parameter2 = cell2mat(EstMdl.GARCH);
        end;
        
        %Approach 3
        Adjust_returns = zeros(Approach3_Est_Window, 1);
            for p = 1 : Approach3_Est_Window
                Adjust_returns(p, 1) = (Garch_vol(end)/Garch_vol(p,1))*Garchsample(p, 1);
            end
        len = (Approach3_Est_Window/10)+9*(Approach3_Est_Window/10-1);
        Approach3_Ret = zeros(len, 1);
        g = 0;
        for n = 1 : 10
            for m = n+9 : 10 : Approach3_Est_Window 
            Approach3_Ret(g+1, 1) = sum(Adjust_returns(m-9:m));  
            g = g + 1;
            end
        end
        length3 = length(Approach3_Ret);
        length3 = length3 - mod(length3, 10);
        Sort_3 = sort(Approach3_Ret);
        Optimised_3 = floor(length3*alpha);
        if Optimised_3 == 0
           Optimised_3 = 1;
        end
        Approach_3_VaR(j_n, l_length) = -Sort_3(Optimised_3)*value;
        Approach_3_ES(j_n,l_length) = mean(Sort_3(1:Optimised_3))*value;
    end
end 


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%4th Approach: Overlapping 10-day VaR&ES with Garch(1, 1) filtered returns  

Approach_4_VaR = zeros(Test_Window, 5);  
Approach_4_ES = zeros(Test_Window, 5);        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for l_length = 1:5
    Approach4_Est_Window = 500*l_length;
    T = Approach4_Est_Window+Test_Window;
    Sample_Returns4 = Returns(length_sample-T-9: length_sample);
       
    for j_n = 1 : Test_Window  
        j_n_1 = Approach4_Est_Window+j_n;
        j_n_2 = Approach4_Est_Window+j_n+9;
                
        % Garch(1,1) fitting and calibration
        % Estimate conditional volatilities using MATLAB infer function
        Garchsample4 = Sample_Returns4(j_n: j_n+Approach4_Est_Window-1);
        Mdl = garch(1,1);
        EstMdl = estimate(Mdl, Garchsample4, 'display', 'off');      
        Garch_vol4 = sqrt(infer(EstMdl,Garchsample4,'E0', Garchsample4(1)));
        Constant = EstMdl.Constant;
        if isempty(EstMdl.ARCH)==1
            Parameter1 = 0;
        else
            Parameter1 = cell2mat(EstMdl.ARCH);
        end
        if isempty(EstMdl.GARCH)==1
           Parameter2 = 0;
        else
           Parameter2 = cell2mat(EstMdl.GARCH);
        end;
        
        %Approach 4
        Adjust_returns = zeros(Approach4_Est_Window, 1);
        for p = 1 : Approach4_Est_Window
            Adjust_returns(p, 1) = (Garch_vol4(end)/Garch_vol4(p,1))*Garchsample4(p, 1);
        end
        len = Approach4_Est_Window/10+9*(Approach4_Est_Window/10-1);
        returns3 = NaN(len, 1);
        g = 0;
        for n = 1 : 10
            for m = n+9 : 10 : Approach4_Est_Window 
            returns3(g+1, 1) = sum(Adjust_returns(m-9:m));  
            g = g + 1;
            end
        end
        
        
       
        Standard_Residuals = Garchsample4./Garch_vol4;
        sigma0 = Garch_vol4(end);
        r0 = Garchsample4(end);
        conditionalvariance = NaN(11, 1);
        Forecast_returns = NaN(10, 1);
        Simulations = 100;
        Approach_Ret4 = NaN(Simulations, 1);	 
        conditionalvariance(1, 1) = Constant + Parameter1*(r0^2) + Parameter2*(sigma0^2);	  
        
        b = 1;
        while b < Simulations+1
            for c = 2: 11	
                z = randperm(Approach4_Est_Window,1);
                Forecast_returns(c-1, 1) = sqrt(conditionalvariance(c-1, 1))*Standard_Residuals(z, 1);			
                conditionalvariance(c, 1) = Constant + Parameter1*(Forecast_returns(c-1, 1)^2)...
                    + Parameter2*(conditionalvariance(c-1, 1)); 
            end
            Approach_Ret4(b, 1) = sum(Forecast_returns);
            b = b + 1;
        end
        
        length4 = length(Approach_Ret4);
        Sort_4 = sort(Approach_Ret4);
        Optimised_4 = ceil(length4*alpha);
        Approach_4_VaR(j_n,l_length) = -Sort_4(Optimised_4)*value;
        Approach_4_ES(j_n,l_length) = mean(Sort_4(1:Optimised_4))*value;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%Create Matrices for Backtesting VaR and ES
Violation_Ratio = zeros(4,5);                   % Violation Ratio
Norm_Shortfall = zeros(4,5);                    % Normalised Shortfall
bertest = zeros(4, 5);                          % Bernolii Test
indtest = zeros(4, 5);                          % Independence Test

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Bernolii coverage test - Independence test
First_Sample_Test = zeros(Test_Window, 5);
Second_Sample_Test = zeros(Test_Window, 5);
Third_Sample_Test = zeros(Test_Window, 5);
Forth_Sample_Test = zeros(Test_Window, 5);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

for O_period = 1:5
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Exceedances
    %Violation Ratio
    %Normalised Shortfall

    %Approach 1
    Approach1_exceedances = find(Historical_OB < -Approach_1_VaR(:,O_period));
    Violation_Ratio(1, O_period) = length(Approach1_exceedances)/(alpha*(Test_Window));
    Norm_Shortfall(1, O_period) = mean(Historical_OB(Approach1_exceedances)./-Approach_1_ES(Approach1_exceedances, O_period));
    
    %Approach 2
    Approach2_exceedances = find(Historical_OB < -Approach_2_VaR(:,O_period));
    Violation_Ratio(2, O_period) = length(Approach2_exceedances)/(alpha*(Test_Window));
    Norm_Shortfall(2, O_period) = mean(Historical_OB(Approach2_exceedances)./-Approach_2_ES(Approach2_exceedances, O_period));
    
    %Approach 3
    Approach3_exceedances = find(Historical_OB < -Approach_3_VaR(:,O_period));
    Violation_Ratio(3, O_period) = length(Approach3_exceedances)/(alpha*(Test_Window));
    Norm_Shortfall(3, O_period) = mean(Historical_OB(Approach3_exceedances)./-Approach_3_ES(Approach3_exceedances, O_period));
    
    %Approach 4
    Approach4_exceedances = find(Historical_OB < -Approach_4_VaR(:,O_period));
    Violation_Ratio(4, O_period) = length(Approach4_exceedances)/(alpha*(Test_Window));
    Norm_Shortfall(4, O_period) = mean(Historical_OB(Approach4_exceedances)./-Approach_4_ES(Approach4_exceedances, O_period));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Bernoulli coverage test and independance test
    First_Sample_Test(Approach1_exceedances, O_period) = 1;
    bertest(1, O_period) = bern_test(alpha,First_Sample_Test(:, O_period));
    indtest(1, O_period) = ind_test(First_Sample_Test(:, O_period));
    
    Second_Sample_Test(Approach2_exceedances, O_period) = 1;
    bertest(2, O_period) = bern_test(alpha,Second_Sample_Test(:, O_period));
    indtest(2, O_period) = ind_test(Second_Sample_Test(:, O_period));
    
    Third_Sample_Test(Approach3_exceedances, O_period) = 1;
    bertest(3, O_period) = bern_test(alpha,Third_Sample_Test(:, O_period));
    indtest(3, O_period) = ind_test(Third_Sample_Test(:, O_period));
    
    Forth_Sample_Test(Approach4_exceedances, O_period) = 1;
    bertest(4, O_period) = bern_test(alpha,Forth_Sample_Test(:, O_period));
    indtest(4, O_period) = ind_test(Forth_Sample_Test(:, O_period));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %displays matrices containing the answers
    disp([O_period, Violation_Ratio(1, O_period), Norm_Shortfall(1, O_period), bertest(1, O_period), 1-chi2cdf(bertest(1, O_period),1),...
        indtest(1, O_period),1-chi2cdf(indtest(1, O_period),1);...
        O_period, Violation_Ratio(2, O_period), Norm_Shortfall(2, O_period) bertest(2, O_period),1-chi2cdf(bertest(2, O_period),1),...
        indtest(2, O_period), 1-chi2cdf(indtest(2, O_period),1);...
        O_period, Violation_Ratio(3, O_period), Norm_Shortfall(3, O_period), bertest(3, O_period), 1-chi2cdf(bertest(3, O_period),1),...
        indtest(3, O_period),1-chi2cdf(indtest(3, O_period),1);...
        O_period, Violation_Ratio(4, O_period), Norm_Shortfall(4, O_period) , bertest(4, O_period),1-chi2cdf(bertest(4, O_period),1),...
        indtest(4, O_period), 1-chi2cdf(indtest(4, O_period),1)] );
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Data = [Historical_OB -Approach_1_VaR(:,O_period) -Approach_2_VaR(:,O_period)  -Approach_3_VaR(:,O_period) -Approach_4_VaR(:,O_period)];
    FifthTimeseries = fints(Dates, Data, {'HistoricalReturns',...
    'ScaledVaR', 'NonoverlappingVaR','OverlappingAdjustedVaR', 'OverlappingFiteredVaR'}, 0, 'Back testing 10-day VaR' );
    figure(O_period+6)
    plot(FifthTimeseries);
    xlabel('Date');
    ylabel('10-Day Returns');
    title('10-Day VaR Back Testing');
    colormap(jet);
    
end