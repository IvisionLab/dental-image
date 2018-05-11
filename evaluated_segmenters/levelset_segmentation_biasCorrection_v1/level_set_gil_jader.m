function level_set_gil_jader(dir_cat, image, ROI, numimage)

    dir_level_set = [dir_cat 'segmented_images\boundary\level_set\'];
    dir_level_set_roi = [dir_cat 'segmented_images\boundary\level_set\roi\'];
    
   
    Img = imresize(image, [198, 350]);
    Img=double(Img(:,:,1));
    A=255;
    Img=A*normalize01(Img); % rescale the image intensities
    nu=0.001*A^2; % coefficient of arc length term

    sigma = 4; % scale parameter that specifies the size of the neighborhood
    iter_outer=50; 
    iter_inner=10;   % inner iteration for level set evolution

    timestep=.1;
    mu=1;  % coefficient for distance regularization term (regularize the level set function)

    c0=1;

    % initialize level set function
    initialLSF = c0*ones(size(Img));
    initialLSF(30:90,50:90) = -c0;
    u=initialLSF;


    epsilon=1;
    b=ones(size(Img));  %%% initialize bias field

    K=fspecial('gaussian',round(2*sigma)*2+1,sigma); % Gaussian kernel
    KI=conv2(Img,K,'same');
    KONE=conv2(ones(size(Img)),K,'same');

    [row,col]=size(Img);
    N=row*col;

    for n=1:iter_outer
        [u, b, C]= lse_bfe(u,Img, b, K,KONE, nu,timestep,mu,epsilon, iter_inner);

    end
    Mask =(Img>10);
    Img_corrected=normalize01(Mask.*Img./(b+(b==0)))*255;


    BW = im2bw(uint8(Img_corrected));
   
        
    ROI = imresize(ROI, [198, 350]);

    result_roi = double(BW) .* ROI;

%       I write the images segmented in the specified directory
      imwrite(BW,[dir_level_set,num2str(numimage),'.bmp'],'bmp');
%       I write the ROI of the images segmented in the specified directory
      imwrite(result_roi,[dir_level_set_roi,num2str(numimage),'.bmp'],'bmp');


end

