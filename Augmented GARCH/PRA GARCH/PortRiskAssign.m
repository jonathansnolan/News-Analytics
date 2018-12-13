%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                     %
% Robin Bogan - 16106636                                              %
% Portfolio Risk Analysis (FI6012) - Technical Assignment             %
%                                                                     %
% This code uses historical data to calculate the 10-day VaR and ES   %
% of an equity portfolio using 3 different approaches:                %
%   1. 1-day Var/ES scaled to 10-day using sqrt(time)                 %
%   2. Non-overlapping 10-day periods                                 %
%   3. Overlapping 10 day periods and filtered historical simulation  %
%                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Clear workspace of old values before running
clear

% User input: VaR/ES calculation parameters
alpha = 0.01;     % Significance level
h = 10;           % Risk horizon
n = 10;           % Number of years of past data to be analysed
start = 0;        % Years back from 17/02/2017 that the data starts
prop = 1/5;      % Proportion of estimation window/total window
daysinyear = 250; % Number of days in a year

% Import equity portfolio data, calculate returns and dimensions needed 
% for initlising arrays.
%raw_data = xlsread('SPX_VIX_1990_2017_daily.xlsx');
SPX = xlsread('SPX_Historical_Last_Prices.xlsx',1, 'A:B','basic');

start_date = 1 + (start*daysinyear);
trim_data = raw_data(start_date:start_date+(daysinyear*n),1);
clear raw_data
trim_data = flipud(trim_data);
data = price2ret(trim_data);
[samp_size,dummy] = size(data);
est = ceil(n*daysinyear*prop);
test = samp_size - est;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Approach 1: 1-day Var/ES scaled to h-day using sqrt(h)              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Intialise larger arrays
VaR_ap1 = zeros(test,1);
ES_ap1 = zeros(test,1);
Test_10_day_ret = zeros(test-(h-1),1);

% Loop thru estimation window and calculate VaR/ES for test window
for k = est+1:samp_size

    % Define estimation window
    k1 = k-est;
    window = data(k1:k-1);
    sort_window = sort(window);
    
    % Sort in descending order and use bottom alpha% as VaR
    op=floor(est*alpha);
    if op == 0; op = 1; end % Use lowest return if op=0
    VaR=sort_window(op);
    ES = mean(sort_window(1:op));
    VaR_ap1(k)= -VaR*sqrt(h);
    ES_ap1(k) = -ES*sqrt(h);
    
    % Calculate 10 day returns for test window (needed in output)
    if k < samp_size-h+1
        Test_10_day_ret(k) = sum(data(k:k+h-1));
    end
end

% Count number of exceedences. Calculate violation ratio & std dev
ExE_ap1=length(find(Test_10_day_ret(est+1:samp_size-h)<...
    -ES_ap1(est+1:samp_size-h)));
ExV_ap1=length(find(Test_10_day_ret(est+1:samp_size-h)<-...
    VaR_ap1(est+1:samp_size-h)));
Viol_V1 = ExV_ap1/(test*alpha);
Std_VaR1 = std(VaR_ap1(est+1:samp_size));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Approach 2: Non-overlapping h-day periods                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialise larger arrays
VaR_ap2 = zeros(test,1);
ES_ap2 = zeros(test,1);
ten_day_ret = zeros(floor(est/h),1);

% Loop thru calibation set and calculate VaR/ES for test window
for k = est+1:samp_size
    
    % Define estimation window
    k1 = k-est;
    window = data(k1:k-1);
    
    % Sum non-overlapping 10-day periods
    for j = 1:floor(est/h)
        ten_day_ret(j) = sum(window(1+((j-1)*h):j*h));
    end
    
    % Sort 10-day returns in descending order and get alpha percentile
    ten_day_ret = sort(ten_day_ret);
    op=floor(est*alpha/h);
    if op == 0; op = 1; end % Use lowest return if op=0
    VaR=ten_day_ret(op);
    ES = mean(ten_day_ret(1:op));
    
    VaR_ap2(k)= -VaR;
    ES_ap2(k) = -ES;
end

% Count number of exceedences. Calculate violation ratio & std dev
ExE_ap2=length(find(Test_10_day_ret(est+1:samp_size-h)<...
    -ES_ap2(est+1:samp_size-h)));
ExV_ap2=length(find(Test_10_day_ret(est+1:samp_size-h)<...
    -VaR_ap2(est+1:samp_size-h)));
Viol_V2 = ExV_ap2/(test*alpha);
Std_VaR2 = std(VaR_ap2(est+1:samp_size));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Approach 3: Overlapping h-day periods w/ filtered historical data  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Intialise larger arrays
VaR_ap3 = zeros(test,1);
ES_ap3 = zeros(test,1);
ten_day_ret = zeros(est-h+1,1);
filt_returns = zeros(samp_size,1);
CVol = zeros(est,1);

% Set GARCH model 
Mdl=garch(1,1);

% Loop thru calibation set and calculate VaR/ES for test window
for k = est+1:samp_size

    % Define estimation window
    k1 = k-est;
    window = data(k1:k-1);
    
    % Fit GARCH(1,1) to estimation window
    EstMdl=estimate(Mdl,window(2:end),'E0',window(1),...
        'Display','off');
%     omega = EstMdl.Constant;
%     GAR_aplha = cell2mat(EstMdl.ARCH);
%     GAR_beta = cell2mat(EstMdl.GARCH);
%     
%     % Initial values for CVol and Epsilon
%      Vool = (std(window))^2;
%      eps = window(1)-mean(window);
%     
%     % Calculate the conditional volatility for filtering returns
%     for j = 2:est
%         CVol(j) = sqrt(omega + (GAR_aplha*epsilon(j-1)^2) + ...
%             (GAR_beta*CVol(j-1)^2));
%         epsilon(j) = window(j)/CVol(j);
%     end
    
    % Infer conditional variances from estimation window
    CVol = sqrt(infer(EstMdl,window));
    
    % Filter returs
    filt_returns = window.*(CVol(end)./CVol);
    
    % Sum overlapping 10-day filtered returns
    for j = 1:est-h+1
        ten_day_ret(j) = sum(filt_returns(j:h+j-1));
    end
    
    % Sort ten-day returns in descending and get alpha percentile
    ten_day_ret = sort(ten_day_ret);
    op=floor((est-h+1)*alpha);
    if op == 0; op = 1; end % Use lowest return if op=0
    VaR=ten_day_ret(op);
    ES = mean(ten_day_ret(1:op));
    
    VaR_ap3(k)= -VaR;
    ES_ap3(k) = -ES;
    
end

% Count number of exceedences. Calculate violation artio & std dev
ExE_ap3=length(find(Test_10_day_ret(est+1:samp_size-h)<...
    -ES_ap3(est+1:samp_size-h)));
ExV_ap3=length(find(Test_10_day_ret(est+1:samp_size-h)<...
    -VaR_ap3(est+1:samp_size-h)));
Viol_V3 = ExV_ap3/(test*alpha);
Std_VaR3 = std(VaR_ap3(est+1:samp_size));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs: Graphs, tables, etc.                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Graph return distribution for approach 1
 figure(1);
 histfit(data,200);
 title('Histogram of log returns');
 xlabel('Log Returns');ylabel('Frequency');
% hold all;
% Y = plot(VaR,0,'x','MarkerSize', 15,'color',[0 1 0]);
% text(VaR,2.5,'1-day VaR \rightarrow','Rotation',-45,...
%     'VerticalAlignment','top','HorizontalAlignment','right');
% U = plot(ES,0,'x','MarkerSize', 15,'color',[0 1 1]);
% text(ES,2.5,'1-day ES \rightarrow','Rotation',-45,...
%     'VerticalAlignment','top','HorizontalAlignment','right');
% legend([Y U],['1-day VaR = ' num2str(VaR)],...
%     ['1-day ES = ' num2str(ES)],'Location','northwest');
 hold off;

% QQ Plot for normality test
figure(2);
qqplot(data);
title('QQ Plot of log returns');
ar = archtest(data); % 1 means ARCH properties present
hold off;

% Check suitability of GARCH
figure(3);
autocorr(data.^2);
title('Autocorrelation of returns^2');
hold off;
 
% Compare 10-day VaR for different apporaches
figure(4)
A = plot(-VaR_ap1(est+1:samp_size),'color', [0 0 1]);
hold on
B = plot(-VaR_ap2(est+1:samp_size),'color', [0 1 0]);
hold on
C = plot(-VaR_ap3(est+1:samp_size),'color', [1 0 0]);
hold on
D = plot(Test_10_day_ret(est+1:samp_size-h),'color', [1 0 1]);
hold on
title('Comparison of 10-day VaR');
xlabel('Test Window Time');ylabel('10-day VaR');
legend([A B C D],'Approach 1','Approach 2','Approach 3','Returns',...
    'Location','northwest');
hold off;

% Compare 10-day ES for different apporaches
figure(5)
A = plot(ES_ap1(est+1:samp_size),'color', [0 0 1]);
hold on
B = plot(ES_ap2(est+1:samp_size),'color', [0 1 0]);
hold on
C = plot(ES_ap3(est+1:samp_size),'color', [1 0 0]);
hold on
title('Comparison of 10-day ES');
xlabel('Test Window Time');ylabel('10-day ES');
legend([A B C],'Approach 1','Approach 2','Approach 3',...
    'Location','northwest');
hold off;

figure(6)
plot(data(1:est),'color', [1 0 1]);
title('Estimation Window Returns');
hold off