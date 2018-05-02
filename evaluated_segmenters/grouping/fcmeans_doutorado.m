function fcmeans_doutorado(diretorio_categoria, imagem, regiaoInteresse, numImagem)

    dir_cmeans = [diretorio_categoria 'segmentadas\clustering\cmeans\'];
    dir_cmeans_roi = [diretorio_categoria 'segmentadas\clustering\cmeans\roi\'];
    
    im=imagem;
    fim=mat2gray(im);
    [bwfim1,level1]=fcmthresh(fim,1);
%     imshow(bwfim1);title(sprintf('FCM1,level=%f',level1));
    

    result_roi = double(bwfim1) .* regiaoInteresse;

      % Gravo as imagens segmentadas no diretório especificado
      imwrite(bwfim1,[dir_cmeans,num2str(numImagem),'.bmp'],'bmp');
      % Gravo o ROI das imagens segmentadas no diretório especificado
      imwrite(result_roi,[dir_cmeans_roi,num2str(numImagem),'.bmp'],'bmp');


end

