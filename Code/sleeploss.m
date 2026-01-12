clear all; close all; clc;

% Example code for estimating potential climate-related sleep loss
% SSP585, 2100s, ukesm1-0-ll (global climate model), China
% Set path and year range
PATH = "/share/home/ISIMIP/Data/2/";
years = 2091:2100;
num_years = length(years);

% Pre-allocate arrays for storing results
sleeploss_year_all = zeros(1, num_years);
ratio_all = zeros(4, 4, num_years);

% Load region mask and population data
load("/share/home/Pop/Data/1/Land_line_region.mat"); %land1
load("/share/home/Pop/Data/1/SSP5_2100_0.5.mat");

tmin_gfdl_ssp585_2050 = ncread("ukesm1-0-ll_r1i1p1f2_w5e5_ssp585_tasmin_global_daily_2041_2050.nc","tasmin");
tmin = ncread("ukesm1-0-ll_r1i1p1f2_w5e5_ssp585_tasmin_global_daily_2091_2100.nc","tasmin");

in = land1(:,:,10)/10; %1~200  ~200 countries or regions, here select CHN (number 10)
%land = land1(:,:,10) %china
%popchn  = single(pop).*land/10;

% Main loop: process data for each year
for y = 1:num_years
    year = years(y);
    fprintf('Processing year %d...\n', year);
    
    % Read yearly data
    filename = fullfile(PATH, sprintf('era5_tmin_%d.nc', year));
    
    tmin = ncread(filename, 't2m');
        
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
   % pop_uk = round(pop_uk, 2);
    pop_chn(pop_chn == 0) = nan;
        
    sleeploss_pop = sleeploss_ .* pop_chn;
       
    %m2 = sleeploss_pop;
    %m2(m2 < 0) = 1;
    %sleeploss_year = nansum(sleeploss_pop .* m2, "all") / nansum(pop_chn .* m2, "all");
    sleeploss_year_pop = nansum(sleeploss_pop, "all") / nansum(pop_chn, "all");

    % Simulate sleep duration distribution (consistent with original logic)
    num = normrnd(7.034, 1.074, 62366, 1);
        
    ratio_ = zeros(4, 4);
    ratio_(1, 1) = sum(num < 6);
    ratio_(2, 1) = sum(num < 7);
    ratio_(4, 1) = sum(num > 9);
    ratio_(3, 1) = length(num) - ratio_(4, 1) - ratio_(2, 1);
    ratio_(2, 1) = ratio_(2, 1) - ratio_(1, 1);
        
    num2 = num - sleeploss_year_pop / days / 60;

    ratio_(1, 2) = sum(num2 < 6);
    ratio_(2, 2) = sum(num2 < 7);
    ratio_(4, 2) = sum(num2 > 9);
    ratio_(3, 2) = length(num2) - ratio_(4, 2) - ratio_(2, 2);
    ratio_(2, 2) = ratio_(2, 2) - ratio_(1, 2);

    ratio_ = ratio_ / length(num);
    ratio_(:, 3) = ratio_(:, 2) - ratio_(:, 1);

    % Apply health risk coefficients
    ratio_(1, 4) = ratio_(1, 3) * 0.03099;
    ratio_(2, 4) = ratio_(2, 3) * 0.01587;
    ratio_(4, 4) = ratio_(4, 3) * 0.01610;

    % Save yearly results
    sleeploss_year_all(y) = sleeploss_year_pop;
    ratio_all(:, :, y) = ratio_;
        
    fprintf('Year %d processed successfully.\n', year);

end

save('sleep_loss_results_2011-2023.mat', 'years', 'sleeploss_year_all', 'ratio_all');
