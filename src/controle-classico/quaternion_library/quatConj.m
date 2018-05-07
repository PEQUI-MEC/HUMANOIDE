%--------------------------------------
%M�todo para calcular o conjugado de
%um quat�rnio
%Par�metros: 
%q: quat�rnio
%Retorno:
%qr: quat�rnio resultante
%--------------------------------------
function qr = quatConj(q)
    %q = a + bi + cj + dk
    qr(1,1) =  q(1,1);%parte real
    qr(2,1) = -q(2,1);%imagin�rio i
    qr(3,1) = -q(3,1);%imagin�rio j
    qr(4,1) = -q(4,1);%imagin�rio k
end