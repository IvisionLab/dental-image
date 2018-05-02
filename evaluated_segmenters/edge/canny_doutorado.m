function canny_doutorado(diretorio_categoria, imagem, regiaoInteresse, numImagem)

    dir_canny = [diretorio_categoria 'segmentadas\edge\canny\'];
    dir_canny_roi = [diretorio_categoria 'segmentadas\edge\canny\roi\'];
    
    BW = edge(imagem,'Canny');
%     imshow(bwfim1);title(sprintf('FCM1,level=%f',level1));
    

    result_roi = double(BW) .* regiaoInteresse;

      % Gravo as imagens segmentadas no diretório especificado
      imwrite(BW,[dir_canny,num2str(numImagem),'.bmp'],'bmp');
      % Gravo o ROI das imagens segmentadas no diretório especificado
      imwrite(result_roi,[dir_canny_roi,num2str(numImagem),'.bmp'],'bmp');


end

