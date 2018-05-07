%--------------------------------------
%Método para calcular a norma de
%um quatérnio
%Parâmetros: 
%q: quatérnio
%Retorno:
%qr: quatérnio resultante
%--------------------------------------
function normq=quatNorm(q)
    normq = sqrt(q(1,1)*q(1,1) + q(2,1)*q(2,1) + q(3,1)*q(3,1) + q(4,1)*q(4,1));
end