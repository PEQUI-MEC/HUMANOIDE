%--------------------------------------
%Método para calcular a rotação dada por
%um quatérnio
%Parâmetros: 
%p: ponto
%r: quatérnio de rotação
%Retorno:
%pr: ponto rotacionado
%--------------------------------------
function pr = quatRot(p,r)
%--------------------------------------
%cálcula a rotação pr = rpr*
%--------------------------------------
    pr = quatMult(r,quatMult(p,quatConj(r)));
end