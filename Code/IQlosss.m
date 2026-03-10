%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: 
% 
% Year:
%
% Author: 
%
% Affiliation: 
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all; close all; clc;

% Example code for estimating potential IQ loss related to sleep loss
% SSP585, 2100s, China

%R = normrnd(MU,SIGMA,m,n);

iqloss = zeros(4);

load("/share/home/Pop/Data/2/SSP5_2100_child.mat");
pop(pop ==0) = nan;

% parameters
mu;
sigma;
sleeploss_year_pop_1d;
IQ; 
r;

% parameters that we want to obtain
iqloss;


if isnan(pop)
    iqloss(:) = NaN;

else 
d1 = normrnd(0,1,round(pop),1);  
d2 = normrnd(mu,sigma,round(pop),1);  %
d2_lost = d2-(sleeploss_year_pop_1d)/365;

xx = polyfit(d2,d1,1);
y1 = normalize(d2)*r + normalize(d1-(d2*xx(1)+xx(2)))*sqrt(1-r*r);

IQ1=y1*IQ(2)+IQ(1);   %IQ average & SD 
% chn 10.69  104.35


if isnan(IQ1) 
    iqloss(:) = NaN;

else

xx2 = polyfit(d2,IQ1,1);


IQ1_lost=IQ1-(d2-d2_lost)*xx2(1);

%mean(IQ1_lost);std(IQ1_lost)

[A1,A2,A3,A4] = ttest2(IQ1,IQ1_lost);

%mean(A3)
iqloss(1) = mean(A3);
iqloss(2) = A3(1);
iqloss(3) = A3(2);
iqloss(4) = A2;

end
end







