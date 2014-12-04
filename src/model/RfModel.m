classdef RfModel < Model
  properties    % derived from abstract class "Model"
    dim                 % dimension of the input space X (determined from x_mean)
    trainGeneration     % # of the generation when the model was built
    trainMean           % mean of the generation when the model was built
    options

    nTrees
    minLeaf
    inputFraction
    forest
  end

  methods
    function obj = RfModel(modelOptions, xMean)
      % constructor
      assert(size(xMean,1) == 1, 'RfModel (constructor): xMean is not a row-vector.');
      obj.options = modelOptions;
      obj.dim     = size(xMean, 2);

      % this is a MOCK/TEST IMPLEMENTATION!
      obj.nTrees = 100;
      obj.minLeaf = 5;
      obj.inputFraction = 1;
    end

    function nData = getNTrainData(obj)
      % returns the required number of data for training the model
      % TODO: *write this* properly according to dimension and
      %       covariance function set in options
      nData = obj.minLeaf * obj.dim;
    end

    function obj = train(obj, X, y, xMean, generation)
      % train the GP model based on the data (X,y)

      assert(size(xMean,1) == 1, 'RfModel.train(): xMean is not a row-vector.');
      obj.trainGeneration = generation;
      obj.trainMean = xMean;

      % learning
      obj.forest = TreeBagger(obj.nTrees,X,y,'method','regression',... 
            'MinLeaf',obj.minLeaf,...
            'FBoot',obj.inputFraction);
    end

    function [y, dev] = predict(obj, X)
      % predicts the function values in new points X
      if (obj.isTrained())
        [y,dev] = predict(obj.forest,X);
      else
        y = []; dev = [];
        warning('RfModel.predict(): the model is not yet trained!');
      end
    end

    function trained = isTrained(obj)
      % check whether the model is already trained
      trained = (obj.trainGeneration >= 0);
    end
  end

end
