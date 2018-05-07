%--------------------------------------
%Método para calcular a subtração de
%dois  quatérnios
%Parâmetros: 
%q1: primeiro quatérnio
%q2: segundo quatérnio
%Retorno:
%qr: quatérnio resultante
%--------------------------------------
function qr = quatSub(q1,q2)
    %q = a + bi + cj + dk
    qr(1,1) = q1(1,1)- q2(1,1);%parte real
    qr(2,1) = q1(2,1)- q2(2,1);%imaginário i
    qr(3,1) = q1(3,1)- q2(3,1);%imaginário j
    qr(4,1) = q1(4,1)- q2(4,1);%imaginário k
end