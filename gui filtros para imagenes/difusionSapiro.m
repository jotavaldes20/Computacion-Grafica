function I= difusionSapiro(I, numIt, dt, k)
    
    epsilon=0.00001;

    I = double(I);
    
    xDim = size(I,1);
    yDim = size(I,2);
    
    for it=1:numIt
    Ixf = I([2:xDim xDim],:) - I;
    Ixb = I - I([1 1:xDim-1],:);
    Ix = (Ixf + Ixb).*0.5;
    
    Iyf = I(:,[2:yDim yDim]) - I;
    Iyb = I - I(:,[1 1:yDim-1]);
    Iy = (Iyf + Iyb).*0.5;
    
    g11= Ix.*Ix;
    g12= Ix.*Iy;
    g22= Iy.*Iy;
    
    %calculamos los eigenvalues o valores propios
    lambda1 = 0.5.*(g11 + g22 + sqrt((g11-g22).^2 + 4.*g12.^2));
    lambda2 = 0.5.*(g11 + g22 - sqrt((g11-g22).^2 + 4.*g12.^2));
    
    %angulos asociados a los valores propios,(se agrega epsilon por si la resta da cero)
    teta = 0.5.*atan(2.*g12./(g11 - g22 + epsilon));
    
    %evaluamos para determinar cuando se maximiza la funcion 
    fteta=0.5.*((g11 + g22) + cos(2.*teta).*(g11-g22) + 2.*g12.*sin(2.*teta));
    fteta2=0.5.*((g11 + g22) + cos(2.*teta + pi/2).*(g11-g22) + 2.*g12.*sin(2.*teta+pi/2));
    
    %direccion de maxima variacion(asociado a lambda)
    teta(fteta2 > fteta) = teta(fteta2 > fteta) + pi/2;
    
    v1x=cos(teta);
    v1y=sin(teta);
    
    v2x=cos(teta+pi/2);
    v2y=sin(teta+pi/2);
    
    % normal del gradiente como diferencia de eigenvalues
    normGrad=sqrt(lambda1 - lambda2);
    c = 1./(1+ (normGrad./k).^2); 
    
    %segundas derivadas
    Ixx=I([2:xDim xDim],:) + I([1 1:xDim-1],:) -2.*I;
    Iyy=I(:,[2:yDim yDim]) + I(:,[1 1:yDim-1]) -2.*I;
    Ixy=0.25.*(I([2:xDim xDim],[2:yDim yDim]) + I([1 1:xDim-1],[1 1:yDim-1]) - I([1 1:xDim-1],[2 yDim yDim])  - I([2:xDim xDim],[1 1:yDim-1]));
    
    %derivada direccional de acuerdo a la minima variacion
    Iv2v2=Ixx.*(v2x.^2) + 2.*v2x.*v2y.*Ixy + (v2y.^2).*Iyy;
    I=I + dt.*(c.*Iv2v2);
    end
    
%Is =difusionSapiro(Inoisy,100,0.1,5)