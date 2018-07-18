%--------------------------------------
%Método para calcular operador de Halmiton
% de um quatérnio dual
%Parâmetros: 
%h: quatérnio dual
%op: tipo de operador + ou -
%Retorno:
%T: matriz resultante
%--------------------------------------
function T = dualHamiltonOp(h,op)
    %separa elementos do dual quatérnio
    h1 = h(1,1);
    h2 = h(2,1);
    h3 = h(3,1);
    h4 = h(4,1);
    h5 = h(5,1);
    h6 = h(6,1);
    h7 = h(7,1);
    h8 = h(8,1);
   
   %calculo de H
   Hp = HamiltonOp([h1 h2 h3 h4]',op);
   Hd = HamiltonOp([h5 h6 h7 h8]',op);
   %matriz de zeros
   O = zeros(4,4);
   %operador de Halmiton para quatérnios duais
   T = [Hp O;Hd Hp];
end