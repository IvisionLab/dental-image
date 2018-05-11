function active_contour_gil_jader(dir_cat, image, ROI, numimage)

    dir_active_contour = [dir_cat 'segmented_images\boundary\active_contour\'];
    dir_active_contour_roi = [dir_cat 'segmented_images\boundary\active_contour\roi\'];
    
    m = zeros(size(image));
    m(25:end-25,25:end-25) = 1;
    BW = chenvese(image,m,500,0.1,'chan');
        
    ROI = imresize(ROI, [200, 354]);

    result_roi = double(BW) .* ROI;

%       I record the segmented images in the specified directory
      imwrite(BW,[dir_active_contour,num2str(numimage),'.bmp'],'bmp');
%       Record the ROI of the segmented images in the specified directory
      imwrite(result_roi,[dir_active_contour_roi,num2str(numimage),'.bmp'],'bmp');


end

