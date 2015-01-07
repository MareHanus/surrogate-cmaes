mailTo = 'bajeluk@gmail.com,z.pitra@gmail.com';

% Divide instances to machines
params = [bbParamDef, sgParamDef, cmParamDef];
nCombinations = structReduce(params, @(s,x) s*length(x.values), 1);
nMachines = length(machines);

combsPerMachine = ceil(nCombinations / nMachines);
startIdxs = 1:combsPerMachine:nCombinations;
endIdxs =   min(startIdxs + (combsPerMachine-1), nCombinations);

% Generate .sh scripts
fNameMng = [exppath filesep exp_id '_manager.sh'];
fMng = fopen(fNameMng, 'w'); 
fprintf(fMng, '#!/bin/sh\n');
fprintf(fMng, '# Manager for experiment "%s", created on %s\n', exp_id, char(datetime('now')));

for i = 1:nMachines
  machine = machines{i};
  fName = [exppath filesep exp_id '_' machine '.sh'];

  % Logging of Matlab output
  if (exist('logMatlabOutput', 'var') && logMatlabOutput)
    logFile = [exppath filesep exp_id '__log__' machine '.txt'];
    logString = ' | tee -a $LOGS';
  else
    logFile = '/dev/null';
    logString = '';
  end

  fprintf(fMng, 'ssh %s@%s "screen -d -m \\"%s\\""\n', login, machine, fName);

  fid = fopen(fName, 'w'); 
  fprintf(fid, '#!/bin/sh\n');
  fprintf(fid, '# Script for experiment "%s" on machine "%s", created on %s\n', exp_id, machine, char(datetime('now')));
  fprintf(fid, 'cd ~/prg/surrogate-cmaes; ulimit -t unlimited;\n');
  fprintf(fid, 'LOGS="%s"\n\n', logFile);
  fprintf(fid, 'testMatlabFinished () {\n');
  fprintf(fid, '  if [ -f "$1" -a "$1" -nt "%s" ]; then\n', fNameMng);
  fprintf(fid, '    echo `date "+%%Y-%%m-%%d %%H:%%M:%%S"` " " **%s** at [%s] $2 / %d succeeded. >> ~/WWW/phd/cmaes.txt\n', exp_id, machine, combsPerMachine);
  fprintf(fid, '    echo `date "+%%Y-%%m-%%d %%H:%%M:%%S"` " " **%s** at [%s] $2 / %d succeeded. >> %s\n', exp_id, machine, combsPerMachine, logFile);
  fprintf(fid, '  else\n');
  fprintf(fid, '    echo `date "+%%Y-%%m-%%d %%H:%%M:%%S"` " " **%s** at [%s] $2 / %d !!!  FAILED !!! >> ~/WWW/phd/cmaes.txt\n', exp_id, machine, combsPerMachine);
  fprintf(fid, '    echo `date "+%%Y-%%m-%%d %%H:%%M:%%S"` " " **%s** at [%s] $2 / %d !!!  FAILED !!! >> %s\n', exp_id, machine, combsPerMachine, logFile);
  fprintf(fid, '    mail -s "[surrogate-cmaes] Script failed =%s= [%s] $2 / %d" "%s" <<EOM\n', exp_id, machine, combsPerMachine, mailTo);
  fprintf(fid, 'Script **%s** has failed on machine [%s].\n', exp_id, machine);
  fprintf(fid, '`date "+%%Y-%%m-%%d %%H:%%M:%%S"`\n');
  fprintf(fid, 'EOM\n');
  fprintf(fid, '  fi\n');
  fprintf(fid, '}\n');
  for id = startIdxs(i):endIdxs(i)
    idFrom1 = id-startIdxs(i)+1;
    [bbParams, sgParams] = getParamsFromIndex(id, bbParamDef, sgParamDef, cmParamDef);

    lastResultsFileID = [num2str(bbParams.functions(end)) '_' num2str(bbParams.dimensions(end)) 'D_' num2str(id)];
    resultsFile = [exppath filesep exp_id '_results_' lastResultsFileID '.mat'];

    fprintf(fid, '\necho "###########################################"%s\n', logString);
    fprintf(fid, 'echo "     Matlab call %d / %d"%s\n', idFrom1, combsPerMachine, logString);
    fprintf(fid, 'echo ""%s\n', logString);
    fprintf(fid, 'echo "  dim(s): %s    f(s): %s    N(inst): %d"%s\n', num2str(bbParams.dimensions), num2str(bbParams.functions), length(bbParams.instances), logString);
    if (isfield(sgParams, 'modelType'))
      model = sgParams.modelType;
    else
      model = 'NONE';
    end
    fprintf(fid, 'echo "  model: %s    maxfunevals: %s"%s\n', model, bbParams.maxfunevals, logString);
    fprintf(fid, 'echo "###########################################"%s\n', logString);
    fprintf(fid, 'nice -n 19 %s -nodisplay -r "bbob_test_01(%d, ''%s'', ''%s''); exit(0);"%s\n', matlabcommand, id, exp_id, exppath_short, logString);
    fprintf(fid, 'testMatlabFinished "%s" %d\n', resultsFile, idFrom1);
  end
  
  fprintf(fid, 'echo `date "+%%Y-%%m-%%d %%H:%%M:%%S"` " " **%s** at [%s] ==== FINISHED ==== >> ~/WWW/phd/cmaes.txt\n', exp_id, machine);

  fclose(fid);
  fileattrib(fName, '+x');
end

fclose(fMng);
fileattrib(fNameMng, '+x');
