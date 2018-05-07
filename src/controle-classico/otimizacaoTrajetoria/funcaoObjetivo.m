%-----------------------------------------------------------
%Calcula o valor da fun��o objetivo
%Par�metros: 
%pa - Vetor com posi��o espacial do p� A
%pb - Vetor com posi��o espacial do p� B
%pc - Vetor com posi��o espacial do centro de massa
%Retorno: 
%fo -  valor da fun��o objetivo
%-----------------------------------------------------------
function fo = funcaoObjetivo(pa,pb,pc)
%-----------------------------------------------------------
%vari�veis globais
%-----------------------------------------------------------
    global lstep
%-----------------------------------------------------------
%Pegar os valores de x e y do p� A e B e do CoM
%CoM - centro de massa
%-----------------------------------------------------------
    xa = pa(1,1);%posi��o x do p� A
    xb = pb(1,1);%posi��o x do p� B
    ya = pa(2,1);%posi��o y do p� A
    yb = pb(2,1);%posi��o x do p� B
    xc = pc(1,1);%posi��o x do CoM
    yc = pc(2,1);%posi��o x do CoM
%-----------------------------------------------------------
%c�lcula a norma euclidiano do espa�o (fun��o objetivo - fo)
%-----------------------------------------------------------
    s(1,1) = (0.5*(xa + xb) - xc);
    s(2,1) = (0.5*(ya + yb) - yc);
    %s(3,1) = (lstep - xb);
    %s(4,1) = (0.5*lstep - xc);       
    fo = norm(s).^2;
end