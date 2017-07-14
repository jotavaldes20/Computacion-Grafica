% I=rgb2gray(Im); 
% hsize=[5 5]; sigma=5/3;
% PSF = fspecial('gaussian', hsize, sigma);
% Iblurring=imfilter(I,PSF,'conv','same','symmetric');
% Inoisy = imnoise(uint8(Iblurring),'gaussian',0,0.002)%ruido al blurring
% 
% 
% 
% figure,imagesc(Iblurring),colormap(gray),title('blurring')
% figure,imagesc(I),colormap(gray),title('original')
% figure,imagesc(Inoisy),colormap(gray),title('Inoisy')

function result=Landweber(I,PSF,Iteraciones,beta)
    
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
        
        %Pasar al dominio de la frecuenca 
        I_Hfn_Frec = fft2 (I_Hfn);
        
        %multiplicar lo anterior por H que es el PSF en el dominio de la
        %frecuencia, es decir una multiplicacion en la frecuencia es una
        %convolucion en el dominio espacial
        
        H_I_Hfn=H.*I_Hfn_Frec;

        % Conversión del vector de corrección del blurring, del dominio de la Frecuencia a Espacial usando IFFT.
        H_I_Hfn_Espacial = ifft2(H_I_Hfn);
        
        
        
        %fn=fn+beta.*(I- Hfn);
        fn=fn+beta.*(H_I_Hfn_Espacial);
    end
    
    result=fn;%la funcion devuelve la imagen restaurada


end