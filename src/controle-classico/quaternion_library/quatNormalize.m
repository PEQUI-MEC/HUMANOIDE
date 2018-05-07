%--------------------------------------
%Método para normalizar um
%um quatérnio
%Parâmetros: 
%q: quatérnio
%Retorno:
%qr: quatérnio resultante
%--------------------------------------
function qr = quatNormalize(q)
%--------------------------------------
%cálculo da norma do quatérnio
%--------------------------------------
    normq = quatNorm(q);
%--------------------------------------
%se a norma for igual a zero retorna o 
%proprio quatérnio
%--------------------------------------    
    if normq == 0
        qr = q;
    else
        qr = quatScale(1.0 / normq, q);
    end 
end