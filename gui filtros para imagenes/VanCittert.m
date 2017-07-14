% I=rgb2gray(Im); 
% hsize=[5 5]; sigma=5/3;
% PSF = fspecial('gaussian', hsize, sigma);
% Iblurring=imfilter(I,PSF,'conv','same','symmetric');
% Inoisy = imnoise(uint8(Iblurring),'gaussian',0,0.002)%ruido al blurring
function result=VanCittert(I,PSF,Iteraciones,beta)
    
    I=double(I);
    PSF = double(PSF);    
    
    %Primera Estimacion
    fn=I;

    %El tamaño de Psf no es igual al tamaño de imagen así que convierta Psf a Otf (Optical Transfer Function)
    %"calcula la transformada de Fourier rápida (FFT) de la matriz de función de propagación de puntos (PSF)
    %y crea la matriz de función de transferencia óptica, OTF, que no está influenciada por el descentrado
    %de PSF. De forma predeterminada, la matriz OTF tiene el mismo tamaño
    %la imagen con blurring." [https://www.mathworks.com/help/images/ref/otf2psf.html]
    
    H = psf2otf(PSF, size(I)); % H
    
    for i= 1:Iteraciones
        
        %Convierte la estimación al dominio de la frecuencia utilizando el dominio espacial de la forma FFT (imagen frecuencia a domino espacial).
        %fn
        Fn_Frec = fft2 (fn);
        
        % Multiplicar el H con la estimación en el dominio de la frecuencia
        Hfn = H .* Fn_Frec; % fnH

        %Convertir de nuevo a la estimación de imagen borrosa a dominio espacial utilizando IFFT.
        Hfn_Espacial = ifft2 (Hfn);
        
        I_Hfn = I - Hfn_Espacial;    
        
        I_Hfn_Frec = fft2 (I_Hfn);
        
        % Conversión del vector de corrección al dominio espacial del dominio de frecuencia usando IFFT.
        I_Hfn_Espacial = ifft2(I_Hfn_Frec);
        
        %fn=fn+beta.*(I- Hfn);
        fn=fn+beta.*(I_Hfn_Espacial);
    end
    
    result=fn;%la funcion devuelve la imagen restaurada


end
