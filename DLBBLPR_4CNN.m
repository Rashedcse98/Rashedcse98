
%digitDatasetPath = fullfile(matlabroot,'toolbox','nnet','nndemos', ...
 %   'nndatasets','BVLP_CNN');
%imds = imageDatastore(digitDatasetPath, ...
    %'IncludeSubfolders',true,'LabelSource','foldernames');
%figure;

trainingdir   = fullfile(toolboxdir('vision'), 'visiondata','digits','trainingset');
testdir = fullfile(toolboxdir('vision'), 'visiondata','digits','testset');

% |imageDatastore| recursively scans the directory tree containing the
% images. Folder names are automatically used as labels for each image.
trainingset = imageDatastore(trainingdir, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
testset     = imageDatastore(testdir, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
%Use countEachLabel to tabulate the number of images associated with each label. In this example, the training set consists of 101 images for each of the 10 digits. The test set consists of 12 images per digit.

countEachLabel(trainingset)
%figure;
%perm = randperm(1600,20);
%for i = 1:20
    %subplot(4,5,i);
    %imshow(trainingdir.Files{perm(i)});
%end
%labelCount = countEachLabel(imds)
%}
%img = readimage(imds,1); %in previous code imds
%size(img);
numImages = numel(trainingset.Files);
numtestimage=numel(testset.Files);
%numTrainFiles =85;
%[imdsTrain] = splitEachLabel(trainingset,numImages);
%[imdsValidation] = splitEachLabel(testset,numtestimage);
layers = [
    imageInputLayer([30 30 1])
    
    convolution2dLayer(3,32,'Padding',1)
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    convolution2dLayer(3,32,'Padding',1)
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    convolution2dLayer(3,32,'Padding',1)
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    convolution2dLayer(3,64,'Padding',1)
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    fullyConnectedLayer(22)
    softmaxLayer
    classificationLayer];
options = trainingOptions('sgdm', ...
   'InitialLearnRate',0.001, ...    
   'MaxEpochs',15, ...
    'ValidationData',testset, ...
    'ValidationFrequency',10, ...
    'Verbose',false, ...
    'Plots','training-progress');
net = trainNetwork(trainingset,layers,options);
YPred = classify(net,testset);
YValidation = testset.Labels;

accuracy = sum(YPred == YValidation)/numel(YValidation)
%plotconfusion(YValidation,YPred);
