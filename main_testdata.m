% clear all;
% close all;
FDetect = vision.CascadeObjectDetector;
% ch=input('Enter the choice 1 for training. 2 for testing');
% if ch==1
for i=1:6
diry=[pwd '\testset\' num2str(i)];
   disp(' features Extraction.....');
   feature1=training(diry,FDetect);
   if i==1
       out1=feature1;
       group=ones(size(feature1,1),1)*i;
   else
       group1=ones(size(feature1,1),1)*i;
       group=[group;group1];
       out1=[out1;feature1];
   end
   
end 
save Testdata;
msgbox('Training Completed');

%  else
%     load('Trained.mat');
% end
