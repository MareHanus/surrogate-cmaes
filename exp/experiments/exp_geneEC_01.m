
exp_id = 'exp_geneEC_01';
exp_description = 'Surrogate CMA-ES with generation EC, thorough tests 2-20D';

machines = {'u-pl1', 'u-pl2', 'u-pl3', 'u-pl4', 'u-pl5', 'u-pl6', 'u-pl7', 'u-pl8', 'u-pl9', 'u-pl10', 'u-pl11', 'u-pl12', 'u-pl13', 'u-pl14', 'u-pl15', 'u-pl16', 'u-pl17', 'u-pl18', 'u-pl19', 'u-pl20', 'u-pl21', 'u-pl22', 'u-pl23', 'u-pl24', 'u-pl25', 'u-pl26'};

login = 'bajel3am';
if (strfind(mfilename('fullpath'), 'afs'))
  matlabcommand = '/afs/ms/@sys/bin/matlab';
else
  matlabcommand = 'matlab_mff_2014b';
end
logMatlabOutput = true;

% BBOB parameters
bbParamDef(1).name   = 'dimensions';
bbParamDef(1).values = {2, 5, 10, 20};      % {2, 5 10};
bbParamDef(2).name   = 'functions';
bbParamDef(2).values = {1, 2, 5, 6, 8, 10, 20, 21};
% dimensions  = [10];     % which dimensions to optimize, subset of [2 3 5 10 20 40];
% functions   = [8];      % function ID's to optimize (2 Sphere, 3 Rastrigin, 8 Rosenbrock)
bbParamDef(3).name   = 'opt_function';
bbParamDef(3).values = {@opt_s_cmaes};
% opt_function = @opt_s_cmaes;    % function being optimized -- BBOB wrap-around with header
%                                 % xbest = function( fun, dim, ftarget, maxfunevals )
bbParamDef(4).name   = 'instances';
bbParamDef(4).values = {[1:10 31:40]};   % default is [1:5, 31:40]
bbParamDef(5).name   = 'maxfunevals';   % MAXFUNEVALS - 10*dim is a short test-experiment
bbParamDef(5).values = {'250 * dim'};   % increment maxfunevals successively
                                
% Surrogate model parameter lists
sgParamDef(1).name   = 'evoControl';
sgParamDef(1).values = {'generation'};
sgParamDef(2).name   = 'modelType';
sgParamDef(2).values = {'gp', 'rf'};
sgParamDef(3).name   = 'evoControlTrainRange';
sgParamDef(3).values = {8}; % {2, 3, 4, 6, 8};

sgParamDef(4).name   = 'evoControlOrigGenerations';
sgParamDef(4).values = {1};
sgParamDef(5).name   = 'evoControlModelGenerations';
sgParamDef(5).values = {1, 2, 4};
sgParamDef(6).name   = 'evoControlValidatePoints';
sgParamDef(6).values = {2, 4};

% CMA-ES parameters
cmParamDef(1).name   = 'PopSize';
cmParamDef(1).values = {'(4 + floor(3*log(N)))'}; %, '(8 + floor(6*log(N)))'};
cmParamDef(2).name   = 'Restarts';
cmParamDef(2).values = {4};

% path to current file -- do not change this
pathstr = fileparts(mfilename('fullpath'));
exppath  = [pathstr filesep exp_id];
exppath_short  = pathstr;
[s,mess,messid] = mkdir(exppath);
[s,mess,messid] = mkdir([exppath filesep 'cmaes_results']);
addpath(exppath);
save([exppath filesep 'scmaes_params.mat'], 'bbParamDef', 'sgParamDef', 'cmParamDef');

% run the rest of the scripts generation
generateShellScripts
