function [valMaximo] = maximo(vector)

%vectorizamos vector, la coloca como vector
vector = vector(:);

%encotramos valor maximo

valMaximo = vector(1);%colocamos el valor de la primera posicion del vector

%partimos de 2 ya que tenemos la primera posicion del vector}
cont=0;
for l = 2 :size(vector,1)
    if  vector(l) >= valMaximo
        valMaximo = vector(l);
        tamano=size(vector,1);
        cont=cont+1;
        %fprintf('es mayor %d\n',cont);
    end
end
