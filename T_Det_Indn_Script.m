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
I = imread(rgbImage);
GW=rgb2gray(I);
%can=edge(gray,'canny');
%figure(1),imshow(can);title('Cann Edge Map');
SE=strel('square',3);
%closed=imclose(can,SE);
gt=graythresh(GW);
BW=imbinarize(GW,gt);
wp=0;
for p=1:50
    for q=1:50
        wp=wp+BW(p,q);
    end
end
if wp>2000
BW=~BW;
end
    
figure(1),imshow(BW);title('Binary image');
figure(2),imshow(BW);title('Text localization');
[lab,num]=bwlabel(BW,4);
prop=regionprops(lab,'BoundingBox');
%for i=1:size(prop,1);
%rectangle('Position',prop(i).BoundingBox,'Edgecolor','y','Linewidth',4);
%end
count=0;
for indx=1:num
    [row,col]=find(lab==indx);
    C=BW(min(row):max(row),min(col):max(col));
    [height,width]=size(C);
    are=height*width;
    ar=width/height;
    
    if(height<=width && height>10)
        if(ar>=0.1 && ar<=10)
     c_inv=~C;
    DT=bwdist(C);
    DTinvrs=~(c_inv);
    [x,y]=size(DT);
    s=0;
    for i=1:y
        s=s+DT(1,i);
        s=s+DT(x,i);
    end
    for j=1:x
        s=s+DT(j,1);
        s=s+DT(j,y);
    end
    [h,w]=size(DTinvrs);
    s1=0;
    for i=1:w
        s1=s1+DTinvrs(1,i);
        s1=s1+DTinvrs(h,i);
    end
    for j=1:h
        s1=s1+DTinvrs(j,1);
        s1=s1+DTinvrs(j,w);
    end
    
    if(s<s1)      
       T=DT;
    else
        T=DTinvrs;
    end
    %figure(i+2),imshow(C);
    rectangle('Position',prop(indx).BoundingBox,'Edgecolor','y','Linewidth',4);
    count=count+1;
end
    end
end
    
