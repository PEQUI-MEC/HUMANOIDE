%--------------------------------------
%M�todo para calcular o produto escalar de um
%quat�rnio
%Par�metros: 
%s: escalar
%q: quat�rnio
%Retorno:
%qr: quat�rnio resultante
%--------------------------------------
function qr = quatScale(s,q1)
    %q = a + bi + cj + dk
    qr(1,1) = s*q1(1,1);%parte real
    qr(2,1) = s*q1(2,1);%imagin�rio i
    qr(3,1) = s*q1(3,1);%imagin�rio j
    qr(4,1) = s*q1(4,1);%imagin�rio k
end