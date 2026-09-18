%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Lecture and results of the expert's analyse
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Image of the heart after the analyse
figure;
subplot(2,5,6);
imagesc(exp1_sys); colormap('gray'); title('Expert Image1 Systole');
subplot(2,5,1);
imagesc(exp1_dias); colormap('gray'); title('Expert Image1 Dyastole');

subplot(2,5,7);
imagesc(exp2_sys); colormap('gray'); title('Expert Image2 Systole');
subplot(2,5,2);
imagesc(exp2_dias); colormap('gray'); title('Expert Image2 Dyastole');

subplot(2,5,8);
imagesc(exp3_sys); colormap('gray'); title('Expert Image3 Systole');
subplot(2,5,3);
imagesc(exp3_dias); colormap('gray'); title('Expert Image3 Dyastole');

subplot(2,5,9);
imagesc(exp4_sys); colormap('gray'); title('Expert Image4 Systole');
subplot(2,5,4);
imagesc(exp4_dias); colormap('gray'); title('Expert Image4 Dyastole');

subplot(2,5,10);
imagesc(exp5_sys); colormap('gray'); title('Expert Image5 Systole');
subplot(2,5,5);
imagesc(exp5_dias); colormap('gray'); title('Expert Image5 Dyastole');

%% Expected volume results
fprintf('-----Expected results (expert results)----- \n');
fprintf('Expected volume (experts) IMG 1 Dias: %g\n', sum(exp1_dias(:)));
fprintf('Expected volume (experts) IMG 2 Dias: %g\n', sum(exp2_dias(:)));
fprintf('Expected volume (experts) IMG 3 Dias: %g\n', sum(exp3_dias(:)));
fprintf('Expected volume (experts) IMG 4 Dias: %g\n', sum(exp4_dias(:)));
fprintf('Expected volume (experts) IMG 5 Dias: %g\n', sum(exp5_dias(:)));
fprintf('Expected volume (experts) IMG 1 Sys: %g\n', sum(exp1_sys(:)));
fprintf('Expected volume (experts) IMG 2 Sys: %g\n', sum(exp2_sys(:)));
fprintf('Expected volume (experts) IMG 3 Sys: %g\n', sum(exp3_sys(:)));
fprintf('Expected volume (experts) IMG 4 Sys: %g\n', sum(exp4_sys(:)));
fprintf('Expected volume (experts) IMG 5 Sys: %g\n', sum(exp5_sys(:)));

%% Expected ejection fraction
fprintf('-----Expected results (expert results)----- \n');
fprintf('Ejection fraction (theoretical) IMG 1: %g\n', (sum(exp1_dias(:)) - sum(exp1_sys(:)))/sum(exp1_dias(:)));
fprintf('Ejection fraction (theoretical) IMG 2: %g\n', (sum(exp2_dias(:)) - sum(exp2_sys(:)))/sum(exp2_dias(:)));
fprintf('Ejection fraction (theoretical) IMG 3: %g\n', (sum(exp3_dias(:)) - sum(exp3_sys(:)))/sum(exp3_dias(:)));
fprintf('Ejection fraction (theoretical) IMG 4: %g\n', (sum(exp4_dias(:)) - sum(exp4_sys(:)))/sum(exp4_dias(:)));
fprintf('Ejection fraction (theoretical) IMG 5: %g\n', (sum(exp5_dias(:)) - sum(exp5_sys(:)))/sum(exp5_dias(:)));
