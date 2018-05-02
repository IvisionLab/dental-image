function g = localthresh(f, nhood, a, b, meantype, numImagem, diretorio_categoria)
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
    
     % Diretório para gravar as imagens segmentadas
%     dir_local_thresholding = [diretorio_categoria 'segmentadas\thresholding\thresholding_local\'];
    % Diretório para gravar as imagens segmentadas considerando apenas o
    % ROI obtido
    dir_local_thresholding_roi = [diretorio_categoria 'segmentadas\thresholding\thresholding_local\roi_automatico\'];
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
    imgSegmentada = (f > a*SIG) & (f > b*MEAN);
%     g = double(imgSegmentada) .* regiaoInteresse;  
      % Gravo as imagens segmentadas no diretório especificado
%       imwrite(imgSegmentada,[dir_local_thresholding,num2str(numImagem),'.bmp'],'bmp');
      % Gravo o ROI das imagens segmentadas no diretório especificado
      imwrite(imgSegmentada,[dir_local_thresholding_roi,num2str(numImagem),'.bmp'],'bmp');
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


