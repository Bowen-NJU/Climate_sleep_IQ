clear all; close all; clc;

% Example code for estimating potential IQ loss related with sleep loss
% SSP585, 2100s, ukesm1-0-ll (global climate model), China

%R = normrnd(MU,SIGMA,m,n);
%iqloss = zeros(209,6,4);
%%%%%have a  region in row 148, notice
%pop(148,:) = [];
%IQ(148,:) = [];
%sleeploss(148,:) = [];

load("/share/home/Pop/Data/2/SSP5_2100_child.mat");
pop(pop ==0) = nan;

% parameters
mu;
sigma;
sleeploss_year_pop_1d;
IQ; 
r;

iqloss;



for j = 1:6
    for i =1:209
if isnan(pop(i,j))
    iqloss(i,j,:) = NaN;
    continue
end
d1 = normrnd(0,1,round(pop(i,j)),1);  %0.05*1.96 - 1 =  0.902   0.098
d2 = normrnd(mu9.2,sigma0.816,round(pop(i,j)),1);  %take integer %sleep time decrease by 10%
d2_lost = d2-(sleeploss_year_pop_1d)/365;

r  = 0.15;  %r=0.15, 95% [0.06,0.24],
xx = polyfit(d2,d1,1);
y1 = normalize(d2)*r + normalize(d1-(d2*xx(1)+xx(2)))*sqrt(1-r*r);

IQ1=y1*IQ(2)+IQ(1);   %IQ average & SD 
% chn 10.69  104.35

%corrcoef(d2,IQ1)
if isnan(IQ1) 
    iqloss(i,j,:) = NaN;
else
xx2 = polyfit(d2,IQ1,1);
%a = polyval(xx2,d2);
%figure
%plot(d2,IQ1,'o')
%hold on
%plot(d2,a)

IQ1_lost=IQ1-(d2-d2_lost)*xx2(1);
%IQ1_lost=IQ1-(d2-d2_lost)*mean(IQ1)/mean(d2);

%mean(IQ1_lost);std(IQ1_lost)
%corrcoef(d2_lost,IQ1_lost)
[A1,A2,A3,A4] = ttest2(IQ1,IQ1_lost);
%[A1,A2,A3] = kstest2(IQ1,IQ1_lost);

%mean(A3)
iqloss(1) = mean(A3);
iqloss(2) = A3(1);
iqloss(3) = A3(2);
iqloss(4) = A2;

end
end
    end
aaa = iqloss(:,:,1);

%sample  = zeros(1000,1000);
%for i = 1:1000
%sample(:,i) = randsample(p,sample,true); 
 %prctile
%histogram(IQ1_lost)
%hold on
%histogram(IQ1,"FACEALPHA",0.3)