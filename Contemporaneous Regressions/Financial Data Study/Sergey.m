%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Jonathan Nolan
% Sergey Test Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1. Clear workspace of past values before running code 
clc
clear

%% 2. Load the Data
GE = xlsread('AZNnew.L.xlsx',1, 'A:B','basic'); 


%% 3. Get the Descriptive Statistics of General Electric Company Stock Market CLosing Daily Prices

%%
% 3.1 Average Closing Prices
TEST = GE;
TEST(:,1) = [];
%%
%J = cell2num(TEST)
%%
AveragePrices = nanmean(TEST);

%%
% 3.2 Standard Deviation
StdDevPrices = nanstd(TEST);

%%
% 3.3  Min Prices
MinPrices = min(TEST);

%%
% 3.4 Max Prices
MaxPrices = max(TEST);

%% 4. Calculate  the daily returns from the prices 
Rtns = 100*diff(log(GE(:,2)));

%% 5. Get the Descriptive Statistics of General Electric Company Stock Market Daily Returns

%%
% 5.1 Average Closing Prices
TEST = Rtns;
AverageRet = nanmean(TEST);

%%
% 5.2 Standard Deviation
StdDevRet = nanstd(TEST);

%%
% 5.3  Min Prices
MinRet = min(TEST);

%%
% 5.4 Max Prices
MaxRet = max(TEST);

%%
KurtRet = num2str(kurtosis(TEST));

%%
skewRet = num2str(skewness(TEST));
%%
% THESE ARE LI's AND MINE OLD PARAMETERS
% TAKEN FROM THE PORTFOLIO RISK ANALYSIS 
% ASSIGNMENT


%Initialise Parameters 

%alpha = 0.01;               % significance level 
%H_1 = 1;                    % 1-day risk horizon 
%H_2 = 10;                   % 10-day risk horizon 
%Scale_Factor = sqrt(H_2);   % square root of time 
%value = 1;                  % portfolio value

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%4. Calculate these values 
%Mod_Returns = mod(length(Rtns), 746);            %Modulo returns 
%length_sample = length(Rtns) - Mod_Returns + 9;  %Sample Length 
%Returns = Rtns(end-length_sample+1 : end);       %Returns 
%Dates = GE(end-length_sample+1:end, 1);          %Dates 
%Number_of_Dates = x2mdate(Dates, 0);             %Converts date number to matlab serial date 
%Sample_GE = GE(end-length_sample+1:end,2);       %sample size 

%%
%4. Calculate these values 
Mod_Returns = (length(Rtns));            %Modulo returns 
length_sample = length(Rtns);  %Sample Length 
Returns = Rtns;       %Returns 
Dates = GE(2:end, 1);          %Dates 
Number_of_Dates = x2mdate(Dates, 0);             %Converts date number to matlab serial date 
Sample_GE = GE(2:end,2);       %sample size 


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5. Data Analysis and Pretesting 
%FirstTimeseries = fints(Number_of_Dates, Sample_GE, {'Historical'}, 0, 'GE_index' ); 
%SecondTimeseries = fints(Number_of_Dates, Returns, {'Returns'}, 0, 'GE_returns' );

%-------------------------------------------------------------------------
%Edited
FirstTimeseries = fints(Number_of_Dates, Sample_GE, {'Historical'}, 0, 'GE_index' ); 
SecondTimeseries = fints(Number_of_Dates, Returns, {'Returns'}, 0, 'GE_returns' );


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 6. Graphs 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 6.1 Comparison of Historical AZN Returns with Index figure(1) 
subplot(2, 1, 2); 
x = plot(FirstTimeseries); 
set(x(1), 'color', 'blue'); 
xlabel('Date');
ylabel('Historical AstraZeneca Index'); 
title('AstraZeneca Index') 
subplot(2,1,1); 
plot(SecondTimeseries); 
xlabel('Date');
ylabel('Historical AstraZeneca Returns'); 
title('AstraZeneca Returns'); 

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 6.2 Create Histograms for Returns Data 
% Plot histogram of daily Optimized Portfolio Daily Returns 
figure (2) 
histfit(Returns, 500) 
title('Histogram of AstraZeneca Histroical Daily Returns') 
xlabel('Historical Daily Returns') 
ylabel('Frequency') 
string_1 = {'Mean Return:' ,num2str(nanmean(Returns)),...
    'Kurtosis:' ,num2str(kurtosis(Returns)),...
    'Skewness: ' ,num2str(skewness(Returns))}; 
annotation('textbox', [0.6,0.7,0.055,0.21],'String', string_1); 
Histogram_Kurtosis = kurtosis(Returns); 

%%3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 6.3 QQplot Comparison of Daily Returns versus Standard Normal 
figure(3) 
qqplot(Returns); 
xlabel('Standard Normal Quantiles'); 
ylabel('Quantiles of AstraZeneca Daily Returns'); 
title('AstraZeneca Daily Returns VS Standard Normal') 

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 6.4 Autocorrelation Test 
figure(4) 
subplot(1, 2, 2) 
autocorr(Returns); 
title('Daily Returns Autocorrelation Test'); 
subplot(1, 2, 1) 
autocorr(Returns.^2); 
title('Squared Returns Autocorrelation Test');


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 7. Calculate the following: 
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

%%
% 8. Graph of 10-Day Historical Returns Versus 10-day period Volatilities 
figure(5) 
subplot(2, 1, 2); 
y = plot(ThirdTimeseries); 
set(y(1), 'color', 'blue'); 
xlabel('Date');
ylabel('10-Day Historical Returns'); 
title('10-Day Historical Returns') 
subplot(2,1,1); 
plot(FourthTimeseries); 
xlabel('Date');
ylabel('Volatility'); 
title('10-Day period Volatilities');

%%

% 9. Graph comparing the returns versus the 10-day returns 
figure(6) 
subplot(2, 1, 2); 
y = plot(ThirdTimeseries); 
set(y(1), 'color', 'blue'); 
xlabel('Date');
ylabel('10-Day Historical Returns'); 
title('10-Day Historical Returns') 
subplot(2,1,1); 
plot(SecondTimeseries); 
xlabel('Date');
ylabel('Historical GE Returns'); 
title('GE Returns');

%%
% 10. Calculate the following: 
% 21-day historical returns 
% 21-day period daily volatilities 

TwentyOne_day_returns = zeros(length_sample-20, 1); 
Volatility = zeros(length_sample-20, 1); 
for i = 1: length_sample-20 
    TwentyOne_day_returns(i,1) = sum(Returns(i:i+20)); 
    Volatility(i,1) = std(Returns(i:i+20)); 
end

TwentyOne_day_date = Number_of_Dates(21:length_sample); 
FifthTimeseries = fints(TwentyOne_day_date, TwentyOne_day_returns,{'TwentyOneDayHistoricalReturns'},0,...
    'TwentyOneDayReturns' ); 
SixthTimeseries = fints(TwentyOne_day_date, Volatility, {'Volatility'},0, 'TwentyOneDayVolatilities' );


%%
% 11. Graph of 21-Day Historical Returns Versus 21-day period Volatilities 
figure(7) 
%subplot(2, 1, 2); 
%y = plot(FifthTimeseries); 
%set(y(1), 'color', 'blue'); 
%xlabel('Date');
%ylabel('21-Day Historical Returns'); 
%title('21-Day Historical Returns') 
%subplot(2,1,1); 
plot(SixthTimeseries); 
xlabel('Date');
ylabel('Volatility'); 
title('21-Day period Volatilities');


%%

% 12. Graph comparing the returns versus the 21-day returns 
figure(8) 
%subplot(2, 1, 2); 
y = plot(FifthTimeseries); 
set(y(1), 'color', 'blue'); 
xlabel('Date');
ylabel('21-Day Historical Returns'); 
title('21-Day Historical Returns') 
%subplot(2,1,1); 
%plot(SecondTimeseries); 
%xlabel('Date');
%ylabel('Historical GE Returns'); 
%title('GE Returns');
%%






