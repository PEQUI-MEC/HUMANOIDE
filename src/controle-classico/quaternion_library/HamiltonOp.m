%--------------------------------------
%Método para calcular o operador de Halmilton
%quatérnios
%Parâmetros: 
%op: tipo do operador + ou -
%h - quatérnio
%Retorno:
%T: HamiltonOp
%--------------------------------------
function T = HamiltonOp(h,op)
    %quatérnio
    h1 = h(1,1);
    h2 = h(2,1);
    h3 = h(3,1);
    h4 = h(4,1);
    %Operador -
    H_ = [h1 -h2 -h3 -h4;
          h2  h1  h4 -h3;
          h3 -h4  h1  h2;
          h4  h3 -h2  h1];
    %operador +  
    H = [h1 -h2 -h3 -h4;
         h2  h1 -h4  h3;
         h3  h4  h1 -h2;
         h4 -h3  h2 h1];
    %tipo do retorno
    if op == 1
        T = H;
    else
        T =H_;
    end
end