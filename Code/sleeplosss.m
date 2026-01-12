%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: 
% 
% Year:
%
% Author: 
%
% Affiliation: 
%



clear all; close all; clc;

% Example code for estimating potential climate-related sleep loss
% SSP585, 2100s, ukesm1-0-ll (global climate model), China
% Set path and year range

PATH = "/share/home/ISIMIP/Data/2/";
years = 2091:2100;
num_years = length(years);


% Load region mask and population data
load("/share/home/Pop/Data/1/Land_line_region.mat"); %land1
load("/share/home/Pop/Data/1/SSP5_2100_0.5.mat");

%tmin_gfdl_ssp585_2050 = ncread("ukesm1-0-ll_r1i1p1f2_w5e5_ssp585_tasmin_global_daily_2041_2050.nc","tasmin");

tmin = ncread("ukesm1-0-ll_r1i1p1f2_w5e5_ssp585_tasmin_global_daily_2091_2100.nc","tasmin");

in = land1(:,:,10)/10; %1~200  ~200 countries or regions, here select CHN (number 10)
%land = land1(:,:,10) %china
%popchn  = single(pop).*land/10;

% tmin = ncread(filename, 't2m');
        
    % Ensure correct dimensions (365 or 366 days, handle leap years)
    [rows, cols, days] = size(tmin);
 
    % Sleep loss calculation (consistent with original logic)
    tmin_10 = ones(rows, cols, days, "single") * 283.15;  % 10°C
    tmin_knot = tmin - tmin_10;
    tmin_a = tmin_knot < 0;
    sleeploss = -(0.618) * not(tmin_a) .* tmin_knot;
        
    % Spatial population weighting
    sleeploss_ = sum(sleeploss, 3) .* in /10; % average per year
    sleeploss_(sleeploss_ == 0) = nan;
        
    pop_chn = in .* single(pop);
   
    pop_chn(pop_chn == 0) = nan;
        
    sleeploss_pop = sleeploss_ .* pop_chn;
       
    %m2 = sleeploss_pop;
    %m2(m2 < 0) = 1;
    %sleeploss_year = nansum(sleeploss_pop .* m2, "all") / nansum(pop_chn .* m2, "all");
    sleeploss_year_pop = nansum(sleeploss_pop, "all") / nansum(pop_chn, "all");


save('sleeploss_results_ukesm1-0-ll_2100_ssp585_chn.mat', "sleeploss_year_pop");
