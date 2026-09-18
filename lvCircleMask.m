%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Function lvCircleMask(imgBin, rRange, sensitivity, figureName)
%%% - imgBin = The binary image
%%% - rRange = Range of the radius
%%% - sensitivity 
%%% - figureName (to print)
%%%
%%% - maskCircle = The mask with the values of the circle
%%% - center = The center of the circle
%%% - radius = The radius of the circle
%%% - metric = Confidence score of the selected circle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This function detects the left-ventricle (LV) cavity by approximating it
% as a circle in a binary image. It uses imfindcircles to search for bright,
% circular structures within a given radius range, then selects the
% circle whose center is closest to the right. Finally, it
% returns a filled binary mask corresponding to the selected circle, along
% with its center, radius, and metric.

function [maskCircle, center, radius, metric] = lvCircleMask(imgBin, rRange, sensitivity, figureName)

    % Defaults (To avoid empty variables)
    [rows, cols] = size(imgBin);
    maskCircle = false(rows, cols);
    center = [NaN NaN];
    radius = NaN;
    metric = NaN;

    % To find the circle between the rRange of the picture that is
    % brighter than the background and using the sensitivity given.
    [centers, radii, metrics] = imfindcircles(imgBin, rRange, ...
        'ObjectPolarity','bright', 'Sensitivity', sensitivity);
    
    % In case there is no circle detected
    if isempty(centers)
        warning("No circle found in %s (r=[%g %g], sens=%g). Returning empty mask.", ...
            figureName, rRange(1), rRange(2), sensitivity);
        return; % We return the default values
    end

    % We chose the circle that is closest to the right.
    [~, idx] = max(centers(:,1));
    % We save the metrics, radius and center of the circle
    metric = metrics(idx);
    center = centers(idx,:);
    radius = radii(idx);

    % We declare a figure and show the binary image with the circle
    % detected in colour
    figure('Name', ['DEBUG - ' figureName], 'NumberTitle','off');
    imshow(imgBin, []); hold on;
    viscircles(center, radius, 'EdgeColor','b');
    title(['C?rculo detectado - ' figureName]);
    hold off;

    % Construction of the binary mask that shows the pixels of the circle
    [X, Y] = meshgrid(1:cols, 1:rows);
    maskCircle = (X - center(1)).^2 + (Y - center(2)).^2 <= radius^2;
end
