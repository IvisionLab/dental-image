function region_splitting_merging_gil_jader(dir_cat, I, ROI, numImage, Entropy)
%     I=imread('PAN_modif11.jpg');
%     I=rgb2gray(I);


% 
%     S = qtdecomp(I,17);
%     blocks = repmat(uint8(0),size(S));
%     for dim = [512 256 128 64 32 16 8 4 2 1];
%         numblocks = length(find(S==dim));
%         if (numblocks > 0)
%             values = repmat(uint8(1),[dim dim numblocks]);
%             values(2:dim,2:dim,:)=0;
%             blocks = qtsetblk(blocks,S,dim,values);
%         end
%     end
%     blocks(end,1:end)=1;
%     blocks(1:end,end)=1;
%     subplot(1,2,1), imshow(I);
%     k = find(blocks==1);
%     A=I;A(k)=255;
%     subplot(1,2,2),imshow(A)
% Directory to record segmented images
dir_region_splitting_and_merging = [dir_cat 'segmented_images\region\splitting_merging\'];
% Directory to write the images segmented considering only the ROI obtained
dir_region_splitting_and_merging_roi = [dir_cat 'segmented_images\region\splitting_merging\roi\'];
% Execut the function
splitmerge(dir_region_splitting_and_merging, dir_region_splitting_and_merging_roi, I, ROI,numImage, Entropy)

end


function splitmerge(dir_region_splitting_and_merging, dir_region_splitting_and_merging_roi, f, ROI,numImage, Entropy)
    q=2^nextpow2(max(size(f)));
    [m n]=size(f);
    f=padarray(f,[q-m,q-n],'post');
    mindim=2;
    s=qtdecomp(f,@split,mindim,@predicate, Entropy);
    lmax=full(max(s(:)));
    g=zeros(size(f));
    marker=zeros(size(f));
    for k=1:lmax
        [vals,r,c]=qtgetblk(f,s,k);
        if ~isempty(vals)
            for i=1:length(r)
                xlow=r(i);ylow=c(i);
                xhigh=xlow+k-1;
                yhigh=ylow+k-1;
                region=f(xlow:xhigh,ylow:yhigh);
                flag=feval(@predicate,region, Entropy);
                if flag
                     g(xlow:xhigh,ylow:yhigh)=1;
                     marker(xlow,ylow)=1;
                end
            end
        end
    end
    g=bwlabel(imreconstruct(marker,g));
    g=g(1:m,1:n);
    f=f(1:m,1:n);
%     figure, imshow(f),title('Original Image');
    result = double(g) .* ROI;
%     figure, imshow(im2bw(result)),title('Segmented Image');
    % Gravo as imagens segmented nos diretórios especificados
    imwrite(im2bw(g),[dir_region_splitting_and_merging,num2str(numImage),'.bmp'],'bmp');
    imwrite(im2bw(result),[dir_region_splitting_and_merging_roi,num2str(numImage),'.bmp'],'bmp');

end

function v=split(b,mindim,fun, Entropy)
k=size(b,3);
v(1:k)=false;
for i=1:k
    quadrgn=b(:,:,i);
    if size(quadrgn,1)<=mindim
        v(i)=false;
        continue;
    end
    flag=feval(fun,quadrgn, Entropy);
    if flag
        v(i)=true;
    end
end
end

function flag=predicate(region, Entropy)
sd=std2(region);
m=mean2(region);
flag = (sd > Entropy/2);
end



