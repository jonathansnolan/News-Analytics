%% 
clear;
SPX = xlsread('SPX_Historical_Last_Prices.xlsx',1,'A:B','basic'); % load S&P500 data into matlab
returns = price2ret(SPX(:,2)); % convert last prices to returns
returns = log(1+returns); % convert returns to log-returns
dates = SPX(:,1); % create an array of dates
dates = x2mdate(dates,0); % convert dates from excel format to matlab
datarange = 4321; % set number of days used for VaR estimations and backtesting
% modify returns and dates arrays to use only the 
% specified number of dates:
returns = returns(length(returns)-datarange+1:end); 
dates = dates(length(dates)-datarange+1:end);
h=10; % number of days for which VaR is estimated
WE=500; % Estimation window size
WT=length(returns)-WE-9; % Testing window size
p=0.01; % Confidence level for VaR
%% 
% Approach 1%
VaR1 = NaN(1,WT); %initialize a vector of VaRs for the 1st approach
ES1 = NaN (1,WT); %initialize a vector of ESs for the 1st approach
for i = 1:WT
    mu = mean(returns(i:WE+i-1));
    std0 = std(returns(i:WE+i-1));
    ys1 = sort(returns(i:WE+i-1)); % sort returns
    op = floor(WE*p); % p % smallest
    VaR1 (i) = -ys1(op)*sqrt(h); % find VaR as a "p" quantile of sorted returns distribution
    ES1(i) = -mean(ys1(1:op))*sqrt(h); %find ES
end
%% 
% Approach 2 %                                              
VaR2 = NaN (1,WT); % initialize a vector of VaRs for the 2nd approach
ES2= NaN (1,WT); % initialize a vector of ESs for the 2nd approach
A = NaN(1, floor(WE/h)); % Initialize a vector for 10-day returns
T1=length(A);
for j = 1:WT
for i = 1:floor(WE/h)
    A(i)= sum (returns((h*(i-1)+j):(h*i+j-1))); %Calculate 10-day returns for each non-overlapping period
end
    ys2=sort(A); %sort 10-day returns in ascending order
    if T1*p >=1
        op1 = floor(T1*p); %Find the index number of p% smallest return
    else
        op1 = 1; %If there are not enough observations in the estimation window, set the number to 1
    end
    VaR2 (j)= -ys2(op1); %Find VaR values for the 2nd approach
    ES2 (j) = -mean(ys2(1:op1)); %Find ES values for the 2nd approach
end
%% 
% Approach 3 %
VaR31 = NaN (1,WT); %initialize a vector of VaRs for the 3rd approach
ES3 = NaN (1,WT); %initialize a vector of ESs for the 3rd approach
NumSimulations = 30000; %set a number of monte-carlo simulations for the filtering
epsi = NaN(1,WE); %initialize a vector of innovations
sigma = NaN(1,WE); %initialize a vector of conditional volatilities from GARCH estimation
for i = 1:WT 
    
    Mdl = gjr(1,1); %Create a GJR-GARCH model
    Mdlest= estimate(Mdl, returns(i:WE+i-1), 'E0', returns(i), 'Display', 'off'); %Estimate coefficients of a GARCH model
%     if isempty(Mdlest.GARCH) == 0
%     GARCHe(i) = cell2mat(Mdlest.GARCH);
%     else 
%         GARCHe(i) = 0;
%     end
    sigma = sqrt(infer(Mdlest, returns(i:WE+i-1))); %calculate conditional variances from a GARCH model
    epsi = returns(i:WE+i-1)./sigma; %Estimate standardized innovations
    btr = epsi (unidrnd (WE, h, NumSimulations)); %Create an hxNumSimulations matrix of random permutations of innovations
    [V,Y] = filter (Mdlest, btr, 'Z0', epsi(end), 'V0', sigma(WE)^2); %Run filtered historical simulation with "h" steps
    Y10d = sum(Y,1); %Find 10-day returns
    ys3 = sort (Y10d); %sort 10-day returns in ascending order
    op3 = floor(NumSimulations*p);
    VaR3 (i) = -ys3(floor(op3));
    ES3 (i) = -mean(ys3(1:op3));
end
%% 
% Comparison of approaches %
ret10d = NaN (1, WT); % initialize an array for historical 10 day returns
for i = 1:WT
    ret10d(i)=sum(returns(WE+i:WE+i+9)); % calculate historical 10 day returns
end
for i = 1:length(returns)-9
    std1(i) = std(returns(i:i+9));
end
testdates = dates(end-WT-8:end-9);
figure (1);
plot (fints(testdates, transpose(ret10d)))
hold on
plot (fints(testdates, transpose(-VaR1)))
hold on
plot (fints(testdates, transpose(-VaR2)))
hold on
plot (fints(testdates, transpose(-VaR3)))
hold off 
xlabel('days')
ylabel('returns')
legend('returns','scaled VaR', 'Non-Overlapping periods VaR', 'Overlapping periods VaR')
title('Comparison of VaR estimations')

figure (2);
plot (fints(testdates, transpose(ret10d)))
hold on
plot (fints(testdates, transpose(-ES1)))
hold on
plot (fints(testdates, transpose(-ES2)))
hold on
plot (fints(testdates, transpose(-ES3)))
hold off 
xlabel('days')
ylabel('returns')
legend('returns','scaled ES', 'Non-Overlapping periods ES', 'Overlapping periods ES')
title('Comparison of ES estimations')

figure (3);
plot(fints(dates(1:end-9),transpose(std1)))
hold off
xlabel('date')
ylabel('10-day volatility')
title('10-day volatility for S&P 500 from 7 Feb 1990 to 24-Feb 2017')
legend ('off')


EV = p*WT;
q1 = find(ret10d<-VaR1);
v1 = VaR1*0;
v1(q1) = 1;
ber1 = bern_test(p,v1);
disp([ber1,1-chi2cdf(ber1,1)])
VR1 = length(q1)/EV;
nES1 = mean(ret10d(q1) ./-ES1(q1)); 
q2 = find(ret10d<-VaR2);
v2 = VaR2*0;
v2(q2) = 1;
ber2 = bern_test(p,v2);
disp([ber2,1-chi2cdf(ber2,1)])
VR2 = length(q2)/EV;
nES2 = mean(ret10d(q2) ./-ES2(q2)); 
q3 = find(ret10d<-VaR3);
v3 = VaR3*0;
v3(q3) = 1;
ber3 = bern_test(p,v3);
disp([ber3,1-chi2cdf(ber3,1)])
VR3 = length(q3)/EV;
nES3 = mean(ret10d(q3) ./-ES3(q3)); 
