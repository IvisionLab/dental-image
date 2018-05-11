function basic_global_thresholding_gil_jader(dir_cat, image, T, highestValue, deltaT, numimage)
%     image = imcrop(image,[337 316 1312 554]);
%     image = imadjust(image, [0 1], [1 0]);
%  image = imadjust(image, stretchlim(image), [1 0]);
    % Directory to record segmented images
%     dir_basic_global_thresholding = [dir_cat 'segmented_images\thresholding\global_thresholding\'];
    % Directory to write the images segmented considering only the ROI obtained
    dir_basic_global_thresholding_roi = [dir_cat 'segmented_images\thresholding\global_thresholding\roi\'];
    count = 0;
    done = false;
    while ~done
        count = count + 1;
        imgSegmented = image > T;
        Tnext = 0.5*(mean(image(imgSegmented)) + mean(image(~imgSegmented)));
        done = abs(T - Tnext) < deltaT;
        T = Tnext;
    end
%     count
    T
    deltaT
    imgSegmented = im2bw(image, T/highestValue); % i.e. 222 is the highest pixel intensity value of the image 
    imshow(image) % original image
%     figure, imhist(image) % Hist of the image
    figure, imshow(imgSegmented) % image segmented by basic_global_thresholding
%     figure, imshow(result) % Display of the segmented image considering only the gegen of interest

      % I write the images segmented in the specified directory
%       imwrite(imgSegmented,[dir_basic_global_thresholding,num2str(numimage),'.bmp'],'bmp');
      % I write the ROI of the images segmented in the specified directory
%       imwrite(imgSegmented,[dir_basic_global_thresholding_roi,num2str(numimage),'.bmp'],'bmp');
end


