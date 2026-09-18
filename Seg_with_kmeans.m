%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Methode 3: Segmentation with Kmeans (unsupervised learning)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% We convert the images to uint8
M4_1_dias = im2uint8(img1_dias_S);                 
M4_2_dias = im2uint8(img2_dias_S);
M4_3_dias = im2uint8(img3_dias_S);
M4_4_dias = im2uint8(img4_dias_S);
M4_5_dias = im2uint8(img5_dias_S);

M4_1_sys = im2uint8(img1_sys_S);
M4_2_sys = im2uint8(img2_sys_S);
M4_3_sys = im2uint8(img3_sys_S);
M4_4_sys = im2uint8(img4_sys_S);
M4_5_sys = im2uint8(img5_sys_S);

[rows, cols] = size(M4_1_dias); % The size of the image

% We use the guassian filter to eliminate the noise
% Sigma = 1 is used to slightly reduce noise while preserving edge details.

M4_1_dias = imgaussfilt(M4_1_dias, 1);
M4_2_dias = imgaussfilt(M4_2_dias, 1);
M4_3_dias = imgaussfilt(M4_3_dias, 1);
M4_4_dias = imgaussfilt(M4_4_dias, 1);
M4_5_dias = imgaussfilt(M4_5_dias, 1);

M4_1_sys = imgaussfilt(M4_1_sys, 1);
M4_2_sys = imgaussfilt(M4_2_sys, 1);
M4_3_sys = imgaussfilt(M4_3_sys, 1);
M4_4_sys = imgaussfilt(M4_4_sys, 1);
M4_5_sys = imgaussfilt(M4_5_sys, 1);

% We generate the amount of clusters necessary in order to have a good
% segmentation of the zone and we repeate that 3 times.
% We store the cluster centers and the label image indicating which cluster
% each pixel belongs to.
[L1d, Centers1d] = imsegkmeans(M4_1_dias, 3, "NumAttempts", 3);
[L2d, Centers2d] = imsegkmeans(M4_2_dias, 2, "NumAttempts", 3);
[L3d, Centers3d] = imsegkmeans(M4_3_dias, 3, "NumAttempts", 3);
[L4d, Centers4d] = imsegkmeans(M4_4_dias, 3, "NumAttempts", 3);
[L5d, Centers5d] = imsegkmeans(M4_5_dias, 3, "NumAttempts", 3);

[L1s, Centers1s] = imsegkmeans(M4_1_sys, 5, "NumAttempts", 3);
[L2s, Centers2s] = imsegkmeans(M4_2_sys, 3, "NumAttempts", 3);
[L3s, Centers3s] = imsegkmeans(M4_3_sys, 3, "NumAttempts", 3);
[L4s, Centers4s] = imsegkmeans(M4_4_sys, 3, "NumAttempts", 3);
[L5s, Centers5s] = imsegkmeans(M4_5_sys, 3, "NumAttempts", 3);

% We show the images with the segmentation
figure;

subplot(2,5,1)
imshow(labeloverlay(M4_1_dias, L1d)); title("imsegkmeans labels");
subplot(2,5,2)
imshow(labeloverlay(M4_2_dias, L2d)); title("imsegkmeans labels");
subplot(2,5,3)
imshow(labeloverlay(M4_3_dias, L3d)); title("imsegkmeans labels");
subplot(2,5,4)
imshow(labeloverlay(M4_4_dias, L4d)); title("imsegkmeans labels");
subplot(2,5,5)
imshow(labeloverlay(M4_5_dias, L5d)); title("imsegkmeans labels");

subplot(2,5,6)
imshow(labeloverlay(M4_1_sys, L1s)); title("imsegkmeans labels");
subplot(2,5,7)
imshow(labeloverlay(M4_2_sys, L2s)); title("imsegkmeans labels");
subplot(2,5,8)
imshow(labeloverlay(M4_3_sys, L3s)); title("imsegkmeans labels");
subplot(2,5,9)
imshow(labeloverlay(M4_4_sys, L4s)); title("imsegkmeans labels");
subplot(2,5,10)
imshow(labeloverlay(M4_5_sys, L5s)); title("imsegkmeans labels");


%%

% Final masks (ROI)
% The function select the left ventricle

M4mask1d = bestLVMaskFromLabels(M4_1_dias, L1d);
M4mask2d = bestLVMaskFromLabels(M4_2_dias, L2d);
M4mask3d = bestLVMaskFromLabels(M4_3_dias, L3d);
M4mask4d = bestLVMaskFromLabels(M4_4_dias, L4d);
M4mask5d = bestLVMaskFromLabels(M4_5_dias, L5d);

M4mask1s = bestLVMaskFromLabels(M4_1_sys,  L1s);
M4mask2s = bestLVMaskFromLabels(M4_2_sys,  L2s);
M4mask3s = bestLVMaskFromLabels(M4_3_sys,  L3s);
M4mask4s = bestLVMaskFromLabels(M4_4_sys,  L4s);
M4mask5s = bestLVMaskFromLabels(M4_5_sys,  L5s);

% We apply the dilatation operator to each ventricle with a disk form to
% avoid a sub segmentation

M4mask2d = imdilate(M4mask2d,  strel('disk', 3));
M4mask3d = imdilate(M4mask3d,  strel('disk', 3));
M4mask4d = imdilate(M4mask4d,  strel('disk', 4));
M4mask5d = imdilate(M4mask5d,  strel('disk', 4));

M4mask1s = imdilate(M4mask1s,  strel('disk', 3));
M4mask2s = imdilate(M4mask2s,  strel('disk', 4));
M4mask3s = imdilate(M4mask3s,  strel('disk', 5));
M4mask4s = imdilate(M4mask4s,  strel('disk', 5));
M4mask5s = imdilate(M4mask5s,  strel('disk', 5));

% We plot the original images with the red contour of the segmentation.

figure;
subplot(2,5,1); imshow(M4_1_dias,[]); hold on; visboundaries(M4mask1d,'Color','r'); title('Img1 Dias'); hold off;
subplot(2,5,2); imshow(M4_2_dias,[]); hold on; visboundaries(M4mask2d,'Color','r'); title('Img2 Dias'); hold off;
subplot(2,5,3); imshow(M4_3_dias,[]); hold on; visboundaries(M4mask3d,'Color','r'); title('Img3 Dias'); hold off;
subplot(2,5,4); imshow(M4_4_dias,[]); hold on; visboundaries(M4mask4d,'Color','r'); title('Img4 Dias'); hold off;
subplot(2,5,5); imshow(M4_5_dias,[]); hold on; visboundaries(M4mask5d,'Color','r'); title('Img5 Dias'); hold off;

subplot(2,5,6); imshow(M4_1_sys, []); hold on; visboundaries(M4mask1s,'Color','r'); title('Img1 Sys'); hold off;
subplot(2,5,7); imshow(M4_2_sys, []); hold on; visboundaries(M4mask2s,'Color','r'); title('Img2 Sys'); hold off;
subplot(2,5,8); imshow(M4_3_sys, []); hold on; visboundaries(M4mask3s,'Color','r'); title('Img3 Sys'); hold off;
subplot(2,5,9); imshow(M4_4_sys, []); hold on; visboundaries(M4mask4s,'Color','r'); title('Img4 Sys'); hold off;
subplot(2,5,10); imshow(M4_5_sys,[]); hold on; visboundaries(M4mask5s,'Color','r'); title('Img5 Sys'); hold off;

%% 
originalSize = [256 256]; % original size DICOM

% We resize the image back to its original size for better visualization.
M4_img1_dias_res  = PadToOriginal(M4mask1d,  idx1, idx2, originalSize);
M4_img2_dias_res  = PadToOriginal(M4mask2d,  idx1, idx2, originalSize);
M4_img3_dias_res  = PadToOriginal(M4mask3d,  idx1, idx2, originalSize);
M4_img4_dias_res  = PadToOriginal(M4mask4d,  idx1, idx2, originalSize);
M4_img5_dias_res  = PadToOriginal(M4mask5d,  idx1, idx2, originalSize);

M4_img1_sys_res = PadToOriginal(M4mask1s, idx1, idx2, originalSize);
M4_img2_sys_res = PadToOriginal(M4mask2s, idx1, idx2, originalSize);
M4_img3_sys_res = PadToOriginal(M4mask3s, idx1, idx2, originalSize);
M4_img4_sys_res = PadToOriginal(M4mask4s, idx1, idx2, originalSize);
M4_img5_sys_res = PadToOriginal(M4mask5s, idx1, idx2, originalSize);

% We show the results with the original size

% --- Systole:
figure;
subplot(2,5,6);
imagesc(M4_img1_sys_res); colormap('gray'); title('Vol Img1Sys Estimé');

subplot(2,5,7);
imagesc(M4_img2_sys_res); colormap('gray'); title('Vol Img2Sys Estimé');

subplot(2,5,8);
imagesc(M4_img3_sys_res); colormap('gray'); title('Vol Img3Sys Estimé');

subplot(2,5,9);
imagesc(M4_img4_sys_res); colormap('gray'); title('Vol Img4Sys Estimé');

subplot(2,5,10);
imagesc(M4_img5_sys_res); colormap('gray'); title('Vol Img5Sys Estimé');

% --- Diastole ---
subplot(2,5,1);
imagesc(M4_img1_dias_res); colormap('gray'); title('Vol Img1Dias Estimé');

subplot(2,5,2);
imagesc(M4_img2_dias_res); colormap('gray'); title('Vol Img2Dias Estimé');

subplot(2,5,3);
imagesc(M4_img3_dias_res); colormap('gray'); title('Vol Img3Dias Estimé');

subplot(2,5,4);
imagesc(M4_img4_dias_res); colormap('gray'); title('Vol Img4Dias Estimé');

subplot(2,5,5);
imagesc(M4_img5_dias_res); colormap('gray'); title('Vol Img5Dias Estimé');

%% Estimated volume
fprintf('-----Results using Kmeans----- \n');
fprintf('Estimated volume IMG 1 Dias: %g\n', sum(M4_img1_dias_res(:)));
fprintf('Estimated volume IMG 2 Dias: %g\n', sum(M4_img2_dias_res(:)));
fprintf('Estimated volume IMG 3 Dias: %g\n', sum(M4_img3_dias_res(:)));
fprintf('Estimated volume IMG 4 Dias: %g\n', sum(M4_img4_dias_res(:)));
fprintf('Estimated volume IMG 5 Dias: %g\n', sum(M4_img5_dias_res(:)));
fprintf('Estimated volume IMG 1 Sys: %g\n', sum(M4_img1_sys_res(:)));
fprintf('Estimated volume IMG 2 Sys: %g\n', sum(M4_img2_sys_res(:)));
fprintf('Estimated volume IMG 3 Sys: %g\n', sum(M4_img3_sys_res(:)));
fprintf('Estimated volume IMG 4 Sys: %g\n', sum(M4_img4_sys_res(:)));
fprintf('Estimated volume IMG 5 Sys: %g\n', sum(M4_img5_sys_res(:)));

%% Estimated ejection fraction
fprintf('-----Results using Kmeans----- \n');
fprintf('Ejected fraction (estimated) IMG 1: %g\n', (sum(M4_img1_dias_res(:)) - sum(M4_img1_sys_res(:)))/sum(M4_img1_dias_res(:)));
fprintf('Ejected fraction (estimated) IMG 2: %g\n', (sum(M4_img2_dias_res(:)) - sum(M4_img2_sys_res(:)))/sum(M4_img2_dias_res(:)));
fprintf('Ejected fraction (estimated) IMG 3: %g\n', (sum(M4_img3_dias_res(:)) - sum(M4_img3_sys_res(:)))/sum(M4_img3_dias_res(:)));
fprintf('Ejected fraction (estimated) IMG 4: %g\n', (sum(M4_img4_dias_res(:)) - sum(M4_img4_sys_res(:)))/sum(M4_img4_dias_res(:)));
fprintf('Ejected fraction (estimated) IMG 5: %g\n', (sum(M4_img5_dias_res(:)) - sum(M4_img5_sys_res(:)))/sum(M4_img5_dias_res(:)));