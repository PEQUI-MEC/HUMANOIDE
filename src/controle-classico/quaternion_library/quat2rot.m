%--------------------------------------
%Método para calcular a matriz de rotação
%equivalente dado um quatérnio
%Parâmetros: 
%q: quatérnio
%Retorno:
%R: matriz de rotação
%--------------------------------------
function R = quat2rot(q)   
    %inicializar variaveis
    w = q(1,1);
    x = q(2,1);
    y = q(3,1);
    z = q(4,1);  
    %montar matriz de rotação
    R(1,1) = w*w + x*x - y*y - z*z;
    R(2,1) = 2*x*y + 2*z*w;
    R(3,1) = 2*x*z - 2*y*w;
    R(4,1) = 0;
    R(1,2) = 2*x*y - 2*z*w;
    R(2,2) = w*w - x*x + y*y - z*z;
    R(3,2) = 2*y*z + 2*x*w;
    R(4,2) = 0;
    R(1,3) = 2*x*z + 2*y*w;
    R(2,3) = 2*y*z - 2*x*w;
    R(3,3) = w*w - x*x - y*y + z*z;
    R(4,3) = 0;
    R(1,4) = 0;
    R(2,4) = 0;
    R(3,4) = 0;
    R(4,4) = 1;   
end