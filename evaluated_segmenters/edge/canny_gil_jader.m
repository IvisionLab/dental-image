function canny_gil_jader(dir_cat, image, ROI, numimage)

    dir_canny = [dir_cat 'segmented_images\edge\canny\'];
    dir_canny_roi = [dir_cat 'segmented_images\edge\canny\roi\'];
    
    BW = edge(image,'Canny');
%     imshow(bwfim1);title(sprintf('FCM1,level=%f',level1));
    

    result_roi = double(BW) .* ROI;

      % I write the images segmented in the specified directory
      imwrite(BW,[dir_canny,num2str(numimage),'.bmp'],'bmp');
      % I write the ROI of the images segmented in the specified directory
      imwrite(result_roi,[dir_canny_roi,num2str(numimage),'.bmp'],'bmp');


end

