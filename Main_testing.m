load('Trained.mat');
%% Testing phase
[file,path]=uigetfile('*.*','Select Image');
filename=[path,file];
color=imread(filename);
color=imresize(color,[256 256]);
figure(1),subplot(1,4,1),imshow(color);
title('Color RGB Image');

%%
%% 
clear Ig
Ig(:,:,1)=adapthisteq(color(:,:,1));
Ig(:,:,2)=adapthisteq(color(:,:,2));
Ig(:,:,3)=adapthisteq(color(:,:,3));
figure(1),subplot(1,4,2),imshow(Ig); 
title('Enhanced Image image');

%%  %%  image conversion

redChannel = color(:, :, 1);
greenChannel = color(:, :, 2);
blueChannel = color(:, :, 3);
 gray = .299*redChannel + .587*greenChannel + .114*blueChannel;
% gs=gray;
figure(1),subplot(1,4,3),imshow(gray); 
title('Gray Image');
gray=color;
%Returns Bounding Box values based on number of objects
B1= step(FDetect,gray);
if size(B1,1)>=1 
 for ik=1:size(B1,1)
 
F=imcrop(gray,B1(ik,:));
figure(1),subplot(1,4,4),imshow(Ig); 
title('Face Detected Image');
hold on
 for i = 1:1%size(BB,1)
     rectangle('Position',B1(ik,:),'LineWidth',4,'LineStyle','-','EdgeColor','g');
 end
ff=lbp(F);
%% NOSE DETECTION:

%To detect Nose
nose = vision.CascadeObjectDetector('Nose','MergeThreshold',2);

figure,imshow(F);
% bb=step(lefteye,F);
bb1=step(nose,F);
if size(bb1,1)>=1 
for i = 1:size(bb1,1) 
    b5=bb1(i,:);
    a5(i)=(b5(2)+b5(4));%+(b(1)-b(3));
end
[a1,b1]=min(a5);
clear a5
hold on
 for i = 1:1%size(BB,1)
     rectangle('Position',bb1(b1,:),'LineWidth',4,'LineStyle','-','EdgeColor','g');
 end
% % title('Nose Detection');
nose=imcrop(F,bb1(1,:));
fn=lbp(nose);
else
    fn=0;
   nose=0; 
end

%% MOUTH DETECTION:


%To detect Mouth
MouthDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',16);

BB=step(MouthDetect,F);
if size(BB,1)>=1 
%   pause(0.1)
hold on
for i = 1:size(BB,1)
 rectangle('Position',BB(1,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
end
hold off
M=imcrop(F,BB(1,:));
fm=lbp(M);
else
    fm=0;
    M=0;
end


%% EYE DETECTION:

%To detect Eyes
righteye = vision.CascadeObjectDetector('RightEye','MergeThreshold',2);

BB=step(righteye,F); 
if size(BB,1)>=1 
    clear a5
for i = 1:size(BB,1) 
    b5=BB(i,:);
    a5(i)=(b5(2)+b5(4));%+(b(1)-b(3));
end
[a1,b1]=max(a5);
hold on
%  figure,imshow(F);
rectangle('Position',BB(b1,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
hold off
clear bl
clear a5

Eyes=imcrop(F,BB(b1,:));
fr=lbp(Eyes);
else
    fr=0;
    Eyes=0;
end

%To detect Eyes
righteye = vision.CascadeObjectDetector('LeftEye','MergeThreshold',3);

BB=step(righteye,F); 
if size(BB,1)>=1 

% title('Eyes Detection');
Eyesl=imcrop(F,BB(1,:));
fl=lbp(Eyesl);
hold on
%  figure,imshow(F);
rectangle('Position',BB(1,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
hold off
else
    fl=0;
    Eyesl=0;
end
xc=[ff fn fm fr fl];
fea=xc(1:256);

%% 
st={'Happy ','Sad','Anger'};
[result] = multisvm(out1,group,fea);


msgbox(['Recognized Emotion is= ',st(round(result))]);
figure,imshow(color);
title('Result of System');
BB = step(FDetect,gray);
hold on
 for i = 1:1%size(BB,1)
     rectangle('Position',BB(ik,:),'LineWidth',4,'LineStyle','-','EdgeColor','g');
 end
 text( BB(ik,1), BB(ik,2),st(round(result)))
 
end
else
  fl=lbp(gray);
    fea=fl(1:256);  
    st={'Happy ','Sad','Anger'};
[result] = multisvm(out1,group,fea);


msgbox(['Recognized Emotion is= ',st(round(result))]);
end




