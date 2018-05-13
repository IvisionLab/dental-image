% ---------------------------------------------------------------------------------------------------------------------------------% 
% --------------------------------------------Developed by: Gil Jader ---------------------------------------------------%
% ---------------------------------------------------gil.jader@gmail.com-----------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------%
%   Main function used to execute and evaluate segmenting algorithms   %
function exec_segmenting()
    clc;
    clear;
    close all;
    
   % Images root directory
   dir_root = 'D:\DOCTORATE_DEGREE\THESIS\classified_panoramic_X-ray_images_dataset\';
    
   % Directory of the images of the CATEGORY 1
   dir_cat1 = [dir_root 'cat1\cropped_images\'];
   % Directory of the images of the CATEGORY 2
   dir_cat2 = [dir_root 'cat2\cropped_images\'];
   % Directory of the images of the CATEGORY 3
   dir_cat3 = [dir_root 'cat3\cropped_images\'];
   % Directory of the images of the CATEGORY 4
   dir_cat4 = [dir_root 'cat4\cropped_images\'];
   % Directory of the images of the CATEGORY 5
   dir_cat5 = [dir_root 'cat5\cropped_images\'];
   % Directory of the images of the CATEGORY 6
   dir_cat6 = [dir_root 'cat6\cropped_images\'];
   % Directory of the images of the CATEGORY 7
   dir_cat7 = [dir_root 'cat7\cropped_images\'];
   % Directory of the images of the CATEGORY 8
   dir_cat8 = [dir_root 'cat8\cropped_images\'];
   % Directory of the images of the CATEGORY 9
   dir_cat9 = [dir_root 'cat9\cropped_images\'];
   % Directory of the images of the CATEGORY 10
   dir_cat10 = [dir_root 'cat10\cropped_images\'];
   
   % images to be processed
   proc_segmenting(dir_cat2);
end

function  proc_segmenting(dir_cat)   
       % images from category 
       image_files = dir([dir_cat '*.jpg']);
        % Check the total of original images of the category
       tot_images = size(image_files, 1);
       
      % Directory of binary images of the category
      binary_directory = [dir_cat 'annotated_images\'];
      
       % Directory of binary images of mouths of the category
      binary_directory_mouth = [dir_cat 'annotated_images\Mouth\'];

      %Variable to add all averages;
      SumAverage = 0;
      seeds = [];
       % image to image search 
       for i = 1 : tot_images
        if (i > 1)
            break;
        end;

           % I get the Name of the Original Images (images inside the Loop)
           filenameOri = [dir_cat num2str(i) '.jpg'];
           % I get the Name of Binary Images (images inside the Loop)
           filenameBw = [binary_directory num2str(i) '.bmp'];
           % I get the Name of Binary Images - Mouth (image inside the Loop)
           filenameBwMouth = [binary_directory_mouth num2str(i) '.bmp'];
           
           % I display the name of each image to follow the process
           disp(filenameOri)
           
           % I read the original image
            imgOri = imread(filenameOri);

           % I read the binary image
            imgBw = imread(filenameBw);
           % I read the binary image of the mouth
            imgBwMouth = imread(filenameBwMouth);
           
            % Image of x-ray is in RGB format
            % Convert the original RGB image to Grayscale
            imgOriGray = rgb2gray(imgOri);

            % Image of the teeth region is in logical format
            % converting Bw logical to double and setting values 0 to negative.
                filenameBwNeg = im2double(imgBw);
                filenameBwNeg(filenameBwNeg==0)=-1;
                
            % Image of the mouth region is in logical format
            % converting BwMouth logical to double and setting values 0 to negative.
                filenameBwNegMouth = im2double(imgBwMouth);
                filenameBwNegMouth(filenameBwNegMouth==0)=-1;

            %Creating the new array on top of the mask
            %A matriz deverá ser processada no tipo double. Para visualizar será
            imm = double(imgOriGray);
            imm(imm<=0)=-1;
            
            %Creating the new matrix on top of the Mouth mask
            %The array must be processed in double type. To view it will be
            immMouth = double(imgOriGray);
            immMouth(immMouth<=0)=-1;
            
            % I get the only values that are part of the ROI and store
            % in a vector to perform the operations 
            MatrixROI = imm(imm>=0);
            MatrixROIMouth = immMouth(immMouth>=0);

            % I get the size of the ROI array dimensions
            s = size(MatrixROIMouth); 
            [c,r] = meshgrid(1:s(1),1:s(2));
            r = r(:);
            c = c(:);
            
             % I call functions to calculate statistics           
            maxValue = max(MatrixROIMouth); 
            minValue = min(MatrixROIMouth); 
            Average = calcAverage(MatrixROIMouth);
            StandardDeviation = std2(MatrixROIMouth);
            Entropy = calcEntropy(MatrixROIMouth);
            deltaT = Entropy / StandardDeviation;     
            
% imshow(filenameBw)
%             watershed_marker_controlled_gil_jader(imgOri, filenameBwNegMouth, dir_cat, i);
                       
%             region_splitting_merging_gil_jader(dir_cat, imgOriGray, filenameBwNegMouth, i, Entropy);
             
%             basic_global_thresholding_gil_jader(dir_cat, imgOriGray, filenameBwNegMouth, Average, maxValue, deltaT, i)
             
%             fcmeans_gil_jader(dir_cat, imgOri, filenameBwNegMouth,  i)

%             canny_gil_jader(dir_cat, imgOriGray, filenameBwNegMouth,  i)
   
%             sobel_gil_jader(dir_cat, imgOriGray, filenameBwNegMouth,  i)
   
%             active_contour_gil_jader(dir_cat, imgOriGray, filenameBwNegMouth, i)

%             level_set_gil_jader(dir_cat, imgOriGray, filenameBwNegMouth, i)

%             localthresh_gil_jader(imgOriGray, ones(3), 1,1, 'global',i, filenameBwNegMouth, dir_cat);
%             SIG = stdfilt(uint8(immBoca), ones(3));
%             figure, imshow(SIG, [])
%             figure, imshow(g)



       end 

end


% ------------------------------------------------------------------------------------------------------------- %
% Function to SEGMENT images using the region growing function
function segment_region_growing(dir_cat, I, num, imbw, ROI)
                        
            % ***** information about the images ******
            % imshow(filenameBwNeg)
            cc = bwconncomp(imbw, 8);
            labeled = labelmatrix(cc);
            % whos labeled
            % labels = label2rgb(labeled, @spring, 'c', 'shuffle');
            % imshow(labels)
            graindata = regionprops(cc,'basic');
            centroids = [graindata.Centroid];

            % ***** Distribute the centroids in lines ******
            k=1;
            t=1;
            j=1;
             while j<=size(centroids,2)
               while t <= 2 
                    seeds(k,t) = centroids(1,j);  
                    t = t + 1;
                    j = j + 1;
               end
               t=1;
               k = k + 1;
             end
            % Round the values of the final matrix of seeds
            seeds = round(seeds);
            % size(seeds)
        
        I = im2double(I);
        mask = zeros(size(I,1),size(I,2));
        xy = seeds;
        
        for ii=1:size(xy,1)
            
            RG = region_growing_gil_jader(I,xy(ii,2),xy(ii,1),0.1);
            mask = mask +RG(:,:,1);
            
        end
        imgSegmented = im2bw(mask);
        result = double(imgSegmented) .* ROI;
        
        % Directory to record segmented images
        dir_region_growing = [dir_cat 'segmented_images\region\region_gowin\'];
        imwrite(imgSegmented,[dir_region_growing,num2str(num),'.bmp'],'bmp');
        % Directory to record the segmented images considering only the ROI obtained
        dir_region_growing_roi = [dir_cat 'segmented_images\region\region_gowin\roi\'];
        imwrite(result,[dir_region_growing_roi,num2str(num),'.bmp'],'bmp');
   
end 



%--------------------------- Calc Entropy --------------------------------------------------
function Entropy = calcEntropy(roi)
    % Reference: Haralick RM, Shapiro LG. Computer and Robot Vision: Vol. 1,
    % Addison-Wesley, 1992, p. 460.  
        frequency = histc(roi,0:255);

        prob = frequency ./ numel(roi);  %the numel function returns the number of elements in an array (thus verifying the probability of occurrence of each element)        
        Entropy = -sum(prob.*log2(prob+eps)); % cal entropy
end


  
%---------------------------Calc Average--------------------------------------------------
function M = calcAverage(roi)
    %   Copyright 1993-2005 The MathWorks, Inc.
    %   $Revision: 5.19.4.6 $  $Date: 2006/06/15 20:09:12 $
    M = sum(roi(:), [], 'double') / numel(roi);
end    




