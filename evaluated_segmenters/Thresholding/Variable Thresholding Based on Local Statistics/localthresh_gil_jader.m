function g = localthresh_gil_jader(f, nhood, a, b, meantype, numImage, dir_cat)
    %LOCALTHRESH Local thresholding.
    % G = LOCALTHRESH(F, NHOOD, A, B, MEANTYPE) thresholds image F by
    % computing a local threshold at the center,(x, y), of every
    % neighborhood in F. The size of the neighborhoods is defined by
    % NHOOD, an array of zeros and ones in which the nonzero elements
    % specify the neighbors used in the computation of the local mean
    % and standard deviation. The size of NHOOD must be odd in both
    % dimensions.
    %
    % The segmented image is given by
    %
    %       1 if (F > A*SIG) AND (F > B*MEAN)
    % G = 
    %       0 otherwise
    % where SIG is an array of the same size as F containing the local
    % standard deviations. If MEANTYPE = 'local' (the default), then
    % MEAN is an array of local means. If MEANTYPE = 'global', then
    % MEAN is the global (image) mean, a scalar. Constants A and B
    % are nonnegative scalars.
    
     % Directory to write segmented images
%     dir_local_thresholding = [dir_cat 'segmented_images\thresholding\thresholding_local\'];
    % Directory to write the images segmented considering only the ROI obtained
    dir_local_thresholding_roi = [dir_cat 'segmented_images\thresholding\thresholding_local\roi\'];
    % Intialize.
    % Compute the local standard deviations.
    SIG = stdfilt(f, nhood);
    % Compute MEAN.
    if nargin == 8 && strcmp (meantype, 'global' )
        MEAN = mean2 (f) ;
    else
        MEAN = localmean(f, nhood); % This is a custom function.
    end
    % Obtain the segmented image.
    imgSegmented = (f > a*SIG) & (f > b*MEAN); 
      % I write the images segmented in the specified directory
%       imwrite(imgSegmented,[dir_local_thresholding,num2str(numImage),'.bmp'],'bmp');
      % I write the ROI of the images segmented in the specified directory
      imwrite(imgSegmented,[dir_local_thresholding_roi,num2str(numImage),'.bmp'],'bmp');
end

function mean = localmean(f, nhood)
    %LOCALMEAN Computes an array of local means.
    % MEAN = LOCALMEAN(F, NHOOD) computes the mean at the center of
    % every neighborhood of F defined by NHOOD, an array of zeros and
    % ones where the nonzero elements specify the neighbors used in the
    % computation of the local means. The size of NHOOD must be odd in
    % each dimension; the default is ones(3). Output MEAN is an array
    % the same size as F containing the local mean at each point.
    if nargin == 1
    nhood = ones(3) / 9;
    else
    nhood = nhood / sum(nhood(:));
    end
    mean = imfilter(f, nhood, 'replicate');
end


