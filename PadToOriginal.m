%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Function PadToOriginal(mask_small, idx1, idx2, originalSize
%%% - mask_small = The mask we want to expand
%%% - idx1 = Starting index of the mask in the original image
%%% - idx2 = Ending index of the mask in the original image
%%% - OrginalSize = The size that the immage will have at the expantion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function big = PadToOriginal(mask_small, idx1, idx2, originalSize)
    % We create a zero matrix with the original size
    big = zeros(originalSize);
    % We replace the values of the mask in the correct place
    big(idx1:idx2, idx1:idx2) = mask_small;
end


