exp_id = 'exp_doubleEC_ada_06';
exp_description = 'Surrogate CMA-ES model using double-trained EC with rankDiff criterion and GPs with 1.5-population, and adaptive original ratio updates with the best settings from preliminary experiment exp_doubleEC_ada_05';

% BBOB/COCO framework settings

bbobParams = { ...
  'dimensions',         { 2, 3, 5, 10 }, ...
  'functions',          num2cell(1:24), ...      % all functions: num2cell(1:24)
  'opt_function',       { @opt_s_cmaes }, ...
  'instances',          { [1:5 41:50] }, ...    % default is [1:5, 41:50]
  'maxfunevals',        { '250 * dim' }, ...
  'resume',             { true }, ...
};

% Surrogate manager parameters

surrogateParams = { ...
  'evoControl',         { 'doubletrained' }, ...    % 'none', 'individual', 'generation', 'restricted'
  'observers',          { {'DTScreenStatistics', 'DTFileStatistics'} },... % logging observers
  'modelType',          { 'gp' }, ...               % 'gp', 'rf', 'bbob'
  'updaterType',        { 'rankDiff' }, ...         % OrigRatioUpdater
  'DTAdaptive_aggregateType', { 'lastValid' }, ...
  'DTAdaptive_updateRate',    { 0.8 }, ...
  'DTAdaptive_startRatio',      { 0.1 }, ...
  'DTAdaptive_maxRatio',      { 1.0 }, ...
  'DTAdaptive_minRatio',      { 0.02 }, ...
  'DTAdaptive_lowRank',       { 0.15 }, ...
  'DTAdaptive_highRank',      { 0.50 }, ...
  'evoControlPreSampleSize',       { 0 }, ...       % {0.25, 0.5, 0.75}, will be multip. by lambda
  'evoControlIndividualExtension', { [] }, ...      % will be multip. by lambda
  'evoControlBestFromExtension',   { [] }, ...      % ratio of expanded popul.
  'evoControlTrainRange',          { 10 }, ...      % will be multip. by sigma
  'evoControlSampleRange',         { 1 }, ...       % will be multip. by sigma
  'evoControlOrigGenerations',     { [] }, ...
  'evoControlModelGenerations',    { [] }, ...
  'evoControlValidatePoints',      { [] }, ...
  'evoControlRestrictedParam',     { 0.05 }, ...
};

% Model parameters

modelParams = { ...
  'useShift',           { false }, ...
  'predictionType',     { 'sd2' }, ...
  'trainAlgorithm',     { 'fmincon' }, ...
  'covFcn',             { '{@covMaterniso, 5}' }, ...
  'hyp',                { struct('lik', log(0.01), 'cov', log([0.5; 2])) }, ...
  'nBestPoints',        { 0 }, ...
  'minLeaf',            { 2 }, ...
  'inputFraction',      { 1 }, ...
  'normalizeY',         { true }, ...
  'trainsetSizeMax'     { '15*dim' }, ...
};

% CMA-ES parameters

cmaesParams = { ...
  'PopSize',            { '(6 + floor(4.5*log(N)))' }, ...        %, '(8 + floor(6*log(N)))'};
  'Restarts',           { 50 }, ...
  'DispModulo',         { 0 }, ...
  % 'CMA',                { struct('damps', '1.5 + 2*max(0,sqrt((mueff-1)/(N+1))-1) + cs') }, ...
};

logDir = '/storage/plzen1/home/bajeluk/public';
