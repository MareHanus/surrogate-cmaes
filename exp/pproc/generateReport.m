function generateReport(expFolder)
% generates report of experiment in folder

%TODO: settings comparison - what is different between individual settings
%TODO: rewrite printStructure to return string
 
  if nargin < 1
    help generateReport
    return
  end
  
  assert(isdir(expFolder), '%s is not a folder', expFolder)
  paramFile = fullfile(expFolder, 'scmaes_params.mat');
  assert(logical(exist(paramFile, 'file')), 'Folder %s does not contain scmaes_params.mat', expFolder)
  
  % load data
  params = load(paramFile);
  expName = params.exp_id;
  BBfunc = cell2mat(getParam(params.bbParamDef, 'functions'));
  dims   = cell2mat(getParam(params.bbParamDef, 'dimensions'));
  nAlgs  = prod(cellfun(@length, [{params.cmParamDef.values}, {params.sgParamDef.values}]));
  
  
  % open report file
  ppFolder = fullfile(expFolder, 'pproc');
  reportFile = fullfile(ppFolder, [expName, '_report.m']);
  FID = fopen(reportFile, 'w');
  
  % print report
  
  % introduction
  fprintf(FID, '%%%% %s report\n', expName);
  fprintf(FID, '%% Script for making graphs comparing the dependences of minimal function\n');
  fprintf(FID, '%% values on the number of function values of different algorithm settings\n');
  fprintf(FID, '%% tested in experiment %s. Moreover, algorithm settings are compared\n', expName);
  fprintf(FID, '%% to important algorithms in continuous black-box optimization field \n');
  fprintf(FID, '%% (CMA-ES, BIPOP-s*ACM-ES, SMAC, S-CMA-ES, and DTS-CMA-ES).\n');
  fprintf(FID, '%% \n');
  fprintf(FID, '%% To gain results publish this script.\n');
  fprintf(FID, '%% \n');
  fprintf(FID, '%% Created on %s in folder %s.\n', datestr(now), ppFolder);
  fprintf(FID, '\n');
  
  % data loading
  fprintf(FID, '%%%% load data\n');
  fprintf(FID, '\n');
  fprintf(FID, 'expFolder = ''%s'';\n', expFolder);
  fprintf(FID, 'resFolder = fullfile(expFolder, ''pproc'');\n');
  fprintf(FID, 'if ~isdir(resFolder)\n');
  fprintf(FID, '  mkdir(resFolder)\n');
  fprintf(FID, 'end\n');
  fprintf(FID, '\n');
  fprintf(FID, '%% loading results\n');
  fprintf(FID, 'funcSet.BBfunc = ');
  printStructure(BBfunc, FID)
  fprintf(FID, ';\n');
  fprintf(FID, 'funcSet.dims = ');
  printStructure(dims, FID)
  fprintf(FID, ';\n');
  fprintf(FID, '[exp_evals, exp_settings] = dataReady(expFolder, funcSet);\n');
  fprintf(FID, 'nSettings = length(exp_settings);\n');
  fprintf(FID, 'expData = arrayfun(@(x) exp_evals(:,:,x), 1:nSettings, ''UniformOutput'', false);\n');
  fprintf(FID, '\n');
  fprintf(FID, '%% create algorithm names\n');
  algNames = arrayfun(@(x) ['ALG', num2str(x)], 1:nAlgs, 'UniformOutput', false);
  fprintf(FID, 'expAlgNames = ');
  printStructure(algNames, FID)
  fprintf(FID, ';\n');
  fprintf(FID, '\n');
  fprintf(FID, '%% color settings\n');
  colors = randi(256, nAlgs, 3) - 1;
  fprintf(FID, 'expCol = ');
  printStructure(colors, FID)
  fprintf(FID, ';\n');
  fprintf(FID, '\n');
  fprintf(FID, '%% load algorithms to compare\n');
  fprintf(FID, 'alg = load(fullfile(''exp'', ''pproc'', ''compAlgMat.mat''));\n');
  fprintf(FID, 'algorithms = alg.algorithm;\n');
  fprintf(FID, '\n');
  
  % tested algorithms comparison
  fprintf(FID, '%%%% Tested algorithms comparison\n');
  fprintf(FID, '\n');
  fprintf(FID, 'for f = funcSet.BBfunc\n');
  fprintf(FID, '  %%%% \n');
  fprintf(FID, '  close all\n');
  fprintf(FID, '  \n');
  fprintf(FID, '  fprintf(''Function %%d\\n'', f)\n');
  fprintf(FID, '  han = relativeFValuesPlot(expData, ...\n');
  fprintf(FID, '                            ''DataDims'', funcSet.dims, ...\n');
  fprintf(FID, '                            ''DataFuns'', funcSet.BBfunc, ...\n');
  fprintf(FID, '                            ''PlotFuns'', f, ...\n');
  fprintf(FID, '                            ''AggregateDims'', false, ...\n');
  fprintf(FID, '                            ''AggregateFuns'', false, ...\n');
  fprintf(FID, '                            ''DataNames'', expAlgNames, ...\n');
  fprintf(FID, '                            ''Colors'', expCol, ...\n');
  fprintf(FID, '                            ''LegendOption'', ''out'', ...\n');
  fprintf(FID, '                            ''Statistic'', @median);\n');
  fprintf(FID, 'end\n');
  fprintf(FID, '\n');

  % all algorithms comparison
  fprintf(FID, '%%%% All algorithms comparison\n');
  fprintf(FID, '\n');
  fprintf(FID, 'data = [expData, {algorithms.data}];\n');
  fprintf(FID, 'datanames = [expAlgNames, {algorithms.name}];\n');
  fprintf(FID, 'colors = [expCol; cell2mat({algorithms.color}'')];\n');
  fprintf(FID, '\n');
  fprintf(FID, 'for f = funcSet.BBfunc\n');
  fprintf(FID, '  %%%% \n');
  fprintf(FID, '  close all\n');
  fprintf(FID, '  \n');
  fprintf(FID, '  fprintf(''Function %%d\\n'', f)\n');
  fprintf(FID, '  han = relativeFValuesPlot(data, ...\n');
  fprintf(FID, '                            ''DataDims'', funcSet.dims, ...\n');
  fprintf(FID, '                            ''DataFuns'', funcSet.BBfunc, ...\n');
  fprintf(FID, '                            ''PlotFuns'', f, ...\n');
  fprintf(FID, '                            ''AggregateDims'', false, ...\n');
  fprintf(FID, '                            ''AggregateFuns'', false, ...\n');
  fprintf(FID, '                            ''DataNames'', datanames, ...\n');
  fprintf(FID, '                            ''Colors'', colors, ...\n');
  fprintf(FID, '                            ''LegendOption'', ''out'', ...\n');
  fprintf(FID, '                            ''Statistic'', @median);\n');
  fprintf(FID, 'end\n');
  
  % close report file
  fclose(FID);

end

function value = getParam(setting, paramName)
% finds and returns appropriate value
  paramID = strcmp({setting.name}, paramName);
  if any(paramID)
    value = setting(paramID).values;
  else
    value = [];
  end
end