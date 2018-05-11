function fcmeans_gil_jader(dir_cat, image, ROI, numimage)

    dir_cmeans = [dir_cat 'segmented_images\clustering\cmeans\'];
    dir_cmeans_roi = [dir_cat 'segmented_images\clustering\cmeans\roi\'];
    
    im=image;
    fim=mat2gray(im);
    [bwfim1,level1]=fcmthresh(fim,1);
%     imshow(bwfim1);title(sprintf('FCM1,level=%f',level1));
    

    result_roi = double(bwfim1) .* ROI;

      % I write the images segmented in the specified directory
      imwrite(bwfim1,[dir_cmeans,num2str(numimage),'.bmp'],'bmp');
      % I write the ROI of the images segmented in the specified directory
      imwrite(result_roi,[dir_cmeans_roi,num2str(numimage),'.bmp'],'bmp');


end

