clc;
clear all;
close all;
imtool close all;
workspace;
% Read the input image
[FN, PN]=uigetfile( {'*.jpg';'*.jpeg';'*.gif';'*.png';'*.bmp'},'Select file'); 
 rgbImage = strcat(PN, FN);
%This code checks if the user pressed cancel on the dialog.
        if isequal(FN,0) || isequal(PN,0)
            uiwait(msgbox ('User pressed cancel','failed','modal')  )
            hold on;
        else
            uiwait(msgbox('Image is selected sucessfully','Weldone','modal'));
            hold off;
            %%imshow(MyImage)
        end
desfolder = 'D:\resultanalysis\rokib';
roifile='D:\resultanalysis\roi';
I = imread(rgbImage);
GW=rgb2gray(I);
gt=graythresh(GW);
[height,width]=size(GW);
Sz=width*height;
x=1;y=1;
%BW=zeros(height,width);
bw=imbinarize(GW,gt);
sum=0;
for i=1:50
    for j=1:50
        sum=sum+bw(i,j);
    end
end
sum
if sum>=1000
    bw=~bw;
end
h=fspecial('gaussian');
bw=imfilter(bw,h,'conv');
figure(1), imshow(bw), title('Filtered binary image');
[lab,num]=bwlabel(bw,8);
prop=regionprops(lab,'BoundingBox');
count=0;
for indx=1:num
    bp=0;wp=0;
    [row,col]=find(lab==indx);
    C=bw(min(row):max(row),min(col):max(col));
    [height,width]=size(C);
    for i=1:height
        for j=1:width
            wp=wp+C(i,j);
        end
    end
    bp=(height*width)-wp;
    arr=height*width;
    %pause;
    bwpr=bp/wp*100;
    if bwpr>95
        if(width>height)
            if(height>10 && height<200)
                if(arr>=500)
    rectangle('Position',prop(indx).BoundingBox,'Edgecolor','y','Linewidth',4);
    count=count+1;
    baseFileName = sprintf('Q %d.jpg', count);
    fullFileName = fullfile(desfolder, baseFileName);
    n2=imresize(C,[30,30]);
    %txt = ocr(n2,'Language','Bengali');
    imwrite(n2, fullFileName);
                end
            end
        end
  end
end
%txt=ocr(bw);

%end