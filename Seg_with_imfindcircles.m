%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Methode 4: Segmentation  with imfindcircles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% We use our function to find the left ventricle giving the radius we want,
% the sensivity and the binary image
M3_BW1_dias  = lvCircleMask(img1_dias_bin, [15 25], 0.9, 'Img1 Dias');
M3_BW2_dias  = lvCircleMask(img2_dias_bin, [15 25], 0.9, 'Img2 Dias');
M3_BW3_dias  = lvCircleMask(img3_dias_bin, [15 25], 0.9, 'Img3 Dias');
M3_BW4_dias  = lvCircleMask(img4_dias_bin, [15 25], 0.9, 'Img4 Dias');
M3_BW5_dias  = lvCircleMask(img5_dias_bin, [15 30], 0.9, 'Img5 Dias');

M3_BW1_sys = lvCircleMask(img1_sys_bin, [7 18], 0.88, 'Img1 Sys');
M3_BW2_sys = lvCircleMask(img2_sys_bin, [9 16], 0.9, 'Img2 Sys');
M3_BW3_sys = lvCircleMask(img3_sys_bin, [9 20], 0.9, 'Img3 Sys');
M3_BW4_sys = lvCircleMask(img4_sys_bin, [6 18], 0.85, 'Img4 Sys');
M3_BW5_sys = lvCircleMask(img5_sys_bin, [7 20], 0.85, 'Img5 Sys');

%% Resize of the image
originalSize = [256 256]; % Original size DICOM

% We resize the image back to its original size for better visualization.
idx1 = 70;
idx2 = 170;

M3_BW1_dias_res  = PadToOriginal(M3_BW1_dias,  idx1, idx2, originalSize);
M3_BW2_dias_res  = PadToOriginal(M3_BW2_dias,  idx1, idx2, originalSize);
M3_BW3_dias_res  = PadToOriginal(M3_BW3_dias,  idx1, idx2, originalSize);
M3_BW4_dias_res  = PadToOriginal(M3_BW4_dias,  idx1, idx2, originalSize);
M3_BW5_dias_res  = PadToOriginal(M3_BW5_dias,  idx1, idx2, originalSize);
 
M3_BW1_sys_res = PadToOriginal(M3_BW1_sys, idx1, idx2, originalSize);
M3_BW2_sys_res = PadToOriginal(M3_BW2_sys, idx1, idx2, originalSize);
M3_BW3_sys_res = PadToOriginal(M3_BW3_sys, idx1, idx2, originalSize);
M3_BW4_sys_res = PadToOriginal(M3_BW4_sys, idx1, idx2, originalSize);
M3_BW5_sys_res = PadToOriginal(M3_BW5_sys, idx1, idx2, originalSize);

% We show the images at its original size
figure;
subplot(2,5,6);
imagesc(M3_BW1_sys_res); colormap('gray'); title('Vol Img1Sys Estimé');

subplot(2,5,7);
imagesc(M3_BW2_sys_res); colormap('gray'); title('Vol Img2Sys Estimé');

subplot(2,5,8);
imagesc(M3_BW3_sys_res); colormap('gray'); title('Vol Img3Sys Estimé');

subplot(2,5,9);
imagesc(M3_BW4_sys_res); colormap('gray'); title('Vol Img4Sys Estimé');

subplot(2,5,10);
imagesc(M3_BW5_sys_res); colormap('gray'); title('Vol Img5Sys Estimé');

subplot(2,5,1);
imagesc(M3_BW1_dias_res); colormap('gray'); title('Vol Img1Dias Estimé');

subplot(2,5,2);
imagesc(M3_BW2_dias_res); colormap('gray'); title('Vol Img2Dias Estimé');

subplot(2,5,3);
imagesc(M3_BW3_dias_res); colormap('gray'); title('Vol Img3Dias Estimé');

subplot(2,5,4);
imagesc(M3_BW4_dias_res); colormap('gray'); title('Vol Img4Dias Estimé');

subplot(2,5,5);
imagesc(M3_BW5_dias_res); colormap('gray'); title('Vol Img5Dias Estimé');

%% Estimated volume
fprintf('-----Results using circles detection (imfindcircles)----- \n');
fprintf('Estimated volume IMG 1 Dias: %g\n', sum(M3_BW1_dias_res(:)));
fprintf('Estimated volume IMG 2 Dias: %g\n', sum(M3_BW2_dias_res(:)));
fprintf('Estimated volume IMG 3 Dias: %g\n', sum(M3_BW3_dias_res(:)));
fprintf('Estimated volume IMG 4 Dias: %g\n', sum(M3_BW4_dias_res(:)));
fprintf('Estimated volume IMG 5 Dias: %g\n', sum(M3_BW5_dias_res(:)));
fprintf('Estimated volume IMG 1 Sys: %g\n', sum(M3_BW1_sys_res(:)));
fprintf('Estimated volume IMG 2 Sys: %g\n', sum(M3_BW2_sys_res(:)));
fprintf('Estimated volume IMG 3 Sys: %g\n', sum(M3_BW3_sys_res(:)));
fprintf('Estimated volume IMG 4 Sys: %g\n', sum(M3_BW4_sys_res(:)));
fprintf('Estimated volume IMG 5 Sys: %g\n', sum(M3_BW5_sys_res(:)));


%% Estimated ejection fraction
fprintf('-----Results using circles detection (imfindcircles)----- \n');
fprintf('Estimated ejection fraction IMG 1: %g\n', (sum(M3_BW1_dias_res(:)) - sum(M3_BW1_sys_res(:)))/sum(M3_BW1_dias_res(:)));
fprintf('Estimated ejection fraction IMG 2: %g\n', (sum(M3_BW2_dias_res(:)) - sum(M3_BW2_sys_res(:)))/sum(M3_BW2_dias_res(:)));
fprintf('Estimated ejection fraction IMG 3: %g\n', (sum(M3_BW3_dias_res(:)) - sum(M3_BW3_sys_res(:)))/sum(M3_BW3_dias_res(:)));
fprintf('Estimated ejection fraction IMG 4: %g\n', (sum(M3_BW4_dias_res(:)) - sum(M3_BW4_sys_res(:)))/sum(M3_BW4_dias_res(:)));
fprintf('Estimated ejection fraction IMG 5: %g\n', (sum(M3_BW5_dias_res(:)) - sum(M3_BW5_sys_res(:)))/sum(M3_BW5_dias_res(:)));

