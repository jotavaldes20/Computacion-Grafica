
function Iero= ErosionColor(I, se)
Iero=I;
c1=0;
c2=0;
c3=0;
c4=0;
tam= floor(size(se)/2);%tomamos elemento estructurante

Irep=zeros(size(I,1)+2*tam(1),size(I,2)+2*tam(2)).*double(maximo(I));%Crea una imagen con el valor maximo de los pixeles de la imagen I por los bordes

%Hacemos copia de la imagen
for ch =1:size(I,3) 
    Irep(1+tam(1):end-tam(1),1+tam(2):end-tam(2),ch)=double(I(:,:,ch));%insertar en cada canal lo que corresponde a cada canal
end

% figure, imagesc(Irep),title('Imagen repetida');

%distancia euclidiana con respecto al origen

Ieuc=sqrt(Irep(:,:,1).^2 + Irep(:,:,2).^2 + Irep(:,:,3).^2);

%tamaño de la imagen
[m,n,p] =size(Irep);
for i = 1+tam:size(Irep,1)-tam
    for j=1+tam:size(Irep,2)-tam
        %recorremos segun nuestro elemento estructurante vamos sacando la
    %vencidad a trabajar
    elementosRgb=Irep(i-tam(1):i+tam(1), j-tam(2):j+tam(2),:);%hasta todos los valores
    elementosEuc=Ieuc(i-tam(1):i+tam(1), j-tam(2):j+tam(2));
    Iero(i-tam(1), j-tam(2)) = minimo(se(se~=0).* elementosRgb(se~=0));%se consideran los elementos solo oonde el elemento estructurante distinto de cero
    %Pixel Central-RGB
    pixelRGB=[Irep(i,j,1),Irep(i,j,2),Irep(i,j,3)];

    valmin=min(elementosEuc);%valor maximo de toda la vecindad

    %vemos si se repite en alguna posicion
    [fila, columna]=find(elementosEuc==min(valmin));
    posMin = [fila,columna];
    %ordenamiento parcial terminado

    %si existen diferentes colores que tienen la misma distancia
    %euclidiana pasamos a criterio 2 la proyeccion ortogonal a la diagonal
    %cambiamos el valor del pixel central por el minimo encontrado de la vecindad

    r=elementosRgb(:,:,1); %vecindad para Red
    g=elementosRgb(:,:,2); %vecindad para Green
    b=elementosRgb(:,:,3); %vecindad para Blue


    [fr,cr]=size(posMin);%fr es la cantidad de filas (valores euclidianos repetidos)

    if (fr==1)
        c1=c1+1;
    %cambiamos el valor del pixel central por el minimo encontrado de la vecindad
    %fprintf('Primer criterio \n');
    %si el valor del pixel central es mayor que el menor de los pixel de la vecidad se cambia 
    if( elementosEuc(2,2)> min(valmin))
        pixelRGB(1)=r(posMin(1,1),posMin(1,2));
    pixelRGB(2)=g(posMin(1,1),posMin(1,2));
    pixelRGB(3)=b(posMin(1,1),posMin(1,2));
    %cambiar pixel a pixel

    end        
    else
        %Proyeccion ortogonal a la diagonal para distancias euclidianas
    %iguales
    Diagonal = [255,255,255];

    %usamos funcion dot(A,B) para producto escalar

    Vec_valorProyecciones=zeros([1,fr]);
    for o= 1:fr
        pixelRGB_aux(1)=r(posMin(o,1),posMin(o,2));
    pixelRGB_aux(2)=g(posMin(o,1),posMin(o,2));
    pixelRGB_aux(3)=b(posMin(o,1),posMin(o,2));
    Vec_valorProyecciones(o)=dot(Diagonal,[pixelRGB_aux(1),pixelRGB_aux(2),pixelRGB_aux(3)])/norm(Diagonal);
    %fprintf('contador %d\n',o)             
    end

    Pos_Ort=[posMin Vec_valorProyecciones(:)];

    ValorMinProye=min(Pos_Ort(:,3));

    [fila_ort, columna_ort]=find(Pos_Ort(:,3)==(ValorMinProye));
    PosOrtMin = [fila_ort,columna_ort];

    %Preguntar si existen proyecciones ortogonales iguales
    [fproy,cproy]=size(PosOrtMin);%fproy es la cantidad de filas ( proyecciones ortogonales repetidas)


    if(fproy==1)
        if( elementosEuc(2,2)> ValorMinProye)
            c2=c2+1;
        %aplicamos 2 criterio 
        %fprintf('Segundo criterio \n');
        pixelRGB(1)=r(Pos_Ort(1,1),Pos_Ort(1,2));
        pixelRGB(2)=g(Pos_Ort(1,1),Pos_Ort(1,2));
        pixelRGB(3)=b(Pos_Ort(1,1),Pos_Ort(1,2));

        end
        else
            %entramos al tercer criterio donde vemos la Distancia Mínima entre el píxel que se desea reemplazar y los puntos de proyección igual a la diagonal
        %Se toma el de menor distancia al pixel de interes y se
        %cambia en el pixel de interes
        %fprintf('Tercer criterio \n');

        %recorremos el vector donde estan los pixeles con misma
        %proyeccion ortogonal
        Distancias=zeros(1,fproy);
        for p=1:fproy
            pixelRGB_aux(1)=r(Pos_Ort(p,1),Pos_Ort(p,2));
        pixelRGB_aux(2)=g(Pos_Ort(p,1),Pos_Ort(p,2));
        pixelRGB_aux(3)=b(Pos_Ort(p,1),Pos_Ort(p,2));
        Distancias(p)=sqrt((pixelRGB_aux(1)-pixelRGB(1))^2+(pixelRGB_aux(2)-pixelRGB(2))^2+(pixelRGB_aux(3)-pixelRGB(3))^2);
        end
        Pos_ProyRep=[PosOrtMin Distancias(:)];%vector guarda las posicione del rgb,valor de proyecion,dist_euc entre el pixel de interes y la proyeccion

        %               Recogemos el valor minimo entre el pixel de interes y la proyeccion ortogonal 
        ValorMinProyRep=min(Pos_ProyRep(:,3));

        [fila_rep, columna_rep]=find(Pos_ProyRep(:,3)==(ValorMinProyRep));
        PosRepMin = [fila_rep,columna_rep];

        [cant_rep,y]=size(PosRepMin);

        if(cant_rep==1)
            c3=c3+1;
        % aplicamos 3 criterio
        % fprintf('Tercer criterio \n');
        pixelRGB(1)=r(Pos_ProyRep(1,1),Pos_ProyRep(1,2));
        pixelRGB(2)=g(Pos_ProyRep(1,1),Pos_ProyRep(1,2));
        pixelRGB(3)=b(Pos_ProyRep(1,1),Pos_ProyRep(1,2));


        %                     Si de todas formas siguen siendo iguales se debe pasar al
        %                 criterio 4
        else
            c4=c4+1;
        %CRITERIO 4
        %En este caso si siguen siendo igual tomares el valor
        %minimo encontrado primero y usaremos ese, hasta
        %implementar el Criterio 4 que soluciona lo anterior
        %aplicamos 3 criterio
        %fprintf('Tercer criterio \n');

        pixelRGB(1)=r(Pos_ProyRep(1,1),Pos_ProyRep(1,2));
        pixelRGB(2)=g(Pos_ProyRep(1,1),Pos_ProyRep(1,2));
        pixelRGB(3)=b(Pos_ProyRep(1,1),Pos_ProyRep(1,2));


        %Si de todas formas siguen siendo iguales se debe pasar al
        %criterio 4

        %IMPLEMENTADO HASTA AQUI
        end
        end
        end
        
        Iero(i-tam,j-tam,1)=uint8(pixelRGB(1));
        Iero(i-tam,j-tam,2)=uint8(pixelRGB(2));
        Iero(i-tam,j-tam,3)=uint8(pixelRGB(3));
        end
    end
end
