exp_id = 'exp_doubleEC_23_adapt05';
exp_description = 'Surrogate CMA-ES, DTS with preselection(1pt), DTIterations={2}, Valid.Gen.Period/PopSz=4/2, PreSampleSize=0.75, sd2 criterion, 2pop';

% BBOB/COCO framework settings

bbobParams = { ...
  'dimensions',         { 2, 3, 5, 10, 20 }, ...
  'functions',          num2cell(1:24), ...      % all functions: num2cell(1:24)
  'opt_function',       { @opt_s_cmaes }, ...
  'instances',          { [1:5], [41:50] }, ...    % default is [1:5, 41:50]
  'maxfunevals',        { '250 * dim' }, ...
  'resume',             { true }, ...
};

% Surrogate manager parameters

surrogateParams = { ...
  'evoControl',         { 'doubletrained' }, ...    % 'none', 'individual', 'generation', 'restricted'
  'observers',          { {'DTScreenStatistics', 'DTFileStatistics'} },... % logging observers
  'modelType',          { 'gp' }, ...               % 'gp', 'rf', 'bbob'
  'updaterType',        { 'rankDiff' }, ...         % OrigRatioUpdater
  'DTAdaptive_updateRate',     { 0.3, 0.4, 0.5 }, ...
  'DTAdaptive_updateRateDown', { 'obj.updateRate', 'min(2*obj.updateRate,1)' }, ...
  'DTAdaptive_maxRatio',       { 0.5, 0.75, 1.0 }, ...
  'DTAdaptive_minRatio',       { 0.04 }, ...
  'DTAdaptive_lowErr',         { '@(x) [ones(size(x,1),1) x(:,1) x(:,2) x(:,1).*x(:,2) x(:,2).^2] * [0.17; -0.00067; -0.095; 0.0087; 0.15]' }, ...
  'DTAdaptive_highErr',        { '@(x) [ones(size(x,1),1) log(x(:,1)) x(:,2) log(x(:,1)).*x(:,2) x(:,2).^2] * [0.35; -0.047; 0.44; 0.044; -0.19]' }, ...
  'DTAdaptive_defaultErr',     { 0.05 }, ...
  'evoControlMaxDoubleTrainIterations', { 1 }, ...
  'evoControlPreSampleSize',       { 0.75 }, ...       % {0.25, 0.5, 0.75}, will be multip. by lambda
  'evoControlNBestPoints',         { 0 }, ...
  'evoControlValidationGenerationPeriod', { 4 }, ...
  'evoControlValidationPopSize',   { 0 }, ...
  'evoControlOrigPointsRoundFcn',  { 'ceil' }, ...  % 'ceil', 'getProbNumber'
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
  'normalizeY',         { true }, ...
  'trainsetSizeMax'     { '15*dim' }, ...
};

% CMA-ES parameters

cmaesParams = { ...
  'PopSize',            { '(8 + floor(6*log(N)))' }, ...        %, '(8 + floor(6*log(N)))'};
  'Restarts',           { 50 }, ...
  'DispModulo',         { 0 }, ...
};

logDir = '/storage/plzen1/home/bajeluk/public';
