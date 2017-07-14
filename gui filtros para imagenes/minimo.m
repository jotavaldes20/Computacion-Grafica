function valMinimo = maximo(vector)

%vectorizamos vector, la coloca como vector
vector = vector(:);

%encotramos valor maximo

valMinimo = vector(1);%colocamos el valor de la primera posicion del vector

%partimos de 2 ya que tenemos la primera posicion del vector
for i = 2 :size(vector,1)
    if  vector(i) < valMinimo
        valMinimo = vector(i);
    end
end
