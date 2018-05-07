%--------------------------------------
%Método para calcular o conjugado de
%um quatérnio
%Parâmetros: 
%q: quatérnio
%Retorno:
%qr: quatérnio resultante
%--------------------------------------
function qr = quatConj(q)
    %q = a + bi + cj + dk
    qr(1,1) =  q(1,1);%parte real
    qr(2,1) = -q(2,1);%imaginário i
    qr(3,1) = -q(3,1);%imaginário j
    qr(4,1) = -q(4,1);%imaginário k
end