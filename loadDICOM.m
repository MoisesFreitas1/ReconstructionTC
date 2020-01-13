close all;
clc;
clear all;
files = dir('*.dcm');
lenFiles = max(size(files));
info = dicominfo(files(1).name);
nRows = info.Rows;
nCols = info.Columns;
nPlanes = info.SamplesPerPixel;
nFrames = lenFiles;
X = repmat(int16(0), [nRows, nCols, nPlanes, nFrames]);
for p = 1:nFrames
  X(:,:,:,p) = dicomread(files(p).name);
end

minPixels = repmat(0, [1, nFrames]);
maxPixels = repmat(0, [1, nFrames]);

for p = 1:nFrames
  info = dicominfo(files(p).name);
  minPixels(p) = info.SmallestImagePixelValue;
  maxPixels(p) = info.LargestImagePixelValue;
end

b = min(minPixels);
m = 2^16/(max(maxPixels) - b);
Y = imlincomb(m, X, -(m * b), 'uint16');
montage(Y,[])