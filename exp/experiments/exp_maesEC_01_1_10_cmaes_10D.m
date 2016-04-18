exp_id = 'exp_maesEC_01';
exp_description = 'Model Assisted Evolution Strategy (Ulmer, 2003), GP model, (1,10) CMA-ES, individual EC, 3*lambda pre-selection, 2*lambda training points, POI or mean prediction, 24 functions, 15 instances';

% BBOB/COCO framework settings

bbobParams = { ...
  'dimensions',         { 2, 3, 5, 10 }, ...
  'functions',          num2cell(1:24), ...                % all functions: num2cell(1:24)
  'opt_function',       { @opt_s_cmaes }, ...
  'instances',          { [1:5, 41:50] }, ...              % default is [1:5, 41:50]
  'maxfunevals',        { '250 * dim' }
};

% Surrogate manager parameters

surrogateParams = { ...
  'evoControl',                      { 'maes' }, ...       %  'none', 'individual', 'generation', 'restricted', 'maes'
  'modelType',                       { 'gp' }, ...         % 'gpop', 'rf', 'bbob'
  'evoControlPreSampleSize',         { 0 }, ...            % {0.25, 0.5, 0.75}, will be multip. by lambda
  'evoControlIndividualExtension',   { 3 }, ...            % will be multip. by lambda
  'evoControlBestFromExtension',     { [] }, ...           % ratio of expanded popul.
  'evoControlTrainRange',            { 10 }, ...           % will be multip. by sigma
  'evoControlTrainNArchivePoints',   { '2*lambda' }, ...   % will be myeval()'ed, 'nRequired', 'nEvaluated', 'lambda', 'dim' can be used
  'evoControlSampleRange',           { 1 }, ...            % will be multip. by sigma
};

% Model parameters

modelParams = { ...
  'useShift',           { false }, ...
  'trainAlgorithm',     { 'fmincon' }, ...
  'covFcn',             { '{@covSum, {@covSEard, @covNoise}}' }, ...
  'hyp',                { struct( ...
                            'lik', log(0.001), ...
                            'cov', 'log([0.5 * ones(dim, 1); 0.1, 1e-4])' ... % ell, signal variance, signal noise
                          ), ...
                        }, ...
  'predictionType',     { 'poi', 'fvalues' }, ...
  'normalizeY',         { true }
};

% CMA-ES parameters

cmaesParams = { ...
  'PopSize',            { 10 }, ...                         % 35, '(4 + floor(3*log(N)))', '(8 + floor(6*log(N)))';
  'ParentNumber',       { 1 }, ...                          % 5, default is 'floor(popsize/2)'
  'Restarts',           { 4 }, ...
};

logDir = '/storage/budejovice1/home/repjak/public';
