% hsize=[5 5]; sigma=5/3;
% PSF = fspecial('gaussian', hsize, sigma);
% Iblurring=imfilter(I,PSF,'conv','same','symmetric');
% Inoisy = imnoise(uint8(Iblurring),'gaussian',0,0.002)%ruido al blurring

function result=DeconvRL(I,PSF,Iteraciones)
    I=double(I);
    %Primera Estimacion
    fn = I;


    %El tamaño de Psf no es igual al tamaño de imagen así que convierta Psf a Otf (Optical Transfer Function)
    %"calcula la transformada de Fourier rápida (FFT) de la matriz de función de propagación de puntos (PSF)
    %y crea la matriz de función de transferencia óptica, OTF, que no está influenciada por el descentrado
    %de PSF. De forma predeterminada, la matriz OTF tiene el mismo tamaño
    %la imagen con blurring." [https://www.mathworks.com/help/images/ref/otf2psf.html]

    H = psf2otf(PSF, size(I)); % H
    for i= 1:Iteraciones

        %Convertir a dominio de frecuencia la estimacion, mediante fft2.
        %fn
        Fn_Frec = fft2 (fn);

        % Multiplicar H con la estimación(imagen con blurring) en el dominio de la frecuencia
        fnH = H .* Fn_Frec; % fnH

        %Convertir la estimación de imagen borrosa a dominio espacial utilizando IFFT.
        fnH_espacial = ifft2 (fnH);

        %Calcular la razon entre la imagen borrosa y la estimación de la imagen con blurring
        g_Hfn = I ./ fnH_espacial; %(g/Hfn)

        %Conversión de la razón al dominio de la frecuencia usando FFT
        g_Hfn_Frec = fft2 (g_Hfn);

        %Calcular la corrección para el deblurring
        Hg_Hfn_Frec = H .* g_Hfn_Frec;

        % Conversión de la corrección al dominio espacial del dominio de frecuencia usando IFFT.
        Hg_Hfn_espacial = ifft2(Hg_Hfn_Frec);

        %Para encontrar una nueva estimación, multiplique el vector de corrección calculado con la estimación de la imagen deblurada
        fn_sgt = Hg_Hfn_espacial .* fn;

        fn = fn_sgt;
    
    end
    result=fn;%la funcion devuelve la imagen restaurada

end