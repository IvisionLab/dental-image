function sobel_doutorado(diretorio_categoria, imagem, regiaoInteresse, numImagem)

    dir_sobel = [diretorio_categoria 'segmentadas\edge\sobel\'];
    dir_sobel_roi = [diretorio_categoria 'segmentadas\edge\sobel\roi\'];
    
    BW = edge(imagem,'Sobel');   

    result_roi = double(BW) .* regiaoInteresse;

      % Gravo as imagens segmentadas no diretório especificado
      imwrite(BW,[dir_sobel,num2str(numImagem),'.bmp'],'bmp');
      % Gravo o ROI das imagens segmentadas no diretório especificado
      imwrite(result_roi,[dir_sobel_roi,num2str(numImagem),'.bmp'],'bmp');


end

