%--------------------------------------
%M�todo para normalizar um
%um quat�rnio
%Par�metros: 
%q: quat�rnio
%Retorno:
%qr: quat�rnio resultante
%--------------------------------------
function qr = quatNormalize(q)
%--------------------------------------
%c�lculo da norma do quat�rnio
%--------------------------------------
    normq = quatNorm(q);
%--------------------------------------
%se a norma for igual a zero retorna o 
%proprio quat�rnio
%--------------------------------------    
    if normq == 0
        qr = q;
    else
        qr = quatScale(1.0 / normq, q);
    end 
end