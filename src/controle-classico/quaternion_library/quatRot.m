%--------------------------------------
%M�todo para calcular a rota��o dada por
%um quat�rnio
%Par�metros: 
%p: ponto
%r: quat�rnio de rota��o
%Retorno:
%pr: ponto rotacionado
%--------------------------------------
function pr = quatRot(p,r)
%--------------------------------------
%c�lcula a rota��o pr = rpr*
%--------------------------------------
    pr = quatMult(r,quatMult(p,quatConj(r)));
end