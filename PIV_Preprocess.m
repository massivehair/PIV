function [PIVData, MaskData] = PIV_Preprocess(DataIn, varargin)
%%% Preprocess the data to find the blood vessels as well as enhance the
%%% differences

if nargin > 1
    MaskThreshold = varargin{1};
else
    MaskThreshold = 0.2;
end

SmoothData = DataIn;
for index = 1:size(SmoothData,3)
    SmoothData(:,:,index) = sort(DataIn(:,:,index),1);
    SmoothData(:,:,index) = DataIn(:,:,index) - repmat(SmoothData(100,:,index), [size(SmoothData,1),1]); % demodulate
    SmoothData(:,:,index) = imgaussfilt(SmoothData(:,:,index),2);
end
PIVData = DataIn(:,:,1:end);
MeanData = cast(mean(DataIn,3), 'like', DataIn);
for index = 1:size(PIVData,3)
    %DiffData(:,:,index) = abs(Data(:,:,index)-Data(:,:,index+1));
    %DiffData(:,:,index) = Data(:,:,index)-Data(:,:,index+1);
    PIVData(:,:,index) = DataIn(:,:,index)-MeanData;
end

switch 'stdIntensity'
    case 'max'
        MaskData = max(PIVData,[],3);
    case 'mean'
        MaskData = mean(PIVData,3);
    case 'std'
        MaskData = std(single(PIVData),0,3);
    case 'kurtosisIntensity'
        MaskData = inpaint_nans(kurtosis(double(DataIn),1,3));
    case 'meanIntensity'
        MaskData = mean(DataIn,3);
    case 'stdIntensity'
        MaskData = std(single(SmoothData),0,3);
    case 'IntensityAndFlow'
        MaskData = mean(Data,3) .* ((inpaint_nans(kurtosis(double(DataIn),1,3))).^0.4);
end

MaskData = imgaussfilt(MaskData,2);
MaskData = MaskData-imerode(MaskData, strel('disk', 25, 0));

MaskData = ~im2bw(MaskData/max(MaskData(:)), MaskThreshold);