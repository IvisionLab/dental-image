function active_contour_doutorado(diretorio_categoria, imagem, regiaoInteresse, numImagem)

    dir_active_contour = [diretorio_categoria 'segmentadas\boundary\active_contour\'];
    dir_active_contour_roi = [diretorio_categoria 'segmentadas\boundary\active_contour\roi\'];
    
    m = zeros(size(imagem));
    m(25:end-25,25:end-25) = 1;
    BW = chenvese(imagem,m,500,0.1,'chan');
        
    regiaoInteresse = imresize(regiaoInteresse, [200, 354]);

    result_roi = double(BW) .* regiaoInteresse;

%       Gravo as imagens segmentadas no diretório especificado
      imwrite(BW,[dir_active_contour,num2str(numImagem),'.bmp'],'bmp');
%       Gravo o ROI das imagens segmentadas no diretório especificado
      imwrite(result_roi,[dir_active_contour_roi,num2str(numImagem),'.bmp'],'bmp');


end

