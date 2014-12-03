% Add Deep learning toolbox code
addpath(genpath('DeepLearnToolbox'));

% Add common code
addpath(genpath('common'));

% Load the train data if needed
if (exist('mergedData', 'var') == 0)
	loadTrainData;
end

% Load the test data if needed (warning: takes a LONG time)
if (exist('mergedTestData', 'var') == 0) 
	loadTestData;
end

% Create neural net targeted output
yTrain = zeros(size(trainData, 1), numClasses);
for i = 1:numTrainSamples
	yTrain(i, classification(i)) = 0.99;
endfor

% Normalize
[normFeatures, mu, sigma] = zscore(features);
[normTestFeatures, mu, sigma] = zscore(testFeatures);

% Construct 3 layer ANN with 5 hidden nodes and 7 output nodes for all features
neuralNet = nnsetup([size(normFeatures, 2) 5 numClasses]);
neuralNet.activation_function = 'sigm';
neuralNet.learningRate = 0.5;
opts.numepochs = 50;
opts.batchsize = 105;
opts.plot = 1;

% Train
[neuralNet, L] = nntrain(neuralNet, normFeatures, yTrain, opts);

%L
fflush(stdout);

% Test
printf('predicting...');
fflush(stdout);
predictions = [];
for i = 1:numTestSamples
	predictions = [predictions ; testData(i,1) nnpredict(neuralNet, normTestFeatures(i,:))];
endfor

printf('saving predictions to file...');
fflush(stdout);
save vanillaNNSigmPredictions.txt predictions;