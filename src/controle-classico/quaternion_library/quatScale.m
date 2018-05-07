%--------------------------------------
%Método para calcular o produto escalar de um
%quatérnio
%Parâmetros: 
%s: escalar
%q: quatérnio
%Retorno:
%qr: quatérnio resultante
%--------------------------------------
function qr = quatScale(s,q1)
    %q = a + bi + cj + dk
    qr(1,1) = s*q1(1,1);%parte real
    qr(2,1) = s*q1(2,1);%imaginário i
    qr(3,1) = s*q1(3,1);%imaginário j
    qr(4,1) = s*q1(4,1);%imaginário k
end