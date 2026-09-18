%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% MAZZANTE Lorenzo
%%% SCORZA Martin
%%% FIORITI Federico
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

addpath(genpath(pwd)); 
  
folderimages = fullfile(pwd, 'images_og');

% We read and save the DICOMs 
img1_dias  = dicomread(fullfile(folderimages, 'IM-0009-0020.dcm'));
img1_sys = dicomread(fullfile(folderimages, 'IM-0009-0028.dcm'));

img2_dias  = dicomread(fullfile(folderimages, 'IM-0009-0040.dcm'));
img2_sys = dicomread(fullfile(folderimages, 'IM-0009-0048.dcm'));

img3_dias  = dicomread(fullfile(folderimages, 'IM-0009-0060.dcm'));
img3_sys = dicomread(fullfile(folderimages, 'IM-0009-0068.dcm'));

img4_dias  = dicomread(fullfile(folderimages, 'IM-0009-0080.dcm'));
img4_sys = dicomread(fullfile(folderimages, 'IM-0009-0088.dcm'));

img5_dias  = dicomread(fullfile(folderimages, 'IM-0009-0100.dcm'));
img5_sys = dicomread(fullfile(folderimages, 'IM-0009-0108.dcm'));

folderexpert = fullfile(pwd, 'Expert');

% We read and normalised the images of the expert's results
exp1_dias = imread(fullfile(folderexpert,'IM-0001-0020-icontour-manual.pgm'))/255;
exp1_sys = imread(fullfile(folderexpert,'IM-0001-0028-icontour-manual.pgm'))/255;

exp2_dias = imread(fullfile(folderexpert,'IM-0001-0040-icontour-manual.pgm'))/255;
exp2_sys = imread(fullfile(folderexpert,'IM-0001-0048-icontour-manual.pgm'))/255;

exp3_dias = imread(fullfile(folderexpert,'IM-0001-0060-icontour-manual.pgm'))/255;
exp3_sys = imread(fullfile(folderexpert,'IM-0001-0068-icontour-manual.pgm'))/255;

exp4_dias = imread(fullfile(folderexpert,'IM-0001-0080-icontour-manual.pgm'))/255;
exp4_sys = imread(fullfile(folderexpert,'IM-0001-0088-icontour-manual.pgm'))/255;

exp5_dias = imread(fullfile(folderexpert,'IM-0001-0100-icontour-manual.pgm'))/255;
exp5_sys = imread(fullfile(folderexpert,'IM-0001-0108-icontour-manual.pgm'))/255;

%% ================== 1. Plot original images =========================
figure;
subplot(2,5,1);
imagesc(img1_dias); colormap('gray'); title('Image1 Diastole Original');
subplot(2,5,6);
imagesc(img1_sys); colormap('gray'); title('Image1 Systole Original');

subplot(2,5,2);
imagesc(img2_dias); colormap('gray'); title('Image2 Diastole Original');
subplot(2,5,7);
imagesc(img2_sys); colormap('gray'); title('Image2 Systole Original');

subplot(2,5,3);
imagesc(img3_dias); colormap('gray'); title('Image3 Diastole Original');
subplot(2,5,8);
imagesc(img3_sys); colormap('gray'); title('Image3 Systole Original');

subplot(2,5,4);
imagesc(img4_dias); colormap('gray'); title('Image4 Diastole Original');
subplot(2,5,9);
imagesc(img4_sys); colormap('gray'); title('Image4 Systole Original');

subplot(2,5,5);
imagesc(img5_dias); colormap('gray'); title('Image5 Diastole Original');
subplot(2,5,10);
imagesc(img5_sys); colormap('gray'); title('Image5 Systole Original');

%% ================== 2. Plot zone of interest =============================
idx1 = 70;  % Initial point of the zone we want to analyse
idx2 = 170; % Last point of the zone we want to analyse

% We separate the zones in each image
img1_dias_carre = img1_dias(idx1:idx2,idx1:idx2);
img2_dias_carre = img2_dias(idx1:idx2,idx1:idx2);
img3_dias_carre = img3_dias(idx1:idx2,idx1:idx2);
img4_dias_carre = img4_dias(idx1:idx2,idx1:idx2);
img5_dias_carre = img5_dias(idx1:idx2,idx1:idx2);

img1_sys_carre  = img1_sys(idx1:idx2,idx1:idx2);
img2_sys_carre  = img2_sys(idx1:idx2,idx1:idx2);
img3_sys_carre  = img3_sys(idx1:idx2,idx1:idx2);
img4_sys_carre  = img4_sys(idx1:idx2,idx1:idx2);
img5_sys_carre  = img5_sys(idx1:idx2,idx1:idx2);

% Results of the zones selection
figure;
subplot(2,5,6);
imagesc(img1_sys_carre); colormap('gray'); title('Image1 Systole Reduced');
subplot(2,5,1);
imagesc(img1_dias_carre); colormap('gray'); title('Image1 Diastole Reduced');

subplot(2,5,7);
imagesc(img2_sys_carre); colormap('gray'); title('Image2 Systole Reduced');
subplot(2,5,2);
imagesc(img2_dias_carre); colormap('gray'); title('Image2 Diastole Reduced');

subplot(2,5,8);
imagesc(img3_sys_carre); colormap('gray'); title('Image3 Systole Reduced');
subplot(2,5,3);
imagesc(img3_dias_carre); colormap('gray'); title('Image3 Diastole Reduced');

subplot(2,5,9);
imagesc(img4_sys_carre); colormap('gray'); title('Image4 Systole Reduced');
subplot(2,5,4);
imagesc(img4_dias_carre); colormap('gray'); title('Image4 Diastole Reduced');

subplot(2,5,10);
imagesc(img5_sys_carre); colormap('gray'); title('Image5 Systole Reduced');
subplot(2,5,5);
imagesc(img5_dias_carre); colormap('gray'); title('Image5 Diastole Reduced');

%% ================== 3. Transformation S-curve =======================
k  = 10;  % The slope of the S-curve
x0 = 0.5; % The medium point of the S-curve

% We make a S-curve that elevate the contrast near the medium point
s_curve = @(I) 1 ./ (1 + exp(-k * (I - x0)));

% We aplicate the s-curve to all the images
img1_sys_S   = s_curve(mat2gray(img1_sys_carre));
img2_sys_S   = s_curve(mat2gray(img2_sys_carre));
img3_sys_S   = s_curve(mat2gray(img3_sys_carre));
img4_sys_S   = s_curve(mat2gray(img4_sys_carre));
img5_sys_S   = s_curve(mat2gray(img5_sys_carre));

img1_dias_S  = s_curve(mat2gray(img1_dias_carre));
img2_dias_S  = s_curve(mat2gray(img2_dias_carre));
img3_dias_S  = s_curve(mat2gray(img3_dias_carre));
img4_dias_S  = s_curve(mat2gray(img4_dias_carre));
img5_dias_S  = s_curve(mat2gray(img5_dias_carre));

% We plot the results
figure;
subplot(2,5,6);
imagesc(img1_sys_S); colormap('gray'); title('Image1 Systole S-curve');
subplot(2,5,1);
imagesc(img1_dias_S); colormap('gray');title('Image1 Diastole S-curve');

subplot(2,5,7);
imagesc(img2_sys_S); colormap('gray');title('Image2 Systole S-curve');
subplot(2,5,2);
imagesc(img2_dias_S); colormap('gray');title('Image2 Diastole S-curve');

subplot(2,5,8);
imagesc(img3_sys_S); colormap('gray');title('Image3 Systole S-curve');
subplot(2,5,3);
imagesc(img3_dias_S); colormap('gray');title('Image3 Diastole S-curve');

subplot(2,5,9);
imagesc(img4_sys_S); colormap('gray');title('Image4 Systole S-curve');
subplot(2,5,4);
imagesc(img4_dias_S); colormap('gray');title('Image4 Diastole S-curve');

subplot(2,5,10);
imagesc(img5_sys_S); colormap('gray');title('Image5 Systole S-curve');
subplot(2,5,5);
imagesc(img5_dias_S); colormap('gray');title('Image5 Diastole S-curve');

%% ================== 4. Binarization ================================

% We make a binarization of the images
% The limit of the binaritation we use is determinated manually and adapted
% for each image to get the best result

img1_dias_bin  = imbinarize(img1_dias_S);
img2_dias_bin  = imbinarize(img2_dias_S, 0.23);
img3_dias_bin  = imbinarize(img3_dias_S, 0.3);
img4_dias_bin  = imbinarize(img4_dias_S, 0.3);
img5_dias_bin  = imbinarize(img5_dias_S, 0.3);

img1_sys_bin = imbinarize(img1_sys_S, 0.35);
img2_sys_bin = imbinarize(img2_sys_S, 0.18);
img3_sys_bin = imbinarize(img3_sys_S, 0.25);
img4_sys_bin = imbinarize(img4_sys_S, 0.35);
img5_sys_bin = imbinarize(img5_sys_S, 0.31);

% We show the images after binarization
figure;
subplot(2,5,6);
imagesc(img1_sys_bin); colormap('gray'); title('Image1 Systole Binarized');
subplot(2,5,1);
imagesc(img1_dias_bin); colormap('gray');title('Image1 Diastole Binarized');

subplot(2,5,7);
imagesc(img2_sys_bin); colormap('gray');title('Image2 Systole Binarized');
subplot(2,5,2);
imagesc(img2_dias_bin); colormap('gray');title('Image2 Diastole Binarized');

subplot(2,5,8);
imagesc(img3_sys_bin); colormap('gray');title('Image3 Systole Binarized');
subplot(2,5,3);
imagesc(img3_dias_bin); colormap('gray');title('Image3 Diastole Binarized');

subplot(2,5,9);
imagesc(img4_sys_bin); colormap('gray');title('Image4 Systole Binarized');
subplot(2,5,4);
imagesc(img4_dias_bin); colormap('gray');title('Image4 Diastole Binarized');

subplot(2,5,10);
imagesc(img5_sys_bin); colormap('gray');title('Image5 Systole Binarized');
subplot(2,5,5);
imagesc(img5_dias_bin); colormap('gray');title('Image5 Diastole Binarized');


