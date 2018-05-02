% ---------------------------------------------------------------------------------------------------------------------------------% 
% --------------------------------------------Desenvolvido por: Gil Jader ---------------------------------------------------%
% ---------------------------------------------------gil.jader@gmail.com-----------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------%
%   Função principal utilizada para executar e avaliar os algoritimos de segmentação   %
function executa_segmentacao()
    clc;
    clear;
    close all;
    
   % Diretório raiz das imagens 
   dir_root = 'D:\DOUTORADO\PROJETO_TESE\dataset_panoramicas_classificadas\';
    
   % Diretório das imagens da CATEGORIA 1
   dir_cat1 = [dir_root 'cat1_imagens_com_todos_dentes_contendo_dentes_com_restauracao_e_com_aparelho\cortadas\'];
   % Diretório das imagens da CATEGORIA 2
   dir_cat2 = [dir_root 'cat2_imagens_com_todos_dentes_contendo_dentes_com_restauracao_e_sem_aparelho\cortadas\'];
   % Diretório das imagens da CATEGORIA 3
   dir_cat3 = [dir_root 'cat3_imagens_com_todos_dentes_contendo_dentes_sem_restauracao_e_com_aparelho\cortadas\'];
   % Diretório das imagens da CATEGORIA 4
   dir_cat4 = [dir_root 'cat4_imagens_com_todos_dentes_contendo_dentes_sem_restauracao_e_sem_aparelho\cortadas\'];
   % Diretório das imagens da CATEGORIA 5
   dir_cat5 = [dir_root 'cat5_imagens_contendo_IMPLANTE\cortadas\'];
   % Diretório das imagens da CATEGORIA 6
   dir_cat6 = [dir_root 'cat6_imagens_contendo_mais_de_32_dentes\cortadas\'];
   % Diretório das imagens da CATEGORIA 7
   dir_cat7 = [dir_root 'cat7_imagens_faltando_dentes_contendo_dentes_com_restauracao_e_com_aparelho\cortadas\'];
   % Diretório das imagens da CATEGORIA 8
   dir_cat8 = [dir_root 'cat8_imagens_faltando_dentes_contendo_dentes_com_restauracao_e_sem_aparelho\cortadas\'];
   % Diretório das imagens da CATEGORIA 9
   dir_cat9 = [dir_root 'cat9_imagens_faltando_dentes_contendo_dentes_sem_restauracao_e_com_aparelho\cortadas\'];
   % Diretório das imagens da CATEGORIA 10
   dir_cat10 = [dir_root 'cat10_imagens_faltando_dentes_contendo_dentes_sem_restauracao_e_sem_aparelho\cortadas\'];
   % Diretório das imagens da CATEGORIA 11
   dir_cat11 = [dir_root 'cat11_imagens_sem_NENHUM_dente\cortadas\'];
   
  % Chamo a função, apenas é necessário alterar o parâmetro passando o diretório das
   % imagens da categoria a serem processadas
   processa_segmentacao(dir_cat2);
end

function  processa_segmentacao(diretorio_categoria)   
   % imagens da categoria a serem processadas
       image_files = dir([diretorio_categoria '*.jpg']);
        % Verifica o total de iamgens originais da categoria a serem utilizadas no diretório
       total_imagens = size(image_files, 1);
       
       % Diretório das imagens binárias da categoria
      diretorio_binarias = [diretorio_categoria 'anotadas\'];
      
       % Diretório das imagens binárias das bocas da categoria
      diretorio_binarias_boca = [diretorio_categoria 'anotadas\boca\'];

      % Variável para somar todas as médias;
      SomaMedia = 0;
      seeds = [];
       % procura imagem a imagem 
       for i = 1 : total_imagens
        if (i > 1)
            break;
        end;

           % Pego o Nome das Imagens Originais (Imagem a imagem dentro do Loop)
           filenameOri = [diretorio_categoria num2str(i) '.jpg'];
           % Pego o Nome das Imagens Binárias (Imagem a imagem dentro do Loop)
           filenameBw = [diretorio_binarias num2str(i) '.bmp'];
           % Pego o Nome das Imagens Binárias - Boca (Imagem a imagem dentro do Loop)
           filenameBwBoca = [diretorio_binarias_boca num2str(i) '.bmp'];
           
           % Exibo o nome de cada imagem para acompanhar o processo
           disp(filenameOri)
           
           % Leio imagem a imagem original
            imgOri = imread(filenameOri);

           % Leio a imagem binária
            imgBw = imread(filenameBw);
           % Leio a imagem binária da Boca
            imgBwBoca = imread(filenameBwBoca);
           
           %Imagem do raio-x está no foramto RGB
            %Convertendo a imagem original RGB to Grayscale
            imgOriGray = rgb2gray(imgOri);
%             imgOriGray = histeq(imgOriGray);

            % Imagem da região dos dentes está em formato logical
            % convertendo Bw logical para double e setando valores 0 para negativo.
                filenameBwNeg = im2double(imgBw);
                filenameBwNeg(filenameBwNeg==0)=-1;
                
            % Imagem da região da boca está em formato logical
            % convertendo BwBoca logical para double e setando valores 0 para negativo.
                filenameBwNegBoca = im2double(imgBwBoca);
                filenameBwNegBoca(filenameBwNegBoca==0)=-1;

            %Criando a nova matriz em cima da máscara
            %A matriz deverá ser processada no tipo double. Para visualizar será
            imm = double(imgOriGray);
            imm(imm<=0)=-1;
            
            %Criando a nova matriz em cima da máscara da Boca
            %A matriz deverá ser processada no tipo double. Para visualizar será
            immBoca = double(imgOriGray);
            immBoca(immBoca<=0)=-1;
            
            % Pego os somente os valore que fazem parte do ROI e armazeno
            % em um vetor para realizar as operações 
            MatrizROI = imm(imm>=0);
            MatrizROIBoca = immBoca(immBoca>=0);

            % Pego o tamanho das dimensões da matriz dp ROI
            s = size(MatrizROIBoca); 
            [c,r] = meshgrid(1:s(1),1:s(2));
            r = r(:);
            c = c(:);
            
             % Chamo as funções para calcular as estatísticas             
            MaiorValor = max(MatrizROIBoca); 
            MenorValor = min(MatrizROIBoca); 
            Media = calculaMedia(MatrizROIBoca);
            DesvioPadrao = std2(MatrizROIBoca);
%             Variancia = calculaVariancia(MatrizROIBoca,r,c);
%             Entropia = calculaEntropia(MatrizROIBoca);
%             Homogenidade = calculaHomogenidade(MatrizROI,r,c);
%             Energia = calculaEnergia(MatrizROI);
%             deltaT = Entropia / DesvioPadrao;            
            

            
%             segmenta_region_growing(diretorio_categoria, imgOri, i, imgBw, filenameBwNegBoca);

%             watershed_marker_controlled(imgOri, filenameBwNegBoca, diretorio_categoria, i);
            
            
%             region_splitting_merging(diretorio_categoria, imgOriGray, filenameBwNegBoca, i, Entropia);
            
            % Segmentação por basic_global_thresholding  
%             basic_global_thresholding(diretorio_categoria, imgOriGray, filenameBwNegBoca, Media, MaiorValor, deltaT, i)
             

	%    fcmeans_doutorado(diretorio_categoria, imgOri, filenameBwNegBoca,  i)

	%    canny_doutorado(diretorio_categoria, imgOriGray, filenameBwNegBoca,  i)
   
	%    sobel_doutorado(diretorio_categoria, imgOriGray, filenameBwNegBoca,  i)
   
	%    active_contour_doutorado(diretorio_categoria, imgOriGray, filenameBwNegBoca, i)

	%    level_set_doutorado(diretorio_categoria, imgOriGray, filenameBwNegBoca, i)

              
            % Segmentação por thresholding_local
%             localthresh(imgOriGray, ones(3), 1,1, 'global',i, filenameBwNegBoca, diretorio_categoria);
%             SIG = stdfilt(uint8(immBoca), ones(3));
%             figure, imshow(SIG, [])
%             figure, imshow(g)



       end 

end


% ------------------------------------------------------------------------------------------------------------- %
% Função para SEGMENTAR as imagens utilizando a função region_growing
function segmenta_region_growing(diretorio_categoria, I, num, imbw, regiaoInteresse)
%     seeds = [420 300; 484	378; 579 408; 672 414; 750 421; 814 429; 888 442; 955 453; 1035 454; 1100 454; 1179 460; 1263 456; 1334 451; 1424 444; 1538 396; 1595 297; 346 576; 468 581; 609	614; 711 630; 784 645; 864	650; 934 645; 988 644; 1044 642; 1097 642; 1163 642; 1248 650; 1328 651; 1433 609; 1562 582; 1688 578];
            
            % Redimensiono as imagens, pois o algoritmo region_growin
            % demanda muito processamento
            I = imresize(I, [198, 350]);
            imbw = imresize(imbw, [198, 350]);
            regiaoInteresse = imresize(regiaoInteresse, [198, 350]);
            
            % ***** informações sobre as imagens ******
            % imshow(filenameBwNeg)
            cc = bwconncomp(imbw, 8);
            labeled = labelmatrix(cc);
            % whos labeled
            % labels = label2rgb(labeled, @spring, 'c', 'shuffle');
            % imshow(labels)
            graindata = regionprops(cc,'basic');
            centroids = [graindata.Centroid];

            % ***** Distribuir os centrois em linhas ******
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
            % Arredonda os valores da matriz final de seeds
            seeds = round(seeds);
            % size(seeds)
        
        %Aplicação da função region_growing
        %O script é executado três vezes, uma para cada variação do
        %parametro dist, para isso comento a linha que foi executada e
        %descomento a seguinte a cada nova execução e após renomear manualmente as
        %imagens segmentadas nas pastas
        
%         region_growing(dir_imagens, seeds, 0.025);
%         region_growing(dir_imagens, seeds, 0.050);
%         region_growing(dir_imagens, seeds, 0.1);

        I = im2double(I);
        mask = zeros(size(I,1),size(I,2));
        xy = seeds;
        
        for ii=1:size(xy,1)
            
            RG = segment_xy(I,xy(ii,2),xy(ii,1),0.1);
            mask = mask +RG(:,:,1);
            
        end
        imgSegmentada = im2bw(mask);
        result = double(imgSegmentada) .* regiaoInteresse;
        
        % Diretório para gravar as imagens segmentadas
        dir_region_growing = [diretorio_categoria 'segmentadas\region\region_gowin\'];
        imwrite(imgSegmentada,[dir_region_growing,num2str(num),'.bmp'],'bmp');
        % Diretório para gravar as imagens segmentadas considerando apenas o
        % ROI obtido
        dir_region_growing_roi = [diretorio_categoria 'segmentadas\region\region_gowin\roi\'];
        imwrite(result,[dir_region_growing_roi,num2str(num),'.bmp'],'bmp');
   
end 




%------------------------------Calcular Homogeneidade-------------------------------------
function Homogenidade = calculaHomogenidade(roi,r,c)
    % Reference: Haralick RM, Shapiro LG. Computer and Robot Vision: Vol. 1,
    % Addison-Wesley, 1992, p. 460.    
    term1 = (1 + abs(r - c));
    term = roi(:) ./ term1;
    Homogenidade = sum(term);
end

%---------------------------Calcular Entropia--------------------------------------------------
function Entropia = calculaEntropia(roi)
    % Reference: Haralick RM, Shapiro LG. Computer and Robot Vision: Vol. 1,
    % Addison-Wesley, 1992, p. 460.  
%         matrizNorm = uint8(floor(roi * 256)); % normaliza por 256 e arredonda para baixo
        frequencia = histc(roi,0:255);

        prob = frequencia ./ numel(roi);  %a função numel retorna o número de elementos de uma matriz (Verificando assim a probabilidade de ocorrência de cada elemento)        
        Entropia= -sum(prob.*log2(prob+eps)); % calculo da entropia
end

%------------------------------Calcular Soma da Entropia-----------------------------------------------
function SEn = calculateSomaEntropia(roi)

        tamLinhaROI=size(roi,1);
        prob=zeros(1,2*tamLinhaROI);
        
        for i=1:tamLinhaROI
            for j=1:tamLinhaROI
                prob(i+j) = prob(i+j)+roi(i,j);
            end
        end
        
        for i=2:2*tamLinhaROI
            entropia(i) = prob(i)*log(prob(i)+eps);
        end
        
        SEn = sum(entropia);
end
  
%---------------------------Calcular Média--------------------------------------------------
function M = calculaMedia(roi)
    %   Copyright 1993-2005 The MathWorks, Inc.
    %   $Revision: 5.19.4.6 $  $Date: 2006/06/15 20:09:12 $
    M = sum(roi(:), [], 'double') / numel(roi);
end    

%------------------------------Calcular Variância-----------------------------------------------
function V = calculaVariancia(roi,r,c)
    % Reference: Haralick RM, Shapiro LG. Computer and Robot Vision: Vol. 1,
    % Addison-Wesley, 1992, p. 460.    
    term1 = (r - c).^2;
    term = term1 .* roi(:);
    V = sum(term);
end


%---------------------------Calcular Energia--------------------------------------------------
function E = calculaEnergia(roi)
    % Reference: Haralick RM, Shapiro LG. Computer and Robot Vision: Vol. 1,
    % Addison-Wesley, 1992, p. 460.  
    term = roi.^2;
    E = sum(term(:));
end
