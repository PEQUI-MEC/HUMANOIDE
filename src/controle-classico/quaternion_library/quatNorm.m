%--------------------------------------
%M�todo para calcular a norma de
%um quat�rnio
%Par�metros: 
%q: quat�rnio
%Retorno:
%qr: quat�rnio resultante
%--------------------------------------
function normq=quatNorm(q)
    normq = sqrt(q(1,1)*q(1,1) + q(2,1)*q(2,1) + q(3,1)*q(3,1) + q(4,1)*q(4,1));
end