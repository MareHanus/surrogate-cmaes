%% PPSN 2016 article plots
% Script for making graphs showing the dependence of minimal function
% values on the number of function values and graphs showing the speed up
% of GP DTS-CMA-ES.
% 
% Created for PPSN 2016 article.

%% load data

% path settings
exppath = fullfile('exp', 'experiments');

sd2_r10_20_path = fullfile(exppath, 'exp_restrEC_04');
sd2_r05_40_path = fullfile(exppath, 'exp_doubleEC_01_restr05_40');
sd2_r05_2pop_path = fullfile(exppath, 'exp_restrEC_04_2pop');
sd2_r10_2pop_path = fullfile(exppath, 'exp_doubleEC_01_2pop');
sd2_r20_40_2pop_path = fullfile(exppath, 'exp_doubleEC_01_2pop_restr20_40');
sd2_path20D = fullfile(exppath, 'exp_doubleEC_01_20D');

ei_poi_lcb_path = fullfile(exppath, 'exp_doubleEC_01_ei_poi_lcb');
ei_poi_lcb_path20D = fullfile(exppath, 'exp_doubleEC_01_ei_poi_lcb_20D');

gen_path = fullfile(exppath, 'exp_geneEC_10');
gen_path20D = fullfile(exppath, 'exp_geneEC_10_20D');

cmaespath = fullfile(ei_poi_lcb_path, 'cmaes_results');
cmaespath20D = fullfile(ei_poi_lcb_path20D, 'cmaes_results');

saacmes_path = fullfile(exppath, 'saACMES');
smac_path = fullfile(exppath, 'SMAC');

% folder for results
plotResultsFolder = '/tmp';

% needed function and dimension settings
funcSet.BBfunc = 1:24;
funcSet.dims = [2, 3, 5, 10];

% loading data
[sd2_r10_20_evals, sd2_r10_20_settings] = dataReady(sd2_r10_20_path, funcSet);
[sd2_r05_40_evals, sd2_r05_40_settings] = dataReady(sd2_r05_40_path, funcSet);
[sd2_r05_2pop_evals, sd2_r05_2pop_settings] = dataReady(sd2_r05_2pop_path, funcSet);
[sd2_r10_2pop_evals, sd2_r10_2pop_settings] = dataReady(sd2_r10_2pop_path, funcSet);
[sd2_r20_40_2pop_evals, sd2_r20_40_2pop_settings] = dataReady(sd2_r20_40_2pop_path, funcSet);

[ei_poi_lcb_evals, ei_poi_lcb_settings] = dataReady(ei_poi_lcb_path, funcSet);

[gen_evals, gen_settings] = dataReady(gen_path, funcSet);

% concatenate cmaes
cmaes_evals = dataReady(cmaespath, funcSet);
for f = 1:size(cmaes_evals, 1)
  for d = 1:size(cmaes_evals, 2)
    notEmptyId = ~cellfun(@isempty, cmaes_evals(f, d, :));
    cmaes_evals{f,d,1} = cmaes_evals{f, d, notEmptyId};
  end
end
cmaes_evals = cmaes_evals(:, :, 1);

funcSet.dims = 20;
[sd2_evals_20D, sd2_settings_20D] = dataReady(sd2_path20D, funcSet);
[ei_poi_lcb_evals_20D, ei_poi_lcb_settings_20D] = dataReady(ei_poi_lcb_path20D, funcSet);
[gen_evals_20D, gen_settings_20D] = dataReady(gen_path20D, funcSet);
cmaes_evals_20D = dataReady(cmaespath20D, funcSet); 

funcSet.dims = [2, 3, 5, 10, 20];
saacmes_evals = bbobDataReady(saacmes_path, funcSet);
smac_evals = readSMACResults(smac_path, funcSet);

% finding data indexes
set.modelType = 'gp';
set.modelOpts.normalizeY = true;
set.evoControlModelGenerations = 5;
genId = getStructIndex(gen_settings, set);
genId20D = getStructIndex(gen_settings_20D, set);

set = rmfield(set, 'evoControlModelGenerations');
set.evoControlRestrictedParam = 0.1;
set.PopSize = '(4 + floor(3*log(N)))';

set.modelOpts.predictionType = 'ei';
eiId = getStructIndex(ei_poi_lcb_settings, set);
eiId20D = getStructIndex(ei_poi_lcb_settings_20D, set);

set.modelOpts.predictionType = 'poi';
poiId = getStructIndex(ei_poi_lcb_settings, set);
poiId20D = getStructIndex(ei_poi_lcb_settings_20D, set);

set.modelOpts.predictionType = 'lcb';
lcbId = getStructIndex(ei_poi_lcb_settings, set);
lcbId20D = getStructIndex(ei_poi_lcb_settings_20D, set);

set.modelOpts.predictionType = 'sd2';
set.evoControlRestrictedParam = 0.05;
sd2_r05_Id = getStructIndex(sd2_r05_40_settings, set);
sd2_r05_Id20D = getStructIndex(sd2_settings_20D, set);

set.evoControlRestrictedParam = 0.1;
sd2_r10_Id = getStructIndex(sd2_r10_20_settings, set);
sd2_r10_Id20D = getStructIndex(sd2_settings_20D, set);

set.evoControlRestrictedParam = 0.2;
sd2_r20_Id = getStructIndex(sd2_r10_20_settings, set);
sd2_r20_Id20D = getStructIndex(sd2_settings_20D, set);

set.evoControlRestrictedParam = 0.4;
sd2_r40_Id = getStructIndex(sd2_r05_40_settings, set);
sd2_r40_Id20D = getStructIndex(sd2_settings_20D, set);

set.PopSize = '(8 + floor(6*log(N)))';
set.evoControlRestrictedParam = 0.05;
sd2_r05_2pop_Id = getStructIndex(sd2_r05_2pop_settings, set);
sd2_r05_2pop_Id20D = getStructIndex(sd2_settings_20D, set);

set.evoControlRestrictedParam = 0.1;
sd2_r10_2pop_Id = getStructIndex(sd2_r10_2pop_settings, set);
sd2_r10_2pop_Id20D = getStructIndex(sd2_settings_20D, set);

set.evoControlRestrictedParam = 0.2;
sd2_r20_2pop_Id = getStructIndex(sd2_r20_40_2pop_settings, set);
sd2_r20_2pop_Id20D = getStructIndex(sd2_settings_20D, set);

set.evoControlRestrictedParam = 0.4;
sd2_r40_2pop_Id = getStructIndex(sd2_r20_40_2pop_settings, set);
sd2_r40_2pop_Id20D = getStructIndex(sd2_settings_20D, set);

% concatenate data
eiData  = [ei_poi_lcb_evals(:, :, eiId),  ei_poi_lcb_evals_20D(:, :, eiId20D)];
poiData = [ei_poi_lcb_evals(:, :, poiId), ei_poi_lcb_evals_20D(:, :, poiId20D)];
lcbData = [ei_poi_lcb_evals(:, :, lcbId), ei_poi_lcb_evals_20D(:, :, lcbId20D)];

sd2Data_05 = [sd2_r05_40_evals(:, :, sd2_r05_Id), sd2_evals_20D(:, :, sd2_r05_Id20D)];
sd2Data_10 = [sd2_r10_20_evals(:, :, sd2_r10_Id), sd2_evals_20D(:, :, sd2_r10_Id20D)];
sd2Data_20 = [sd2_r10_20_evals(:, :, sd2_r20_Id), sd2_evals_20D(:, :, sd2_r20_Id20D)];
sd2Data_40 = [sd2_r05_40_evals(:, :, sd2_r40_Id), sd2_evals_20D(:, :, sd2_r40_Id20D)];

sd2Data_05_2pop = [sd2_r05_2pop_evals(:, :, sd2_r05_2pop_Id), sd2_evals_20D(:, :, sd2_r05_2pop_Id20D)];
sd2Data_10_2pop = [sd2_r10_2pop_evals(:, :, sd2_r10_2pop_Id), sd2_evals_20D(:, :, sd2_r10_2pop_Id20D)];
sd2Data_20_2pop = [sd2_r20_40_2pop_evals(:, :, sd2_r20_2pop_Id), sd2_evals_20D(:, :, sd2_r20_2pop_Id20D)];
sd2Data_40_2pop = [sd2_r20_40_2pop_evals(:, :, sd2_r40_2pop_Id), sd2_evals_20D(:, :, sd2_r40_2pop_Id20D)];

saacmesData = saacmes_evals;
smacData = smac_evals;
cmaesData = [cmaes_evals(:, :, 1) , cmaes_evals_20D(:, :, 1)];
genData = [gen_evals(:, :, genId), gen_evals_20D(:, :, genId20D)];

% color settings
cmaesCol = [22 22 138];

eiCol = [255 0 0];
poiCol = [255 215 0];
lcbCol = [208 32 144];
sd2Col = [0 0 0];
saacmesCol = [100 149 237];
smacCol = [116 172 66];
genCol = [178,34,34];

sd2Col_05 = [0 0 139];
sd2Col_10 = sd2Col;
sd2Col_20 = [148 0 211];
sd2Col_40 = [255 20 147];
sd2Col_05_2pop = [154 205 50];
sd2Col_10_2pop = [34,139,34];
sd2Col_20_2pop = [0,128,128];
sd2Col_40_2pop = [70,130,180];

% evaluation target settings
defTargets = floor(power(20, linspace(1, log(250)/log(20), 25)));

%% Criterion comparison: EI, PoI, lcb, sd2
% Aggregation of function values across dimensions 2, 3, 5, 10, 20.

data = {eiData, ...
        poiData, ...
        lcbData, ...
        sd2Data_10, ...
        cmaesData};

datanames = {'EI', 'poi', 'lcb', 'sd2', 'CMA-ES'};

colors = [eiCol; poiCol; lcbCol; sd2Col; cmaesCol]/255;

for f = funcSet.BBfunc

  %% 
  close all

  fprintf('Function %d\n', f)
  fValuesPlot(data, 'DataNames', datanames, 'DataDims', funcSet.dims, ...
                      'DataFuns', funcSet.BBfunc, 'Colors', colors, ...
                      'PlotFuns', f, 'PlotDims', funcSet.dims, ...
                      'Statistic', 'median', 'AggregateDims', true, ...
                      'Dependency', 'alg');

  reverseDistributionPlot(data, ...
                            'DataNames', datanames, 'DataDims', funcSet.dims, ...
                            'DataFuns', funcSet.BBfunc, 'Colors', colors, ...
                            'PlotFuns', f, 'PlotDims', funcSet.dims, ...
                            'DefaultTargets', defTargets, 'AggregateDims', true);
end

%% Restricted parameter comparison: 0.05, 0.1, 0.2. 0.4
% Aggregation of function values across dimensions 2, 3, 5, 10, 20.

data = {sd2Data_05, ...
        sd2Data_10, ...
        sd2Data_20, ...
        sd2Data_40, ...
        cmaesData};

datanames = {'0.05', '0.1', '0.2', '0.4', 'CMA-ES'};

colors = [sd2Col_05; sd2Col_10; sd2Col_20; sd2Col_40; cmaesCol]/255;

for f = funcSet.BBfunc

  %% 
  close all

  fprintf('Function %d\n', f)
  fValuesPlot(data, 'DataNames', datanames, 'DataDims', funcSet.dims, ...
                      'DataFuns', funcSet.BBfunc, 'Colors', colors, ...
                      'PlotFuns', f, 'PlotDims', funcSet.dims, ...
                      'Statistic', 'median', 'AggregateDims', true, ...
                      'Dependency', 'alg');

  reverseDistributionPlot(data, ...
                            'DataNames', datanames, 'DataDims', funcSet.dims, ...
                            'DataFuns', funcSet.BBfunc, 'Colors', colors, ...
                            'PlotFuns', f, 'PlotDims', funcSet.dims, ...
                            'DefaultTargets', defTargets, 'AggregateDims', true);
end

%% Population size comparison: default, 2*default
% Aggregation of function values across dimensions 2, 3, 5, 10, 20.

data = {sd2Data_05, ...
        sd2Data_10, ...
        sd2Data_20, ...
        sd2Data_40, ...
        sd2Data_05_2pop, ...
        sd2Data_10_2pop, ...
        sd2Data_20_2pop, ...
        sd2Data_40_2pop, ...
        cmaesData};

datanames = {'0.05', '0.1', '0.2', '0.4', '0.05 2pop', '0.1 2pop', '0.2 2pop', '0.4 2pop', 'CMA-ES'};

colors = [sd2Col_05; sd2Col_10; sd2Col_20; sd2Col_40; sd2Col_05_2pop; sd2Col_10_2pop; sd2Col_20_2pop; sd2Col_40_2pop; cmaesCol]/255;

for f = funcSet.BBfunc

  %% 
  close all

  fprintf('Function %d\n', f)
  fValuesPlot(data, 'DataNames', datanames, 'DataDims', funcSet.dims, ...
                      'DataFuns', funcSet.BBfunc, 'Colors', colors, ...
                      'PlotFuns', f, 'PlotDims', funcSet.dims, ...
                      'Statistic', 'median', 'AggregateDims', true, ...
                      'Dependency', 'alg');

  reverseDistributionPlot(data, ...
                            'DataNames', datanames, 'DataDims', funcSet.dims, ...
                            'DataFuns', funcSet.BBfunc, 'Colors', colors, ...
                            'PlotFuns', f, 'PlotDims', funcSet.dims, ...
                            'DefaultTargets', defTargets, 'AggregateDims', true);
end

%% Algorithm comparison: DTS-CMA-ES, GS-CMA-ES, saACMES. SMAC, CMA-ES
% Aggregation of function values across dimensions 2, 5, 10, 20.
% Dimension 3 is omitted due to SMAC results absence.

data = {sd2Data_10, ...
        genData, ...
        saacmesData, ...
        smacData, ...
        cmaesData};

datanames = {'DTS-CMA-ES', 'GS-CMA-ES', 'saACMES', 'SMAC', 'CMA-ES'};

colors = [sd2Col; genCol; saacmesCol; smacCol; cmaesCol]/255;

plotDims = [2, 5, 10, 20];

for f = funcSet.BBfunc

  %% 
  close all

  fprintf('Function %d\n', f)
  fValuesPlot(data, 'DataNames', datanames, 'DataDims', funcSet.dims, ...
                      'DataFuns', funcSet.BBfunc, 'Colors', colors, ...
                      'PlotFuns', f, 'PlotDims', plotDims, ...
                      'Statistic', 'median', 'AggregateDims', true, ...
                      'Dependency', 'alg');

  reverseDistributionPlot(data, ...
                            'DataNames', datanames, 'DataDims', funcSet.dims, ...
                            'DataFuns', funcSet.BBfunc, 'Colors', colors, ...
                            'PlotFuns', f, 'PlotDims', plotDims, ...
                            'DefaultTargets', defTargets, 'AggregateDims', true);
end




%% EI, PoI, lcb, sd2: f-values comparison

% data = {eiData, ...
%         poiData, ...
%         lcbData, ...
%         sd2Data_10, ...
%         cmaesData};
% 
% datanames = {'EI', 'poi', 'lcb', 'sd2', 'CMA-ES'};
% 
% colors = [eiCol; poiCol; lcbCol; sd2Col; cmaesCol]/255;
% 
% defTargets = floor(power(20,linspace(1,log(250)/log(20),25)));
% 
% for d = funcSet.dims
%   for f = funcSet.BBfunc
%     
%     %% 
%     close all
%     
%     fprintf('Function %d, dimension %d\n', f, d)
%     fValuesPlot(data, 'DataNames', datanames, 'DataDims', funcSet.dims, ...
%                         'DataFuns', funcSet.BBfunc, 'Colors', colors, ...
%                         'PlotFuns', f, 'PlotDims', d, ...
%                         'Statistic', 'median', 'AggregateDims', false, ...
%                         'Dependency', 'alg');
%                       
%     reverseDistributionPlot(data, ...
%                               'DataNames', datanames, 'DataDims', funcSet.dims, ...
%                               'DataFuns', funcSet.BBfunc, 'Colors', colors, ...
%                               'PlotFuns', f, 'PlotDims', d, ...
%                               'DefaultTargets', defTargets, 'AggregateDims', false);
%   end
% end

%% EI, PoI, lcb, sd2: f-values comparison
% 
% close all
% 
% data = {eiData, ...
%         poiData, ...
%         lcbData, ...
%         sd2Data_10, ...
%         cmaesData};
% 
% datanames = {'EI', 'poi', 'lcb', 'sd2', 'CMA-ES'};
% 
% colors = [eiCol; poiCol; lcbCol; sd2Col; cmaesCol]/255;
% 
% % for i = 1:length(funcSet.BBfunc)
% %   pdfNames{i} = fullfile(plotResultsFolder, ['f', num2str(funcSet.BBfunc(i))]);
% % end
% 
% han = fValuesPlot(data, 'DataNames', datanames, 'DataDims', funcSet.dims, ...
%                         'DataFuns', funcSet.BBfunc, 'Colors', colors, ...
%                         'Statistic', 'median', 'AggregateDims', false, ...
%                         'Dependency', 'alg');
% %   print2pdf(han, pdfNames, 1)
% 
%% EI, PoI, lcb, sd2: reverse distribution comparison
close all

data = {eiData, ...
        poiData, ...
        lcbData, ...
        sd2Data_10, ...
        cmaesData};
      
datanames = {'EI', 'PoI', 'lcb', 'sd2', 'CMA-ES'};

colors = [eiCol; poiCol; lcbCol; sd2Col; cmaesCol]/255;
      
han = reverseDistributionPlot(data, ...
                              'DataNames', datanames, 'DataDims', funcSet.dims, ...
                              'DataFuns', funcSet.BBfunc, 'Colors', colors, ...
                              'PlotFuns', 1:5, 'PlotDims', funcSet.dims, ...
                              'DefaultTargets', 10*(1:25), 'AggregateDims', true);

%% final clearing
close all
