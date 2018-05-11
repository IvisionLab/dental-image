function sobel_gil_jader(dir_cat, image, ROI, numimage)

    dir_sobel = [dir_cat 'segmented_images\edge\sobel\'];
    dir_sobel_roi = [dir_cat 'segmented_images\edge\sobel\roi\'];
    
    BW = edge(image,'Sobel');   

    result_roi = double(BW) .* ROI;

      % I record the segmented images in the specified directory
      imwrite(BW,[dir_sobel,num2str(numimage),'.bmp'],'bmp');
      % Record the ROI of the segmented images in the specified directory
      imwrite(result_roi,[dir_sobel_roi,num2str(numimage),'.bmp'],'bmp');


end

