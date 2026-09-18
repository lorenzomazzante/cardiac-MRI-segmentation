%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Function bestLVMaskFromLabels(I8, L)
%%% - I8 = Image uint8 
%%% - L = The mask with the clusters
%%%
%%% - maskLV = The mask with the left ventricle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This function selects the most likely left-ventricle (LV) cavity mask
% from the k-means label image by scoring connected components using
% intensity (blood is brighter), position (typically on the right),
% and shape descriptors (compact/circular regions).

function maskLV = bestLVMaskFromLabels(I8, L)

    [rows, cols] = size(I8); % Save the size of the image
    K = double(max(L(:))); % To know the number of clusters

    % We accept only the surface between the A_min and the A_max to avoid
    % detecting formes really big or really small
    A_min = round(0.002 * rows * cols);   % 0.2%
    A_max = round(0.30  * rows * cols);   % 30% 

    % We declare the best value with -inf and an empty mask
    bestVal = -Inf;
    maskLV  = false(rows, cols);
    
    % We analyse each cluster
    for lab = 1:K
        % Compare the L with the lab and complete the m with true or false
        m = (L == lab);

        % Eliminate the zones coonected that are smaller than the A_min
        m = bwareaopen(m, A_min);
        
        % Found conected components in m
        CC = bwconncomp(m);
        
        % If there is not components concected, it continue with the next
        % label
        if CC.NumObjects == 0, continue; end
        
        % Compute geometric and intensity features for each connected component
        stats = regionprops(CC, I8, "Area","Centroid","MeanIntensity","Perimeter","Solidity","Eccentricity","BoundingBox");

        % Evaluate each component and keep the one with the highest score
        for i = 1:numel(stats)
            A  = stats(i).Area;
            cx = stats(i).Centroid(1);
            mi = stats(i).MeanIntensity;
            P  = stats(i).Perimeter;
            sol = stats(i).Solidity;
            ecc = stats(i).Eccentricity; % 0 = circle and 1 = oval 
            bb  = stats(i).BoundingBox; % [x y width height]

            % circularity (1 ideal)
            circ = 4*pi*A / (P^2 + eps);

            % If the area is lower or higher than the limits, we discart it
            if A < A_min || A > A_max
                continue;
            end
            
            % Reject components that touch the ROI border (background)
            touchesBorder = (bb(1) <= 1) || (bb(2) <= 1) || ((bb(1)+bb(3)) >= cols) || ((bb(2)+bb(4)) >= rows);
            if touchesBorder
                continue;
            end

            % REject components in the left, in this dataset, the LV cavity is expected on the right
            if cx < 0.55*cols
                continue;
            end

            % Enforce minimum circularity and solidity
            if circ < 0.35 || sol < 0.75
                continue;
            end

            % internal score (NOT returned)
            nx   = cx/cols;
            nmi  = double(mi)/255;
            val = 2.0*nmi + 1.5*nx + 1.0*circ + 0.8*sol - 0.6*ecc + 0.3*log(A+1);

            % Keep the best-scoring component as the LV mask
            if val > bestVal
                bestVal = val;
                maskLV = false(rows, cols);
                maskLV(CC.PixelIdxList{i}) = true;
            end
        end
    end

    % 2) Fallback if nothing passed the strict filters
    if bestVal == -Inf
        % Allow lower circularity/solidity but still avoid border components
        for lab = 1:K
            m = bwareaopen(L == lab, A_min);
            CC = bwconncomp(m);
            if CC.NumObjects == 0, continue; end
            stats = regionprops(CC, I8, "Area","Centroid","MeanIntensity","Perimeter","Solidity","Eccentricity","BoundingBox");

            for i = 1:numel(stats)
                A  = stats(i).Area;
                cx = stats(i).Centroid(1);
                mi = stats(i).MeanIntensity;
                P  = stats(i).Perimeter;
                sol = stats(i).Solidity;
                ecc = stats(i).Eccentricity;
                bb  = stats(i).BoundingBox;

                circ = 4*pi*A / (P^2 + eps);
                
                %Basic area and border filtering
                if A < A_min || A > A_max, continue; end
                touchesBorder = (bb(1) <= 1) || (bb(2) <= 1) || ((bb(1)+bb(3)) >= cols) || ((bb(2)+bb(4)) >= rows);
                if touchesBorder, continue; end

                % Here we only keep the "right side"
                if cx < 0.55*cols, continue; end

                nx = cx/cols; nmi = double(mi)/255;
                val = 2.0*nmi + 1.5*nx + 0.6*circ + 0.4*sol - 0.5*ecc + 0.2*log(A+1);

                if val > bestVal
                    bestVal = val;
                    maskLV = false(rows, cols);
                    maskLV(CC.PixelIdxList{i}) = true;
                end
            end
        end
    end

    % 3) Final post-processing
    maskLV = imfill(maskLV, "holes");               % fill internal holes
    maskLV = imclose(maskLV, strel("disk", 3));     % smooth boundary
    maskLV = imopen(maskLV, strel("disk", 1));      % remove noise
    maskLV = bwareafilt(maskLV, 1);                 % leave the bigger component
end