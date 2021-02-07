function face_feature=training(directory,FDetect)

       file=dir(directory);
       i3=1;
for i1=3:length(file)
    
       filename=[directory '\' file(i1).name];
       color=imread(filename);
       color=imresize(color,[256 256]);
%% 

Ig(:,:,1)=adapthisteq(color(:,:,1));
Ig(:,:,2)=adapthisteq(color(:,:,2));
Ig(:,:,3)=adapthisteq(color(:,:,3));


%%  %%  image conversion

redChannel = color(:, :, 1);
greenChannel = color(:, :, 2);
blueChannel = color(:, :, 3);
% gray = .299*redChannel + .587*greenChannel + .114*blueChannel;
% gs=gray;
gray=color;
%Returns Bounding Box values based on number of objects
BB = step(FDetect,gray);
if size(BB,1)>=1 
F=imcrop(gray,BB(1,:));

ff=lbp(F);
%% NOSE DETECTION:

%To detect Nose
nose = vision.CascadeObjectDetector('Nose','MergeThreshold',2);


% bb=step(lefteye,F);
bb1=step(nose,F);
if size(bb1,1)>=1 
for i = 1:size(bb1,1) 
    b5=bb1(i,:);
    a5(i)=(b5(2)+b5(4));%+(b(1)-b(3));
end
[a1,b1]=min(a5);
clear a5

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
for i = 1:size(BB,1) 
    b5=BB(i,:);
    a5(i)=(b5(2)+b5(4));%+(b(1)-b(3));
end
[a1,b1]=max(a5);
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
else
    fl=0;
    Eyesl=0;
end
xc=[ff fn fm fr fl];
face_feature(i3,:)=xc(1:256);
i3=i3+1;
else
    fl=lbp(gray);
    face_feature(i3,:)=fl(1:256);
i3=i3+1;
end
end
      
end