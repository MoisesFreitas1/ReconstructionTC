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

Q = cell(1,1,lenFiles);
for i=1:lenFiles
  Q{i} = X(:,:,:,i);
end
II = cell2mat(Q);

sizeII_ = size(II);
xII_ = sizeII_(1);
yII_ = sizeII_(2);
zII_ = sizeII_(3);

l = 0;
for i = 1:xII_
    for j = 1:yII_
       for k = 1:zII_
           if(II(i,j,k)>0 & II(i,j,k)<4000)
                l = l + 1;
                XII(l) = i;
                YII(l) = j;
                ZII(l) = k;
           end
       end
    end
end

II_1 = zeros(xII_,yII_,zII_);
for i = 1:l
    II_1(XII(i),YII(i),ZII(i)) = II(XII(i),YII(i),ZII(i));
end

II_ = II_1;
sizeII = size(II_1);
zII = sizeII(3);
j = 1;
for i = zII:-1:1
   II_(:,:,j) = II_1(:,:,i);
   j = j + 1;
end

vol3d('cdata', II_);
view(3)
lighting PHONG
axis tight
colormap('gray');
set(gca,'color','black')
view(0,0)
