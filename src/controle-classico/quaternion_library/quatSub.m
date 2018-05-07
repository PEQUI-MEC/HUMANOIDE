%--------------------------------------
%M�todo para calcular a subtra��o de
%dois  quat�rnios
%Par�metros: 
%q1: primeiro quat�rnio
%q2: segundo quat�rnio
%Retorno:
%qr: quat�rnio resultante
%--------------------------------------
function qr = quatSub(q1,q2)
    %q = a + bi + cj + dk
    qr(1,1) = q1(1,1)- q2(1,1);%parte real
    qr(2,1) = q1(2,1)- q2(2,1);%imagin�rio i
    qr(3,1) = q1(3,1)- q2(3,1);%imagin�rio j
    qr(4,1) = q1(4,1)- q2(4,1);%imagin�rio k
end