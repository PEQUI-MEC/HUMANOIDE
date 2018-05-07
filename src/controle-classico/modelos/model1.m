%-----------------------------------------------------------
%Calcula o valor das derivadas do modelo dinamico 1
%Parâmetros
%t   - tempo
%Y0  - Vetor com a condição inicial do sistema
%params: parametros do sistema
%m   - massa
%L   - comprimento da perna do modelo
%g   - gravidade
%k   - constante da mola
%Bss - coeficiente angular do modelo
%Retorno:
%dydt - vetor com primeira e segunda derivada do sistema
%-----------------------------------------------------------
function dydt = model1(t,Y0,params)  
%-----------------------------------------------------------
%constantes
%-----------------------------------------------------------
    m    = params(1,1);
    L    = params(2,1);
    g    = params(3,1);
    k    = params(4,1);
    Bss  = params(5,1);
    expK = params(6,1);    
%-----------------------------------------------------------
%condição inicial
%----------------------------------------------------------- 
    x  = Y0(1,1);
    dx = Y0(2,1);
    y  = Y0(3,1);
    dy = Y0(4,1);
    z  = Y0(5,1);
    dz = Y0(6,1);
%-----------------------------------------------------------
%norma de L
%-----------------------------------------------------------      
    norma = (x*x + y*y + z*z )^0.5;
%-----------------------------------------------------------
%derivadas
%-----------------------------------------------------------   
    f1 = dx;
    f2 = (k*expK/m)*( L +Bss*t - norma)*(x/norma);
    f3 = dy;
    f4 = (k*expK/m)*( L +Bss*t - norma)*(y/norma);
    f5 = dz;
    f6 = (k*expK/m)*( L +Bss*t - norma)*(z/norma) - g;
%-----------------------------------------------------------
%solução
%-----------------------------------------------------------    
    dydt = [f1;f2;f3;f4;f5;f6];  
end