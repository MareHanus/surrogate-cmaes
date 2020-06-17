%Original experiment: exp_doubleEC_26_1model
exp_id = 'marek_newfunc205_linQuadEC_lmm';
exp_description = 'DTS-CMA-ES with PoI criterion, 1 model for all dimensions: best dataset-generation type from offline model testing and ANOVA assessment, in [2,3,5,10,20]D, Surrogate CMA-ES, fixed DTS 0.05 (merged code), DTIterations={1}, PreSampleSize=0.75, 2pop';

% BBOB/COCO framework settings

bbobParams = { ...
  'dimensions',         { 2, 4, 10, 12, 16, 20 }, ...
  'functions',          num2cell(205), ...      % all functions: num2cell(1:24)
  'opt_function',       { @opt_s_cmaes }, ...
  'instances',          { [1:10, 251:260] }, ...    % default is [1:5, 41:50]
  'maxfunevals',        { '250 * dim' }, ...
  'resume',             { true }, ...
};

% Surrogate manager parameters

surrogateParams = { ...
  'evoControl',         { 'linquad' }, ...    % 'none', 'individual', 'generation', 'restricted'
  'observers',          { {'DTScreenStatistics', 'DTFileStatistics'} },... % logging observers
  'modelType',          { 'lmm' }, ...               % 'gp', 'rf', 'bbob'
  'updaterType',        { 'rankDiff' }, ...         % OrigRatioUpdater
  'evoControlMaxDoubleTrainIterations', { 1 }, ...
  'evoControlPreSampleSize',       { 0.75 }, ...       % {0.25, 0.5, 0.75}, will be multip. by lambda
  'evoControlOrigPointsRoundFcn',  { 'ceil' }, ...  % 'ceil', 'getProbNumber'
  'evoControlTrainRange',          { 100000 }, ...      % will be multip. by sigma
  'evoControlSampleRange',         { 1 }, ...       % will be multip. by sigma
  'evoControlOrigGenerations',     { [] }, ...
  'evoControlModelGenerations',    { [] }, ...
  'evoControlValidatePoints',      { [] }, ...
  'evoControlRestrictedParam',     { 0.05 }, ...
  'evoControlUseInject',           { true }, ...
};

% Model parameters

modelParams = { ...
  'covFcn',             { '{@covMaterniso, 5}' }, ...
  'hyp',                { struct('lik', log(0.01), 'cov', log([0.5; 2])) }, ...
  'meanFcn',            { 'meanConst' }, ...
  'trainAlgorithm',     { 'fmincon' }, ...
  'predictionType',     { 'fvalues' }, ...
  'useShift',           { false }, ...
  'normalizeY',         { true }, ...
  'trainsetType'        { 'nearest' }, ...
  'trainRange',         { 100000 }, ...
  'trainsetSizeMax'     { '20*dim' }, ...l
};


% CMA-ES parameters

cmaesParams = { ...
  'PopSize',            { '(8+floor(6*log(N)))' }, ...        %, '(8 + floor(6*log(N)))'};
  'Restarts',           { 50 }, ...
  'DispModulo',         { 0 }, ...
};

logDir = '/storage/plzen1/home/hanusm12/public';
