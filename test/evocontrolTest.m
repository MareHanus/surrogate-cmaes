function tests = evocontrolTest
  tests = functiontests(localfunctions);
end

function testSimpleCmaes(testCase)
  [xmin, fmin, counteval] = s_cmaes('fellii', [2 2 2 2], 2);

  verifyEqual(testCase, counteval, 1100, 'RelTol', 0.2);
  verifyEqual(testCase, fmin, 0, 'AbsTol', 1e-10);
  verifyEqual(testCase, xmin, [0 0 0 0]', 'AbsTol', 1e-7);
end

function testNoModelNoEvoControl(testCase)
  surrogateOpts.evoControl = 'none';
  surrogateOpts.sampleFcn = @sampleCmaes;

  [xmin, fmin, counteval] = s_cmaes('fellii', [2 2 2 2], 2, [], 'SurrogateOptions', surrogateOpts);

  verifyEqual(testCase, counteval, 1100, 'RelTol', 0.2);
  verifyEqual(testCase, fmin, 0, 'AbsTol', 1e-10);
  verifyEqual(testCase, xmin, [0 0 0 0]', 'AbsTol', 1e-7);
end

function testNoModelGenEvoControl(testCase)
  surrogateOpts.evoControl = 'generation';
  surrogateOpts.sampleFcn = @sampleCmaes;

  [xmin, fmin, counteval] = s_cmaes('fellii', [2 2 2 2], 2, [], 'SurrogateOptions', surrogateOpts);

  verifyEqual(testCase, counteval, 1100, 'RelTol', 0.2);
  verifyEqual(testCase, fmin, 0, 'AbsTol', 1e-10);
  verifyEqual(testCase, xmin, [0 0 0 0]', 'AbsTol', 1e-7);
end

function testGpModelGenEvoControl(testCase)
  surrogateOpts.evoControl = 'generation';
  surrogateOpts.modelType = 'gp';
  surrogateOpts.modelOpts = [];

  [xmin, fmin, counteval] = s_cmaes('fellii', [2 2 2 2], 2, [], 'SurrogateOptions', surrogateOpts);

  verifyEqual(testCase, counteval, 1100, 'RelTol', 0.2);
  verifyEqual(testCase, fmin, 0, 'AbsTol', 1e-10);
  verifyEqual(testCase, xmin, [0 0 0 0]', 'AbsTol', 1e-7);
end
