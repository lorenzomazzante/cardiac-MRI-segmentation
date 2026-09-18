%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Methode 1: Segmentation with mathematical morphologie
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% ================== Labels to separe the regions =============

% We only take the left ventricle of the binary image (The number of that
% zone depends on the segmentation and the image)
M1_BW1_dias  = bwlabel(img1_dias_bin) == 13;
M1_BW2_dias  = bwlabel(img2_dias_bin) == 24;
M1_BW3_dias  = bwlabel(img3_dias_bin) == 24;
M1_BW4_dias  = bwlabel(img4_dias_bin) == 12;
M1_BW5_dias  = bwlabel(img5_dias_bin) == 15;

M1_BW1_sys = bwlabel(img1_sys_bin) == 18;
M1_BW2_sys = bwlabel(img2_sys_bin) == 17;
M1_BW3_sys = bwlabel(img3_sys_bin) == 27;
M1_BW4_sys = bwlabel(img4_sys_bin) == 26;
M1_BW5_sys = bwlabel(img5_sys_bin) == 20;


%% ================== Plot regions ===========================
figure;

subplot(2,5,6);
imagesc(M1_BW1_sys); colormap('gray'); title('Regions Image1 Sys');

subplot(2,5,7);
imagesc(M1_BW2_sys); colormap('gray'); title('Regions Image2 Sys');

subplot(2,5,8);
imagesc(M1_BW3_sys); colormap('gray'); title('Regions Image3 Sys');

subplot(2,5,9);
imagesc(M1_BW4_sys); colormap('gray'); title('Regions Image4 Sys');

subplot(2,5,10);
imagesc(M1_BW5_sys); colormap('gray'); title('Regions Image5 Sys');

subplot(2,5,1);
imagesc(M1_BW1_dias); colormap('gray'); title('Regions Image1 Dias');

subplot(2,5,2);
imagesc(M1_BW2_dias); colormap('gray'); title('Regions Image2 Dias');

subplot(2,5,3);
imagesc(M1_BW3_dias); colormap('gray'); title('Regions Image3 Dias');

subplot(2,5,4);
imagesc(M1_BW4_dias); colormap('gray'); title('Regions Image4 Dias');

subplot(2,5,5);
imagesc(M1_BW5_dias); colormap('gray'); title('Regions Image5 Dias');

%% ================== Dilatation et Erosion ===========================

% We use the sphere form with radius 7
SE7 = strel('sphere', 7);

% We apply the closing operation to all the images
M1_BW1_sys_cl  = imclose(M1_BW1_sys,SE7);
M1_BW2_sys_cl  = imclose(M1_BW2_sys,SE7);
M1_BW3_sys_cl  = imclose(M1_BW3_sys,SE7);
M1_BW4_sys_cl  = imclose(M1_BW4_sys,SE7);
M1_BW5_sys_cl  = imclose(M1_BW5_sys,SE7);

M1_BW1_dias_cl  = imclose(M1_BW1_dias,SE7);
M1_BW2_dias_cl  = imclose(M1_BW2_dias,SE7);
M1_BW3_dias_cl  = imclose(M1_BW3_dias,SE7);
M1_BW4_dias_cl  = imclose(M1_BW4_dias,SE7);
M1_BW5_dias_cl  = imclose(M1_BW5_dias,SE7);

% We create other kind of forms specific for each image
SE1 = strel('disk', 1);
SE2 = strel('disk', 2);
SE4 = strel('disk', 4);
SE5 = strel('disk', 5);

% Now we apply the dilatation operation to each image
M1_BW1_dias_cl_d  = imdilate(M1_BW1_dias_cl,SE1);
M1_BW2_dias_cl_d  = imdilate(M1_BW2_dias_cl,SE1);
M1_BW3_dias_cl_d  = imdilate(M1_BW3_dias_cl,SE1);
M1_BW4_dias_cl_d  = imdilate(M1_BW4_dias_cl,SE1);
M1_BW5_dias_cl_d  = imdilate(M1_BW5_dias_cl,SE1);

M1_BW1_sys_cl_d  = imdilate(M1_BW1_sys_cl,SE2);
M1_BW2_sys_cl_d  = imdilate(M1_BW2_sys_cl,SE4);
M1_BW3_sys_cl_d  = imdilate(M1_BW3_sys_cl,SE2);
M1_BW4_sys_cl_d  = imdilate(M1_BW4_sys_cl,SE5);
M1_BW5_sys_cl_d  = imdilate(M1_BW5_sys_cl,SE2);

% We show the results of the operations
figure;
subplot(2,5,1);
imagesc(M1_BW1_dias_cl_d); colormap('gray'); title('Op Morphologie Img1 Dias');

subplot(2,5,2);
imagesc(M1_BW2_dias_cl_d); colormap('gray'); title('Op Morphologie Img2 Dias');

subplot(2,5,3);
imagesc(M1_BW3_dias_cl_d); colormap('gray'); title('Op Morphologie Img3 Dias');

subplot(2,5,4);
imagesc(M1_BW4_dias_cl_d); colormap('gray'); title('Op Morphologie Img4 Dias');

subplot(2,5,5);
imagesc(M1_BW5_dias_cl_d); colormap('gray'); title('Op Morphologie Img5 Dias');

subplot(2,5,6);
imagesc(M1_BW1_sys_cl_d); colormap('gray'); title('Op Morphologie Img1 Sys');

subplot(2,5,7);
imagesc(M1_BW2_sys_cl_d); colormap('gray'); title('Op Morphologie Img2 Sys');

subplot(2,5,8);
imagesc(M1_BW3_sys_cl_d); colormap('gray'); title('Op Morphologie Img3 Sys');

subplot(2,5,9);
imagesc(M1_BW4_sys_cl_d); colormap('gray'); title('Op Morphologie Img4 Sys');

subplot(2,5,10);
imagesc(M1_BW5_sys_cl_d); colormap('gray'); title('Op Morphologie Img5 Sys');

%% ================== Reshape image ===========================

originalSize = [256 256]; % Original size DICOM

M1_img1_dias_res  = PadToOriginal(M1_BW1_dias_cl_d,  idx1, idx2, originalSize);
M1_img2_dias_res  = PadToOriginal(M1_BW2_dias_cl_d,  idx1, idx2, originalSize);
M1_img3_dias_res  = PadToOriginal(M1_BW3_dias_cl_d,  idx1, idx2, originalSize);
M1_img4_dias_res  = PadToOriginal(M1_BW4_dias_cl_d,  idx1, idx2, originalSize);
M1_img5_dias_res  = PadToOriginal(M1_BW5_dias_cl_d,  idx1, idx2, originalSize);

M1_img1_sys_res = PadToOriginal(M1_BW1_sys_cl_d, idx1, idx2, originalSize);
M1_img2_sys_res = PadToOriginal(M1_BW2_sys_cl_d, idx1, idx2, originalSize);
M1_img3_sys_res = PadToOriginal(M1_BW3_sys_cl_d, idx1, idx2, originalSize);
M1_img4_sys_res = PadToOriginal(M1_BW4_sys_cl_d, idx1, idx2, originalSize);
M1_img5_sys_res = PadToOriginal(M1_BW5_sys_cl_d, idx1, idx2, originalSize);

% We plot the results with the images original size
figure;
subplot(2,5,6);
imagesc(M1_img1_sys_res); colormap('gray'); title('Vol Img1Sys Estime');

subplot(2,5,7);
imagesc(M1_img2_sys_res); colormap('gray'); title('Vol Img2Sys Estime');

subplot(2,5,8);
imagesc(M1_img3_sys_res); colormap('gray'); title('Vol Img3Sys Estime');

subplot(2,5,9);
imagesc(M1_img4_sys_res); colormap('gray'); title('Vol Img4Sys Estime');

subplot(2,5,10);
imagesc(M1_img5_sys_res); colormap('gray'); title('Vol Img5Sys Estime');

subplot(2,5,1);
imagesc(M1_img1_dias_res); colormap('gray'); title('Vol Img1Dias Estime');

subplot(2,5,2);
imagesc(M1_img2_dias_res); colormap('gray'); title('Vol Img2Dias Estime');

subplot(2,5,3);
imagesc(M1_img3_dias_res); colormap('gray'); title('Vol Img3Dias Estime');

subplot(2,5,4);
imagesc(M1_img4_dias_res); colormap('gray'); title('Vol Img4Dias Estime');

subplot(2,5,5);
imagesc(M1_img5_dias_res); colormap('gray'); title('Vol Img5Dias?Estime');


%% Estimated volume
fprintf('-----Results using mathematic morfology----- \n');
fprintf('Estimated volume IMG 1 Dias: %g\n', sum(M1_img1_dias_res(:)));
fprintf('Estimated volume IMG 2 Dias: %g\n', sum(M1_img2_dias_res(:)));
fprintf('Estimated volume IMG 3 Dias: %g\n', sum(M1_img3_dias_res(:)));
fprintf('Estimated volume IMG 4 Dias: %g\n', sum(M1_img4_dias_res(:)));
fprintf('Estimated volume IMG 5 Dias: %g\n', sum(M1_img5_dias_res(:)));
fprintf('Estimated volume IMG 1 Sys: %g\n', sum(M1_img1_sys_res(:)));
fprintf('Estimated volume IMG 2 Sys: %g\n', sum(M1_img2_sys_res(:)));
fprintf('Estimated volume IMG 3 Sys: %g\n', sum(M1_img3_sys_res(:)));
fprintf('Estimated volume IMG 4 Sys: %g\n', sum(M1_img4_sys_res(:)));
fprintf('Estimated volume IMG 5 Sys: %g\n', sum(M1_img5_sys_res(:)));

%% Estimated ejected fraction
fprintf('-----Results using mathematic morfology----- \n');
fprintf('Estimated ejected fraction IMG 1: %g\n', (sum(M1_img1_dias_res(:)) - sum(M1_img1_sys_res(:)))/sum(M1_img1_dias_res(:)));
fprintf('Estimated ejected fraction IMG 2: %g\n', (sum(M1_img2_dias_res(:)) - sum(M1_img2_sys_res(:)))/sum(M1_img2_dias_res(:)));
fprintf('Estimated ejected fraction IMG 3: %g\n', (sum(M1_img3_dias_res(:)) - sum(M1_img3_sys_res(:)))/sum(M1_img3_dias_res(:)));
fprintf('Estimated ejected fraction IMG 4: %g\n', (sum(M1_img4_dias_res(:)) - sum(M1_img4_sys_res(:)))/sum(M1_img4_dias_res(:)));
fprintf('Estimated ejected fraction IMG 5: %g\n', (sum(M1_img5_dias_res(:)) - sum(M1_img5_sys_res(:)))/sum(M1_img5_dias_res(:)));
