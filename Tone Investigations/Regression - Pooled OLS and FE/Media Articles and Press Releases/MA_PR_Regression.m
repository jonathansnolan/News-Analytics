%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Jonathan Nolan
% NOTE:
% Function of this code will be to calculate the Pooled OLS,
% And Fixed Effects Regressions of the MA Tone and PR Tone
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%---------------------------------------------------------
% 1. Clear any Previous Work
clear;
clc;
%%
% 2. Load your data set
Data = xlsread('Data.xlsx',1, 'A:I','basic'); 


%---------------------------------------------------------
% 3. Set your Dependent and Independent Variables
% NOTE:
% Dependent Variable : Media Article Average Tone
% Independent Variable: Press Releases Average Tone

y = Data(:,[6, 5]);


%---------------------------------------------------------
% 4. Set your Index
% NOTE:
% In this case it will be the Company Name
ID = Data(:,3);

%---------------------------------------------------------
% 5. Set your variable names
vnames =  ['M',		% Media Tone 
          'P'];     % Press Release     
%%
x = Data(:,[8,9]); 

%%

%---------------------------------------------------------
% 6. Pooled Estimation
results = ppooled(y);
prt_panel(results,vnames)
%%
%---------------------------------------------------------
% 7. Fixed Effects Estimation
result1 = pfixed(y,ID);
prt_panel(result1,vnames);

%%
% Random Effects Estimation
result2 = prandom(y,ID);
prt_panel(result2,vnames);
%%
phaussman(result1, result2);






