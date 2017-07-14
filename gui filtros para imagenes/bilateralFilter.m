

function Iout = bilateralFilter(I, sigma_d , sigma_r)

I = double(I);
tamaKernel = [ceil(sigma_d*3),ceil(sigma_d*3)];
numPixRep = ceil((tamaKernel-1)/2);
tama = numPixRep;
%numPixRep = floor(tamaKernel/2);

     
[x,y] = meshgrid(-numPixRep(1):numPixRep(1),-numPixRep(2):numPixRep(2));
gaus = exp(-(x.*x./(3.*(sigma_d(1))^2) + y.*y./(3.*(sigma_d(1))^2)));
G =gaus./sum(gaus(:));
Irep = padarray(I,[numPixRep(1) numPixRep(2)],'symmetric');

[xDim, yDim, fDim] = size(I);
 
for i = 1 + tama(1): xDim + tama(1)
    for j = 1 + tama(2): yDim + tama(2)
        
        for f = 1: fDim
        
            N  = Irep(i-tama(1):i+tama(1), j-tama(2):j+tama(2),f);
            pCent = Irep(i,j,f);
        
            d = N - repmat(pCent,[size(N,1) size(N,2)]);
            w = exp( - (d.^2./(sigma_r^2)));      
            w = w./sum(w(:));
        
        
            Nch = N(:,:);
            Iout(i-tama(1),j-tama(2),f) =  sum(Nch(:).*w(:));
        end
        
    end
end
Iout = uint8(Iout);

