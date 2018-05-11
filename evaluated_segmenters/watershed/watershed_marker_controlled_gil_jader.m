function watershed_marker_controlled(rgb, ROI, dir_cat, numImagem)

%Step 1: Read in the Color Image and Convert it to Grayscale
%     rgb = imread('PAN_modif4.jpg');
    I = rgb2gray(rgb);
%     imshow(I)

%Step 2: Use the Gradient Magnitude as the Segmentation Function
    hy = fspecial('sobel');
    hx = hy';
    Iy = imfilter(double(I), hy, 'replicate');
    Ix = imfilter(double(I), hx, 'replicate');
    gradmag = sqrt(Ix.^2 + Iy.^2);
% % % % % %     figure
% % % % % %     imshow(gradmag,[]), title('Gradient magnitude (gradmag)')
    
%Can you segment the image by using the watershed transform directly on the gradient magnitude?    
L = watershed(gradmag);
Lrgb = label2rgb(L);
% % % % % % figure, imshow(Lrgb), title('Watershed transform of gradient magnitude (Lrgb)')
 
%Step 3: Mark the Foreground Objects
    se = strel('disk', 20);
    Io = imopen(I, se);
% % % % %     figure
% % % % %     imshow(Io), title('Opening (Io)')

%Next compute the opening-by-reconstruction using imerode and imreconstruct.    
    Ie = imerode(I, se);
    Iobr = imreconstruct(Ie, I);
% % % % %     figure
% % % % %     imshow(Iobr), title('Opening-by-reconstruction (Iobr)')

%Following the opening with a closing can remove the dark spots and stem marks.
Ioc = imclose(Io, se);
% % % % % figure
% % % % % imshow(Ioc), title('Opening-closing (Ioc)')

%Now use imdilate followed by imreconstruct. 
%Notice you must complement the image inputs and output of imreconstruct.
    Iobrd = imdilate(Iobr, se);
    Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
    Iobrcbr = imcomplement(Iobrcbr);
% % % % %     figure
% % % % %     imshow(Iobrcbr), title('Opening-closing by reconstruction (Iobrcbr)')

% As you can see by comparing Iobrcbr with Ioc, 
% reconstruction-based opening and closing are more effective 
% than standard opening and closing at removing small blemishes without 
% affecting the overall shapes of the objects. Calculate the regional maxima of 
% Iobrcbr to obtain good foreground markers.    
    fgm = imregionalmax(Iobrcbr);
% % % % %     figure
% % % % %     imshow(fgm), title('Regional maxima of opening-closing by reconstruction (fgm)')
    
%To help interpret the result, superimpose the foreground marker image on the original image.     
    I2 = I;
    I2(fgm) = 255;
% % % % %     figure
% % % % %     imshow(I2), title('Regional maxima superimposed on original image (I2)')
    
    
% Notice that some of the mostly-occluded and shadowed objects are not marked, 
% which means that these objects will not be segmented properly in the end result. 
% Also, the foreground markers in some objects go right up to the objects' edge. 
% That means you should clean the edges of the marker blobs and then shrink them a bit. 
% You can do this by a closing     
    
    se2 = strel(ones(5,5));
    fgm2 = imclose(fgm, se2);
    fgm3 = imerode(fgm2, se2);
    
% This procedure tends to leave some stray isolated pixels that must be removed. 
% You can do this using bwareaopen, which removes all blobs that have fewer than a certain number of pixels.    
fgm4 = bwareaopen(fgm3, 20);
I3 = I;
I3(fgm4) = 255;
% % % % % figure
% % % % % imshow(I3)
% % % % % title('Modified regional maxima superimposed on original image (fgm4)')    
 
% Step 4: Compute Background Markers    
    bw = im2bw(Iobrcbr, graythresh(Iobrcbr));
%     figure
%     imshow(bw), title('Thresholded opening-closing by reconstruction (bw)')
    
    result = double(bw) .* ROI;
% imshow(Im_seg)

    % Directory to record segmented images
    dir_watershed = [dir_cat 'segmented_images\watershed\'];
    % I record the segmented images in the specified directory
    imwrite(bw,[dir_watershed,num2str(numImagem),'.bmp'],'bmp');
    % Directory to record the segmented images considering only the ROI obtained
    dir_watershed_roi = [dir_cat 'segmentadas\watershed\roi\'];
   % Record the ROI of the segmented images in the specified directory
    imwrite(result,[dir_watershed_roi,num2str(numImagem),'.bmp'],'bmp');
    
%     
%     D = bwdist(bw);
%     DL = watershed(D);
%     bgm = DL == 0;
%     figure
%     imshow(bgm), title('Watershed ridge lines (bgm)')
%     
%     gradmag2 = imimposemin(gradmag, bgm | fgm4);
%     L = watershed(gradmag2);
%     I4 = I;
%     I4(imdilate(L == 0, ones(3, 3)) | bgm | fgm4) = 255;
%     figure
%     imshow(I4)
%     title('Markers and object boundaries superimposed on original image (I4)')

end

