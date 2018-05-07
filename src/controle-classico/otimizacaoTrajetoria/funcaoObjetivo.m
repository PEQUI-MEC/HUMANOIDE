%-----------------------------------------------------------
%Calcula o valor da função objetivo
%Parâmetros: 
%pa - Vetor com posição espacial do pé A
%pb - Vetor com posição espacial do pé B
%pc - Vetor com posição espacial do centro de massa
%Retorno: 
%fo -  valor da função objetivo
%-----------------------------------------------------------
function fo = funcaoObjetivo(pa,pb,pc)
%-----------------------------------------------------------
%variáveis globais
%-----------------------------------------------------------
    global lstep
%-----------------------------------------------------------
%Pegar os valores de x e y do pé A e B e do CoM
%CoM - centro de massa
%-----------------------------------------------------------
    xa = pa(1,1);%posição x do pé A
    xb = pb(1,1);%posição x do pé B
    ya = pa(2,1);%posição y do pé A
    yb = pb(2,1);%posição x do pé B
    xc = pc(1,1);%posição x do CoM
    yc = pc(2,1);%posição x do CoM
%-----------------------------------------------------------
%cálcula a norma euclidiano do espaço (função objetivo - fo)
%-----------------------------------------------------------
    s(1,1) = (0.5*(xa + xb) - xc);
    s(2,1) = (0.5*(ya + yb) - yc);
    %s(3,1) = (lstep - xb);
    %s(4,1) = (0.5*lstep - xc);       
    fo = norm(s).^2;
end