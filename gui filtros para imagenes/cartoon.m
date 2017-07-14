
% Radio de máscara = radio de la vecindad de píxeles para la comparación de intensidad
 % Umbral = diferencia de intensidad relativa que resultará en oscurecimiento
 % Rampa = cantidad de diferencia de intensidad relativa antes del total negro
 % Radio de desenfoque = radio de la máscara / 3,0
 %
 % Algoritmo:
 % Para cada píxel, calcule el valor de intensidad de píxel como: avg (radio de desenfoque)
 % Relative diff = intensidad de píxel / avg (radio de la máscara)
 % Si diferencia relativa <Umbral
 % Intensidad mult = (Rampa - MIN (Rampa, (Umbral - Diferencia relativa))) / Rampa
 % Intensidad de píxel * = intensidad mult
function imr=cartoon(im,mask_radius,threshold,ramp)
if ndims(im) == 3 
        % rgb 
        r=im(:,:,1);
        g=im(:,:,2);
        b=im(:,:,3);
        rr=cartoonlize(r,mask_radius,threshold,ramp);
        gr=cartoonlize(g,mask_radius,threshold,ramp);
        br=cartoonlize(b,mask_radius,threshold,ramp);
        imr=cat(3,rr,gr,br);
else
        %grayscale
        imr=cartoonlize(im,mask_radius,threshold,ramp);
end

function gr=cartoonlize(g,mask_radius,threshold,ramp)

g=im2double(g); % avoid  overflow

mask=fspecial('average',mask_radius);
g_new=imfilter(g,mask);
g_new=g./g_new;
mult=(ramp-min(ramp,(threshold-g_new)))/ramp;
ind=find(g_new<threshold);
gr=g;
gr(ind)=g(ind).*mult(ind);

