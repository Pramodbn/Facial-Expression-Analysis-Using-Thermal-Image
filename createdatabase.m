
vid = webcam(1);

% Npix_resolution = get(vid, 'VideoResolution');
Nfrm_movie = 100;


%%
n=1;
  
%FDetect = vision.CascadeObjectDetector;
for k = 1:Nfrm_movie
    
    
     % Getting Image
     I = snapshot(vid);
     
     I=imresize(I,[287,460]);

imwrite(I,['frame\',num2str(n),'.jpg']);n=n+1;
subplot(1,1,1),imshow(I)
pause(2)
end
delete(vid)