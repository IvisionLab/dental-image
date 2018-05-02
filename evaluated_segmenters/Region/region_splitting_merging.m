function region_splitting_merging(diretorio_categoria, I, regiaoInteresse, numImagem, Entropia)
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
% Diretório para gravar as imagens segmentadas
dir_region_splitting_and_merging = [diretorio_categoria 'segmentadas\region\splitting_merging\'];
% Diretório para gravar as imagens segmentadas considerando apenas o
% ROI obtido
dir_region_splitting_and_merging_roi = [diretorio_categoria 'segmentadas\region\splitting_merging\roi\'];
%Executa a função
splitmerge(dir_region_splitting_and_merging, dir_region_splitting_and_merging_roi, I, regiaoInteresse,numImagem, Entropia)

end


function splitmerge(dir_region_splitting_and_merging, dir_region_splitting_and_merging_roi, f, regiaoInteresse,numImagem, Entropia)
    q=2^nextpow2(max(size(f)));
    [m n]=size(f);
    f=padarray(f,[q-m,q-n],'post');
    mindim=2;
    s=qtdecomp(f,@split,mindim,@predicate, Entropia);
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
                flag=feval(@predicate,region, Entropia);
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
    result = double(g) .* regiaoInteresse;
%     figure, imshow(im2bw(result)),title('Segmented Image');
    % Gravo as imagens segmentadas nos diretórios especificados
    imwrite(im2bw(g),[dir_region_splitting_and_merging,num2str(numImagem),'.bmp'],'bmp');
    imwrite(im2bw(result),[dir_region_splitting_and_merging_roi,num2str(numImagem),'.bmp'],'bmp');

end

function v=split(b,mindim,fun, Entropia)
k=size(b,3);
v(1:k)=false;
for i=1:k
    quadrgn=b(:,:,i);
    if size(quadrgn,1)<=mindim
        v(i)=false;
        continue;
    end
    flag=feval(fun,quadrgn, Entropia);
    if flag
        v(i)=true;
    end
end
end

function flag=predicate(region, Entropia)
sd=std2(region);
m=mean2(region);
flag = (sd > Entropia/2);
end



