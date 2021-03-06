classdef ExpResults
  % a container with task's results
  properties
    results = 0;
  end % properties

  methods
    function obj = ExpResults()
    % initialize a struct array
%       obj.results = struct('evals', cell(1, n), ...
%         'restarts', cell(1, n), ...
%         'f025', cell(1, n), ...
%         'f050', cell(1, n), ...
%         'f075', cell(1, n), ...
%         'fbests', cell(1, n), ...
%         'stopflags', cell(1, n), ...
%         'y_evals', cellfun(@(x) {{}}, cell(1,n)), ... % a cell array of empty cell arrays
%         'time', 0 ...
%       );
       obj.results = struct('evals', [], ...
        'restarts', [], ...
        'f025', [], ...
        'f050', [], ...
        'f075', [], ...
        'fbests', [], ...
        'stopflags', [], ...
        'y_evals', {{}}, ...
        'time', 0 ...
      );
    end % function
    
    function obj = combine(obj, results)
    % add two result records together with an operation depending on the field
      obj.results.evals = [obj.results.evals results.evals];
      obj.results.restarts = [obj.results.restarts results.restarts];
      obj.results.f025 = [obj.results.f025 results.f025];
      obj.results.f050 = [obj.results.f050 results.f050];
      obj.results.f075 = [obj.results.f075 results.f075];
      obj.results.fbests = [obj.results.fbests results.fbests];
      obj.results.y_evals = cat(1, obj.results.y_evals, results.y_evals);
      obj.results.time = obj.results.time + results.time;
    end % function
    
    function isEmpty = isEmpty(obj)
      isEmpty = true;
      fields = fieldnames(obj.results);
      for i = 1:numel(fields)
        fname = fields{i};
        if (~isscalar(obj.results.(fname)) && ~isempty(obj.results.(fname))) || ...
            (isscalar(obj.results.(fname)) && obj.results.(fname) > 0)
          isEmpty = false;
          return;
        end
      end
    end % function
  end % methods
end % classdef